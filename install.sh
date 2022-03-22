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
force_defaults() {
  sudo -H -u "${1}" bash <<-EOF
   exec dbus-run-session -- bash -c "dconf reset /org/gnome/shell/favorite-apps"
EOF
  sudo -H -u "${1}" bash -c "mv -f ~/.config/variety{,.bak} 2>/dev/null"
  sudo -H -u "${1}" bash -c "mv -f ~/.config/sublime-text-3{,.bak} 2>/dev/null"
  sudo -H -u "${1}" bash -c "mv -f ~/.cache/sublime-text-3{,.bak} 2>/dev/null"
}
main() {
  # shellcheck disable=SC2155
  declare -r EXC_DEF=$(declare -f exception)
  # shellcheck disable=SC2155
  declare -r RUN_DEF=$(declare -f run_playbooks)
  declare -r TRASH_FILES=".zsh_history .zshrc.local .zshrc zshrc vimrc bashcfg omgf butt .ansible"
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
      *-) echo "$0: Unrecognized option '$1'" >&2; exit 2 ;;
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
  # install ansible requirements
  ansible-galaxy collection install community.general \
    || exit 1
  ansible-galaxy install -r "${DIR}/requirements.ubuntu.yml" \
    || exit 1
  chmod -R 755 /usr/share/ansible \
    || exception "Failed to set permissions to /usr/share/ansible"
  # install global tasks
  for config in "$@"; do
    bash -c "${EXC_DEF}; ${RUN_DEF}; run_playbooks ${config} global" \
      || exit 1
  done
  # install user tasks for all users
  for user in $(getent passwd {1000..2000} | cut -d: -f1); do
    # force defaults
    [[ ${FORCE} == 1 ]] \
      && force_defaults "${user}"
    # install user files and settings
    for config in "$@"; do
      sudo -H -u "${user}" bash -c "${EXC_DEF}; ${RUN_DEF}; run_playbooks ${config} user" \
        || exit 1
    done
    # set default shell
    usermod -s /usr/bin/bash "${user}" \
      || exit 1
    # remove previous mess
    for file in $TRASH_FILES; do
      # shellcheck disable=SC2115
      rm -rf "/home/${user}/${file}"
    done
  done
  # uninstall previous apps
  ansible-playbook --connection=local --inventory 127.0.0.1, clear_env.yml \
    || exception "Failed to clear enviroment"
  # remove previous mess for root
  for file in ${TRASH_FILES}; do
    rm -rf "/root/${file}"
  done
}

main "$@"
