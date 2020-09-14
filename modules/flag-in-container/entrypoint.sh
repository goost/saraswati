#!/bin/sh

service docker start
sleep 2
exec $1
