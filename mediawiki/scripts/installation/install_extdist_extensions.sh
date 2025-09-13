#!/usr/bin/env bash
set -e

# Installs all extensions available on the extension distributor: https://www.mediawiki.org/wiki/Special:ExtensionDistributor

MEDIAWIKI_RELEASE="REL$(echo $MEDIAWIKI_MAJOR_VERSION | tr . _)"

declare -a extension_names=( \
    CommonsMetadata \
    ContributionScores \
    MobileFrontend \
    SandboxLink \
    StopForumSpam \
    WikimediaMessages \
    NewestPages \
    googleAnalytics \
)

function fetch_extension_url() {
    url_page=$(curl -s "https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=$1&extdistversion=$2")

    if [[ "$!" != "0" ]];
    then
        echo $url_page | grep -oP 'https://extdist.wmflabs.org/dist/extensions/.*?.tar.gz' | head -1
    else
        echo "Extension version page download failed. Retrying in 1s." >&2
        sleep 1

        fetch_extension_url "$@"
    fi
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

    curl -qO $versioned_extension_url
    tar -xzf "$versioned_extension_name"
    mv $extension_name /srv/mediawiki/extensions/
done
popd