# Internet Guru Ansible

> Handy ansible playbooks for multiple enviroments.

## Requirements

- Ubuntu 20.04.1 LTS
  > [download iso](https://releases.ubuntu.com/20.04/ubuntu-20.04.1-desktop-amd64.iso)
  
  > [create a bootable USB stick on Ubuntu](https://ubuntu.com/tutorials/create-a-usb-stick-on-ubuntu#1-overview)
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
- ulauncher
- pinta (alternative to mspaint)
- rtorrent
- we-get
- rhythmbox
- vlc
- chrome
- [ubuntucfg](https://github.com/jiripavelka/ubuntucfg.git)

### `ubuntu-dev.yml`

- docker
- slack
- visual-studio-code with shared settings
- java
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

4. Apply ansible
```
cd ~/ansible

# install fres-env.yml
ansible-playbook --connection=local --inventory 127.0.0.1, --ask-become-pass fresh_env.yml

# install global vim plugins and exit (:q)
sudo vim

# install ubuntu.yml
ansible-galaxy install -r requirements.ubuntu.yml
ansible-playbook --connection=local --inventory 127.0.0.1, --ask-become-pass ubuntu.yml

# load ubuntucfg manually, see Known Bugs (below)
cd ~/ubuntucfg
./filter dirs < settings.dconf | dconf load /

# install ubuntu-dev.yml
cd ~/ansible
ansible-galaxy install -r requirements.ubuntu-dev.yml
ansible-playbook --connection=local --inventory 127.0.0.1, --ask-become-pass ubuntu-dev.yml

# restart
sudo reboot
```

## Known Bugs

- Unable to load VSC shared settings from ansible.
  > Open VSC, hit `ctr+shift+p`, type `sync download`, sign in to GitHub.
- VSC toggle spellcheck (`F6`) not working without a workspace.
  > Open VSC, hit File / Add Folder to Workspace… and select a folder.
- Unable to load `ubuntucfg` from ansible.
  > Load `ubuntucfg` manually, see Appy ansible (above).

## Typical Issues and Howtos

- [How to use manual partitioning during installation](https://askubuntu.com/questions/343268/how-to-use-manual-partitioning-during-installation)
- [Change swap size](https://bogdancornianu.com/change-swap-size-in-ubuntu/)
- [Move home to external partition](https://www.tecmint.com/move-home-directory-to-new-partition-disk-in-linux/)
- [Set default audio device](https://askubuntu.com/questions/1038490/how-do-you-set-a-default-audio-output-device-in-ubuntu-18-04)
- [Make login screen appear in external display](https://askubuntu.com/questions/1043337/is-there-to-make-the-login-screen-appear-on-the-external-display-in-18-04)
- [Transfer audio from PC to iPhone](https://www.groovypost.com/howto/howto/sync-your-iphone-or-ipod-touch-in-ubuntu/)
- [Enable ssh server](https://linuxize.com/post/how-to-enable-ssh-on-ubuntu-18-04/)
- [Compose key cheet sheet](https://tuttle.github.io/python-useful/compose-key-cheat-sheet.html)
- [rtorrent cheet sheet](https://devhints.io/rtorrent)
- [we-get readme](https://github.com/rachmadaniHaryono/we-get)

## Suggestions

- [x] Shortcut to turn off the screen with no lock and no suspend.
- [ ] Ulauncher to `win` and `win+s`.
- [x] Do nothing when lid is closed.
