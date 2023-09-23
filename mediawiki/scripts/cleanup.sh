#!/bin/bash

cleanup() {
	echo "Container stopped. Removing nginx configuration."
	rm /etc/nginx/sites-enabled/wiki.metaploy.conf
}

trap 'cleanup' SIGQUIT

"${@}" &

wait $!