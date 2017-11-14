FROM nginx:mainline
COPY wiki.metakgp.org /etc/nginx/sites-enabled/
COPY static.metakgp.org /etc/nginx/sites-enabled/
COPY nginx.conf /etc/nginx/
RUN rm /etc/nginx/conf.d/default.conf
