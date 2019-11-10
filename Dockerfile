FROM quay.io/openshifthomeroom/workshop-terminal:master

USER root

RUN mkdir -p /tmp/working && cd /tmp/working

WORKDIR /tmp/working

COPY config/zshrc /tmp/working/zshrc

RUN yum update -y && yum clean all

RUN yum install wget ed curl nano vim gcc gcc-c++ gcc-gfortran gettext initscripts openssh openssh-server openssh-server-sysvinit libtool patch git make ncurses-devel python3-pip python3 python3-setuptools python3-devel unzip ansible zsh rsyslog -y && yum clean all

RUN yum install -y epel-release && yum install nodejs npm -y && yum clean all

RUN cat "$(which zsh)" >> /etc/shells && \
    git clone https://github.com/powerline/fonts.git --depth=1 && \
    cd fonts && ./install.sh && cd .. && rm -rf fonts/ && \
    pip3 install thefuck && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
    wget -O oc.tar.gz "https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz" && \
    tar zxvf oc.tar.gz && cd openshift-origin-client-* && mv kubectl /usr/local/bin && mv oc /usr/local/bin && \
    rm -rf /tmp/working

RUN rm -rf /tmp/src/.git* && \
    chown -R 1001 /tmp/src && \
    chgrp -R 0 /tmp/src && \
    chmod -R g+w /tmp/src

USER 1001

RUN /usr/libexec/s2i/assemble
