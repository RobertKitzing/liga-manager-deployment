#!/usr/bin/env bash
# This script is supposed to be run as root on the target host
set -ex

SSH_ARGS="-i /root/.ssh/migration_key root@157.230.106.170"
TEMP_FILE="$(mktemp)"

# Determine latest backups
ssh $SSH_ARGS sh -s > "$TEMP_FILE" <<EOF
  cd /opt/liga-manager
  ls -t backup/wp-files*.tar.gz | head -n 1
  ls -t backup/wordpress*.sql.gz | head -n 1
  ls -t backup/api*.sql.gz | head -n 1
EOF

# Transfer latest backups
while read -r BACKUP_FILE; do
  scp $SSH_ARGS:"/opt/liga-manager/$BACKUP_FILE" /tmp/
done < "$TEMP_FILE"

# Restore backups on target host
zcat /tmp/api*.sql.gz | docker compose exec -T mariadb mysql lima
zcat /tmp/wordpress*.sql.gz | docker compose exec -T mariadb mysql wordpress
tar xfz /tmp/wp-files*.tar.gz -C /var/lib/docker/volumes/liga-manager_wp-files/_data --strip-components 2

# Cleanup
rm /tmp/api*.sql.gz /tmp/wordpress*.sql.gz /tmp/wp-files*.tar.gz "$TEMP_FILE"
