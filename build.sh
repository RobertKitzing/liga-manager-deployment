#!/bin/bash

docker build -f api/docker/php/Dockerfile -t ligamanager/php .
cd ui
docker build -f Dockerfile -t ligamanager/ui:prod .
