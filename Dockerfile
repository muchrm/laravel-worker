FROM php:7.1-fpm-alpine

RUN apk update && \
    apk add \
        curl \
        libmemcached-dev \
        zlib-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        freetype-dev \
        openssl-dev \
        libmcrypt-dev \
        autoconf \
        g++ \
        make

RUN docker-php-ext-install \
                    mcrypt \
                    pdo_mysql \
                    zip


 

RUN docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-jpeg-dir=/usr/lib \
        --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd

#####################################
# MongoDB:
#####################################

RUN pecl install mongodb && \
    docker-php-ext-enable mongodb    

ADD ./php.ini /usr/local/etc/php/conf.d
ADD ./php.pool.conf /usr/local/etc/php-fpm.d/

RUN rm -rf /var/cache/apk/* \
    && find / -type f -iname \*.apk-new -delete \
    && rm -rf /var/cache/apk/*

WORKDIR /var/www/html
RUN deluser www-data && adduser -D -H -u 1000 -s /bin/bash www-data

#install composer
RUN curl -s http://getcomposer.org/installer | php && mv ./composer.phar /usr/local/bin/composer

RUN apk update && apk add -u python py-pip
RUN pip install supervisor

#Install supervisor
RUN mkdir -p /var/log/supervisor && \
    mkdir -p /var/run/sshd && \
    mkdir -p /var/run/supervisord

#Add supervisord conf
ADD supervisord.conf /etc/supervisord.conf
ADD start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 9000 443 80

STOPSIGNAL SIGTERM

CMD ["sh","/start.sh"]