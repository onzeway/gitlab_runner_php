FROM php:5.6-cli

RUN apt-get update -y
RUN apt-get install -y \
	curl \
	git \
	subversion \
	unzip \
	wget \
	libmcrypt-dev \
	libxslt-dev

RUN mkdir -p /composer/bin

ENV COMPOSER_HOME /composer
ENV PATH /composer/vendor/bin:/composer/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini
RUN echo "date.timezone=${PHP_TIMEZONE:-UTC}" > $PHP_INI_DIR/conf.d/date_timezone.ini

RUN docker-php-ext-install -j$(nproc) iconv mcrypt bcmath mbstring pcntl xsl && \
	docker-php-ext-configure gettext --with-gettext=shared

COPY ./composer_install.sh /tmp/composer_install.sh
COPY ./composer.sh $COMPOSER_HOME/bin/composer
RUN chmod +x $COMPOSER_HOME/bin/composer

RUN /bin/bash /tmp/composer_install.sh --install-dir=$COMPOSER_HOME
