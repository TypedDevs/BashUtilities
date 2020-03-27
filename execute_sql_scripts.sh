#!/bin/sh
# Getting .env values to use on the script
CONTAINER_ID=$(grep MYSQL_HOST .env | cut -d '=' -f2)
MYSQL_ROOT_USER=$(grep MYSQL_ROOT_USER .env | cut -d '=' -f2)
MYSQL_ROOT_PASSWORD=$(grep MYSQL_ROOT_PASSWORD .env | cut -d '=' -f2)
MYSQL_DATABASE=$(grep MYSQL_DATABASE .env | cut -d '=' -f2)
MYSQL_SCRIPT_PATH=$(grep MYSQL_SCRIPT_PATH .env | cut -d '=' -f2)

echo "☢ Executing SQL migration"
echo "============================"
echo "📑 Copying sql file ${MYSQL_SCRIPT_PATH##*/} from $MYSQL_SCRIPT_PATH"
docker cp $MYSQL_SCRIPT_PATH $CONTAINER_ID:/${MYSQL_SCRIPT_PATH##*/}
echo "💾 Executing sql ${MYSQL_SCRIPT_PATH##*/}"
docker exec -i $CONTAINER_ID mysql  -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < $MYSQL_SCRIPT_PATH
echo "🗑 Deleting sql ${MYSQL_SCRIPT_PATH##*/}"
docker exec -it $CONTAINER_ID rm ${MYSQL_SCRIPT_PATH##*/}
