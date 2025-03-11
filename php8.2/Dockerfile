FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update
RUN apt-get install -y software-properties-common vim wget git supervisor

RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get install -y apache2 libapache2-mod-php8.4 mysql-server php8.4 php8.4-mysql
RUN ln -sfn /usr/bin/php8.4 /etc/alternatives/php

RUN apt-get install -y php8.4-dev python3-pip \
    php8.4-curl php8.4-bcmath php8.4-xml php8.4-mbstring \
    php8.4-gd php8.4-zip php8.4-intl

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
ADD apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer

RUN sed -ri -e "s/^upload_max_filesize.*/upload_max_filesize = 10M/" /etc/php/8.4/apache2/php.ini
RUN sed -ri -e "s/^post_max_size.*/post_max_size = 10M/" /etc/php/8.4/apache2/php.ini
RUN sed -i "s/display_errors = Off/display_errors = On/g" /etc/php/8.4/apache2/php.ini
RUN sed -i "s/memory_limit = 128M/memory_limit = -1/g" /etc/php/8.4/cli/php.ini

RUN mkdir -p /var/run/mysqld
RUN chown mysql:mysql /var/run/mysqld
RUN echo "[program:mysql]" > /etc/supervisor/conf.d/mysql.conf && \
    echo "#command=/usr/bin/mysqld_safe" >> /etc/supervisor/conf.d/mysql.conf && \
    echo "command=/usr/bin/mysqld_safe" >> /etc/supervisor/conf.d/mysql.conf && \
    echo "process_name = mysql" >> /etc/supervisor/conf.d/mysql.conf && \
    echo "[program:apache]" > /etc/supervisor/conf.d/apache.conf && \
    echo "command=/usr/sbin/apachectl -DFOREGROUND -k start" >> /etc/supervisor/conf.d/apache.conf && \
    echo "process_name = apache" >> /etc/supervisor/conf.d/apache.conf && \
    echo "#!/bin/bash" > /create_user.sh && \
    echo "mysql -uroot -e \"CREATE USER 'admin'@'%' IDENTIFIED BY 'adminpw'\"" >> /create_user.sh && \
    echo "mysql -uroot -e \"GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION\"" >> /create_user.sh && \
    echo "#!/bin/bash" > /start.sh && \
    echo "/usr/bin/supervisord -n" >> /start.sh
RUN chmod 755 /*.sh

RUN git clone --recurse-submodules https://github.com/WSP-LAB/FUGIO.git /FUGIO
ADD benchmarks/ /FUGIO/benchmarks
WORKDIR /FUGIO

# For php8.4
