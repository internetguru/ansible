#!/bin/bash

for user in $(getent passwd {1000..2000} | cut -d: -f1); do
  eval "$1"
done
