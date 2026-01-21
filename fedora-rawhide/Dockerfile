#PLATFORMS amd64 arm64 ppc64le

ARG distro=fedora
ARG version=rawhide

# FROM ${distro}:${version}
FROM quay.io/${distro}/${distro}:${version}

ARG distro
ARG version
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
LABEL org.opencontainers.image.source="https://github.com/kinkie/dockerfiles/${distro}-${version}"
LABEL description="${distro} ${version} userland used to build Squid"
#  dnf clean all && yum swap fakesystemd systemd \
#  dnf -y update --releasever=30 fedora-repos\* fedora-release dnf && \
#  rpm --import https://src.fedoraproject.org/rpms/fedora-repos/raw/master/f/RPM-GPG-KEY-fedora-32-primary && \
#    libdb4-devel \
RUN \
  dnf update -y && \
  dnf install -y --setopt=install_weak_deps=False \
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
    libatomic \
    libcap-devel \
    libtdb-devel \
    libtool \
    libtool-ltdl-devel \
    libxml2-devel \
    m4 \
    make \
    nettle-devel \
    openldap-devel \
    openssl-devel \
    pandoc \
    pam-devel \
    perl-Pod-MinimumVersion \
    pkgconf-pkg-config \
    xz \
    which \
  && \
  yum clean all && \
  true
RUN \
  groupadd -g 1000 jenk && \
  useradd -u 1000 -g jenk -m jenk && \
  groupadd -g 3128 jenkins && \
  useradd -u 3128 -g jenkins -m jenkins && \
  groupadd -g 1001 kinkie && \
  useradd -u 1001 -m -g kinkie kinkie && \
  rm -f /usr/local/bin/ccache && \
  true
RUN \
  if [ "`uname -m`" = "armv7l" -a -f /usr/bin/armv7hl-redhat-linux-gnueabi-pkg-config ] ; then rm -f /usr/bin/pkg-config && ln -s /usr/bin/armv7hl-redhat-linux-gnueabi-pkg-config /usr/bin/pkg-config; fi

USER jenkins
CMD ["/bin/bash", "-l"]

