#!/usr/bin/env bash

set -xe

echo "Updating spam denylist"

pushd /tmp
wget https://www.stopforumspam.com/downloads/listed_ip_30_all.zip

unzip listed_ip_30_all.zip
mv listed_ip_30_all.txt /srv/mediawiki/extensions/StopForumSpam/
popd
