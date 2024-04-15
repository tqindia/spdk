FROM ubuntu:20.04

ENV TZ=Asia/Kolkata \
    DEBIAN_FRONTEND=noninteractive

# if you are behind a proxy, set that up now
WORKDIR /src
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
RUN apt-get update && apt-get install git linux-modules-extra tzdata -y
RUN git clone https://github.com/spdk/spdk --recursive

WORKDIR /src/spdk
RUN scripts/pkgdep.sh --all && ./configure && make

ENTRYPOINT [ "entrypoint.sh" ]