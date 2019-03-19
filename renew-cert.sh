#!/bin/bash
docker-compose stop nginx
docker run --rm -p 80:80 -p 443:443 -v $PWD/volumes/letsencrypt:/etc/letsencrypt certbot/certbot renew --standalone
docker-compose start nginx
