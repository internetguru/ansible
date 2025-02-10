#!/bin/bash

exception() {
  echo "[EXCEPTION] ${1:-Unknown exception} in $(basename "${0}")" >&2
  # shellcheck disable=SC2086
  exit ${2:-1}
}
run_playbooks() {
  echo "Installing ${1} [${2}] as $(whoami)..."
  ansible-playbook --connection=local --inventory 127.0.0.1, --tags "${2}" "${1}" \
    || exception "Failed to install ${1} [${2}] as $(whoami)"
  echo "Installing ${1} [${2}] as $(whoami) SUCCESSFULLY FINISHED"
}
main() {
  # shellcheck disable=SC2155
  declare -r EXC_DEF=$(declare -f exception)
  # shellcheck disable=SC2155
  declare -r RUN_DEF=$(declare -f run_playbooks)
  # shellcheck disable=SC2155
  declare -r WORKDIR="$(dirname "$0")"
  declare -r USE_SHELL="/usr/bin/bash"
  declare FORCE=0
  declare SKIP_GLOBAL=0
  ## option preprocessing
  if ! LINE=$(getopt -n "$0" -o fs -l force,skip-global -- "$@"); then
    exit 1
  fi
  eval set -- "$LINE"
  ## load user options
  while [ $# -gt 0 ]; do
    case $1 in
      -f|--force) FORCE=1; shift ;;
      -s|--skip-global) SKIP_GLOBAL=1; shift ;;
      --) shift; break ;;
      *-) exception "Unrecognized option '$1'" 2 ;;
       *) break ;;
    esac
  done
  [[ -z "${1}" ]] \
    && exception "Missing config path(s)"
  for config in "$@"; do
    [[ ! -f "${config}" ]] \
      && exception "Configuration file ${config} not found"
  done
  [[ $(id -u) != 0 ]] \
    && exception "Script must be run as root"
  # check for supported ubuntu version
  [[ $(lsb_release -cs) != "oracular" ]] \
    || exception "Unsupported Ubuntu version, please use Ubuntu 24.10"
  # force config location for ansible
  export ANSIBLE_CONFIG="${WORKDIR}/ansible.cfg"
  eval "$(tail --lines=+2 "${ANSIBLE_CONFIG}")"
  # shellcheck disable=SC2154
  mkdir -p "${fact_caching_connection}"
  chmod 777 "${fact_caching_connection}"
  # install general collection
  # downgrade because of bug, see https://github.com/ansible-collections/community.general/issues/6271
  ansible-galaxy collection install community.general:6.4.0 \
    || exit 1
  # install specific roles
  for config in "$@"; do
    roles_file="${WORKDIR}/roles.$(basename "${config}")"
    [[ ! -f  "${roles_file}" ]] \
      && continue
    ansible-galaxy install -r "${roles_file}" \
      || exit 1
  done
  chmod -R 755 /usr/share/ansible
  if [[ $SKIP_GLOBAL == 0 ]]; then
    # install global tasks
    for config in "$@"; do
      bash -c "${EXC_DEF}; ${RUN_DEF}; run_playbooks ${config} global" \
        || exit 1
    done
  fi
  # install user tasks for all users
  for user in $(getent passwd {1000..2000} | cut -d: -f1); do
    # install user files and settings
    for config in "$@"; do
      [[ ${FORCE} == 0 ]] \
        || sudo -H -u "${user}" bash -c "${EXC_DEF}; ${RUN_DEF}; run_playbooks ${config} force" \
        || exit 1
      sudo -H -u "${user}" bash -c "${EXC_DEF}; ${RUN_DEF}; run_playbooks ${config} user" \
        || exit 1
    done
    # set default shell
    [[ "$(grep "^${user}:" /etc/passwd | cut -d: -f7)" == "${USE_SHELL}" ]] \
      || usermod -s "${USE_SHELL}" "${user}" \
      || exit 1
  done
}

main "$@"
