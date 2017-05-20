#!/usr/bin/env bash

set -xe

cd /srv/mediawiki/maintainence && php update.php
chown -R www-data:www-data /srv/mediawiki
