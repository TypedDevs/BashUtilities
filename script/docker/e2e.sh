#!/bin/sh

# Getting .env values to use on the script
CONTAINER_ID=$(grep NODE_CONTAINER_NAME .env | cut -d '=' -f2);

docker exec -it $CONTAINER_ID ./node_modules/.bin/cypress install;
docker exec -it $CONTAINER_ID apt-get update && apt-get install -y libgtk2.0-0 libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 xvfb;
docker exec -it $CONTAINER_ID ./node_modules/.bin/vue-cli-service test:e2e $@;

return 0;
