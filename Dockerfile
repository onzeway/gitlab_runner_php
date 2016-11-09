FROM php:5.6-cli

ENV COMPOSER_HOME /composer
ENV PATH /composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini
RUN echo "date.timezone=${PHP_TIMEZONE:-UTC}" > $PHP_INI_DIR/conf.d/date_timezone.ini
RUN docker-php-ext-install bcmath mcrypt zip bz2 mbstring pcntl xsl

RUN apt-get -y update && apt-get install -y curl git subversion unzip wget unzip

RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
 	&& curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
 	&& php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }"