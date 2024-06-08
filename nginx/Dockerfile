FROM nginx:mainline

# Configure IST Timezone
ENV TZ="Asia/Kolkata"

# Set up local nginx server
COPY nginx.conf /etc/nginx/
RUN rm /etc/nginx/conf.d/default.conf

# Run a postinstall script that configures metaploy
COPY wiki.metaploy.conf /etc/nginx/sites-enabled/
COPY postinstall.sh /

CMD ["/postinstall.sh", "nginx", "-g", "daemon off;"]