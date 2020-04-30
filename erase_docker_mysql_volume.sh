#!/bin/sh
# Getting .env values to use on the script
CONTAINER_ID=$(grep MYSQL_SERVICE_NAME .env | cut -d '=' -f2)

docker-compose stop $CONTAINER_ID
docker-compose rm -f $CONTAINER_ID
sudo rm -rf data/db