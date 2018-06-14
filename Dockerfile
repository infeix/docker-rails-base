FROM ubuntu:18.04

RUN echo "# Upgrade apt" && \
    sed -i 's/main$/main contrib/g' /etc/apt/sources.list && \
    apt-get update -qy && \
    echo "# Install common dev dependencies via apt" && \
      apt-get install -y \
      git curl wget rsync patch build-essential && \
    apt-get clean


# Define locale/timezone
RUN apt-get clean && apt-get update && apt-get install -y locales
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_US.UTF-8
ENV TZ Europe/Berlin
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales
RUN /usr/sbin/update-locale LANG=en_US.UTF-8

# Install things
RUN git clone -b master https://github.com/infeix/usirs.git
RUN chmod +x usirs/install_on_docker.sh
RUN ./usirs/install_on_docker.sh -f

ENV PHANTOMJS_VERSION 2.1.1
RUN echo "# Phantomjs" && \
      mkdir -p /srv/var && \
      wget -q --no-check-certificate -O /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
      tar -xjf /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 -C /tmp && \
      rm -f /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
      mv /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/ /srv/var/phantomjs && \
      ln -s /srv/var/phantomjs/bin/phantomjs /usr/bin/phantomjs

RUN echo "NODE VERSION:" && echo $(node -v)
RUN echo "PHANTOMJS VERSION:" && echo $(phantomjs -v)

CMD [ "bash" ]
