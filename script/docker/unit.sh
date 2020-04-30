#!/bin/sh

# Getting .env values to use on the script
CONTAINER_ID=$(grep NODE_CONTAINER_NAME .env | cut -d '=' -f2);

docker exec -it $CONTAINER_ID ./node_modules/.bin/vue-cli-service test:unit $@

return 0;
