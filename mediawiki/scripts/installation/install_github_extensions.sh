#!/usr/bin/env bash
set -e

# Install extensions on Github

# Install SlackNotifications extension
pushd /tmp
curl -sLO https://github.com/metakgp/SlackNotifications/archive/master.zip

unzip master.zip
mv SlackNotifications-master/ /srv/mediawiki/extensions/SlackNotifications/
popd