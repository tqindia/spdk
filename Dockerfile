FROM ubuntu:20.04

ENV TZ=Asia/Kolkata \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y git linux-modules-extra tzdata curl libhugetlbfs-bin numactl hugeadm  locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker

# if you are behind a proxy, set that up now
WORKDIR /src

RUN git clone https://github.com/spdk/spdk --recursive

RUN chown prod_user:prod_user -R  /src/spdk

WORKDIR /src/spdk
RUN scripts/pkgdep.sh --all &&  ./configure &&  make

ENTRYPOINT [ "entrypoint.sh" ]