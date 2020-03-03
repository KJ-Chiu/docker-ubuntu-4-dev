FROM ubuntu:16.04

# System update
RUN apt-get update \
    && apt-get upgrade -y

# System setting
ENV LANG C.UTF-8

# Add User developer
ENV DEVELOPER developer
RUN useradd -ms /bin/bash $DEVELOPER

# Editor
RUN apt-get install vim -y

# Window Control
RUN apt-get install screen tmux -y

# zsh
RUN apt-get install zsh -y

# Package install
RUN apt-get install perl liberror-perl wget curl sudo build-essential -y

# Git
RUN apt-get install git -y

# Golang install
RUN wget https://dl.google.com/go/go1.13.5.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.13.5.linux-amd64.tar.gz \
    && rm go1.13.5.linux-amd64.tar.gz \
    && mkdir /home/$DEVELOPER/go \
    && mkdir /home/$DEVELOPER/go/src \
    && echo "\n export PATH=$PATH:/usr/local/go/bin" >> /etc/profile \
    && chown -R $DEVELOPER:$DEVELOPER /home/$DEVELOPER/go/

# PHP install
RUN apt-get install apt-transport-https lsb-release ca-certificates -y; \
    apt-get update; \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg; \
    sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'; \
    apt-get install software-properties-common -y; \
    apt-get update -y; \
    add-apt-repository ppa:ondrej/php -y; \
    apt-get update -y; \
    apt-get install zip unzip -y; \
    apt-get install php7.3 php7.3-common php7.3-cli php7.3-fpm php7.3-mbstring php7.3-mysqli php7.3-xml php7.3-zip -y --allow-unauthenticated; \
    mkdir /log

# Composer install
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'baf1608c33254d00611ac1705c1d9958c817a1a33bce370c0595974b342601bd80b92a3f46067da89e3b06bff421f182') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /bin/composer

# Nginx install
RUN apt-get install nginx nginx-extras -y --allow-unauthenticated

# NVM environment variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 12.13.1

# NVM install
RUN mkdir $NVM_DIR \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash

# Node NPM install
RUN . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# Give permission back
RUN chown -R $DEVELOPER:$DEVELOPER $NVM_DIR

# Add Node and NPM path
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install NPM global package
RUN npm install -g @vue/cli@"^4.1.1"
RUN npm install -g create-react-app

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -; \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list; \
    apt update; \
    apt install --no-install-recommends yarn -y

# Outside file setting
COPY config/php/ /etc/php/7.3/fpm
COPY config/nginx/default.conf /etc/nginx/sites-available/default
COPY config/sample/info.php /home/$DEVELOPER/nginx-site/
RUN chown -R $DEVELOPER:$DEVELOPER /home/$DEVELOPER/nginx-site/

# User doing
USER $DEVELOPER

# Plugin install
RUN cd ~/ \
    && git clone https://github.com/KJ-Chiu/shell-config.git \
    && cd shell-config \
    && sh setup.sh \
    && cd ~/ \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc \
    && echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc \
    && echo 'export NVM_DIR="/usr/local/nvm"' >> ~/.zshrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.zshrc \
    && echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.zshrc \
    && echo 'export GOPATH=$HOME/go' >> ~/.zshrc

# Vundle install
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim \
    && vim +PluginInstall +qall

# root come back
USER root

RUN mkdir /run/php \
    && chmod 777 /run/php

EXPOSE 80 3000 4000 8080

WORKDIR /home/$DEVELOPER

CMD service php7.3-fpm restart && nginx -g "daemon off;"
