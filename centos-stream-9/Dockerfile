#PLATFORMS amd64 arm64

ARG distro=centos
ARG variant=stream
ARG version=9
FROM quay.io/${distro}/${distro}:${variant}${version}
ARG distro
ARG variant
ARG version
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
LABEL org.opencontainers.image.source="https://github.com/kinkie/dockerfiles/${distro}-${variant}-${version}"
LABEL description="${distro} ${variant} ${version} userland used to build Squid"
RUN \
  dnf -y install dnf-plugins-core && \
  dnf install -y epel-release 'dnf-command(config-manager)' && \
  dnf config-manager --set-enabled crb && \
  dnf update -y && \
  dnf install -y \
    autoconf \
    automake \
    bzip2 \
    ccache \
    clang \
    cppunit \
    cppunit-devel \
    ed \
    expat-devel \
    file \
    git \
    gnutls-devel \
    gnutls-utils \
    libatomic \
    gcc-toolset-12-libatomic-devel \
    libcap \
    libcap-devel \
    libdb-devel \
    libtdb \
    libtdb-devel \
    libtool \
    libtool-ltdl-devel \
    libxml2 \
    libxml2-devel \
    make \
    nettle-devel \
    openldap-devel \
    openssl-devel \
    pam-devel \
    pandoc \
    perl-Perl-MinimumVersion \
    screen \
    vim \
    xz \
  && \
  dnf clean all && \
  rm -f /etc/profile.d/ccache* && \
  true
RUN \
  test -e /usr/lib64/libatomic.so.1 -a ! -e /usr/lib64/libatomic.so && \
  (cd /usr/lib64; ln -s libatomic.so.1 libatomic.so) && \
  ln -s `rpm -ql libatomic-static | grep -F libatomic.a` /usr/lib64/libatomic.a && \
  ldconfig -v
RUN \
  groupadd -g 1000 jenk && \
  useradd -u 1000 -g jenk -m jenk && \
  groupadd -g 3128 jenkins && \
  useradd -u 3128 -m -g jenkins -G ccache jenkins && \
  groupadd -g 1001 kinkie && \
  useradd -u 1001 -m -g kinkie -G ccache kinkie && \
  true

USER jenkins
CMD ["/bin/bash", "-l"]
