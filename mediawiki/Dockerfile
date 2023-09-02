FROM php:8.2-fpm-bookworm

RUN apt-get -qq update && apt-get -qq install -y \
      git wget unzip

WORKDIR /tmp
RUN wget -q https://releases.wikimedia.org/mediawiki/1.40/mediawiki-1.40.0.tar.gz \
      && tar -xzf mediawiki-1.40.0.tar.gz \
      && mkdir -p /srv \
      && mv /tmp/mediawiki-1.40.0 /srv/mediawiki

COPY install_extensions.sh post_install.sh /tmp/
RUN /tmp/install_extensions.sh

COPY LocalSettings.php robots.txt /srv/mediawiki/

WORKDIR /srv/mediawiki

COPY extensions/ extensions/

ENV COMPOSER_ALLOW_SUPERUSER=1
RUN wget -cO - https://getcomposer.org/composer-2.phar > composer.phar
RUN php composer.phar --ignore-platform-req=ext-calendar --ignore-platform-req=ext-intl require mediawiki/maps
RUN php composer.phar --ignore-platform-req=ext-calendar --ignore-platform-req=ext-intl update

COPY assets/ resources/assets/

COPY gmconvert.sh /opt/

RUN mkdir -p /srv/static/images && rm -rf images && ln -s /srv/static/images images
RUN mkdir -p images/temp

ENTRYPOINT /tmp/post_install.sh
