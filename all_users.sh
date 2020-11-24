#!/bin/bash

for user in $(getent passwd {1000..2000} | cut -d: -f1); do
  sudo -H -u "$user" bash -c "${1:-}";
done
