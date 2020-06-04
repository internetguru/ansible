# IG Ansible

TODO desc..

## Requirements

 - ansible
```
apt install ansible
```

## Usage

 - Run playbook localy

```
ansible-playbook --connection=local --inventory 127.0.0.1, fresh_env.yml
```

 - Install requirements for server playbook
```
ansible-galaxy install -r requirements.server.yml
```
