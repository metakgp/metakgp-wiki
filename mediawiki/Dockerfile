FROM php:8.2-fpm-bookworm

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
COPY install_extensions.sh post_install.sh /tmp/
COPY LocalSettings.php robots.txt /srv/mediawiki/
COPY assets/ resources/assets/
COPY gmconvert.sh /opt/

# Install composer for installing some extensions
RUN wget -cO - https://getcomposer.org/composer-2.phar > composer.phar
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_IGNORE_PLATFORM_REQS=1

# Install Mediawiki extensions
RUN /tmp/install_extensions.sh

# Create directories for image storage
RUN mkdir -p /srv/static/images && rm -rf images && ln -s /srv/static/images images
RUN mkdir -p images/temp

ENTRYPOINT /tmp/post_install.sh
