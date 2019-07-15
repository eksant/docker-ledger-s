#################################################################
# How to :
# Build : docker build -t docker-ledger-s . 
# Run : docker run -v `pwd`:/home/workspace -ti docker-ledger-s make
#################################################################

FROM ubuntu:latest
LABEL version="1.0"
LABEL maintainer="Eksa <eksant@gmail.com>"
LABEL description="The docker image for compiling Ledger Nano S."

#################################################################
# Tool Setup
#################################################################
RUN apt-get update && apt-get -y upgrade && apt-get -y install \
  gcc \
  git \
  wget \
  nano \
  cmake \
  build-essential \
  python3 python3-pip python-pip python-dev virtualenv \
  libc6-i386 libc6-dev-i386 lib32z1 \
  libudev-dev libusb-1.0-0-dev libssl-dev libffi-dev

#################################################################
# Configuration OpenSSL
#################################################################
RUN cd /usr/include/openssl/ && ln -s /usr/include/gnutls/openssl.h . && ln -s ../x86_64-linux-gnu/openssl/opensslconf.h .

#################################################################
# BOLOS dev envitonment setup
#################################################################
RUN mkdir /opt/ledger-blue
RUN cd /opt/ledger-blue && wget -O - https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q1-update/+download/gcc-arm-none-eabi-5_3-2016q1-20160330-linux.tar.bz2 | tar xjvf -
# RUN cd /opt/ledger-blue && wget -O - http://releases.llvm.org/4.0.0/clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz | tar xJvf - && mv clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-14.04 clang-arm-fropi
# RUN cd /opt/ledger-blue && wget -O - http://releases.llvm.org/4.0.0/clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.10.tar.xz | tar xJvf - && mv clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.10 clang-arm-fropi
RUN cd /opt/ledger-blue && wget -O - http://releases.llvm.org/8.0.0/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz | tar xJvf - && mv clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04 clang-arm-fropi

ENV PATH=/opt/ledger-blue/clang-arm-fropi/bin:/opt/ledger-blue/gcc-arm-none-eabi-5_3-2016q1/bin:$PATH
ENV BOLOS_ENV=/opt/ledger-blue

#################################################################
# BOLOS, Blue and Nano S SDK setup
#################################################################
RUN cd /home && git clone https://github.com/LedgerHQ/nanos-secure-sdk.git
RUN cd /home && git clone https://github.com/LedgerHQ/blue-secure-sdk.git

ENV BOLOS_SDK=/home/nanos-secure-sdk
ENV PYTHON=python3

#################################################################
# TODO: connection issues
# https://support.ledger.com/hc/en-us/articles/115005165269-Connection-issues-with-Windows-or-Linux
#################################################################
RUN cat /etc/group | grep plugdev
# RUN wget -q -O - https://raw.githubusercontent.com/LedgerHQ/udev-rules/master/add_udev_rules.sh | bash

#################################################################
# Application workspace here
#################################################################
RUN mkdir /home/workspace
WORKDIR /home/workspace

RUN cd /home/workspace && pip3 install pillow && pip install pillow
RUN pip3 install git+https://github.com/LedgerHQ/blue-loader-python.git --upgrade
RUN virtualenv -p python3 ledger && . ledger/bin/activate && pip3 install ledgerblue
# RUN virtualenv ledger && . ledger/bin/activate && pip install ledgerblue
