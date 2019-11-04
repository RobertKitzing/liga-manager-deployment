#!/usr/bin/env bash
set -xe
docker-compose pull
docker-compose down -v --remove-orphans
docker-compose up -d
docker-compose exec api php vendor/bin/doctrine-migrations migrations:migrate -n

