FROM ubuntu:20.04
MAINTAINER Yuvraj Yadav<hi@evalsocket.dev>

WORKDIR /src
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
RUN apt-get update && apt-get install git -y
RUN git clone https://github.com/spdk/spdk --recursive

ENV TZ=Asia/Kolkata \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install tzdata

WORKDIR /src/spdk
RUN apt-get install curl sudo  -y
RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


RUN sudo scripts/pkgdep.sh
RUN sudo apt-get install -y pkg-config
RUN sudo ./configure
RUN sudo make

RUN sudo apt-get install linux-modules-extra-$(uname -r) -y

COPY scripts/run.sh .

ENTRYPOINT ["/src/spdk/run.sh"]