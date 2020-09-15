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
echo "====================================================================="
echo "    Starting configuration of Saraswati Authentification containers."
echo "====================================================================="

echo ">>> Enter an eMail address for Let's Encrypt certificate generation."
echo ">>> (Only a minimal validity check is performed.)"
read -e email_address
jwt_secret="$(generate_password)"

quick_email_regex="(.+)@(.+)\.(.+)"
if [[ $email_address =~ $quick_email_regex ]] ; then
    echo ">>> Using email:" $email_address
else
    echo ">>> The address should at least have a '@' and a domain at the end!\nPlease restart the configuration." >&2
    exit 1
fi
echo ">>> Enter domain of server (proceed with 'example.com' if none provided): "
read -e domain
session_secret="$(generate_password)"

if [[ $domain == "" ]]; then
  domain="example.com"
fi

read -ep ">>> Configure as production environment (Y/n)? " production
postgres_pw="$(generate_password)"

if [[ $production != "n" ]]; then
  production=y
  letsencrypt_staging='#'
else
  letsencrypt_staging=''
fi

echo ">>> Updating files with provided data..."
#TODO (glost) Proper TZ customization, extract secrets to docker secure file + ENV vars
sed -i "s/<REPLACE_DOMAIN>/$domain/g" {authentification/authelia/docker-compose.yml,authentification/authelia/config/configuration.yml,authentification/authelia/config/users_database.yml,authentification/traefik/docker-compose.yml,modules/flag-in-container/docker-compose.yml}
sed -i "s/<REPLACE_EMAIL>/$email_address/g" {authentification/authelia/config/configuration.yml,authentification/authelia/config/users_database.yml,authentification/traefik/docker-compose.yml}
sed -i "s/<REPLACE_LETSE>/$letsencrypt_staging/g" authentification/traefik/docker-compose.yml
authelia_admin_pw=$(generate_password 25)
authelia_admin_pw_hash=$(docker run --rm --runtime runc authelia/authelia authelia hash-password "$authelia_admin_pw" | grep -Po "Password hash:\s\K.*$")
#Source: https://unix.stackexchange.com/questions/486131/ask-sed-to-ignore-all-special-characters
authelia_admin_pw_hash="$(<<< "$authelia_admin_pw_hash" sed -e 's`[][\\/.*^$]`\\&`g')"
sed -i "s/<REPLACE_ADMIN_PW>/$authelia_admin_pw_hash/g" authentification/authelia/config/users_database.yml

mkdir -p authentification/authelia/secrets
echo $jwt_secret > authentification/authelia/secrets/jwt
echo $session_secret > authentification/authelia/secrets/session
echo $postgres_pw > authentification/authelia/secrets/postgres

mkdir -p authentification/traefik/mount
touch authentification/traefik/mount/acme.json
chmod 600 authentification/traefik/mount/acme.json

echo ">>> Creating docker network"
docker network create docker-net-proxy > /dev/null

echo ">>> Configuration completed."
echo ">>> Admin username/password is:"
echo "saraswati:"$authelia_admin_pw
echo ">>> Please remember this as they cannot be shown again!"
echo ">>> If you wish to change those or add additional users, please modify"
echo "~/saraswati/authentification/authelia/config/user_database.yml"