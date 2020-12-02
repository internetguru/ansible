#!/bin/bash

tags=""
[[ -n "$1" ]] \
  && tags="--tags $1"

# install fresh-env.yml
ansible-playbook --connection=local --inventory 127.0.0.1, $tags fresh_env.yml

# install ubuntu.yml
ansible-playbook --connection=local --inventory 127.0.0.1, $tags ubuntu.yml

# install ubuntu-dev.yml (optional)
ansible-playbook --connection=local --inventory 127.0.0.1, $tags ubuntu-dev.yml

# clear unused files from previous versions (optional)
ansible-playbook --connection=local --inventory 127.0.0.1, $tags clear_env.yml
