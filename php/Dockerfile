FROM php:7-fpm
RUN apt-get -qq update && apt-get -qq install -y \
            build-essential \
            libfreetype6-dev \
            libjpeg62-turbo-dev \
            libpng-dev \
            libicu-dev \
            git-core \
            graphicsmagick \
      && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
      && docker-php-ext-install -j$(nproc) gd intl mysqli \
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
