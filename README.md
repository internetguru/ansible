# IG Ansible

> Handy ansible playbooks for multiple kinds of linux enviroment.

## Requirements

 - ansible
```
sudo apt install ansible
```

## Usage

 - Run playbook localy

```
ansible-playbook --connection=local --inventory 127.0.0.1, --ask-become-pass fresh_env.yml
```

 - Install requirements for server playbook
```
ansible-galaxy install -r requirements.server.yml
```

