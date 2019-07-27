#!/usr/bin/env bash

set -xe

echo "Updating spam blacklist"

cd /tmp && rm -f /tmp/listed_ip_30_ipv46* && \
    wget -q https://www.stopforumspam.com/downloads/listed_ip_30_ipv46.zip \
    && unzip listed_ip_30_ipv46.zip -d listed_ip_30_ipv46 \
    && rm -rf /srv/mediawiki/extensions/StopForumSpam/listed_ip_30_ipv46 \
    && mv listed_ip_30_ipv46 /srv/mediawiki/extensions/StopForumSpam/ \
    && chown -R www-data:www-data /srv/mediawiki/extensions/StopForumSpam/listed_ip_30_ipv46
