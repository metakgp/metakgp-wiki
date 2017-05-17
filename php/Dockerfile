FROM php:7-fpm
RUN apt-get update && apt-get install -y \
            build-essential \
            libfreetype6-dev \
            libjpeg62-turbo-dev \
            libpng12-dev \
            libicu-dev \
            git-core \
            graphicsmagick \
      && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
      && docker-php-ext-install -j$(nproc) gd intl mysqli \
      && pecl install apcu \
      && docker-php-ext-enable apcu \
      && apt-get purge
COPY php.ini /usr/local/etc/php/
