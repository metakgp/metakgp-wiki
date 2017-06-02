#!/usr/bin/env bash

set -xe

declare -a extensions=( \
    WikimediaMessages-REL1_28-d742c36 \
    Scribunto-REL1_28-a665621 \
    Echo-REL1_28-f55bdd9 \
    googleAnalytics-REL1_28-6dd4ae5 \
    MobileFrontend-REL1_28-a0c8024 \
    ContributionScores-REL1_28-703f4f3 \
    CommonsMetadata-REL1_28-e3c0bbe \
    MultimediaViewer-REL1_28-b426dc3 \
    SandboxLink-REL1_28-aa109b7 \
    Nuke-REL1_28-b617001 \
)

cd /tmp
for extension in "${extensions[@]}"; do
    IFS=- read extension_name _ <<< "$extension"
    wget -q "https://extdist.wmflabs.org/dist/extensions/$extension.tar.gz"
    tar -xzf "$extension.tar.gz"
    mv $extension_name /srv/mediawiki/extensions/
done

# Get RecentPages from Github
wget -q https://github.com/leucosticte/RecentPages/archive/master.zip \
    && unzip master.zip -d RecentPages \
    && mv RecentPages/RecentPages-master /srv/mediawiki/extensions/RecentPages

# Make Lua executable
chmod a+x /srv/mediawiki/extensions/Scribunto/engines/LuaStandalone/binaries/lua5_1_5_linux_64_generic/lua
