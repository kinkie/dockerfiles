#PLATFORMS amd64 arm64 arm riscv64 ppc64le
#EOL 20320501

ARG distro=ubuntu
ARG version=focal

# FROM ${distro}:${version}
FROM public.ecr.aws/${distro}/${distro}:${version}

ARG distro
ARG version
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
LABEL org.opencontainers.image.source="https://github.com/kinkie/dockerfiles/${distro}-${version}"
LABEL description="${distro} ${version} userland used to build Squid"
RUN \
  . /etc/os-release && \
  echo "deb-src mirror://mirrors.ubuntu.com/mirrors.txt ${VERSION_CODENAME} main" >> /etc/apt/sources.list && \
  apt-get update && \
  apt-get upgrade --no-install-recommends -y && \
  apt-get build-dep -y squid && \
  apt-get install --no-install-recommends -y \
    autoconf-archive \
    ca-certificates \
    ccache \
    git \
    gnutls-bin \
    libtool-bin \
  && \
  apt-get autoremove -y && \
  apt-get clean -y && \
  true
RUN \
  if id ubuntu >/dev/null; then userdel -r ubuntu ; fi && \
  if getent group ubuntu >/dev/null; then groupdel ubuntu ; fi && \
  groupadd -g 1000 jenk && \
  useradd -u 1000 -g jenk -m jenk && \
  groupadd -g 3128 jenkins && \
  useradd -u 3128 -g jenkins -m jenkins && \
  groupadd -g 1001 kinkie && \
  useradd -u 1001 -m -g kinkie kinkie && \
  true

USER jenkins
CMD ["/bin/bash", "-l"]

# old packages, not needed anymore
#    default-jre-headless \
