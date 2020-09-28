#!/bin/bash
if [[ $(gsettings get org.gnome.settings-daemon.plugins.color night-light-enabled) == "true" ]]; then 
  if [[ $(gsettings get org.gnome.settings-daemon.plugins.color night-light-schedule-automatic) == "true" ]]; then
    notify-send "Night light enabled"
    gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic false
    gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 0
    gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 0
  else
    notify-send "Night light disabled"
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false
  fi
else
  notify-send "Night light automatic"
  gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
  gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true
  gsettings reset org.gnome.settings-daemon.plugins.color night-light-schedule-from
  gsettings reset org.gnome.settings-daemon.plugins.color night-light-schedule-to
fi
