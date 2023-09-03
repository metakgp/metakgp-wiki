FROM python:3-slim

RUN apt-get -qq update && apt-get install -qq -y \
      wget

ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install https://github.com/aptible/supercronic as a cron replacement
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.26/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=7a79496cf8ad899b99a719355d4db27422396735

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

WORKDIR /root
RUN wget -qO- http://tools.wmflabs.org/pywikibot/core.tar.gz | tar xz \
      && mv core pywikibot

COPY requirements.txt ./
RUN pip install -qr requirements.txt

COPY pywikibot/user-config.py pywikibot/user-password.py pywikibot/
COPY pywikibot/metakgp_family.py pywikibot/pywikibot/families/
COPY pywikibot/scripts/ pywikibot/scripts/

COPY crontab update_top_trending.sh MetaMaint.sh update_spam_blacklist.sh ./

CMD ["supercronic", "/root/crontab"]
