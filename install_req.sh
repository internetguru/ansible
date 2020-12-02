#!/bin/bash

# create global cache folder
mkdir -p /tmp/facts_cache

# install ansible requirements
ansible-galaxy collection install community.general
ansible-galaxy install -r requirements.ubuntu.yml
ansible-galaxy install -r requirements.ubuntu-dev.yml

