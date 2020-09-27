#!/bin/sh

dockerd > /var/log/dockerd.log 2>&1 &
sleep 3
echo "Someones GETing at 4296"
exec $1
