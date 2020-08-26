# IG Ansible

> Handy ansible playbooks for multiple enviroments.

## Requirements

 - ansible
```
sudo apt install ansible
```

## Complete Ubuntu Installation with Ansible

1. Install updates
```
sudo apt update
sudo apt upgrade
sudo reboot
```

2. Install git and ansible
```
sudo apt install ansible
sudo apt install git
```

3. Download ansible project
```
git clone https://github.com/InternetGuru/ansible.git
```

4. Run ansible
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
