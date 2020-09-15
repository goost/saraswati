#!/bin/sh
echo ">>> Starting all containers with compose files..."
for parentDir in $PWD/authentification $PWD/modules
do
  cd $parentDir
  for dir in $(ls -d $PWD/*/)
  do
    cd $dir
    docker-compose build --pull 2> /dev/null &&  docker-compose pull &&  docker-compose up -d
  done
done
echo ">>> Done."
