## docker-phpfpm

Docker PHP FPM with lean alpine base.
It contains PHP7.4.0 with plenty of common extensions.

## Usage
To pull latest image:

```sh
docker pull adhocore/phpfpm:7.4
```

To use in docker-compose
```yaml
# ./docker-compose.yml
version: '3'

services:
  phpfpm:
    image: adhocore/phpfpm:7.4
    container_name: phpfpm
    volumes:
      # Here you can also volume php ini settings
      # - /path/to/zz-overrides:/usr/local/etc/php/conf.d/zz-overrides.ini
    ports:
      - 9000:9000
    environment:
      # ...
```

### Extensions

The following PHP extensions are installed:

```
ast
bcmath
bz2
calendar
Core
ctype
curl
date
dom
exif
fileinfo
filter
ftp
gd
gettext
gmp
hash
iconv
igbinary
imagick
intl
json
ldap
libxml
mbstring
mysqli
mysqlnd
openssl
pcntl
pcre
PDO
pdo_mysql
pdo_pgsql
pdo_sqlite
pgsql
phalcon
Phar
posix
psr
readline
redis
Reflection
session
SimpleXML
soap
sodium
SPL
sqlite3
standard
tideways_xhprof
tokenizer
uuid
xdebug
xml
xmlreader
xmlwriter
yaml
Zend OPcache
zip
zlib
```

`phalcon` web framework `4.0.0-rc.3` has been installed.

Read more about [tideways](https://github.com/tideways/php-xhprof-extension)
and [phalcon](https://github.com/phalcon/cphalcon).