#!/bin/bash

trash=".zsh_history .zshrc.local .zshrc zshrc vimrc bashcfg omgf butt .ansible"

exception() {
  echo "[EXCEPTION] ${1:-Unknown exception} in $(basename "${0}")" >&2
  exit ${2:-1}
}
run_playbooks() {
  for playbook in fresh_env.yml ubuntu.yml ubuntu-dev.yml; do
    echo "Installing $playbook [$1] as $(whoami)"
    ansible-playbook --connection=local --inventory 127.0.0.1, --tags "$1" $playbook \
      || exception "Failed to install $playbook [$1] as $(whoami)"
  done
}
FUNC=$(declare -f run_playbooks)

# create global cache folder
sudo mkdir -p /tmp/facts_cache
sudo chmod 777 /tmp/facts_cache

# install ansible requirements
sudo ansible-galaxy collection install community.general \
  && sudo ansible-galaxy install -r requirements.ubuntu.yml \
  && sudo ansible-galaxy install -r requirements.ubuntu-dev.yml \
  && sudo chmod -R 755 /usr/share/ansible \
  || exception "Failed to install requirements"

# install global tasks
sudo bash -c "$FUNC; run_playbooks global" \
  || exit 1

# install user tasks for all users
for user in $(getent passwd {1000..2000} | cut -d: -f1); do
  # install user files and settings
  sudo -H -u "$user" bash -c "$FUNC; run_playbooks user" \
    || exit 1
  # set default shell
  sudo usermod -s /usr/bin/fish "$user" \
    || exit 1
  # remove previous mess
  for f in $trash; do
    sudo rm -rf "/home/$user/$f"
  done
done

# uninstall previous apps
sudo ansible-playbook --connection=local --inventory 127.0.0.1, clear_env.yml \
  || exception "Failed to clear enviroment"

# remove previous mess for root
for f in $trash; do
  sudo rm -rf "/root/$f"
done
