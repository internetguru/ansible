# Internet Guru Ansible

> Handy ansible playbooks for multiple enviroments.

## Requirements

 - Ubuntu 20.04.1 LTS
  > <a href="https://releases.ubuntu.com/20.04/ubuntu-20.04.1-desktop-amd64.iso">download iso</a>
  
  > <a href="https://ubuntu.com/tutorials/create-a-usb-stick-on-ubuntu#1-overview">create a bootable USB stick on Ubuntu</a>
 - ansible
```
sudo apt install ansible
```

## Content

### <tt>fresh-env.yml</tt>

 - vim
 - curl
 - htop
 - git
 - mc
 - build-essential
 - net-tools
 - gettext
 - zsh
 - <a href="https://github.com/ohmyzsh/ohmyzsh">oh-my-zsh</a>
 - <a href="https://bitbucket.org/igwr/bashcfg">bashcfg</a>
 - <a href="https://github.com/petrzpav/vimrc">vimrc</a>

### <tt>server.yml</tt>

 - 2 GB swapfile in <tt>/root/swapfile</tt>
 - <a href="https://github.com/InternetGuru/ansible/blob/master/res/20-ig">Internet Guru motd</a>
 - ufw with basic rules

### <tt>ubuntu.yml</tt>

 - gnome-screensaver 
 - gnome-session
 - gnome-settings-daemon
 - gnome-tweaks
 - gnome-shell-extension-dash-to-panel
 - python3-pip
 - <a href="https://ulauncher.io/">ulauncher</a>
   - <a href="https://ext.ulauncher.io/-/github-katacarbix-ulauncher-dict-en">English dictionary extension</a>
   - <a href="https://ext.ulauncher.io/-/github-friday-ulauncher-gnome-settings">Gnome Settings</a>
   - <a href="https://ext.ulauncher.io/-/github-skeletonkey-ulauncher-zoom-join-meeting">Zoom - Join a meeting</a>
 - <a href="https://www.pinta-project.com/">pinta</a> (alternative to MS Paint)
 - <a href="https://github.com/rakshasa/rtorrent/wiki">rtorrent</a> (<a href="https://devhints.io/rtorrent">cheet sheet</a>)
 - <a href="https://github.com/rachmadaniHaryono/we-get">we-get</a>
 - <a href="https://wiki.gnome.org/Apps/Rhythmbox">rhythmbox</a>
 - <a href="https://www.videolan.org/vlc/index.html">vlc</a>
 - <a href="https://www.google.com/chrome/">chrome</a>
 - <a href="https://github.com/InternetGuru/ansible/blob/master/tasks/ubuntucfg.yml">system configuration</a>
 - <a href="https://github.com/InternetGuru/ansible/blob/master/tasks/ubuntukeys.yml">system keyboard shortcuts</a>

### <tt>ubuntu-dev.yml</tt>

 - java
 - php 7.4
 - <a href="https://www.virtualbox.org/">virtualbox</a>
 - <a href="https://www.docker.com/products/docker-app">docker</a>
 - <a href="https://slack.com/">slack</a>
 - <a href="https://code.visualstudio.com/">visual-studio-code</a> with <a href="https://gist.github.com/petrzpav/fd6f4ed38d22d4611e6f8a9e0c9e2801">shared settings</a>

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

## Default Shortcuts

 - <tt>Ctrl+Alt+h</tt> &#9;&#9;Display help dialog
 - <tt>Ctrl+Alt+s</tt> &#9;&#9;lock and sleep (suspend)
 - <tt>Ctrl+Alt+f</tt> &#9;&#9;screen off
 - <tt>Ctrl+Alt+l</tt> &#9;&#9;toggle night-light (on/off/auto)
 - <tt>Ctrl+Alt+End</tt> &#9;power off dialog

 - <tt>Ctrl+Shift+PgUp</tt> &#9;volume up
 - <tt>Ctrl+Shift+PgDown</tt> &#9;volume down
 - <tt>Ctrl+Shift+Del</tt> &#9;&#9;mute volume

 - <tt>Win+s</tt> &#9;application overview
 - <tt>Win+f</tt> &#9;Ulauncher (quick open apps)
 - <tt>Win+c</tt> &#9;calculator

 - <tt>Pause</tt>, <tt>Menu</tt> &#9;compose keys

## Known Issues

 - Unable to load VSC shared settings from ansible.
   > Open VSC, hit <tt>ctr+shift+p</tt>, type <tt>sync download</tt>, sign in to GitHub.
 - VSC toggle spellcheck (<tt>F6</tt>) not working without a workspace.
   > Open VSC, hit File / Add Folder to Workspace… and select a folder.

## Howtos

 - <a href="https://askubuntu.com/questions/343268/how-to-use-manual-partitioning-during-installation">How to use manual partitioning during installation</a>
 - <a href="https://bogdancornianu.com/change-swap-size-in-ubuntu/">Change swap size</a>
 - <a href="https://www.tecmint.com/move-home-directory-to-new-partition-disk-in-linux/">Move home to external partition</a>
 - <a href="https://askubuntu.com/questions/1038490/how-do-you-set-a-default-audio-output-device-in-ubuntu-18-04">Set default audio device</a>
 - <a href="https://askubuntu.com/questions/1043337/is-there-to-make-the-login-screen-appear-on-the-external-display-in-18-04">Make login screen appear in external display</a>
 - <a href="https://www.groovypost.com/howto/howto/sync-your-iphone-or-ipod-touch-in-ubuntu/">Transfer audio from PC to iPhone</a>
 - <a href="https://linuxize.com/post/how-to-enable-ssh-on-ubuntu-18-04/">Enable ssh server</a>
 - <a href="https://tuttle.github.io/python-useful/compose-key-cheat-sheet.html">Compose key cheet sheet</a>
 - <a href="https://askubuntu.com/questions/70784/how-can-i-enable-compose-key">Change compose key</a>

## Suggestions

 - [x] Shortcut to turn off the screen with no lock and no suspend.
 - [x] Ulauncher to <tt>win+s</tt>.
 - [x] Do nothing when lid is closed.
 - [x] Use Ulauncher instead of Appmenu (left ico button)
