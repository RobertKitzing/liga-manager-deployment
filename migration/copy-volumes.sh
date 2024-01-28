#!/usr/bin/env bash

set -ex

VOLUMES="certs mariadb wp-files"
for volume in $VOLUMES; do
  rsync -av \
    "root@165.22.89.194:/var/lib/docker/volumes/liga-manager_$volume/_data/" \
    "/var/lib/docker/volumes/liga-manager_$volume/_data/"
done