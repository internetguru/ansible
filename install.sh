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
  declare -r TRASH_FILES=".zsh_history .zshrc.local .zshrc zshrc vimrc bashcfg omgf butt .ansible"
  # shellcheck disable=SC2155
  declare -r DIR="$(dirname "$0")"
  # force config location
  export ANSIBLE_CONFIG="${DIR}/ansible.cfg"

  [[ $(id -u) != 0 ]] \
    && exception "Script must be run as root"
  # create global cache folder
  mkdir -p /tmp/facts_cache
  chmod 777 /tmp/facts_cache
  # install ansible requirements
  ansible-galaxy collection install community.general \
    || exit 1
  ansible-galaxy install -r "${DIR}/requirements.ubuntu.yml" \
    || exit 1
  chmod -R 755 /usr/share/ansible \
    || exception "Failed to set permissions to /usr/share/ansible"
  # install global tasks
  bash -c "${EXC_DEF}; ${RUN_DEF}; run_playbooks ${DIR}/fresh_env.yml global" \
    || exit 1
  bash -c "${EXC_DEF}; ${RUN_DEF}; run_playbooks ${DIR}/ubuntu.yml global" \
    || exit 1
  # install user tasks for all users
  for user in $(getent passwd {1000..2000} | cut -d: -f1); do
    # install user files and settings
    sudo -H -u "${user}" bash -c "${EXC_DEF}; ${RUN_DEF}; run_playbooks ${DIR}/fresh_env.yml user" \
      || exit 1
    sudo -H -u "${user}" bash -c "${EXC_DEF}; ${RUN_DEF}; run_playbooks ${DIR}/ubuntu.yml user" \
      || exit 1
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
