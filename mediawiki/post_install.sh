#!/usr/bin/env bash

set -xe

# TODO figure out when to run
# cd /srv/mediawiki/maintenance && php update.php
chown -LR www-data:www-data /srv/mediawiki
