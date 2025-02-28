#PLATFORMS amd64

FROM squidcache/buildfarm-fedora-41:latest
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
LABEL org.opencontainers.image.source="https://github.com/kinkie/dockerfiles/fedora-mingw"
LABEL description="Fedora MinGW userland used to build Squid"
USER root
RUN \
  dnf -y update && \
  dnf -y install \
    mingw64-binutils \
    mingw64-gcc-c++ \
    mingw64-libgnurx-static \
    mingw64-nettle \
    mingw64-openssl \
    mingw64-winpthreads \
    mingw64-zlib \
    wine \
  && \
  dnf -y clean all

USER jenkins
CMD ["/bin/bash", "-l"]

