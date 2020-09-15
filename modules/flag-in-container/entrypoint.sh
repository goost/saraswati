#!/bin/sh

dockerd > /var/log/dockerd.log 2>&1 &
sleep 3
docker run -d unsuspicious-image > /dev/null
echo "Find the flag in the container."
exec $1
