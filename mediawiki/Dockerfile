FROM php:7-fpm

RUN apt-get -qq update && apt-get -qq install -y \
      git wget unzip

WORKDIR /tmp
RUN wget -q https://releases.wikimedia.org/mediawiki/1.28/mediawiki-1.28.2.tar.gz \
      && tar -xzf mediawiki-1.28.2.tar.gz \
      && mkdir -p /srv \
      && mv /tmp/mediawiki-1.28.2 /srv/mediawiki

COPY LocalSettings.php install_composer.sh composer.local.json /srv/mediawiki/

COPY install_extensions.sh post_install.sh /tmp/
RUN /tmp/install_extensions.sh

WORKDIR /srv/mediawiki

COPY extensions/ extensions/
RUN ./install_composer.sh \
      && php composer.phar update --no-dev --optimize-autoloader --no-suggest --no-progress

COPY assets/ resources/assets/
RUN mkdir -p images/temp

ENTRYPOINT /tmp/post_install.sh
