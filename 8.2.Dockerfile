FROM php:8.2.6-fpm-alpine3.17

MAINTAINER Jitendra Adhikari <jiten.adhikary@gmail.com>

ENV \
  MAXMIND_VERSION=1.4.2 \
  SWOOLE_VERSION=4.8.9 \
  SWOOLE_ASYNC_VERSION=4.5.5 \
  LD_PRELOAD=/usr/lib/preloadable_libiconv.so \
  PECL_EXTENSIONS="apcu ast ds ev igbinary imagick lzf memcached mongodb msgpack oauth pcov \
    psr redis rdkafka simdjson ssh2-1.3.1 uuid xdebug xhprof xlswriter yaml" \
  PHP_EXTENSIONS="bcmath bz2 calendar exif gd gettext gmp imap intl ldap mysqli pcntl pdo_mysql pgsql \
    pdo_pgsql pspell shmop soap sysvshm sysvmsg sysvsem tidy xsl zip" \
  PECL_EXTENSIONS_FUTURE="grpc yaf" \
  PHP_EXTENSIONS_FUTURE="intl sockets"

# docker-*
COPY docker-* /usr/local/bin/

# copy from existing
COPY --from=adhocore/phpfpm:8.2 /usr/local/lib/php/extensions/no-debug-non-zts-20220829/*.so /usr/local/lib/php/extensions/no-debug-non-zts-20220829/
COPY --from=adhocore/phpfpm:8.2 /usr/local/etc/php/conf.d/*.ini /usr/local/etc/php/conf.d/

# ext
COPY ext.php /ext.php

RUN \
# deps
  apk add -U --no-cache --virtual temp \
    # dev deps
    autoconf g++ file re2c make zlib-dev libtool aspell-dev pcre-dev libxml2-dev bzip2-dev libzip-dev \
      icu-dev gettext-dev imagemagick-dev openldap-dev libpng-dev gmp-dev yaml-dev postgresql-dev \
      libxml2-dev tidyhtml-dev libmemcached-dev libssh2-dev libevent-dev libev-dev librdkafka-dev lua-dev libxslt-dev \
      freetype-dev jpeg-dev libjpeg-turbo-dev oniguruma-dev \
    # prod deps
    && apk add --no-cache aspell gettext gnu-libiconv grpc \
      icu imagemagick imap-dev libzip libbz2 librdkafka libxml2-utils libpq \
      libmemcached libssh2 libevent libev libxslt linux-headers lua openldap \
      openldap-back-mdb tidyhtml yaml zlib \
#
# php extensions
  && docker-php-source extract \
    && pecl channel-update pecl.php.net \
    && { php -m | grep gd || docker-php-ext-configure gd --with-freetype --with-jpeg --enable-gd; } \
    && docker-php-ext-install-if $PHP_EXTENSIONS \
    && docker-pecl-ext-install $PECL_EXTENSIONS \
    && { docker-php-ext-enable $(echo $PECL_EXTENSIONS | sed -E 's/\-[^ ]+//g') opcache > /dev/null || true; } \
  && { php -m | grep xdebug && docker-php-ext-disable xdebug || true; } \
    && docker-php-source delete \
#
# composer
  && curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && curl -sSL https://getcomposer.org/installer | php -- --1 --install-dir=/usr/local/bin --filename=composer1 \
#
# cleanup
  && apk del temp \
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/* \
    && php -f /ext.php
