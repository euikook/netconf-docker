FROM python:3.10-slim
LABEL maintainer="euikook euikook@gmail.com"

RUN sed -i 's|http://deb.debian.org|http://ftp.kr.debian.org|g' /etc/apt/sources.list.d/debian.sources

RUN apt-get update && apt-get install -y --no-install-recommends make curl openssl python3-dev build-essential libyaml-dev libffi-dev git

# defaults
#
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/Asia/Seoul /etc/localtime

RUN \
    apt-get update && apt-get install -y \
    --no-install-recommends \
    apt-utils \
    git \
    curl \
    wget \
    libtool \
    build-essential \
    vim \
    libtool	\
    autoconf \
    automake \
    pkg-config \
    libgtk-3-dev \
    make \
    vim \
    valgrind \
    doxygen \
    libev-dev \
    libpcre3-dev \
    libpcre2-dev \
    unzip \
    sudo \
    python3 \
    build-essential \
    bison \
    flex \
    swig \
    libcmocka0 \
    libcmocka-dev \
    cmake \
    supervisor \
    make \
    curl \
    openssl \
    python3-dev \
    build-essential \
    libyaml-dev \
    libffi-dev git \
    libssl-dev \
    net-tools iproute2 iputils-ping


RUN mkdir /netconf

# set password for user (same as the username)
RUN echo "root:root" | chpasswd

# libyang
RUN \
      cd /netconf && \
      git clone  https://github.com/CESNET/libyang.git && cd libyang && \
      mkdir build && cd build && \
      cmake  -DCMAKE_BUILD_TYPE:String="Debug" \
      -DCMAKE_INSTALL_PREFIX:PATH=/usr \
      -DGEN_LANGUAGE_BINDINGS=ON -DGEN_CPP_BINDINGS=ON -DGEN_PYTHON_BINDINGS=ON \
      -DENABLE_BUILD_TESTS=OFF .. && \
      make -j2 && \
      make install && \
      ldconfig

# libssh
RUN \
    cd /netconf && \
    git clone --depth 1 http://git.libssh.org/projects/libssh.git && cd libssh && \
    mkdir build && cd build && \
    cmake .. && \
    make && \
    make install && \
    ldconfig

# libnetconf2
RUN \
      cd netconf && \
      git clone https://github.com/CESNET/libnetconf2.git && cd libnetconf2 && \
      mkdir build && cd build && \
      cmake  -DCMAKE_BUILD_TYPE:String="Debug" -DCMAKE_INSTALL_PREFIX:PATH=/usr -DENABLE_BUILD_TESTS=OFF .. && \
      make && \
      make install && \
      ldconfig

ENV EDITOR vim

WORKDIR /netconf
