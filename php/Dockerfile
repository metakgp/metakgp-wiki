FROM php:8.2-fpm-bookworm

# Install dependencies
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
      wget
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd intl mysqli opcache
RUN pecl install apcu
RUN docker-php-ext-enable apcu
RUN pear install Numbers_Words-beta

# Configure timezone
ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Copy PHP config
COPY php.ini /usr/local/etc/php/

# Create directories for logs and set permissions
RUN mkdir -p /var/log/mediawiki
RUN touch /var/log/mediawiki/debug.log
RUN chown -R www-data:www-data /var/log/mediawiki

VOLUME /var/log