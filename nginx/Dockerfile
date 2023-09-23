FROM nginx:mainline
COPY wiki.metakgp.org /etc/nginx/sites-enabled/
# COPY static.metakgp.org /etc/nginx/sites-enabled/
# COPY gyft.metakgp.org /etc/nginx/sites-enabled/
# COPY wimp.metakgp.org /etc/nginx/sites-enabled/
COPY nginx.conf /etc/nginx/
RUN rm /etc/nginx/conf.d/default.conf
