FROM muchrm/science-php

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

RUN rm -rf /var/cache/apk/* \
    && find / -type f -iname \*.apk-new -delete \
    && rm -rf /var/cache/apk/*

EXPOSE 9000 443 80
STOPSIGNAL SIGTERM
WORKDIR /var/www/html
CMD ["sh","/start.sh"]