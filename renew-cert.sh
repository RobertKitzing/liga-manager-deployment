#!/bin/bash
docker-compose exec -T nginx sh -c "apk add certbot certbot-nginx"
docker-compose exec -T nginx sh -c "certbot --nginx renew"

