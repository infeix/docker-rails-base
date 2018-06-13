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

CMD [ "bash" ]
