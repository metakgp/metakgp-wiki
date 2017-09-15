FROM python:2

RUN apt-get -qq update && apt-get install -qq -y \
      wget

WORKDIR /root
RUN wget -qO- http://tools.wmflabs.org/pywikibot/core.tar.gz | tar xz \
      && mv core pywikibot \
      && pip install -q requests

COPY scripts/* pywikibot/scripts/
COPY user-config.py user-password.py pywikibot/
COPY metakgp_family.py pywikibot/pywikibot/families/
