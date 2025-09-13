FROM mediawiki:1.44-fpm

# Move the mediawiki installation
RUN mv /var/www/html /srv/mediawiki
RUN chown -LR www-data:www-data /srv/mediawiki

# Set work directory
WORKDIR /srv/mediawiki

# Install dependencies used elsewhere
RUN apt-get update
RUN apt-get install -y zip unzip build-essential \
	git-core gnupg2 \
	graphicsmagick imagemagick libfreetype-dev \
	libicu-dev libjpeg62-turbo-dev libpng-dev \
	wget

# Install php extensions
RUN pear install Numbers_Words-beta
RUN docker-php-ext-install -j$(nproc) gd

# Install composer for installing some extensions
COPY scripts/installation/install_composer.sh /tmp/
RUN /tmp/install_composer.sh

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_IGNORE_PLATFORM_REQS=1

# Install Mediawiki extensions
COPY scripts/installation/install_extdist_extensions.sh /tmp/
RUN /tmp/install_extdist_extensions.sh

COPY scripts/installation/install_composer_extensions.sh /tmp/
RUN /tmp/install_composer_extensions.sh

COPY scripts/installation/install_github_extensions.sh /tmp/
RUN /tmp/install_github_extensions.sh

# Download an IP denylist for StopForumSpam extension
COPY scripts/installation/install_ip_denylist.sh /tmp/
RUN /tmp/install_ip_denylist.sh

# Copy all source files
COPY LocalSettings.php robots.txt /srv/mediawiki/
COPY assets/ resources/assets/
COPY scripts/gmconvert.sh /opt/

# Create directories for image storage
RUN mkdir -p /srv/static/images && rm -rf images && ln -s /srv/static/images images
RUN mkdir -p images/temp

RUN chown -LR www-data:www-data /srv/mediawiki

# Remove all temporary files
RUN rm -r /tmp/*

# Configure php extensions
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/

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