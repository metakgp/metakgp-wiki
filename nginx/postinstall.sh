#!/bin/bash

cleanup() {
	echo "Container stopped. Removing nginx configuration."
	rm /etc/nginx/sites-enabled/wiki.metaploy.conf
}

trap 'cleanup' SIGQUIT

"${@}" &

cp /wiki.metaploy.conf /etc/nginx/sites-enabled
cp /static.metaploy.conf /etc/nginx/sites-enabled

wait $!
