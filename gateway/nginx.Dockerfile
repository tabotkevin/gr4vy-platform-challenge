FROM nginx
RUN rm /etc/nginx/conf.d/default.conf
COPY /gateway/nginx.conf /etc/nginx/conf.d/default.conf