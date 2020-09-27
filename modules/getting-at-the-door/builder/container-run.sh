#!/bin/sh

dockerd > /var/log/dockerd.log 2>&1 &
sleep 2

# pull inner images
cd /tmp
docker build -t unsuspicious-image .

# dockerd cleanup (remove the .pid file as otherwise it prevents
# dockerd from launching correctly inside sys container)
kill $(cat /var/run/docker.pid)
kill $(cat /run/docker/containerd/containerd.pid)
rm -f /var/run/docker.pid
rm -f /run/docker/containerd/containerd.pid