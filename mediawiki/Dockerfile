FROM mediawiki:1.44-fpm

# Set work directory
WORKDIR /srv/mediawiki

# Install composer for installing some extensions
RUN apt-get update
# wget is also used by the install extension script
RUN apt-get install wget
RUN wget -cO - https://getcomposer.org/composer-2.phar > composer.phar
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_IGNORE_PLATFORM_REQS=1

# Install Mediawiki extensions
COPY scripts/install_extensions.sh /tmp/
RUN /tmp/install_extensions.sh

# Copy all source files
COPY LocalSettings.php robots.txt /srv/mediawiki/
COPY assets/ resources/assets/
COPY scripts/gmconvert.sh /opt/

# Create directories for image storage
RUN mkdir -p /srv/static/images && rm -rf images && ln -s /srv/static/images images
RUN mkdir -p images/temp

RUN chown -LR www-data:www-data /srv/mediawiki
### /INSTALLING MEDIAWIKI AND ITS EXTENSIONS ###

### RUNNING MEDIAWIKI ###
# Configure php extensions
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
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