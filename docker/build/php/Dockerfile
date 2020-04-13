FROM php:fpm
RUN apt-get update && apt-get install -y --no-install-recommends \
        unzip zip libzip-dev \
        libssl-dev \
        libsasl2-dev \
        pkg-config \
        cron \
        nano \
        libgmp-dev \
        git \
        zlib1g-dev \
        libxml2-dev \
        libpng-dev \
        iputils-ping \
        nmap \
        net-tools \
        vim \
        multitail \
    && docker-php-ext-install \
        pdo_mysql \
        gmp \
        soap \
        bcmath \
        opcache \
        gd

RUN docker-php-ext-configure zip \
&& docker-php-ext-install zip

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

# update to add php.ini file for increase memory value e.g. 2048M
COPY php.ini /usr/local/etc/php/php.ini

RUN pecl install mongodb && pecl clear-cache
RUN echo "extension=mongodb.so" >> /usr/local/etc/php/php.ini

RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN echo 'xdebug.remote_port=9001' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_enable=1' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_autostart=1' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_connect_back=0' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.idekey=PHPSTORM' >> /usr/local/etc/php/php.ini

WORKDIR /var/www/symfony/

EXPOSE 9001