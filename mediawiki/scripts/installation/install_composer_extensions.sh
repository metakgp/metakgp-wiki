#!/usr/bin/env bash
set -e

# Installs extensions using PHP Composer: https://getcomposer.org

declare -a composer_extension_names=( \
    mediawiki/maps \
    mediawiki/simple-batch-upload \
)

php composer.phar config --no-plugins allow-plugins.composer/installers true

for extension_name in "${composer_extension_names[@]}"; do
    php composer.phar require "${extension_name}"
done
php composer.phar update