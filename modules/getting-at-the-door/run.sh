#!/bin/sh
name=$(cat /dev/urandom | tr -dc a-zA-Z0-9 | head -c8)
docker-compose -f /docker-compose.yml -p $name up -d
docker-compose -f /docker-compose.yml -p $name exec webshell
docker-compose -f /docker-compose.yml -p $name down
