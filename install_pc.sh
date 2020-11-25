#!/bin/bash

# enable sudo for ansible-playbook
sudo echo

# install fresh-env.yml
ansible-playbook --connection=local --inventory 127.0.0.1, fresh_env.yml

# install ubuntu.yml
ansible-galaxy collection install community.general
ansible-galaxy install -r requirements.ubuntu.yml
ansible-playbook --connection=local --inventory 127.0.0.1, ubuntu.yml

# install ubuntu-dev.yml (optional)
ansible-galaxy install -r requirements.ubuntu-dev.yml
ansible-playbook --connection=local --inventory 127.0.0.1, ubuntu-dev.yml

# clear unused files from previous versions (optional)
ansible-playbook --connection=local --inventory 127.0.0.1, clear_env.yml
