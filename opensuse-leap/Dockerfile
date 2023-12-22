# note: standard gcc and clang have issues with some c++17 support 2023-12-22

ARG DISTRO=opensuse/leap
ARG VERSION=latest
FROM ${DISTRO}:${VERSION}
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
ADD local/* /usr/local/bin/
RUN \
  zypper --non-interactive up && \
  zypper --non-interactive install --no-confirm --auto-agree-with-licenses --force-resolution \
    autoconf \
    automake \
    bzip2 \
    ccache \
    clang15 \
    cppunit-devel \
    ed \
    gcc13-c++ \
    git \
    libgnutls-devel \
    gnutls \
    gzip \
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
    xz \
  && \
  zypper --non-interactive clean
RUN \
  groupadd -g 3128 jenkins && \
  useradd -u 3128 -g 3128 jenkins && \
  groupadd -g 1001 kinkie && \
  useradd -u 1001 -g 1001 kinkie && \
  groupadd -g 1000 jenk && \
  useradd -u 1000 -g 1000 jenk

USER jenkins
CMD ["/bin/bash", "-l"]
