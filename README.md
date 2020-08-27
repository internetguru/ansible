# IG Ansible

> Handy ansible playbooks for multiple enviroments.

## Requirements

 - ansible
```
sudo apt install ansible
```

## Content

- `fresh-env.yml`
  - vim
  - curl
  - htop
  - git
  - mc
  - build-essential
  - zsh
  - [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
  - [bashcfg](https://bitbucket.org/igwr/bashcfg)
  - [vimrc](https://github.com/petrzpav/vimrc)
- `server.yml`
  - creates 2 GB swapfile in `/root/swapfile`
  - [Internet Guru motd](https://github.com/InternetGuru/ansible/blob/master/res/20-ig)
  - ufw with basic rules
- `ubuntu.yml`
  - gnome disable-screenshield
  - gnome clock-override
  - gnome dash-to-panel
  - gnome-screensaver
  - gnome-session
  - gnome-settings-daemon
  - gnome-tweaks
  - chrome
  - slack
  - teamviewer
  - visual-studio-code with shared settings
  - [system configuration](https://github.com/jiripavelka/ubuntucfg.git)

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
sudo vim # Install global vim plugins and exit (:q)
ansible-galaxy install -r requirements.ubuntu.yml
ansible-playbook --connection=local --inventory 127.0.0.1, --ask-become-pass ubuntu.yml
sudo reboot
```
