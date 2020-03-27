#!/bin/sh
exitfn () {
    trap SIGINT
    echo;
    docker-compose down;
    exit 0;
}
trap "exitfn" INT
docker-compose up -d && npm run database_migration && npm install && npm audit fix  && npm run development
