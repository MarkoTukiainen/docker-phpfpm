## docker-phpfpm

[![Docker build](https://github.com/adhocore/docker-phpfpm/actions/workflows/build.yml/badge.svg)](https://github.com/adhocore/docker-phpfpm/actions/workflows/build.yml)
[![Tweet](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=Production+ready+PHP7+and+PHP8+docker+images+with+plenty+extensions&url=https://github.com/adhocore/docker-phpfpm&hashtags=docker,dockerimage,php7,php8,phpext)
[![Support](https://img.shields.io/static/v1?label=Support&message=%E2%9D%A4&logo=GitHub)](https://github.com/sponsors/adhocore)
<!-- [![Donate 15](https://img.shields.io/badge/donate-paypal-blue.svg?style=flat-square&label=donate+15)](https://www.paypal.me/ji10/15usd)
[![Donate 25](https://img.shields.io/badge/donate-paypal-blue.svg?style=flat-square&label=donate+25)](https://www.paypal.me/ji10/25usd)
[![Donate 50](https://img.shields.io/badge/donate-paypal-blue.svg?style=flat-square&label=donate+50)](https://www.paypal.me/ji10/50usd) -->

**Important Note**: To be able to support arm builds ([#81](https://github.com/adhocore/docker-phpfpm/issues/81)) we removed some big and slow to compile extensions like swoole/grpc/phalcon for now.
Check [example](#extensions) below how to add them back in your images based off on `adhcore/phpfpm`.

Docker PHP FPM with lean alpine base. The download size is just about **~100MB** - tiny given how many extensions it has baked in.

It contains PHP>=8.2.5, PHP>=8.1.18 and PHP>=8.0.28 with plenty of common and useful extensions.

You can also continue using [`adhocore/phpfpm:7.4`](./7.4.Dockerfile) for PHP7.4.33 but this version is now deprecated.

If you are looking for a complete local development stack then check
[`adhocore/lemp`](https://github.com/adhocore/docker-lemp).

It comes prepackaged with `composer` - both v1 and v2.
Use `composer` command for v2 and `composer1` for v1.

## Usage

To pull latest image:

```sh
docker pull adhocore/phpfpm:8.2

# or for 8.1
docker pull adhocore/phpfpm:8.1

# or for php 8.0
docker pull adhocore/phpfpm:8.0

# or for php 7.4
docker pull adhocore/phpfpm:7.4
```

To use in docker-compose
```yaml
# ./docker-compose.yml
version: '3'

services:
  phpfpm:
    image: adhocore/phpfpm:8.0
    container_name: phpfpm
    volumes:
      - ./path/to/your/app:/var/www/html
      # Here you can also volume php ini settings
      # - /path/to/zz-overrides:/usr/local/etc/php/conf.d/zz-overrides.ini
    ports:
      - 9000:9000
    environment:
      # ...
```

### Composer

Latest versions of both Composer v1 and v2 are installed already. You can run v2 with `composer` and v1 with `composer1`.

### Extensions

You can add new extensions in your image like so:
```Dockerfile
FROM adhocore/phpfpm:8.1 # or 8.2, 8.0

RUN \
  # setup
  apk add -U $PHPIZE_DEPS \
  #
  # if it is in pecl: \
  && docker-pecl-ext-install grpc phalcon swoole \
    && apk del $PHPIZE_DEPS \
  #
  # if it is in php ext: \
  && docker-php-source extract && docker-php-ext-install-if dba \
    && docker-php-source delete
```

Debug extension `xdebug` is installed but disabled by default for performance reason,
just run `docker-php-ext-enable xdebug` to enable it again without having to rebuild/recompile.

Below you can find list of extensions by image tags.

#### PHP8.2

The following PHP extensions are installed in `adhocore/phpfpm:8.2`:

```
PHP >=8.2.5, Total extensions: 82
- apcu              - ast               - bcmath            - bz2
- calendar          - core              - ctype             - curl
- date              - dom               - ds                - ev
- exif              - fileinfo          - filter            - fpm
- ftp               - gd                - gettext           - gmp
- hash              - iconv             - igbinary          - imagick
- imap              - intl              - json              - ldap
- libxml            - lzf               - mbstring          - memcached
- mongodb           - msgpack           - mysqli            - mysqlnd
- oauth             - openssl           - pcntl             - pcov
- pcre              - pdo               - pdo_mysql         - pdo_pgsql
- pdo_sqlite        - pgsql             - phar              - posix
- pspell            - psr               - random            - rdkafka
- readline          - redis             - reflection        - session
- shmop             - simdjson          - simplexml         - soap
- sodium            - spl               - sqlite3           - ssh2
- standard          - sysvmsg           - sysvsem           - sysvshm
- tidy              - tokenizer         - uuid              - xdebug
- xhprof            - xlswriter         - xml               - xmlreader
- xmlwriter         - xsl               - yaml              - zend opcache
- zip               - zlib
```

#### PHP8.1

The following PHP extensions are installed in `adhocore/phpfpm:8.1`:

```
PHP >=8.1.18, Total extensions: 83
- apcu              - ast               - bcmath            - bz2
- calendar          - core              - ctype             - curl
- date              - dom               - ds                - ev
- exif              - fileinfo          - filter            - fpm
- ftp               - gd                - gettext           - gmp
- hash              - iconv             - igbinary          - imagick
- imap              - intl              - json              - ldap
- libxml            - lzf               - mbstring          - memcached
- mongodb           - msgpack           - mysqli            - mysqlnd
- oauth             - openssl           - pcntl             - pcov
- pcre              - pdo               - pdo_mysql         - pdo_pgsql
- pdo_sqlite        - pgsql             - phar              - posix
- pspell            - psr               - rdkafka           - readline
- redis             - reflection        - session           - shmop
- simdjson          - simplexml         - soap              - sockets
- sodium            - spl               - sqlite3           - ssh2
- standard          - sysvmsg           - sysvsem           - sysvshm
- tidy              - tokenizer         - uuid              - xdebug
- xhprof            - xlswriter         - xml               - xmlreader
- xmlwriter         - xsl               - yaf               - yaml
- zend opcache      - zip               - zlib
```

#### PHP8.0

The following PHP extensions are installed in `adhocore/phpfpm:8.0`:

```
PHP >=8.0.28, Total extensions: 84
- apcu              - ast               - bcmath            - bz2
- calendar          - core              - ctype             - curl
- date              - dom               - ds                - ev
- exif              - fileinfo          - filter            - fpm
- ftp               - gd                - gettext           - gmp
- hash              - iconv             - igbinary          - imagick
- imap              - intl              - json              - ldap
- libxml            - lzf               - mbstring          - memcached
- mongodb           - msgpack           - mysqli            - mysqlnd
- oauth             - openssl           - pcntl             - pcov
- pcre              - pdo               - pdo_mysql         - pdo_pgsql
- pdo_sqlite        - pgsql             - phalcon           - phar
- posix             - pspell            - psr               - rdkafka
- readline          - redis             - reflection        - session
- shmop             - simdjson          - simplexml         - soap
- sockets           - sodium            - spl               - sqlite3
- ssh2              - standard          - sysvmsg           - sysvsem
- sysvshm           - tidy              - tokenizer         - uuid
- xdebug            - xhprof            - xlswriter         - xml
- xmlreader         - xmlwriter         - xsl               - yaf
- yaml              - zend opcache      - zip               - zlib
```

#### PHP7.4

The following PHP extensions are installed in `adhocore/phpfpm:7.4`:

```
PHP >=7.4.33, Total extensions: 82
- apcu              - ast               - bcmath            - bz2
- calendar          - core              - ctype             - curl
- date              - dom               - ds                - ev
- exif              - fileinfo          - filter            - fpm
- ftp               - gd                - gettext           - gmp
- hash              - hrtime            - iconv             - igbinary
- imagick           - imap              - intl              - json
- ldap              - libxml            - lua               - lzf
- mbstring          - memcached         - mongodb           - msgpack
- mysqli            - mysqlnd           - oauth             - openssl
- pcntl             - pcov              - pcre              - pdo
- pdo_mysql         - pdo_pgsql         - pdo_sqlite        - pgsql
- phar              - posix             - psr               - rdkafka
- readline          - redis             - reflection        - session
- simdjson          - simplexml         - soap              - sockets
- sodium            - spl               - sqlite3           - ssh2
- standard          - sysvmsg           - sysvsem           - sysvshm
- tideways_xhprof   - tidy              - tokenizer         - uuid
- xdebug            - xlswriter         - xml               - xmlreader
- xmlwriter         - yaf               - yaml              - zend opcache
- zip               - zlib
```

Read more about
[pcov](https://github.com/krakjoe/pcov),
[psr](https://github.com/jbboehr/php-psr)

### Production Usage

For production you may want to get rid of some extensions that are not really required.
In such case, you can build a custom image on top `adhocore/phpfpm:8.2` like so:

```Dockerfile
FROM adhocore/phpfpm:8.2 # or 8.1 or 8.0

# Disable extensions you won't need. You can add as much as you want separated by space.
RUN docker-php-ext-disable xdebug pcov ldap
```

> `docker-php-ext-disable` is shell script available in `adhocore/phpfpm` only and not in official PHP docker images.

> Extensions disabled can be re enabled with `docker-php-ext-enable` later again without the overhead of recompiling/rebuilding all over again.
