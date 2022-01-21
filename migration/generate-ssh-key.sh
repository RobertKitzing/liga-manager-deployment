#!/usr/bin/env bash
# This script is supposed to be run as root on the target host
set -ex

mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keygen -t ed25519 -f ~/.ssh/migration_key -N ""
cat ~/.ssh/migration_key.pub
