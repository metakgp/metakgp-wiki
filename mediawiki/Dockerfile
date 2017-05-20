FROM debian:jessie

RUN apt-get update && apt-get install -y \
      wget unzip

WORKDIR /tmp
RUN wget -q https://releases.wikimedia.org/mediawiki/1.28/mediawiki-1.28.2.tar.gz \
      && tar -xzf mediawiki-1.28.2.tar.gz \
      && mkdir -p /srv \
      && mv /tmp/mediawiki-1.28.2 /srv/mediawiki
COPY LocalSettings.php /srv/mediawiki/

COPY install_extensions.sh post_install.sh /tmp/
RUN /tmp/install_extensions.sh

COPY assets/* /srv/mediawiki/resources/assets/
RUN mkdir -p /srv/mediawiki/images/temp

ENTRYPOINT /tmp/post_install.sh
