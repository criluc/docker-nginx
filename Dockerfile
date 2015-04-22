FROM debian:wheezy

MAINTAINER Cristian Lucchesi "cristian.lucchesi@gmail.com"

ENV NGINX_VERSION 1.8.0-1~wheezy

COPY nginx_${NGINX_VERSION}_amd64.deb .

RUN apt-get update && \ 
    apt-get install -y adduser libpcre3 libxml2 libssl1.0.0 sysv-rc && \
    dpkg -i debian/wheezy/nginx_${NGINX_VERSION}_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
