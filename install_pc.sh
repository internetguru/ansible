#!/bin/bash

trash=".zsh_history .zshrc.local .zshrc zshrc vimrc bashcfg omgf butt .ansible"

run_playbooks() {
  for playbook in fresh_env.yml ubuntu.yml ubuntu-dev.yml; do
    echo "Installing $playbook [$1] as $(whoami)"
    ansible-playbook --connection=local --inventory 127.0.0.1, --tags "$1" $playbook \
      || exit 1
  done
}
FUNC=$(declare -f run_playbooks)

# create global cache folder
sudo mkdir -p /tmp/facts_cache
sudo chmod 777 /tmp/facts_cache

# install ansible requirements
sudo ansible-galaxy collection install community.general
sudo ansible-galaxy install -r requirements.ubuntu.yml
sudo ansible-galaxy install -r requirements.ubuntu-dev.yml
sudo chmod -R 755 /usr/share/ansible

# install global tasks
sudo bash -c "$FUNC; run_playbooks global"

# install user tasks for all users
for user in $(getent passwd {1000..2000} | cut -d: -f1); do
  # install user files and settings
  sudo -H -u "$user" bash -c "$FUNC; run_playbooks user"
  # set default shell
  sudo usermod -s /usr/bin/fish "$user"
  # remove previous mess
  for f in $trash; do
    sudo rm -rf "/home/$user/$f"
  done
done

# uninstall previous apps
sudo ansible-playbook --connection=local --inventory 127.0.0.1, clear_env.yml

# remove previous mess for root
for f in $trash; do
  sudo rm -rf "/root/$f"
done
