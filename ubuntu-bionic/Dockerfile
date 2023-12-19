#template dockerfile to build a centos-based build image
# run with "docker build --rm -t farm-centos-XXX Dockerfile.centos"

ARG distro=ubuntu
ARG version=bionic
FROM ${distro}:${version}
MAINTAINER "Francesco Chemolli <kinkie@squid-cache.org>"
ADD local/* /usr/local/bin/
#  sed -i~ 's!http://archive.ubuntu.com/ubuntu/!mirror://mirrors.ubuntu.com/mirrors.txt!' /etc/apt/sources.list && \
RUN \
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
    g++-8 \
    git \
    gnutls-bin \
    icecc \
    libcap-dev \
    libc6-dev \
    libcppunit-dev \
    libexpat-dev \
    libgnutls28-dev \
    libicu-dev \
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
    zlib1g-dev \
  && \
  apt-get autoremove -y && \
  apt-get clean -y && \
  if id ubuntu >/dev/null; then userdel -r ubuntu ; fi && \
  if getent group ubuntu >/dev/null; then groupdel ubuntu ; fi && \
  groupadd -g 3128 jenk && \
  useradd -u 3128 -g jenk -m jenk && \
  groupadd -g 1000 jenkins && \
  useradd -u 1000 -g jenkins -m jenkins && \
  groupadd -g 1001 kinkie && \
  useradd -u 1001 -m -g kinkie kinkie && \
  true
RUN \
  update-alternatives --install /usr/bin/g++ c++ /usr/bin/g++-8 20 && \
  update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-8 20 && \
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 20 && \
  true
USER jenkins
CMD ["/bin/bash", "-l"]
