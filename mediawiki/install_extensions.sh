#!/usr/bin/env bash

set -xe

declare -a extension_names=( \
    AbuseFilter \
    CheckUser \
    CommonsMetadata \
    ContributionScores \
    Echo \
    MobileFrontend \
    MultimediaViewer \
    SandboxLink \
    Scribunto \
    WikimediaMessages \
    googleAnalytics \
)

MEDIAWIKI_RELEASE=REL1_29

function fetch_extension_url() {
    curl -s "https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=$1&extdistversion=$MEDIAWIKI_RELEASE" \
        | grep -oP 'https://extdist.wmflabs.org/dist/extensions/.*?.tar.gz' \
        | head -1
}

cd /tmp
for extension_name in "${extension_names[@]}"; do
    versioned_extension_url=$(fetch_extension_url $extension_name)
    versioned_extension_name=$(echo $versioned_extension_url | awk -F"/" '{print $(NF)}')
    wget -q $versioned_extension_url
    tar -xzf "$versioned_extension_name"
    mv $extension_name /srv/mediawiki/extensions/
done

# Get RecentPages from Github
wget -q https://github.com/leucosticte/RecentPages/archive/master.zip \
    && unzip master.zip -d RecentPages \
    && mv RecentPages/RecentPages-master /srv/mediawiki/extensions/RecentPages

# Make Lua executable
chmod a+x /srv/mediawiki/extensions/Scribunto/engines/LuaStandalone/binaries/lua5_1_5_linux_64_generic/lua
