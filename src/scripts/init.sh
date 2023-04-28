#!/bin/bash

URL=$(cat ../public/.env | grep APP_URL | cut -f 2 -d '=')
DB_STRING=$(cat ../public/.env | grep DATABASE_URL | cut -f 2 -d '=')
sed -i '' -e 's|'"prod"'|'"dev"'|g' ../public/.env
sed -i '' -e 's|'"$DB_STRING"'|'"mysql://root:v399efJP@sw6-mysql:3306/sw6"'|g' ../public/.env
sed -i '' -e 's|'"$URL"'|'"http://sw6.local"'|g' ../public/.env
sed -i '' -e 's|'"TRUSTED_PROXIES=127.0.0.1,127.0.0.2,172.19.0.22"'|'"#TRUSTED_PROXIES=127.0.0.1,127.0.0.2,172.19.0.22"'|g' ../public/.env
docker exec -i sw6-shop /var/www/html/bin/console theme:compile
