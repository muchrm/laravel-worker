FROM muchrm/science-php

#supervisor
RUN apk add --no-cache supervisor

ADD supervisord.conf /etc/supervisord.conf

STOPSIGNAL SIGTERM

WORKDIR /var/www/html

CMD ["supervisord", "-c", "/etc/supervisord.conf"]