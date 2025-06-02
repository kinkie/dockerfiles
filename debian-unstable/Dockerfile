#PLATFORMS amd64 arm64 arm riscv64 ppc64le i386

ARG distro=debian
ARG version=unstable
FROM ${distro}:${version}
ARG distro
ARG version
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
LABEL org.opencontainers.image.source="https://github.com/kinkie/dockerfiles/${distro}-${version}"
LABEL description="${distro} ${version} userland used to build Squid"
RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    autoconf \
    autoconf-archive \
    automake \
    bzip2 \
    ca-certificates \
    ccache \
    clang \
    curl \
    default-jre-headless \
    ed \
    g++ \
    g++-mingw-w64 \
    groff \
    git \
    gnutls-bin \
    icecc \
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
    linuxdoc-tools \
    m4 \
    make \
    nettle-dev \
    pandoc \
    pkg-config \
    po4a \
    translate-toolkit \
    xz-utils \
  && \
  apt-get upgrade --no-install-recommends -y && \
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
