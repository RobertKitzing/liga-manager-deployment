#!/usr/bin/env bash
# This script is supposed to be run as root on the target host
set -ex

rsync -vrltD -e "ssh -i /root/.ssh/migration_key" --chmod=ugo=rwX \
  root@157.230.106.170:/opt/liga-manager/volumes/letsencrypt/ \
  /var/lib/docker/volumes/liga-manager_certs/_data/
