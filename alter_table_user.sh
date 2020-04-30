#!/bin/sh

MYSQL_USER=$(grep -w MYSQL_USER .env | cut -d '=' -f2)
MYSQL_PASSWD=$(grep -w MYSQL_PASSWD .env | cut -d '=' -f2)
MYSQL_MIGRATION=$(grep -w MYSQL_MIGRATION .env | cut -d '=' -f2)

echo "⚒ Creating Alter table to fix MySQL 8 probles with auth"
echo "============================"
echo "📑 Creating Alter table ${MYSQL_MIGRATION}/0_alter_user.sql"
echo "ALTER USER '${MYSQL_USER}'@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASSWD}';" > ${MYSQL_MIGRATION}/0_alter_user.sql;
echo "flush privileges;" >>${MYSQL_MIGRATION}/0_alter_user.sql;