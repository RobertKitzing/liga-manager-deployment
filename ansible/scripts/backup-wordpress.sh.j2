#!/usr/bin/env bash
set -e

RETENTION_DAYS=90
BACKUP_DIRECTORY=$(docker volume inspect --format '{{.Mountpoint}}' "liga-manager_backups")
WP_FILES_DIRECTORY=$(docker volume inspect --format '{{.Mountpoint}}' "liga-manager_wp-files")

case $1 in
  "create")
    find "$BACKUP_DIRECTORY" -mtime +$RETENTION_DAYS -type f -name 'wordpress-db-*.sql.gz' -delete
    find "$BACKUP_DIRECTORY" -mtime +$RETENTION_DAYS -type f -name 'wp-files-*.tar.gz' -delete
    TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
    docker compose exec -T mariadb mysqldump --single-transaction wordpress | gzip > "$BACKUP_DIRECTORY/wordpress-db-$TIMESTAMP.sql.gz"
    tar -C "$WP_FILES_DIRECTORY" -czf "$BACKUP_DIRECTORY/wp-files-$TIMESTAMP.tar.gz" "."
    echo "Backup $TIMESTAMP has been created."
    ;;
  "list")
    cd "$BACKUP_DIRECTORY"
    ls -lh wordpress-db-*.sql.gz
    ls -lh wp-files-*.tar.gz
    ;;
  "restore")
    TIMESTAMP=$2
    zcat "$BACKUP_DIRECTORY/wordpress-db-$TIMESTAMP.sql.gz" | docker compose exec -T mariadb mysql wordpress
    tar -C "$WP_FILES_DIRECTORY" -xzf "$BACKUP_DIRECTORY/wp-files-$TIMESTAMP.tar.gz"
    echo "Backup $TIMESTAMP has been restored."
    ;;
  *)
    echo "Usage:"
    echo "$0 create"
    echo "$0 list"
    echo "$0 restore <timestamp>"
    ;;
esac
