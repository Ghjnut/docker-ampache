# For running the latest ampache directly from the repository

FROM php:7-apache

MAINTAINER Ghjnut <ghjnut@gmail.com>

ENV LANG C.UTF-8

# Install everything
# For installing ffmpeg, the deb-multimedia repository is used which might be considered unsafe so use with caution
RUN echo deb http://www.deb-multimedia.org jessie main non-free >> /etc/apt/sources.list \
  && apt-get update && apt-get install -y --force-yes -q deb-multimedia-keyring \
  && apt-get update && apt-get install -y -q git ffmpeg libgd3 libpng-dev libjpeg-dev libfreetype6-dev \
  && docker-php-ext-install pdo_mysql gettext gd \
  && a2enmod rewrite \
  && cd /var/www   \
  && git clone -b master https://github.com/ampache/ampache.git \
  && mv ampache/* html/ \
  && rm -r ampache \
  && rm -rf /tmp/* /var/tmp/*  \
  && rm -rf /var/lib/apt/lists/* \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && cd html \
  && cp rest/.htaccess.dist rest/.htaccess \
  && cp play/.htaccess.dist play/.htaccess \
  && cp channel/.htaccess.dist channel/.htaccess \
  && composer install --prefer-source --no-interaction \
  && apt-get remove -y git \
  && apt-get autoremove -y \
  && apt-get clean \
  && chown -R www-data:www-data /var/www/html

VOLUME ["/var/www/html/config","/var/www/html/themes"]

CMD ["apache2-foreground"]
