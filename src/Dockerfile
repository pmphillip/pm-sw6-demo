FROM pmphillip/pm-shopware6-php-nginx:php-7.4


ADD ./public /var/www/html

#nginx confs
COPY ./configs/.htpasswd /etc/nginx/.htpasswd
COPY ./configs/nginx.conf /etc/nginx/nginx.conf
COPY ./configs/nginx_dev.conf /etc/nginx/sites-enabled/default.conf


#php confs
COPY ./configs/custom-php.ini /etc/php/7.4/cli/conf.d/10-shopware.ini
COPY ./configs/custom-php.ini /etc/php/7.4/fpm/conf.d/10-shopware.ini

RUN chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html


CMD ["/bin/bash", "/start.sh"]