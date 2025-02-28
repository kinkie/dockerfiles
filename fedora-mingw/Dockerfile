#PLATFORMS amd64

FROM squidcache/buildfarm-fedora-41:latest
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
LABEL org.opencontainers.image.source="https://github.com/kinkie/dockerfiles/${distro}-${version}"
LABEL description="${distro} ${version} userland used to build Squid"
USER root
RUN \
  yum update && \
  dnf install -y \
    mingw64-binutils \
    mingw64-expat \
    mingw64-gcc-c++ \
    mingw64-libgnurx \
    mingw64-libxml2 \
    mingw64-llvm \
    mingw64-nettle \
    mingw64-openssl \
    mingw64-winpthreads \
    mingw64-yaml-cpp \
    mingw64-zlib \
  && \
  yum clean all

USER jenkins
CMD ["/bin/bash", "-l"]

