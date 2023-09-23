FROM php:8.2-fpm-bookworm

### INSTALLING MEDIAWIKI AND ITS EXTENSIONS ###
# Install tools and dependencies
RUN apt-get update && apt-get install -y git wget unzip

# Install mediawiki
WORKDIR /tmp
RUN wget -q https://releases.wikimedia.org/mediawiki/1.40/mediawiki-1.40.0.tar.gz
RUN tar -xzf mediawiki-1.40.0.tar.gz
RUN mkdir -p /srv
RUN mv /tmp/mediawiki-1.40.0 /srv/mediawiki

# Set work directory
WORKDIR /srv/mediawiki

# Copy all source files
COPY scripts/install_extensions.sh /tmp/
COPY LocalSettings.php robots.txt /srv/mediawiki/
COPY assets/ resources/assets/
COPY scripts/gmconvert.sh /opt/

# Install composer for installing some extensions
RUN wget -cO - https://getcomposer.org/composer-2.phar > composer.phar
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_IGNORE_PLATFORM_REQS=1

# Install Mediawiki extensions
RUN /tmp/install_extensions.sh

# Create directories for image storage
RUN mkdir -p /srv/static/images && rm -rf images && ln -s /srv/static/images images
RUN mkdir -p images/temp

RUN chown -LR www-data:www-data /srv/mediawiki
### /INSTALLING MEDIAWIKI AND ITS EXTENSIONS ###

### RUNNING MEDIAWIKI ###
# Install extensions required for the wiki runtime
RUN apt-get update
RUN apt-get install -y build-essential git-core gnupg2 \
	graphicsmagick imagemagick libfreetype6-dev \
	libicu-dev libjpeg62-turbo-dev libpng-dev \
	wget

# Install other php extensions
RUN pecl install apcu
RUN pear install Numbers_Words-beta

# Configure php extensions
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd intl mysqli opcache
RUN docker-php-ext-enable apcu

# Configure timezone
ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Create directories for logs and set permissions
RUN mkdir -p /var/log/mediawiki
RUN touch /var/log/mediawiki/debug.log
RUN chown -R www-data:www-data /var/log/mediawiki

VOLUME /var/log
### /RUNNING MEDIAWIKI ###

### CONFIGURING NGINX ###
COPY wiki.metaploy.conf /etc/nginx/sites-enabled/
# Cleanup script removes the nginx config when stopped
COPY scripts/cleanup.sh /

CMD [ "/cleanup.sh php-fpm" ]
### /CONFIGURING NGINX ###