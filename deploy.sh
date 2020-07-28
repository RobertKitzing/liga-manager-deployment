#!/usr/bin/env bash
set -xe
docker-compose pull
docker-compose down
docker-compose up -d

