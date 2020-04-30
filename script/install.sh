#!/bin/sh

npm install;
npm audit fix;
./node_modules/.bin/cypress install;
apt-get update && apt-get install -y libgtk2.0-0 libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 xvfb;

return 0;
