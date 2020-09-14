#!/bin/sh

dockerd > /var/log/dockerd.log 2>&1 &
sleep 3
exec $1
