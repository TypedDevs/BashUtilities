#!/bin/sh
sed 's/=.*/=/' .env > .env.example;
return 0;
