#!/usr/bin/env bash

set -xe

MEDIAWIKI_RELEASE=REL1_40

# Install extensions from extension distributor
declare -a extension_names=( \
    ArticleFeedbackv5 \
    CheckUser \
    CommonsMetadata \
    ContributionScores \
    MobileFrontend \
    SandboxLink \
    StopForumSpam \
    WikimediaMessages \
    SimpleChanges \
    SlackNotifications \
)

function fetch_extension_url() {
    curl -s "https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=$1&extdistversion=$2" \
        | grep -oP 'https://extdist.wmflabs.org/dist/extensions/.*?.tar.gz' \
        | head -1
}

function fetch_skin_url() {
    curl -s "https://www.mediawiki.org/wiki/Special:SkinDistributor?extdistname=$1&extdistversion=$2" \
        | grep -oP 'https://extdist.wmflabs.org/dist/skins/.*?.tar.gz' \
        | head -1
}

pushd /tmp
for extension_name in "${extension_names[@]}"; do
    version=$MEDIAWIKI_RELEASE
    versioned_extension_url=$(fetch_extension_url $extension_name $version)
    versioned_extension_name=$(echo $versioned_extension_url | awk -F"/" '{print $(NF)}')

    wget -q $versioned_extension_url
    tar -xzf "$versioned_extension_name"
    mv $extension_name /srv/mediawiki/extensions/
done
popd

# Install extensions from composer
declare -a composer_extension_names=( \
    mediawiki/maps \
    mediawiki/simple-batch-upload \
)

for extension_name in "${composer_extension_names[@]}"; do
    php composer.phar require "${extension_name}"
done
php composer.phar update