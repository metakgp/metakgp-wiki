#!/usr/bin/env bash

set -xe

source .env
MYSQL_CONTAINER=$(docker ps --format '{{ .Names }}' | grep mysql)
docker cp $1 $MYSQL_CONTAINER:metakgp_wiki_db.sql
docker exec $MYSQL_CONTAINER sh -c 'mysql -u metakgp_user -p'$MYSQL_PASSWORD' metakgp_wiki_db < metakgp_wiki_db.sql'
