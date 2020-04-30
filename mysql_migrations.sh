CONTAINER_ID=$(grep -w MYSQL_HOST .env | cut -d '=' -f2)
MYSQL_USER=$(grep -w MYSQL_USER .env | cut -d '=' -f2)
MYSQL_PASSWD=$(grep -w MYSQL_PASSWD .env | cut -d '=' -f2)
MYSQL_DB=$(grep -w MYSQL_DB .env | cut -d '=' -f2)
MYSQL_SCRIPT_PATH=$(grep -w MYSQL_SCRIPT_MIGRATIONS .env | cut -d '=' -f2)
MYSQL_SCRIPT_DIR=$(grep -w MYSQL_SCRIPT_DIR .env | cut -d '=' -f2)


echo "☢ Executing SQL migration"
echo "============================"
echo "📑 Copying sql file ${MYSQL_SCRIPT_PATH##*/} from $MYSQL_SCRIPT_PATH"

docker cp $MYSQL_SCRIPT_PATH $CONTAINER_ID:$MYSQL_SCRIPT_DIR
echo "💾 Executing sql ${MYSQL_SCRIPT_PATH##*/}"
docker exec -i $CONTAINER_ID mysql -u${MYSQL_USER} -p${MYSQL_PASSWD} $MYSQL_DB < $MYSQL_SCRIPT_PATH