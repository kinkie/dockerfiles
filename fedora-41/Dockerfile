# EOL Nov 2025
#PLATFORMS amd64 arm64 ppc64le

ARG distro=fedora
ARG version=41
FROM ${distro}:${version}
ARG distro
ARG version
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
LABEL org.opencontainers.image.source="https://github.com/kinkie/dockerfiles/${distro}-${version}"
LABEL description="${distro} ${version} userland used to build Squid"
#  yum clean all && yum swap fakesystemd systemd \
RUN \
  dnf install -y \
    autoconf \
    automake \
    bzip2 \
    ccache \
    clang \
    cppunit \
    cppunit-devel \
    curl \
    diffutils \
    ed \
    expat-devel \
    gcc-c++ \
    git \
    gnutls-devel \
    gnutls-utils \
    icecream \
    libatomic \
    libatomic-static \
    libcap-devel \
    libtdb-devel \
    libtool \
    libtool-ltdl-devel \
    libxml2-devel \
    make \
    nettle-devel \
    openldap-devel \
    openssl-devel \
    pam-devel \
    pandoc \
    perl-Pod-MinimumVersion \
    pkgconf-pkg-config \
    which \
    xz \
  && \
  yum clean all && \
  rm /etc/profile.d/ccache* && \
  true
RUN \
  groupadd -g 1000 jenk && \
  useradd -u 1000 -g jenk -m jenk && \
  groupadd -g 3128 jenkins && \
  useradd -u 3128 -g jenkins -m jenkins && \
  groupadd -g 1001 kinkie && \
  useradd -u 1001 -m -g kinkie kinkie && \
  true
RUN \
  if [ "`uname -m`" = "armv7l" -a -f /usr/bin/armv7hl-redhat-linux-gnueabi-pkg-config ] ; then rm -f /usr/bin/pkg-config && ln -s /usr/bin/armv7hl-redhat-linux-gnueabi-pkg-config /usr/bin/pkg-config; fi

USER jenkins
CMD ["/bin/bash", "-l"]

