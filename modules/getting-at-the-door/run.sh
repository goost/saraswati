#!/bin/sh
name=$(cat /dev/urandom | tr -dc a-zA-Z0-9 | head -c8)
mkdir -p /tmp/$name
cd /tmp/$name
cat > docker-compose.yml << EOF
services:
  webshell:
    restart: "no"
    image: modules/getting-at-the-door
    entrypoint: ['tail', '-f', '/dev/null']
    depends_on:
      - getter

  getter:
    image: alpine
    runtime: runc
    restart: "no"
    entrypoint: ['sh', '-c', 'while true ; do wget -O- webshell:4296/?flag[3x73rn4l_kn0ck!ng] ; sleep 5 ; done']
EOF
# TODO (glost) Ressources are not cleaned up
trap 'docker-compose down ; cd / ; rm -rf /tmp/$name' 1 3 9
docker-compose up -d
docker-compose exec webshell /usr/bin/entrypoint.sh sh
#docker-compose down
#cd /
#rm -rf /tmp/$name
