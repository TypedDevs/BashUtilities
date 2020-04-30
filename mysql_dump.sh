#!/bin/sh
# Getting .env values to use on the script
CONTAINER_ID=$(grep -w MYSQL_SERVICE_NAME .env | cut -d '=' -f2)
MYSQL_USER=$(grep -w MYSQL_USER .env | cut -d '=' -f2)
MYSQL_PASSWD=$(grep -w MYSQL_PASSWD .env | cut -d '=' -f2)
MYSQL_SCRIPT_PATH=$(grep -w MYSQL_SCRIPT_PATH .env | cut -d '=' -f2)

docker-compose exec -T ${CONTAINER_ID} mysqldump -e --all-databases -u${MYSQL_USER} -p${MYSQL_PASSWD} > ${MYSQL_SCRIPT_PATH}