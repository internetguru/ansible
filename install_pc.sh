#!/bin/bash

trash=".zsh_history .zshrc.local .zshrc zshrc vimrc bashcfg omgf butt .ansible"

exception() {
  echo "[EXCEPTION] ${1:-Unknown exception} in $(basename "${0}")" >&2
  exit ${2:-1}
}
EXC=$(declare -f exception)
run_playbooks() {
  echo "Installing $2 [$1] as $(whoami)"
  ansible-playbook --connection=local --inventory 127.0.0.1, --tags "$1" $2 \
    || exception "Failed to install $2 [$1] as $(whoami)"
}
RUN=$(declare -f run_playbooks)

# create global cache folder
sudo mkdir -p /tmp/facts_cache
sudo chmod 777 /tmp/facts_cache

# install ansible requirements
sudo ansible-galaxy collection install community.general \
  || exit 1
sudo ansible-galaxy install -r requirements.ubuntu.yml \
  || exit 1
sudo ansible-galaxy install -r requirements.ubuntu-dev.yml \
  || exit 1
sudo chmod -R 755 /usr/share/ansible \
  || exception "Failed to set permissions to /usr/share/ansible"

# install global tasks
sudo bash -c "$EXC; $RUN; run_playbooks global fresh_env.yml" \
  || exit 1
sudo bash -c "$EXC; $RUN; run_playbooks global ubuntu.yml" \
  || exit 1

# install user tasks for all users
for user in $(getent passwd {1000..2000} | cut -d: -f1); do
  # install user files and settings
  sudo -H -u "$user" bash -c "$EXC; $RUN; run_playbooks user fresh_env.yml" \
    || exit 1
  sudo -H -u "$user" bash -c "$EXC; $RUN; run_playbooks user ubuntu.yml" \
    || exit 1
  # set default shell
  sudo usermod -s /usr/bin/fish "$user" \
    || exit 1
  # remove previous mess
  for f in $trash; do
    sudo rm -rf "/home/$user/$f"
  done
done

# install ubuntu-dev for current user
sudo -H -u "$(whoami)" bash -c "$EXC; $RUN; run_playbooks global ubuntu-dev.yml" \
  || exit 1
sudo -H -u "$(whoami)" bash -c "$EXC; $RUN; run_playbooks user ubuntu-dev.yml" \
  || exit 1

# uninstall previous apps
sudo ansible-playbook --connection=local --inventory 127.0.0.1, clear_env.yml \
  || exception "Failed to clear enviroment"

# remove previous mess for root
for f in $trash; do
  sudo rm -rf "/root/$f"
done
