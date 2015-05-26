FROM debian:jessie

MAINTAINER Cristian Lucchesi "cristian.lucchesi@gmail.com"

RUN echo "deb http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list && \
    echo "deb-src http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list
    
RUN apt-get update && \
    apt-get install -y dpkg-dev wget git

RUN wget http://nginx.org/keys/nginx_signing.key && \ 
    apt-key add nginx_signing.key && \
    apt-get update
    
RUN mkdir /opt/rebuildnginx && mkdir /opt/rebuildnginx/debs && \
    cd /opt/rebuildnginx && \
    apt-get source nginx && apt-get build-dep -y nginx && \
    git clone https://github.com/nginx-shib/nginx-http-shibboleth.git && \
	wget 'https://github.com/openresty/headers-more-nginx-module/archive/v0.26.tar.gz' && \
	tar -xzvf v0.26.tar.gz
    
#RUN dpkg-buildpackage -b
#RUN apt-get install vim
    #rm -rf /var/lib/apt/lists/* && \

WORKDIR /opt/rebuildnginx/nginx-1.8.0

COPY buildpackage.sh /opt/rebuildnginx/nginx-1.8.0/
RUN sed -i 's,--with-ipv6,--with-ipv6 --add-module=/opt/rebuildnginx/nginx-http-shibboleth --add-module=/opt/rebuildnginx/headers-more-nginx-module-0.26,g' debian/rules

VOLUME ["/opt/rebuildnginx"]

CMD ["sh", "buildpackage.sh"]