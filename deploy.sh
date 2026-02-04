#!/usr/bin/env sh
set -eu

wait_healthy() {
  set +e
  container="$1"
  rc=""
  while [ "$rc" != "0" ]; do
    sleep 5
    podman healthcheck run "$container"
    rc=$?
  done
  set -e
}

# Redis
echo "Stopping Redis"
podman rm -f redis || true
podman create \
  --hostname redis \
  --name redis \
  --network custom \
  --health-cmd "CMD redis-cli PING" \
  --restart always \
  redis:8-alpine
echo "Starting Redis"
podman start redis
wait_healthy redis
echo "Redis is healthy"

# MariaDB
echo "Stopping MariaDB"
podman rm -f mariadb || true
podman create \
  --hostname mariadb \
  --name mariadb \
  --network custom \
  --health-cmd "CMD healthcheck.sh --connect --innodb_initialized" \
  --restart always \
  --secret root-db-password \
  --env "MARIADB_ROOT_PASSWORD_FILE=/run/secrets/root-db-password" \
  --volume "mariadb:/var/lib/mysql" \
  --volume "/etc/mariadb/mariadb.cnf:/etc/mysql/mariadb.conf.d/99-custom.cnf:ro" \
  mariadb:11.8
echo "Starting MariaDB"
podman start mariadb
wait_healthy mariadb
echo "MariaDB is healthy"

# Wordpress
echo "Stopping Wordpress"
podman rm -f wordpress || true
podman create \
  --hostname wordpress \
  --name wordpress \
  --network custom \
  --health-cmd "CMD nc -z 127.0.0.1 9000" \
  --restart always \
  --secret wordpress-db-password \
  --env "WORDPRESS_DB_HOST=mariadb" \
  --env "WORDPRESS_DB_USER=wordpress" \
  --env "WORDPRESS_DB_PASSWORD_FILE=/run/secrets/wordpress-db-password" \
  --volume "/etc/wordpress/php-fpm.conf:/usr/local/etc/php-fpm.d/www.conf:ro" \
  --volume "/etc/wordpress/php.ini:/usr/local/etc/php/php.ini:ro" \
  wordpress:6.8-php8.4-fpm-alpine
echo "Starting Wordpress"
podman start wordpress
wait_healthy wordpress
echo "Wordpress is healthy"

# Imgproxy
echo "Stopping imgproxy"
podman rm -f imgproxy || true
podman create \
  --hostname imgproxy \
  --name imgproxy \
  --network custom \
  --health-cmd "CMD imgproxy health" \
  --restart always \
  --env "IMGPROXY_USE_ETAG=false" \
  --env "IMGPROXY_AUTO_AVIF=true" \
  --env "IMGPROXY_AUTO_WEBP=true" \
  ghcr.io/imgproxy/imgproxy:latest
echo "Starting imgproxy"
podman start imgproxy
wait_healthy "imgproxy"
echo "imgproxy is healthy"

# Nginx
echo "Stopping Nginx"
podman rm -f nginx || true
podman create \
  --hostname nginx \
  --name nginx \
  --network custom \
  --health-cmd "CMD nc -z 127.0.0.1 80" \
  --restart always \
  --publish "80:80/tcp" \
  --publish "443:443/tcp" \
  --publish "443:443/udp" \
  nginx:1-alpine
echo "Starting Nginx"
podman start nginx
wait_healthy nginx
echo "Nginx is healthy"

echo "Deployment finished"