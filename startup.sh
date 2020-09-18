#!/bin/sh
echo ">>> Starting all containers with compose files..."
for parentDir in $PWD/authentification $PWD/modules
do
  cd $parentDir
  for dir in $(ls -d $PWD/*/)
  do
    cd $dir
    echo "Starting ${PWD##*/}"
    docker-compose build --pull > /dev/null 2>&1 ;  docker-compose pull > /dev/null 2>&1 ; docker-compose up -d > /dev/null 2>&1
  done
done
echo ">>> Done."
