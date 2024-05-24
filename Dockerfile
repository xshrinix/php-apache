FROM php:8.2-apache


# Surpresses debconf complaints of trying to install apt packages interactively
# https://github.com/moby/moby/issues/4032#issuecomment-192327844
ARG DEBIAN_FRONTEND=noninteractive


# Update
RUN apt-get -y update --fix-missing && \
    apt-get upgrade -y && \
    apt-get --no-install-recommends install -y apt-utils && \
    rm -rf /var/lib/apt/lists/*


# Install useful tools and install important libaries
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install nano wget \
dialog \
libsqlite3-dev \
libsqlite3-0 && \
    apt-get -y --no-install-recommends install default-mysql-client \
zlib1g-dev \
libzip-dev \
libicu-dev && \
    apt-get -y --no-install-recommends install --fix-missing apt-utils \
build-essential \
git \
curl \
libonig-dev && \ 
    apt-get -y --no-install-recommends install --fix-missing libcurl4 \
libcurl4-openssl-dev \
zip \
openssl && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install xdebug
RUN pecl install xdebug-3.3.2 && \
    docker-php-ext-enable xdebug

# Install redis
RUN pecl install redis-6.0.2 && \
    docker-php-ext-enable redis

# Install imagick
RUN apt-get update && \
    apt-get -y --no-install-recommends install --fix-missing libmagickwand-dev && \
    rm -rf /var/lib/apt/lists/* && \
    pecl install imagick && \
    docker-php-ext-enable imagick

# Other PHP7 Extensions

RUN docker-php-ext-install pdo_mysql && \
docker-php-ext-install pdo_sqlite && \
docker-php-ext-install mysqli && \
docker-php-ext-install curl && \
docker-php-ext-install zip && \
docker-php-ext-install -j$(nproc) intl && \
docker-php-ext-install mbstring && \
docker-php-ext-install gettext && \
docker-php-ext-install exif

# Commenting below extension as it is already compiled and enabled on new php versions
# RUN docker-php-ext-install json
# RUN docker-php-ext-install tokenizer


# Install Freetype 
RUN apt-get -y update && \
    apt-get --no-install-recommends install -y libfreetype6-dev \
libjpeg62-turbo-dev \
libpng-dev && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd

# Enable apache modules
RUN a2enmod rewrite headers

# Cleanup
RUN rm -rf /usr/src/*


COPY ./vhosts/default.conf /etc/apache2/sites-enabled
COPY ./php/php.ini /usr/local/etc/php/php.ini
COPY ./php/ixed.8.3.lin /var/www/html/ixed.8.3.lin
COPY ./www/perm.sh /var/www/html/perm.sh

RUN mkdir /var/www/html/dss
COPY ./dss/index.php /var/www/html/dss/index.php

expose 8081 3443

RUN apt-get -y update && apt-get -y install cron

# Copy hello-cron file to the cron.d directory
COPY ./cron/hello-cron /etc/cron.d/hello-cron
 
# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/hello-cron

# Apply cron job
RUN crontab /etc/cron.d/hello-cron
 
# Create the log file to be able to run tail
RUN touch /var/log/cron.log
 
WORKDIR /var/www/html
RUN chgrp -R 0 /var/www/html && chmod -R g=u /var/www/html
RUN chmod +x perm.sh

RUN chgrp crontab /usr/bin/crontab
RUN chmod g+s /usr/bin/crontab

RUN chmod 4774 -R /var/spool/cron

RUN chmod 600 /var/spool/cron/crontabs/*
RUN chmod -R g+s /var/spool/cron
# Run the command on container startup
CMD cron && tail -f /var/log/cron.log
# ENTRYPOINT ["./perm.sh"]
