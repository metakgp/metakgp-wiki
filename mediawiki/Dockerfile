FROM php:8.2-fpm-bookworm

# Update the system
RUN apt-get -qq update && apt-get -qq install -y \
      git wget unzip

# Install mediawiki
WORKDIR /tmp
RUN wget -q https://releases.wikimedia.org/mediawiki/1.40/mediawiki-1.40.0.tar.gz \
      && tar -xzf mediawiki-1.40.0.tar.gz \
      && mkdir -p /srv \
      && mv /tmp/mediawiki-1.40.0 /srv/mediawiki

WORKDIR /srv/mediawiki

# Copy all source files
COPY install_extensions.sh post_install.sh /tmp/
COPY LocalSettings.php robots.txt /srv/mediawiki/
COPY extensions/ extensions/
COPY assets/ resources/assets/
COPY gmconvert.sh /opt/

# Install composer for installing some extensions
RUN wget -cO - https://getcomposer.org/composer-2.phar > composer.phar
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_IGNORE_PLATFORM_REQS=1

# Install Mediawiki extensions
RUN /tmp/install_extensions.sh

RUN php composer.phar --ignore-platform-req=ext-calendar --ignore-platform-req=ext-intl require mediawiki/maps mediawiki/simple-batch-upload
RUN php composer.phar --ignore-platform-req=ext-calendar --ignore-platform-req=ext-intl update

# Create directories for image storage
RUN mkdir -p /srv/static/images && rm -rf images && ln -s /srv/static/images images
RUN mkdir -p images/temp

ENTRYPOINT /tmp/post_install.sh
