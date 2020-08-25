# IG Ansible

> Handy ansible playbooks for multiple enviroments.

## Requirements

 - ansible
```
sudo apt install ansible
```

## Usage

 - For personal usage (Ubuntu)
```
cd ansible
ansible-playbook --connection=local --inventory 127.0.0.1, --ask-become-pass fresh_env.yml
sudo reboot
```
```
cd ansible
ansible-galaxy install -r requirements.ubuntu.yml
ansible-playbook --connection=local --inventory 127.0.0.1, --ask-become-pass ubuntu.yml
sudo reboot
```
