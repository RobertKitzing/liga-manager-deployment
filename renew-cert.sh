#!/bin/bash
docker-compose exec nginx sh -c "apk add certbot certbot-nginx"
docker-compose exec nginx sh -c "certbot --nginx renew"

