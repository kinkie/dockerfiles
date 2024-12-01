ARG DISTRO=opensuse
ARG REPO=${DISTRO}/tumbleweed
ARG VERSION=latest
FROM ${REPO}:${VERSION}
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
LABEL org.opencontainers.image.source="https://github.com/kinkie/dockerfiles"
RUN \
  zypper --non-interactive up && \
  zypper --non-interactive install --no-confirm --auto-agree-with-licenses --force-resolution \
    autoconf \
    automake \
    bzip2 \
    ccache \
    clang \
    cppunit-devel \
    diff \
    ed \
    gawk \
    gcc-c++ \
    git \
    libgnutls-devel \
    gnutls \
    libcap-devel \
    libexpat-devel \
    libltdl7 \
    libnettle-devel \
    libopenssl-devel \
    libtool \
    libxml2-devel \
    make \
    pandoc \
    pkg-config \
    which \
  && \
  zypper --non-interactive clean
RUN \
  groupadd -g 3128 jenkins && \
  useradd -u 3128 -g 3128 jenkins && \
  groupadd -g 1001 kinkie && \
  useradd -u 1001 -g 1001 kinkie && \
  groupadd -g 1000 jenk && \
  useradd -u 1000 -g 1000 jenk

# old pacakges
#    java-1_8_0-openjdk-headless \
