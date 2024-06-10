FROM alpine:latest

RUN addgroup -S container && adduser -S container -G container

RUN apk --update --no-cache add curl ca-certificates nginx certbot certbot-nginx && \
    apk add php83 php83-xml php83-exif php83-fpm php83-session php83-soap php83-openssl php83-gmp php83-pdo_odbc php83-json php83-dom php83-pdo php83-zip php83-mysqli php83-sqlite3 php83-pdo_pgsql php83-bcmath php83-gd php83-odbc php83-pdo_mysql php83-pdo_sqlite php83-gettext php83-xmlreader php83-bz2 php83-iconv php83-pdo_dblib php83-curl php83-ctype php83-phar php83-fileinfo php83-mbstring php83-tokenizer php83-simplexml
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

USER container
ENV USER container
ENV HOME /home/container

WORKDIR /home/container
COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/ash", "/entrypoint.sh"]

USER root
RUN mkdir -p /home/container/sbin && \
    chown -R container:container /home/container/sbin && \
    mv /usr/sbin/nginx /home/container/sbin/nginx && \
    mv /usr/sbin/php-fpm83 /home/container/sbin/php-fpm83 && \
    ln -s /home/container/sbin/nginx /usr/sbin/nginx && \
    ln -s /home/container/sbin/php-fpm83 /usr/sbin/php-fpm83

USER container