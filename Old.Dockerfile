FROM alpine:3.19

RUN apk --no-cache --update \
    add apache2 \
    apache2-ssl \
    curl \
	php83-apache2 \
    php83-bcmath \
    php83-bz2 \
    php83-calendar \
    php83-common \
    php83-ctype \
    php83-curl \
    php83-dom \
    php83-gd \
    php83-iconv \
    php83-mbstring \
    php83-mysqli \
    php83-mysqlnd \
    php83-openssl \
    php83-pdo_mysql \
    php83-pdo_pgsql \
    php83-pdo_sqlite \
    php83-phar \
    php83-session \
    php83-xml \
	nano \
	wget \
	git \
    php83-tokenizer \
    php83-json \
    php83-zip \
    php83-intl \
    php83-mbstring \
    php83-gettext \
    php83-exif \
	php83-pear \
	php83-dev \
	gcc \
	musl-dev \
	make \
	php83-pecl-redis \
	php83-pecl-xdebug
	
	

# RUN apk add --update --no-cache --virtual .build-deps ${PHPIZE_DEPS} \
#   && pecl install xdebug \
#   && docker-php-ext-enable xdebug \
#   && apk del .build-deps
  
# RUN mkdir -p /usr/src/php/ext/xdebug \
#    && curl -fsSL https://pecl.php.net/get/xdebug | tar xvz -C "/usr/src/php/ext/xdebug" --strip 1 \
#    && docker-php-ext-install xdebug
  
# RUN pecl install xdebug && \
# 	docker-php-ext-enable xdebug
	
# Install redis
#RUN pecl install redis-5.1.1 && \
#    docker-php-ext-enable redis


RUN apk --no-cache  \
	--update \
	add libxml2-dev \
	shadow \
	autoconf \
	g++
RUN apk --no-cache --update add imagemagick-dev imagemagick libjpeg-turbo libgomp freetype-dev \
    php83-pecl-imagick

# Enable apache modules
# RUN a2enmod rewrite headers	
# RUN echo "LoadModule rewrite_module modules/mod_rewrite.so" >> /etc/httpd/conf/httpd.conf
# RUN ls /etc/apache/conf


# COPY ./vhosts/default.conf /etc/apache2/sites-enabled
COPY ./php/php.ini /usr/local/etc/php/php.ini
COPY ./php/ixed.8.3.lin /var/www/html/ixed.8.3.lin
COPY ./www/perm.sh /var/www/html/perm.sh

RUN mkdir /var/www/html/dss
COPY ./dss/index.php /var/www/html/dss/index.php

expose 8081 8443

ENTRYPOINT ["/perm.sh"]



