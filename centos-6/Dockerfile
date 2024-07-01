#template dockerfile to build a centos-based build image
# run with "docker build --rm -t farm-centos-XXX Dockerfile.centos"

FROM centos:centos6
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
LABEL org.opencontainers.image.source="https://github.com/kinkie/dockerfiles"
ADD devtools-2.repo /etc/yum.repos.d/
ADD local/* /usr/local/bin/
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm && \
  yum update -y && \
  yum install -y \
    autoconf \
    automake \
    bzip2 \
    ccache \
    clang \
    cppunit \
    cppunit-devel \
    curl \
    db4-devel \
    devtoolset-2-gcc \
    devtoolset-2-gcc-c++ \
    devtoolset-2-binutils \
    ed \
    expat-devel \
    git \
    gnutls-devel \
    gnutls-utils \
    libatomic \
    libcap \
    libcap-devel \
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
    perl-Pod-MinimumVersion \
    screen \
    translate-toolkit \
    vim \
    xz \
  && \
  yum clean all && \
  true
RUN \
  groupadd -g 1000 jenk && \
  useradd -u 1000 -m -g jenk -G ccache jenk && \
  groupadd -g 3128 jenkins && \
  useradd -u 3128 -m -g jenkins -G ccache jenkins && \
  groupadd -g 1001 kinkie && \
  useradd -u 1001 -m -g kinkie -G ccache kinkie && \
  rm -f /etc/profile.d/ccache* && \
  ln -s /opt/rh/devtoolset-2/enable /etc/profile.d/devtoolset-2.sh

USER jenkins
CMD ["/bin/bash", "-l"]
