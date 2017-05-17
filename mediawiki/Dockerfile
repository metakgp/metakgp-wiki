FROM debian:stretch-slim
WORKDIR /tmp
RUN apt-get update && apt-get install -y \
      wget unzip
RUN wget https://releases.wikimedia.org/mediawiki/1.28/mediawiki-1.28.2.tar.gz \
      && tar -xvzf mediawiki-1.28.2.tar.gz \
      && mkdir -p /srv \
      && mv /tmp/mediawiki-1.28.2 /srv/mediawiki
COPY LocalSettings.php /srv/mediawiki/
RUN wget https://extdist.wmflabs.org/dist/extensions/WikimediaMessages-REL1_28-d742c36.tar.gz \
      && tar -xvzf WikimediaMessages-REL1_28-d742c36.tar.gz \
      && mv WikimediaMessages /srv/mediawiki/extensions/ \
      \
      && wget https://extdist.wmflabs.org/dist/extensions/Scribunto-REL1_28-a665621.tar.gz \
      && tar -xvzf Scribunto-REL1_28-a665621.tar.gz \
      && mv Scribunto /srv/mediawiki/extensions \
      && chmod a+x /srv/mediawiki/extensions/Scribunto/engines/LuaStandalone/binaries/lua5_1_5_linux_64_generic/lua \
      \
      && wget https://github.com/leucosticte/RecentPages/archive/master.zip \
      && unzip master.zip -d RecentPages \
      && mv RecentPages/RecentPages-master /srv/mediawiki/extensions/RecentPages
COPY assets/* /srv/mediawiki/resources/assets/
ENTRYPOINT chown -R www-data:www-data /srv/mediawiki
