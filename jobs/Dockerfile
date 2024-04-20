FROM python:3-slim

RUN apt-get update && apt-get install -y wget curl logrotate default-mysql-client

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

COPY requirements.txt ./
RUN pip install -qr requirements.txt

RUN mkdir pywikibot/
COPY pywikibot ./pywikibot

COPY crontab update_top_trending.sh MetaMaint.sh update_spam_denylist.sh logrotate.conf ./
RUN chmod 644 logrotate.conf && groupadd -g 999 mysql && useradd mysql -u 999 -g 999

COPY backup/ ./backup

CMD ["supercronic", "/root/crontab"]
