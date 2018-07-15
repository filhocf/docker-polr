# Forked from TrafeX/docker-php-nginx (https://github.com/TrafeX/docker-php-nginx/)

FROM alpine:latest
LABEL Maintainer="Kelvin Neves <> & Claudio Ferreira <filhocf@gmail.com>" \
      Description="Unofficial Docker image for Polr."

# Install packages
RUN apk --no-cache add gettext php7 php7-fpm php7-pdo php7-mysqli php7-json php7-openssl php7-curl \
    php7-zlib php7-xml php7-phar php7-intl php7-dom php7-xmlreader php7-ctype \
    php7-mbstring php7-gd php7-xmlwriter php7-tokenizer php7-pdo_mysql php7-memcached nginx supervisor curl

# Install composer
RUN curl https://getcomposer.org/installer \
    | php -- --install-dir=/usr/local/bin --filename=composer

# Pull application
RUN cd /var/www; \
    mkdir polr; \
    curl -L https://github.com/cydrobolt/polr/archive/master.tar.gz | \
    tar xz --strip-components=1 -C polr

WORKDIR /var/www/polr

# Install dependencies
RUN composer install --no-dev -o

# Setting logs permissions
RUN mkdir -p storage/logs && \
    touch storage/logs/lumen.log && \
    chmod -R go+w storage

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/zzz_custom.conf
COPY config/php.ini /etc/php7/conf.d/zzz_custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy start.sh script
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
