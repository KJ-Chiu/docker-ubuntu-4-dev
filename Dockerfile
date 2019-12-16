FROM ubuntu:16.04

# System update
RUN apt-get update; \
    apt-get upgrade -y

# System setting
RUN apt-get install -y ntpdate ntp; \
    ntpdate time.stdtime.gov.tw

# Add User developer
RUN useradd -ms /bin/bash  developer

# Editor
RUN apt-get install vim -y

# zsh
RUN apt-get install zsh -y

# Package install
RUN apt-get install perl liberror-perl wget -y

# Git
RUN apt-get install git -y

# Golang install
RUN wget https://dl.google.com/go/go1.13.5.linux-amd64.tar.gz; \
    tar -C /usr/local -xzf go1.13.5.linux-amd64.tar.gz; \
    rm go1.13.5.linux-amd64.tar.gz; \
    mkdir /home/developer/go; \
    mkdir /home/developer/go/src; \
    echo "\n export PATH=$PATH:/usr/local/go/bin" >> /etc/profile

# PHP install
RUN apt install apt-transport-https lsb-release ca-certificates -y; \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg; \
    sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'; \
    apt update; \
    apt install zip unzip -y; \
    apt install php7.3 php7.3-common php7.3-cli php7.3-fpm php7.3-mbstring php7.3-mysqli php7.3-xml php7.3-zip -y; \
    mkdir /log

COPY config/php/ /etc/php/7.3
COPY config/sample/info.php /home/developer/nginx-site/

# Composer install
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'baf1608c33254d00611ac1705c1d9958c817a1a33bce370c0595974b342601bd80b92a3f46067da89e3b06bff421f182') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"; \
    php composer-setup.php; \
    php -r "unlink('composer-setup.php');"; \
    mv composer.phar /bin/composer

# Nginx install
RUN apt-get install nginx nginx-extras -y

COPY config/nginx /etc/nginx/conf.d

# Node install
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash; \
    nvm install v12.13.1; \
    nvm use v12.13.1

# Start services
RUN service php7.3-fpm restart; \
    service nginx restart

CMD tail -f /log/fpm.log