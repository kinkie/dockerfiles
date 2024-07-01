#template dockerfile to build a centos-based build image
# run with "docker build --rm -t farm-centos-XXX Dockerfile.centos"

FROM centos:centos8
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
LABEL org.opencontainers.image.source="https://github.com/kinkie/dockerfiles"
ADD local/* /usr/local/bin/
RUN \
  sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
  sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* && \
  dnf -y install dnf-plugins-core && \
  dnf install -y epel-release 'dnf-command(config-manager)' && \
  dnf update -y && \
  dnf config-manager --set-enabled powertools && \
  dnf update -y && \
  dnf makecache && \
  dnf install -y \
    autoconf \
    automake \
    bzip2 \
    ccache \
    clang \
    curl \
    ed \
    expat-devel \
    git \
    gnutls-devel \
    gnutls-utils \
    libatomic \
    libatomic-static \
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
  dnf install -y \
    cppunit \
    cppunit-devel \
  && \
  dnf clean all && \
  rm -f /etc/profile.d/ccache* && \
  true
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
