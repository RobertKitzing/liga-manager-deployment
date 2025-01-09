#!/bin/bash
set -ex

cd /opt/liga-manager

docker compose down
echo '{ "live-restore": true, "userns-remap": "default" }' > /etc/docker/daemon.json
echo 'dockremap:100000:65536' > /etc/subuid
echo 'dockremap:100000:65536' > /etc/subgid
systemctl restart docker

mv "/var/lib/docker/volumes/liga-manager_certs" "/var/lib/docker/100000.100000/volumes/liga-manager_certs"
chown -R 100000:100000 /var/lib/docker/100000.100000/volumes/liga-manager_certs/_data
mv "/var/lib/docker/volumes/liga-manager_logos" "/var/lib/docker/100000.100000/volumes/liga-manager_logos"
chown -R 100082:100082 /var/lib/docker/100000.100000/volumes/liga-manager_logos/_data
mv "/var/lib/docker/volumes/liga-manager_mariadb" "/var/lib/docker/100000.100000/volumes/liga-manager_mariadb"
chown -R 100999:100999 /var/lib/docker/100000.100000/volumes/liga-manager_mariadb/_data
mv "/var/lib/docker/volumes/liga-manager_wp-files" "/var/lib/docker/100000.100000/volumes/liga-manager_wp-files"
chown -R 100082:100082 /var/lib/docker/100000.100000/volumes/liga-manager_wp-files/_data

docker compose up -d
