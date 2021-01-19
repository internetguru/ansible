#!/bin/bash

trash=".zsh_history .zshrc.local .zshrc zshrc vimrc bashcfg omgf butt .ansible"

exception() {
  echo "[EXCEPTION] ${1:-Unknown exception} in $(basename "${0}")" >&2
  exit ${2:-1}
}
EXC=$(declare -f exception)
run_playbooks() {
  echo "Installing $1 [$2] as $(whoami)"
  ansible-playbook --connection=local --inventory 127.0.0.1, --tags "$2" $1 \
    || exception "Failed to install $1 [$2] as $(whoami)"
}
RUN=$(declare -f run_playbooks)

[[ $(id -u) != 0 ]] \
  && exception "Script must be run as root"

# create global cache folder
mkdir -p /tmp/facts_cache
chmod 777 /tmp/facts_cache

# install ansible requirements
ansible-galaxy collection install community.general \
  || exit 1
ansible-galaxy install -r requirements.ubuntu.yml \
  || exit 1
ansible-galaxy install -r requirements.ubuntu-dev.yml \
  || exit 1
chmod -R 755 /usr/share/ansible \
  || exception "Failed to set permissions to /usr/share/ansible"

# install global tasks
bash -c "$EXC; $RUN; run_playbooks fresh_env.yml global" \
  || exit 1
bash -c "$EXC; $RUN; run_playbooks ubuntu.yml global" \
  || exit 1

# install user tasks for all users
for user in $(getent passwd {1000..2000} | cut -d: -f1); do
  # install user files and settings
  sudo -H -u "$user" bash -c "$EXC; $RUN; run_playbooks fresh_env.yml user" \
    || exit 1
  sudo -H -u "$user" bash -c "$EXC; $RUN; run_playbooks ubuntu.yml user" \
    || exit 1
  # set default shell
  usermod -s /usr/bin/fish "$user" \
    || exit 1
  # remove previous mess
  for f in $trash; do
    rm -rf "/home/$user/$f"
  done
done

# install ubuntu-dev for current user
bash -c "$EXC; $RUN; run_playbooks ubuntu-dev.yml global" \
  || exit 1
sudo -H -u "$(logname)" bash -c "$EXC; $RUN; run_playbooks ubuntu-dev.yml user" \
  || exit 1

# uninstall previous apps
ansible-playbook --connection=local --inventory 127.0.0.1, clear_env.yml \
  || exception "Failed to clear enviroment"

# remove previous mess for root
for f in $trash; do
  rm -rf "/root/$f"
done
