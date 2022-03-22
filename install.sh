#!/bin/bash

exception() {
  echo "[EXCEPTION] ${1:-Unknown exception} in $(basename "${0}")" >&2
  # shellcheck disable=SC2086
  exit ${2:-1}
}
run_playbooks() {
  echo "Installing ${1} [${2}] as $(whoami)"
  ansible-playbook --connection=local --inventory 127.0.0.1, --tags "${2}" "${1}" \
    || exception "Failed to install ${1} [${2}] as $(whoami)"
}
main() {
  # shellcheck disable=SC2155
  declare -r EXC_DEF=$(declare -f exception)
  # shellcheck disable=SC2155
  declare -r RUN_DEF=$(declare -f run_playbooks)
  # shellcheck disable=SC2155
  declare -r DIR="$(dirname "$0")"
  declare FORCE=0
  ## option preprocessing
  if ! LINE=$(getopt -n "$0" -o f -l force -- "$@"); then
    exit 1
  fi
  eval set -- "$LINE"
  ## load user options
  while [ $# -gt 0 ]; do
    case $1 in
      -f|--force) FORCE=1; shift ;;
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
  # force config location for ansible
  export ANSIBLE_CONFIG="${DIR}/ansible.cfg"
  eval "$(tail --lines=+2 "${ANSIBLE_CONFIG}")"
  # shellcheck disable=SC2154
  mkdir -p "${fact_caching_connection}"
  chmod 777 "${fact_caching_connection}"
  # install general collection
  ansible-galaxy collection install community.general \
    || exit 1
  # install specific roles
  for config in "$@"; do
    roles_file="${DIR}/roles.$(basename "${config}")"
    [[ ! -f  "${roles_file}" ]] \
      && continue
    ansible-galaxy install -r "${roles_file}" \
      || exit 1
  done
  chmod -R 755 /usr/share/ansible
  # install global tasks
  for config in "$@"; do
    bash -c "${EXC_DEF}; ${RUN_DEF}; run_playbooks ${config} global" \
      || exit 1
  done
  # install user tasks for all users
  for user in $(getent passwd {1000..2000} | cut -d: -f1); do
    # install user files and settings
    for config in "$@"; do
      [[ ${FORCE} == 1 ]] \
        || sudo -H -u "${user}" bash -c "${EXC_DEF}; ${RUN_DEF}; run_playbooks ${config} force" \
        || exit 1
      sudo -H -u "${user}" bash -c "${EXC_DEF}; ${RUN_DEF}; run_playbooks ${config} user" \
        || exit 1
    done
    # set default shell
    usermod -s /usr/bin/bash "${user}" \
      || exit 1
  done
}

main "$@"
