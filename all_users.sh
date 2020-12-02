#!/bin/bash

for user in $(getent passwd {1000..2000} | cut -d: -f1); do
  echo "User: [$user]"
  echo "Command: [$1]"
  eval "$1"
done
