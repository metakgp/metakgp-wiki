FROM python:3-slim

RUN apt-get update && apt-get install -y wget curl logrotate default-mysql-client

ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install https://github.com/aptible/supercronic as a cron replacement
# Latest releases available at https://github.com/aptible/supercronic/releases
# Each release also contains a sample Dockerfile
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.34/supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=e8631edc1775000d119b70fd40339a7238eece14 \
    SUPERCRONIC=supercronic-linux-amd64

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

WORKDIR /root

COPY requirements.txt ./
RUN pip install -qr requirements.txt

COPY pywikibot ./pywikibot

COPY crontab update_top_trending.sh MetaMaint.sh update_spam_denylist.sh logrotate.conf ./
RUN chmod 644 logrotate.conf && groupadd mysql && useradd mysql -g mysql

COPY backup/ ./backup

CMD ["/usr/local/bin/supercronic", "/root/crontab"]
