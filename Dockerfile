FROM php:7.2

RUN apt-get update -y
RUN apt-get install -y \
    build-essential \
    curl \
    git \
    gnupg \
    libmcrypt-dev \
    libxslt-dev \
    openssl \
    subversion \
    unzip \
    wget

RUN curl -sL https://deb.nodesource.com/setup_9.x | bash -

RUN apt-get install -y nodejs

RUN mkdir -p /composer/bin

ENV COMPOSER_HOME /composer
ENV PATH /composer/vendor/bin:/composer/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini
RUN echo "date.timezone=${PHP_TIMEZONE:-UTC}" > $PHP_INI_DIR/conf.d/date_timezone.ini

RUN pecl install xdebug

RUN docker-php-ext-install -j$(nproc) iconv bcmath mbstring pcntl xsl && \
    docker-php-ext-configure gettext --with-gettext=shared && \
    docker-php-ext-enable xdebug

COPY ./composer_install.sh /tmp/composer_install.sh
COPY ./composer.sh $COMPOSER_HOME/bin/composer
RUN chmod +x $COMPOSER_HOME/bin/composer

RUN /bin/bash /tmp/composer_install.sh --install-dir=$COMPOSER_HOME
