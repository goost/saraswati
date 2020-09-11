#!/bin/bash

generate_password() {
  local length=32
  local re='^[0-9]+$'
  if [[ $1 =~ re  ]] ; then
    local length=$1
  fi
  echo $(cat /dev/urandom | tr -dc a-zA-Z0-9 | head -c$length)
}

set -e
echo "Enter an eMail address for Let's Encrypt certificate generation."
echo "(Only a minimal validity check is performed.)"
read -e email_address
jwt_secret="$(generate_password)"

quick_email_regex="(.+)@(.+)\.(.+)"
if [[ $email_address =~ $quick_email_regex ]] ; then
    echo "Using email:" $email_address
else
    echo "The address should at least have a '@' and a domain at the end!\nPlease restart the configuration." >&2
    exit 1
fi
read -ep "Enter domain of server (proceed with 'example.com' if none provided): " domain
session_secret="$(generate_password)"

if [[ $domain == "" ]]; then
  domain="example.com"
fi

read -ep "Configure as production environment (Y/n)? " production
postgres_pw="$(generate_password)"

if [[ $production != "n" ]]; then
  production=y
  letsencrypt_staging='#'
else
  letsencrypt_staging=''
fi

#TODO (glost) Proper TZ customization, extract secrets to docker secure file + ENV vars
sed -i "s/<REPLACE_DOMAIN>/$domain/g" {authelia/docker-compose.yml,authelia/config/configuration.yml,authelia/config/users_database.yml,traefik/docker-compose.yml}
sed -i "s/<REPLACE_EMAIL>/$email_address/g" {authelia/config/configuration.yml,authelia/config/users_database.yml,traefik/docker-compose.yml}
sed -i "s/<REPLACE_LETSE>/$letsencrypt_staging/g" traefik/docker-compose.yml

mkdir -p authelia/secrets
echo $jwt_secret > authelia/secrets/jwt
echo $session_secret > authelia/secrets/session
echo $postgres_pw > authelia/secrets/postgres

mkdir -p traefik/mount
touch traefik/mount/acme.json
chmod 600 traefik/mount/acme.json

docker network create docker-net-proxy