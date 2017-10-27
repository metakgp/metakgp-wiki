#!/usr/bin/env bash

set -xe

source .env
NGINX_CONTAINER=$(docker ps --format '{{ .Names }}' | grep nginx)
docker cp $1/. $NGINX_CONTAINER:/srv/static
