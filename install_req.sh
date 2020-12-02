#!/bin/bash

# create global cache folder
mkdir -p /tmp/facts_cache
chmod 755 /tmp/facts_cache


# install ansible requirements
ansible-galaxy collection install community.general
ansible-galaxy install -r requirements.ubuntu.yml
ansible-galaxy install -r requirements.ubuntu-dev.yml

# make cache accessible for other users
chmod -R 755 /usr/share/ansible

