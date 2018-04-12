#!/usr/bin/env bash

set -xe

echo "MetaMaint - Update MetaKGP demo day project"

cd /root/pywikibot
export METAKGP_BOT_NAME=batman
timeout 10s python pwb.py login
timeout 30s python pwb.py MetaMaint
