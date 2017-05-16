FROM debian:stretch-slim
WORKDIR /tmp
RUN apt-get update && apt-get install -y \
            wget
RUN wget https://releases.wikimedia.org/mediawiki/1.28/mediawiki-1.28.2.tar.gz \
      && tar -xvzf mediawiki-1.28.2.tar.gz \
      && mkdir -p /srv \
      && mv /tmp/mediawiki-1.28.2 /srv/mediawiki \
      && ls -lh /srv/mediawiki \
      && rm -rf /tmp/* \
      && chown -R www-data:www-data /srv/mediawiki
COPY LocalSettings.php /srv/mediawiki/
