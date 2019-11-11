FROM quay.io/openshifthomeroom/workshop-terminal:master

USER root

RUN mkdir -p /tmp/working && cd /tmp/working && mkdir /tmp/src

WORKDIR /tmp/working

COPY config/zshrc /tmp/working/zshrc

COPY terminal/bin/. /opt/workshop/bin/
COPY terminal/etc/. /opt/workshop/etc/
COPY terminal/.bash_profile /opt/app-root/src/.bash_profile

RUN yum update -y && yum clean all

RUN yum install wget ed curl nano vim gcc gcc-c++ gcc-gfortran gettext libtool patch git make ncurses-devel unzip zsh rsyslog -y && yum clean all

RUN yum install -y epel-release && yum install nodejs npm -y && yum clean all

RUN command -v zsh | tee -a /etc/shells && \
    git clone https://github.com/powerline/fonts.git --depth=1 && \
    cd fonts && ./install.sh && cd .. && rm -rf fonts/ && \
    pip3 install thefuck && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
    cp /tmp/working/zshrc /opt/app-root/src/.zshrc && \
    rm -rf /tmp/working

RUN rm -rf /tmp/src/.git* && \
    chown -R 1001 /tmp/src && \
    chgrp -R 0 /tmp/src && \
    chmod -R g+w /tmp/src && \
    chown -R 1001:0 /opt/app-root && \
    fix-permissions /opt/app-root -P

USER 1001

RUN /usr/libexec/s2i/assemble
