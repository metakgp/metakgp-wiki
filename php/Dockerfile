FROM php:8.2-fpm-bookworm
RUN apt-get -qq update && apt-get -qq install -y \
            build-essential \
            git-core \
            gnupg2 \
            graphicsmagick \
            imagemagick \
            libfreetype6-dev \
            libicu-dev \
            libjpeg62-turbo-dev \
            libpng-dev \
            wget \
      && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
      && docker-php-ext-install -j$(nproc) gd intl mysqli opcache \
      && pecl install apcu \
      && docker-php-ext-enable apcu \
      && pear install Numbers_Words-beta \
      && apt-get purge

ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY php.ini /usr/local/etc/php/

RUN mkdir -p /var/log/mediawiki \
      && touch /var/log/mediawiki/debug.log \
      && chown -R www-data:www-data /var/log/mediawiki
VOLUME /var/log
