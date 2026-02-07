#PLATFORMS amd64 arm64 arm ppc64le i386 riscv64

ARG distro=debian
ARG version=unstable

# FROM ${distro}:${version}
FROM public.ecr.aws/docker/library/${distro}:${version}

ARG distro
ARG version
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
LABEL org.opencontainers.image.source="https://github.com/kinkie/dockerfiles/${distro}-${version}"
LABEL description="${distro} ${version} userland used to build Squid"
RUN \
  . /etc/os-release && \
  echo "deb-src http://deb.debian.org/debian ${VERSION_CODENAME} main" >> /etc/apt/sources.list && \
  apt-get update && \
  apt-get build-dep -y squid && \
  apt-get install --no-install-recommends -y \
    autoconf-archive \
    ca-certificates \
    ccache \
    git \
    gnutls-bin \
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
