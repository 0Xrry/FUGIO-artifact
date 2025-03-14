FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update
RUN apt-get install -y software-properties-common vim wget git supervisor

RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get install -y apache2 libapache2-mod-php8.2 mysql-server php8.2 php8.2-mysql
RUN ln -sfn /usr/bin/php8.2 /etc/alternatives/php

RUN apt-get install -y php8.2-dev python3-pip \
    php8.2-curl php8.2-bcmath php8.2-xml php8.2-mbstring \
    php8.2-gd php8.2-zip php8.2-intl

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
ADD apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer

RUN sed -ri -e "s/^upload_max_filesize.*/upload_max_filesize = 10M/" /etc/php/8.2/apache2/php.ini
RUN sed -ri -e "s/^post_max_size.*/post_max_size = 10M/" /etc/php/8.2/apache2/php.ini
RUN sed -i "s/display_errors = Off/display_errors = On/g" /etc/php/8.2/apache2/php.ini
RUN sed -i "s/memory_limit = 128M/memory_limit = -1/g" /etc/php/8.2/cli/php.ini

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

RUN export https_proxy=http://172.17.0.1:7890 && export http_proxy=http://172.17.0.1:7890 && git clone --recurse-submodules https://github.com/0Xrry/FUGIO.git /FUGIO
ADD benchmarks/ /FUGIO/benchmarks
WORKDIR /FUGIO

# For php8.2
