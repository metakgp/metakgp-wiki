FROM node:8-jessie
RUN apt-get -qq update && apt-get -qq install -y \
            git-core

RUN useradd --create-home --shell /bin/bash parsoid
USER parsoid
WORKDIR /home/parsoid

RUN git clone https://gerrit.wikimedia.org/r/p/mediawiki/services/parsoid && \
    cd parsoid && \
    git checkout v0.8.1 && \
    npm install

WORKDIR /home/parsoid/parsoid
COPY config.yaml ./
CMD ["npm", "start"]
