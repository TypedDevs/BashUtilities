#!/bin/sh
echo "$(id -un)-$(ps ax | grep $$ | grep -v grep | awk '{ print $2 }')-$(id)-$(date +%s%N)-$(head /dev/urandom | LC_CTYPE=C tr -dc '[:alnum:]' | head -c 2048 ; echo $(dd if=/dev/urandom bs=1k count=1 2>/dev/null))" | base64
