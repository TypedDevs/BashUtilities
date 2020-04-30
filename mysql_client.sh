#!/bin/sh
CONTAINER_ID=$(grep -w MYSQL_HOST .env | cut -d '=' -f2)
MYSQL_USER=$(grep -w MYSQL_USER .env | cut -d '=' -f2)
MYSQL_PASSWD=$(grep -w MYSQL_PASSWD .env | cut -d '=' -f2)
MYSQL_DB=$(grep -w MYSQL_DB .env | cut -d '=' -f2)


docker exec -it $CONTAINER_ID mysql -u${MYSQL_USER} -p${MYSQL_PASSWD} $MYSQL_DB