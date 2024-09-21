# Internet Guru Ansible

This project contains handy ansible playbooks divided into several environments. It installs 'global' tag globally and 'user' tag for all accounts individually. Roles are installed for each playbook if the same playbook file exists with a `roles.` prefix, e.g. `roles.ubuntu.yml` for `ubuntu.yml`.

 - [Options](#options)
 - [Requirements](#requirements)
 - [Setup Guide](#setup-guide)
 - [Environments](#environments)
 - [Shortcuts](#shortcuts)
 - [Troubleshooting](#troubleshooting)
 - [Howtos](#howtos)

## Options

 - `-s|--skip-global` Skip tasks with 'global' tag.
 - `-f|--force` Install tasks with 'force' tag.

## Requirements

 - Ubuntu 24.04.1 LTS
   - [Download ISO](https://cz.releases.ubuntu.com/24.04.1/ubuntu-24.04.1-desktop-amd64.iso)
   - [Create a bootable USB stick on Ubuntu](https://ubuntu.com/tutorials/create-a-usb-stick-on-ubuntu#1-overview)
 - Ansible
 - Git

## Setup Guide

This is a complete simple use-case on how to install basic environments on a *fresh Ubuntu 24 installation*. To update or sync after adding a new user account, repeat the very same process.

1. Install updates and required packages. \
Note: The last command will reboot the computer, which may or may not be necessary.

   ```
   sudo apt update
   sudo apt upgrade -y
   sudo apt install ansible git -y
   sudo reboot
   ```

2. Clone or update Ansible project. \
This command either creates a new global repository or updates the existing one.

   ```
   sudo mkdir -p /usr/local/share/ansible/
   cd /usr/local/share/ansible
   sudo git clone https://github.com/internetguru/ansible.git . \
     || sudo git pull
   ```

3. Install Ansible for all users. \
See the commented optional command and notice another reboot command.

   ```
   cd /usr/local/share/ansible
   # sudo git checkout dev
   sudo ./install.sh fresh.yml ubuntu.yml
   sudo reboot
   ```

## Environments

### `fresh.yml`

Installs essential commands and CLI environment for Debian/Ubuntu.

 - vim
 - curl
 - htop
 - git
 - mc
 - build-essential
 - net-tools
 - gettext
 - tree
 - tldr
 - avahi-daemon
<!-- break -->
 - [bashcfg](https://bitbucket.org/igwr/bashcfg)
 - [fonts-firacode](https://github.com/tonsky/FiraCode)
 - [starship prompt](https://starship.rs/)
 - [vimrc](https://github.com/petrzpav/vimrc)
<!-- break -->
 - Set keep alive SSH
 - Disable wayland

### `server.yml`

> Sets up Internet Guru server environment.

 - 2 GB swapfile in `/root/swapfile`
 - [Internet Guru MOTD](https://github.com/internetguru/ansible/blob/master/res/20-ig)
 - ufw with basic rules

### `ubuntu.yml`

Enables Windows-like panel and adds practical programs, scripts and adjustments for *Ubuntu*. It also adds basic developer programs and tools.

 - gnome-screensaver
 - gnome-session
 - gnome-settings-daemon
 - gnome-tweaks
<!-- break -->
 - [keepass](https://keepass.info/)
 - [kolourpaint](https://apps.kde.org/kolourpaint/) (alternative to MS Paint)
 - [mpv](https://mpv.io/)
 - [rhythmbox](https://wiki.gnome.org/Apps/Rhythmbox)
 - [rtorrent](https://github.com/rakshasa/rtorrent/wiki) ([cheat sheet](https://devhints.io/rtorrent))
 - [shellcheck](https://www.shellcheck.net/)
 - [variety](https://peterlevi.com/variety) with awesome background sources!
 - [wmctrl](https://linux.die.net/man/1/wmctrl)
<!-- break -->
 - [dash-to-panel](https://github.com/home-sweet-gnome/dash-to-panel.git)
 - [google-chrome](https://www.google.com/chrome/)
   - chrome-remote-desktop
   - set as default browser
 - [zoom](https://zoom.us/)
<!-- break -->
 - [butt](https://github.com/internetguru/butt)
 - [cursor](https://cursor.sh/)
 - [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy)
 - [docker](https://www.docker.com/products/docker-app)
 - [flow](https://github.com/internetguru/flow)
 - [gnome-boxes](https://apps.gnome.org/en-GB/app/org.gnome.Boxes/)
 - [slack](https://slack.com/)
 - [sublime-text](https://www.sublimetext.com/3) with [shared settings](https://gist.github.com/petrzpav/abf3fa8890a04fd5dedb0dd20711f042)
 - [teamviewer](https://www.teamviewer.com/en-us)
 - [vscode](https://code.visualstudio.com/)
<!-- break -->
 - java
 - php
 - nodejs
 - python3
 - docker
 - `~/work` folder with various format file names touched
 - [system configuration](https://github.com/internetguru/ansible/blob/master/tasks/ubuntucfg.yml)
 - [system keyboard shortcuts](https://github.com/internetguru/ansible/blob/master/tasks/ubuntukeys.yml)
 - [date-menu-formatter
 - night light control script
 - default favorites
 - ubuntu-drivers autoinstall

### `clear.yml`

Clears previously installed applications and configuration that has been withdrawn.

- [code](https://code.visualstudio.com/)
- [fish](https://fishshell.com/)
- [vlc](https://www.videolan.org/vlc/)
<!-- break -->
- /usr/local/share/.oh-my-zsh
<!-- break -->
- ~/.ansible
- ~/bashcfg
- ~/butt
- ~/omgf
- ~/vimrc
- ~/zshrc
- ~/.zsh_history
- ~/.zshrc
- ~/.zshrc.local

## Shortcuts

 - `Ctrl+Alt+i` display README of installed version
 - `Ctrl+Alt+s` lock and sleep (suspend)
 - `Ctrl+Alt+f` screen off
 - `Ctrl+Alt+l` toggle night-light (on/off/auto)
 - `Ctrl+Alt+End` power off dialog
 - `Alt+Shift+End` restart dialog
<!-- break -->
 - `Ctrl+Shift+PageUp` volume up
 - `Ctrl+Shift+PageDown` volume down
 - `Ctrl+Shift+Delete` mute volume
 - `Ctrl+Shift+Insert` play/pause media
 - `Ctrl+Shift+End` next track
 - `Ctrl+Shift+Home` previous track
<!-- break -->
 - `Win+a` application overview
 - `Win+c` calculator
<!-- break -->
 - `Pause`, `Menu` compose keys

## Troubleshooting

 - *"Unknown error when attempting to call Galaxy"*
   - Check your internet connection and run Ansible again.
 - *"already installed"* warnings
   - *Ignore.*
 - Sublime Text not downloading shared settings after installation.
   1. Open Sublime Text.
   1. Run Tools / Command Pallette… (`ctrl+shift+p`) / Install Package Control (or just type `ipc` and press `Enter`).
   1. Restart (close and run) Sublime, wait until Sync Settings plugin is installed.
   1. Run Tools / Command Palette… (`ctrl+shift+p`) / Sync Settings: Download (or just type `download` and press `Enter`). Ignore warning message(s).
   1. Note: You may need to run the Download command again for theme to take effect.
 - Visual Studio Code setup shared settings after installation.
   1. Install [Sync Settings](https://marketplace.visualstudio.com/items?itemName=zokugun.sync-settings) extension.
   1. Open Command Palette (`ctrl+shift+p`) and type `Sync Settings: Open the repository settings`.
   1. Update settings to match following:
      ```yaml
      hostname: "" # add your hostname here
      profile: main
      repository:
        type: git
        url: git@github.com:petrzpav/vscode-settings.git
        branch: master
      ```
   1. Save the file and close it.
   1. Open Command Palette (`ctrl+shift+p`) and type `Sync Settings: Download (repository -> user)`.
   1. Restart Visual Studio Code.
   1. To upload new settings, run `Sync Settings: Upload (user -> repository)`.
 - Global Vim plugins are not installed
   1. `sudo vim`
   1. Hit Enter repeatedly, until installation starts.
   1. After installation finishes, hit Enter again.
   1. Exit vim using `:q` two times.
 - Unable to launch Ansible info desktop icon.
   - Right click on the icon and click on *Allow Launching*.
 - Docker is not running error.
   - If works for `sudo`, try adding user to docker group with `sudo usermod -aG docker $USER`.

## Howtos

 - [Change compose key](https://askubuntu.com/questions/70784/how-can-i-enable-compose-key)
 - [Change font size](https://help.ubuntu.com/stable/ubuntu-help/a11y.html.en)
 - [Change swap size](https://bogdancornianu.com/change-swap-size-in-ubuntu/)
 - [Compose key cheat sheet](https://tuttle.github.io/python-useful/compose-key-cheat-sheet.html)
 - [Enable SSH server](https://linuxize.com/post/how-to-enable-ssh-on-ubuntu-18-04/)
 - [Grant And Remove Sudo Privileges](https://ostechnix.com/how-to-grant-and-remove-sudo-privileges-to-users-on-ubuntu/)
 - [How to Install Ubuntu 24.04 Desktop](https://ubuntuhandbook.org/index.php/2024/04/install-ubuntu-24-04-desktop/).
 - [Internal Microphone Not Working](https://askubuntu.com/questions/6993/internal-microphone-not-working)
 - [Make login screen appear in external display](https://askubuntu.com/questions/1043337/is-there-to-make-the-login-screen-appear-on-the-external-display-in-18-04)
 - [Manual partitioning during Ubuntu installation](https://askubuntu.com/questions/343268/how-to-use-manual-partitioning-during-installation)
 - [Move home to external partition](https://www.tecmint.com/move-home-directory-to-new-partition-disk-in-linux/)
 - [MPV keyboard shortcuts](https://mpv.io/manual/master/#keyboard-control)
 - [Saving Docker Container Image to a Different Directory Than Root](https://stackoverflow.com/questions/56964447/saving-docker-container-image-to-a-different-directory-than-root)
 - [Set default audio device](https://askubuntu.com/questions/1038490/how-do-you-set-a-default-audio-output-device-in-ubuntu-18-04)
 - [Transfer audio from PC to iPhone](https://www.groovypost.com/howto/howto/sync-your-iphone-or-ipod-touch-in-ubuntu/)

 ## Copyright

 Copyright © [Internet Guru](https://www.internetguru.io)

 This software is licensed under the CC BY-NC-SA license. There is NO WARRANTY, to the extent permitted by law. See the [LICENSE](LICENSE) file.

 For commercial use, a nominal fee may be applicable based on the company size and the nature of their product. In many instances, this could result in no fees being charged at all. Please contact us at info@internetguru.io for further information.

 Please do not hesitate to reach out to us for inquiries related to seminars, workshops, training, integration, support, custom development, and additional services. We are more than happy to assist you.
