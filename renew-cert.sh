#!/bin/bash
docker-compose stop nginx
docker run --rm -it -p 80:80 -p 443:443 -v /etc/letsencrypt:/etc/letsencrypt certbot/certbot renew --standalone
docker-compose start nginx
