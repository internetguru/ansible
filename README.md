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
- [ulauncher](https://ulauncher.io/)
  - [English dictionary extension](https://ext.ulauncher.io/-/github-katacarbix-ulauncher-dict-en)
  - [Gnome Settings](https://ext.ulauncher.io/-/github-friday-ulauncher-gnome-settings)
  - [Zoom - Join a meeting](https://ext.ulauncher.io/-/github-skeletonkey-ulauncher-zoom-join-meeting)
- [pinta](https://www.pinta-project.com/) (alternative to MS Paint)
- [rtorrent](https://github.com/rakshasa/rtorrent/wiki) ([cheet sheet](https://devhints.io/rtorrent))
- [we-get](https://github.com/rachmadaniHaryono/we-get)
- [rhythmbox](https://wiki.gnome.org/Apps/Rhythmbox)
- [vlc](https://www.videolan.org/vlc/index.html)
- [chrome](https://www.google.com/chrome/)
- [system configuration](https://github.com/InternetGuru/ansible/blob/master/tasks/ubuntucfg.yml)
- [system keyboard shortcuts](https://github.com/InternetGuru/ansible/blob/master/tasks/ubuntukeys.yml)

### `ubuntu-dev.yml`

- java
- php 7.4
- [virtualbox](https://www.virtualbox.org/)
- [docker](https://www.docker.com/products/docker-app)
- [slack](https://slack.com/)
- [visual-studio-code](https://code.visualstudio.com/) with [shared settings](https://gist.github.com/petrzpav/fd6f4ed38d22d4611e6f8a9e0c9e2801)

## Complete Ubuntu Setup with Ansible

1. Install updates or existing packages
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

3. Clone or update ansible project
```
git clone https://github.com/InternetGuru/ansible.git || git -C ansible pull
```

4. Apply ansible
```
cd ansible

# install fresh-env.yml
ansible-playbook --connection=local --inventory 127.0.0.1, --ask-become-pass fresh_env.yml

# install global vim plugins and exit (:q)
sudo vim

# install ubuntu.yml
ansible-galaxy install -r requirements.ubuntu.yml
ansible-galaxy collection install community.general
ansible-playbook --connection=local --inventory 127.0.0.1, --ask-become-pass ubuntu.yml

# install ubuntu-dev.yml (optional)
ansible-galaxy install -r requirements.ubuntu-dev.yml
ansible-playbook --connection=local --inventory 127.0.0.1, --ask-become-pass ubuntu-dev.yml

# restart
sudo reboot
```

## Known Issues

- Unable to load VSC shared settings from ansible.
  > Open VSC, hit `ctr+shift+p`, type `sync download`, sign in to GitHub.
- VSC toggle spellcheck (`F6`) not working without a workspace.
  > Open VSC, hit File / Add Folder to Workspace… and select a folder.
- Remote mouse wakes up the computer
- Ansible forces VirtualBox version to 6.0

## Howtos

- [How to use manual partitioning during installation](https://askubuntu.com/questions/343268/how-to-use-manual-partitioning-during-installation)
- [Change swap size](https://bogdancornianu.com/change-swap-size-in-ubuntu/)
- [Move home to external partition](https://www.tecmint.com/move-home-directory-to-new-partition-disk-in-linux/)
- [Set default audio device](https://askubuntu.com/questions/1038490/how-do-you-set-a-default-audio-output-device-in-ubuntu-18-04)
- [Make login screen appear in external display](https://askubuntu.com/questions/1043337/is-there-to-make-the-login-screen-appear-on-the-external-display-in-18-04)
- [Transfer audio from PC to iPhone](https://www.groovypost.com/howto/howto/sync-your-iphone-or-ipod-touch-in-ubuntu/)
- [Enable ssh server](https://linuxize.com/post/how-to-enable-ssh-on-ubuntu-18-04/)
- [Compose key cheet sheet](https://tuttle.github.io/python-useful/compose-key-cheat-sheet.html)
- [Change compose key](https://askubuntu.com/questions/70784/how-can-i-enable-compose-key)
- [Change font size](https://help.ubuntu.com/stable/ubuntu-help/a11y.html.en)
- [Chrome streamkeys extension](https://chrome.google.com/webstore/detail/streamkeys/ekpipjofdicppbepocohdlgenahaneen)

## Suggestions

- [x] Shortcut to turn off the screen with no lock and no suspend.
- [x] Ulauncher to `win+s`.
- [x] Do nothing when lid is closed.
- [x] Use Ulauncher instead of Appmenu (left ico button)
