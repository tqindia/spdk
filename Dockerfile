




FROM ubuntu:20.04

MAINTAINER Yuvraj Yadav<hi@evalsocket.dev>





ENV TZ=Asia/Kolkata \
    DEBIAN_FRONTEND=noninteractive
ENV LANG en_US.utf8

WORKDIR /src
RUN apt-get update && apt-get install -y locales git curl sudo tzdata pkg-config linux-modules-extra-azure && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN git clone https://github.com/spdk/spdk --recursive

WORKDIR /src/spdk
RUN apt-get update
RUN  scripts/pkgdep.sh
RUN  ./configure
RUN  make

COPY scripts/run.sh . 

ENTRYPOINT ["/src/spdk/run.sh"]
