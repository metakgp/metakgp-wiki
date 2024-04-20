#!/usr/bin/env bash

set -xe

echo "MetaMaint - Update MetaKGP demo day project"

cd /root/pywikibot
export METAKGP_BOT_NAME=batman
timeout 10s pwb login
timeout 30s pwb MetaMaint
