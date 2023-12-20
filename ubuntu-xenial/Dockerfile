#template dockerfile to build a centos-based build image
# run with "docker build --rm -t farm-centos-XXX Dockerfile.centos"

ARG distro=ubuntu
ARG version=xenial
FROM ${distro}:${version}
MAINTAINER "Francesco Chemolli <kinkie@squid-cache.org>"
ADD local/* /usr/local/bin/
RUN \
  sed -i~ 's!http://archive.ubuntu.com/ubuntu/!mirror://mirrors.ubuntu.com/mirrors.txt!' sources.list && \
  apt-get update && \
  apt-get upgrade --no-install-recommends -y && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    autoconf \
    autoconf-archive \
    automake \
    bzip2 \
    ccache \
    clang \
    curl \
    ed \
    g++ \
    git \
    gnutls-bin \
    libcap-dev \
    libcppunit-dev \
    libexpat-dev \
    libgnutls28-dev \
    libltdl-dev \
    libssl-dev \
    libtdb-dev \
    libtool \
    libtool-bin \
    libxml2-dev \
    make \
    nettle-dev \
    pandoc \
    pkg-config \
    po4a \
    translate-toolkit \
    xz-utils \
  && \
  apt-get autoremove -y && \
  apt-get clean -y && \
  true
RUN \
  groupadd -g 1000 jenk && \
  useradd -u 1000 -g jenk -m jenk && \
  groupadd -g 3128 jenkins && \
  useradd -u 3128 -g jenkins -m jenkins && \
  groupadd -g 1001 kinkie && \
  useradd -u 1001 -m -g kinkie kinkie && \
  true

USER jenkins
CMD ["/bin/bash", "-l"]
