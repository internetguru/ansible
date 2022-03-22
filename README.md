# Internet Guru Ansible

> This project contains handy ansible playbooks divided into several environments. To Install selected environments, simply follow instructions below. Same for any additional account. Make sure, each account has `sudo` permissions (see [Howtos](#howtos) section).

 - [Requirements](#requirements)
 - [Environments](#environments)
 - [Complete Ubuntu Setup with Ansible](#complete-ubuntu-setup-with-ansible)
 - [Shortcuts](#shortcuts)
 - [Troubleshooting](#troubleshooting)
 - [Howtos](#howtos)
 - [Suggestions](#suggestions)

## Requirements

 - Ubuntu 20.04+ (minimal installation)
   - tested on 20.04.1 LTS ([download iso](https://releases.ubuntu.com/20.04/ubuntu-20.04.1-desktop-amd64.iso))
   - [create a bootable USB stick on Ubuntu](https://ubuntu.com/tutorials/create-a-usb-stick-on-ubuntu#1-overview)
 - python and pip
 - ansible and git

```
sudo apt install python3-pip
sudo pip install -U "ansible"
sudo apt install git
```

## Environments

### `fresh.yml`

> Installs essential commands and CLI environment for Debian/Ubuntu.

 - avahi-daemon
 - build-essential
 - curl
 - gettext
 - git
 - htop
 - mc
 - net-tools
 - tldr
 - tree
 - vim
<!-- break -->
 - [bashcfg](https://bitbucket.org/igwr/bashcfg)
 - [fonts-firacode](https://github.com/tonsky/FiraCode)
 - [starship prompt](https://starship.rs/)
 - [vimrc](https://github.com/petrzpav/vimrc)

### `server.yml`

> Sets up Internet Guru server environment.

 - 2 GB swapfile in `/root/swapfile`
 - [Internet Guru MOTD](https://github.com/InternetGuru/ansible/blob/master/res/20-ig)
 - ufw with basic rules

### `ubuntu.yml`

> Enables Windows-like panel and adds practical programs, scripts and adjustments for *Ubuntu*.

 - gnome-screensaver
 - gnome-session
 - gnome-settings-daemon
 - gnome-shell-extension-dash-to-panel
 - gnome-tweaks
<!-- break -->
 - [google-chrome](https://www.google.com/chrome/)
   - chrome-remote-desktop
 - [keepass](https://keepass.info/)
 - [mpv](https://mpv.io/)
 - [kolourpaint](https://apps.kde.org/kolourpaint/) (alternative to MS Paint)
 - [popcorn time](https://github.com/popcorn-time-ru/popcorn-desktop)
 - [rhythmbox](https://wiki.gnome.org/Apps/Rhythmbox)
 - [rtorrent](https://github.com/rakshasa/rtorrent/wiki) ([cheet sheet](https://devhints.io/rtorrent))
 - [variety](https://peterlevi.com/variety)
 - [we-get](https://github.com/rachmadaniHaryono/we-get)
 - [zoom](https://zoom.us/)
<!-- break -->
 - [system configuration](https://github.com/InternetGuru/ansible/blob/master/tasks/ubuntucfg.yml)
 - [system keyboard shortcuts](https://github.com/InternetGuru/ansible/blob/master/tasks/ubuntukeys.yml)

### `ubuntu-dev.yml`

> Installs developer environment *for Ubuntu*.

 - java
 - php 7.4
<!-- break -->
 - [butt](https://github.com/InternetGuru/butt)
 - [discord](https://discord.com/)
 - [docker](https://www.docker.com/products/docker-app)
 - [omgf](https://github.com/InternetGuru/omgf)
 - [slack](https://slack.com/)
 - [sublime-text](https://www.sublimetext.com/3) with [shared settings](https://gist.github.com/petrzpav/abf3fa8890a04fd5dedb0dd20711f042)
 - [virtualbox](https://www.virtualbox.org/)
 - [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy)
<!-- break -->
 - `~/work` folder with various format file names touched

## Complete Ubuntu Setup with Ansible

> This is a complete simple use-case on how to install basic environments on a fresh *Ubuntu* installation, optionally including developer environment. To update, repeat the very same process on an updated repository.

1. Install updates or existing packages
   ```
   sudo apt update
   sudo apt upgrade -y
   sudo reboot
   ```
1. Clone or update ansible project
   ```
   git clone https://github.com/InternetGuru/ansible.git || git -C ansible pull
   ```
1. Force default favorites for current user *(optional)*
   ```
   dconf reset /org/gnome/shell/favorite-apps
   ```
1. Force default Variety configuration for current user *(optional)*
   ```
   mv ~/.config/variety ~/.config/variety.bak
   ```
1. Install ansible for all users
   ```
   cd ~/ansible
   sudo ./install.sh fresh.yml ubuntu.yml
   sudo reboot
   ```

## Shortcuts

 - `Ctrl+Alt+h` display README of installed version
 - `Ctrl+Alt+s` lock and sleep (suspend)
 - `Ctrl+Alt+f` screen off
 - `Ctrl+Alt+l` toggle night-light (on/off/auto)
 - `Ctrl+Alt+End` power off dialog
<!-- break -->
 - `Ctrl+Shift+PgUp` volume up
 - `Ctrl+Shift+PgDown` volume down
 - `Ctrl+Shift+Del` mute volume
<!-- break -->
 - `Win+s` application overview
 - `Win+c` calculator
<!-- break -->
 - `Pause`, `Menu` compose keys

## Troubleshooting

 - *"Unknown error when attempting to call Galaxy"*
   - Check your internet connection and run ansible again.
 - *"already installed"* warnings
   - *Ignore.*
 - *"This task (name) has extra params, which is only allowed"* error
   1. Make sure you installed Ansible using pip (see Requirements above).
   1. You may need to remove the old Ansible version.
      `sudo rm -rf /usr/lib/python3/dist-packages/ansible/`
 - Sublime Text not downloading shared settings after installation.
   1. Open Sublime Text.
   1. Run Tools / Command Pallette… (`ctrl+shift+p`) / Install Package Control (or just type `ipc` and press `Enter`).
   1. Restart (close and run) Sublime, wait until Sync Settings plugin is installed.
   1. Run Tools / Command Palette… (`ctrl+shift+p`) / Sync Settings: Download (or just type `download` and press `Enter`). Ignore warning message(s).
   1. Note: You may need to run the Download command again for theme to take effect.
 - Global Vim plugins are not installed
   1. `sudo vim`
   1. Hit enter as many times as requested until plugins are installed.
   1. Exit vim using `:q` (maybe two times).
 - Wireless mouse wakes up the computer.
   - *No sw solution found. Turn off your mouse physically if possible.*
 - Keyboard switching mismatch, similar to [a 18.04 bug](https://launchpad.net/bugs/1890875).
   - Reboot or re-login or restart gnome-shell with `killall -3 gnome-shell` or `Alt+F2`, type `r` and hit `Enter`.

## Howtos

 - [Manual partitioning during Ubuntu installation](https://askubuntu.com/questions/343268/how-to-use-manual-partitioning-during-installation)
 - [Change swap size](https://bogdancornianu.com/change-swap-size-in-ubuntu/)
 - [Move home to external partition](https://www.tecmint.com/move-home-directory-to-new-partition-disk-in-linux/)
 - [Set default audio device](https://askubuntu.com/questions/1038490/how-do-you-set-a-default-audio-output-device-in-ubuntu-18-04)
 - [Make login screen appear in external display](https://askubuntu.com/questions/1043337/is-there-to-make-the-login-screen-appear-on-the-external-display-in-18-04)
 - [Transfer audio from PC to iPhone](https://www.groovypost.com/howto/howto/sync-your-iphone-or-ipod-touch-in-ubuntu/)
 - [Enable SSH server](https://linuxize.com/post/how-to-enable-ssh-on-ubuntu-18-04/)
 - [Compose key cheet sheet](https://tuttle.github.io/python-useful/compose-key-cheat-sheet.html)
 - [Change compose key](https://askubuntu.com/questions/70784/how-can-i-enable-compose-key)
 - [Change font size](https://help.ubuntu.com/stable/ubuntu-help/a11y.html.en)
 - [Chrome streamkeys extension](https://chrome.google.com/webstore/detail/streamkeys/ekpipjofdicppbepocohdlgenahaneen)
 - [Grant And Remove Sudo Privileges](https://ostechnix.com/how-to-grant-and-remove-sudo-privileges-to-users-on-ubuntu/)
 - [Internal Microphone Not Working](https://askubuntu.com/questions/6993/internal-microphone-not-working)
 - [MPV keyboard shortcuts](https://mpv.io/manual/master/#keyboard-control)

## Suggestions

 - [x] Shortcut to turn off the screen with no lock and no suspend.
 - [x] Do nothing when lid is closed.
 - [ ] Configuration override option, e.g. favorites, variety.
