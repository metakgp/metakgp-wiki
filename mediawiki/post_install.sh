#!/usr/bin/env bash

set -xe

cd /srv/mediawiki/maintenance && php update.php
chown -R www-data:www-data /srv/mediawiki
