# Internet Guru Ansible

> Handy ansible playbooks for multiple enviroments.

## Requirements

- Ubuntu 20.04.1 LTS, [download](https://releases.ubuntu.com/20.04/ubuntu-20.04.1-desktop-amd64.iso)
- ansible
```
sudo apt install ansible
```

## Content

### `fresh-env.yml`

- vim
- curl
- htop
- git
- mc
- build-essential
- net-tools
- gettext
- zsh
- [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
- [bashcfg](https://bitbucket.org/igwr/bashcfg)
- [vimrc](https://github.com/petrzpav/vimrc)

### `server.yml`

- 2 GB swapfile in `/root/swapfile`
- [Internet Guru motd](https://github.com/InternetGuru/ansible/blob/master/res/20-ig)
- ufw with basic rules

### `ubuntu.yml`

- gnome-screensaver 
- gnome-session
- gnome-settings-daemon
- gnome-tweaks
- gnome-shell-extension-dash-to-panel
- python3-pip
- pinta (alternative to mspaint)
- rtorrent
- we-get
- rhythmbox
- vlc
- chrome
- [system configuration](https://github.com/jiripavelka/ubuntucfg.git)
- Additional settings:
  - Show language switch
  - Set idle time to 15 min
  - Disable overlay-key (win)

### `ubuntu-dev.yml`

- slack
- visual-studio-code with shared settings
- ulauncher
- java
- docker
- php 7.4

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

# install fres-env.yml
ansible-playbook --connection=local --inventory 127.0.0.1, --ask-become-pass fresh_env.yml

# install global vim plugins and exit (:q)
sudo vim

# install ubuntu.yml
ansible-galaxy install -r requirements.ubuntu.yml
ansible-playbook --connection=local --inventory 127.0.0.1, --ask-become-pass ubuntu.yml
# for now you must load ubuntucfg manually
cd ~/ubuntucfg
./filter dirs < settings.dconf | dconf load /

# install ubuntu-dev.yml
cd ansible
ansible-galaxy install -r requirements.ubuntu-dev.yml
ansible-playbook --connection=local --inventory 127.0.0.1, --ask-become-pass ubuntu-dev.yml

# restart
sudo reboot
```

## Known Bugs

- VSC shared settings first load
  > `ctr+shift+p` => type `sync download` => sign in to GitHub
- VSC `F6` not working without workspace
  > Add folder to workspace to create untitled workspace, `F6` should work now
- `dconf load` not working inside ansible task

## Typical Issues

- [Change swap size](https://bogdancornianu.com/change-swap-size-in-ubuntu/)
- [Move home to external partition](https://www.tecmint.com/move-home-directory-to-new-partition-disk-in-linux/)
- [Set default audio device](https://askubuntu.com/questions/1038490/how-do-you-set-a-default-audio-output-device-in-ubuntu-18-04)
- [Make login screen appear in external display](https://askubuntu.com/questions/1043337/is-there-to-make-the-login-screen-appear-on-the-external-display-in-18-04)
- [Transfer audio from PC to iPhone](https://www.groovypost.com/howto/howto/sync-your-iphone-or-ipod-touch-in-ubuntu/)
- [Compose key cheet sheet](https://tuttle.github.io/python-useful/compose-key-cheat-sheet.html)
- [rtorrent cheet sheet](https://devhints.io/rtorrent)
- [we-get readme](https://github.com/rachmadaniHaryono/we-get)

## TODO

- [ ] Check do not wake by mouse move
- [ ] Turn off the screen with no lock, no suspend shortcut
- [ ] Ulauncher to `win` and `win+s`
