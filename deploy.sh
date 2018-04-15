#!/usr/bin/env bash
set -xe
docker-compose pull
docker-compose down -v
docker-compose up -d

