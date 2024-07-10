#!/usr/bin/env bash

set -xe

echo "Updating Top and Trending Pages"

cd /root/pywikibot
export METAKGP_BOT_NAME=batman
timeout 10s pwb login
timeout 30s pwb updatestatistics
