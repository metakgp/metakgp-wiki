#!/usr/bin/env bash
set -e

# Download an IP denylist for the StopForumSpam extension
pushd /tmp
curl -O https://www.stopforumspam.com/downloads/listed_ip_30_all.zip

unzip listed_ip_30_all.zip
mv listed_ip_30_all.txt /srv/mediawiki/extensions/StopForumSpam/
popd