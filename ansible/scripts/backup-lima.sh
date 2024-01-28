#!/usr/bin/env bash

set -e

RETENTION_DAYS=90
BACKUP_DIRECTORY=$(docker volume inspect --format '{{.Mountpoint}}' "liga-manager_backups")
LOGOS_DIRECTORY=$(docker volume inspect --format '{{.Mountpoint}}' "liga-manager_logos")

case $1 in
  "create")
    find "$BACKUP_DIRECTORY" -mtime +$RETENTION_DAYS -type f -name 'lima-db-*.sql.gz' -delete
    find "$BACKUP_DIRECTORY" -mtime +$RETENTION_DAYS -type f -name 'lima-logos-*.tar.gz' -delete
    TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
    docker compose exec -T mariadb mysqldump --single-transaction lima | gzip > "$BACKUP_DIRECTORY/lima-db-$TIMESTAMP.sql.gz"
    tar -C "$LOGOS_DIRECTORY" -czf "$BACKUP_DIRECTORY/lima-logos-$TIMESTAMP.tar.gz" "."
    echo "Backup $TIMESTAMP has been created."
    ;;
  "list")
    cd "$BACKUP_DIRECTORY"
    ls -lh lima-db-*.sql.gz
    ls -lh lima-logos-*.tar.gz
    ;;
  "restore")
    TIMESTAMP=$2
    zcat "$BACKUP_DIRECTORY/lima-db-$TIMESTAMP.sql.gz" | docker compose exec -T mariadb mysql lima
    tar -C "$LOGOS_DIRECTORY" -xzf "$BACKUP_DIRECTORY/lima-logos-$TIMESTAMP.tar.gz"
    echo "Backup $TIMESTAMP has been restored."
    ;;
  *)
    echo "Usage:"
    echo "$0 create"
    echo "$0 list"
    echo "$0 restore <timestamp>"
    ;;
esac
