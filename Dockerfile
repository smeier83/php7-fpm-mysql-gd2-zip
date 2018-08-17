FROM josskar/php7-fpm-mysql-gd2


RUN apt-get update && apt-get install -y vim imagemagick graphicsmagick 

# Install mbstring
RUN docker-php-ext-install mbstring

# Install curl
RUN apt-get install -y libcurl4-openssl-dev \
    && docker-php-ext-install curl

# Install zip
RUN docker-php-ext-install zip

# Install json
RUN docker-php-ext-install json

# Install redis
RUN pecl install -o -f redis \
&&  rm -rf /tmp/pear \
&&  docker-php-ext-enable redis

# Install extensions through the scripts the container provides
# Here we install the pdo_mysql extensions to access MySQL.
RUN docker-php-ext-install pdo_mysql

RUN echo "deb http://httpredir.debian.org/debian stretch main" | tee -a /etc/apt/sources.list

RUN apt-get update && apt-get install -y wget


RUN	cd /usr/local/bin \
	&& wget https://raw.githubusercontent.com/helderco/docker-php/master/template/bin/docker-php-pecl-install \
	&& chmod +x /usr/local/bin/docker-php-pecl-install \
	&& docker-php-pecl-install xdebug \
    && echo "xdebug.remote_host=$(getent hosts docker.for.mac.localhost | awk '{ print $1 }')" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
	&& echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
	&& echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
	&& echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
	&& echo "xdebug.default_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
	&& echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
	&& echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
	&& echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
	&& echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
	&& echo "xdebug.remote_log=\"/tmp/xdebug.log\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
	&& export XDEBUG_CONFIG="idekey=phpstorm"

CMD ["php-fpm"]