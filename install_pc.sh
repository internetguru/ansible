#!/bin/bash

# install fresh-env.yml
ansible-playbook --connection=local --inventory 127.0.0.1, --ask-become-pass fresh_env.yml

# install ubuntu.yml
ansible-galaxy collection install community.general
ansible-galaxy install -r requirements.ubuntu.yml
ansible-playbook --connection=local --inventory 127.0.0.1, --ask-become-pass ubuntu.yml

# install ubuntu-dev.yml (optional)
ansible-galaxy install -r requirements.ubuntu-dev.yml
ansible-playbook --connection=local --inventory 127.0.0.1, --ask-become-pass ubuntu-dev.yml

# clear unused files from previous versions (optional)
ansible-playbook --connection=local --inventory 127.0.0.1, --ask-become-pass clear_env.yml
