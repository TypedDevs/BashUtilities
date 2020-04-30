#!/bin/sh
# Getting .env values to use on the script
MYSQL_SCRIPT_DIR=$(grep -w MYSQL_SCRIPT_DIR .env | cut -d '=' -f2)
MYSQL_MIGRATION=$(grep -w MYSQL_MIGRATION .env | cut -d '=' -f2)

find $MYSQL_MIGRATION -type f -name "*.sql" | sort -n -k2 | xargs cat > ${MYSQL_SCRIPT_DIR}/migrations.sql