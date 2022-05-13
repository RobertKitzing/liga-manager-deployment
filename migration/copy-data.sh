#!/usr/bin/env bash
# This script is supposed to be run as root on the target host
set -ex

SSH_ARGS="-i /root/.ssh/migration_key root@157.230.106.170"

# Determine latest backups
BACKUP_FILES=$(ssh $SSH_ARGS sh -s <<EOF
  find /opt/liga-manager/backup -type f -name 'api*.sql.gz' | sort -r | head -n 1
  find /opt/liga-manager/backup -type f -name 'wordpress*.sql.gz' | sort -r | head -n 1
  find /opt/liga-manager/backup -type f -name 'wp-files*.tar.gz' | sort -r | head -n 1
EOF
)

# Transfer latest backups
for BACKUP_FILE in $BACKUP_FILES
do
  scp $SSH_ARGS:$BACKUP_FILE /tmp/
done

# Restore backups on target host
zcat /tmp/api*.sql.gz | docker compose exec -T mariadb mysql lima
zcat /tmp/wordpress*.sql.gz | docker compose exec -T mariadb mysql wordpress
tar xfz /tmp/wp-files*.tar.gz -C /var/lib/docker/volumes/liga-manager_wp-files/_data --strip-components 2

# Cleanup
rm /tmp/api*.sql.gz /tmp/wordpress*.sql.gz /tmp/wp-files*.tar.gz
