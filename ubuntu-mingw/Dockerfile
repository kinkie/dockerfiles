#PLATFORMS amd64
# squid build image, plus wine development
FROM squidcache/buildfarm-ubuntu-noble:latest
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
LABEL org.opencontainers.image.source="https://github.com/kinkie/dockerfiles"
USER root
RUN \
  apt -y update && \
  apt -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y \
    mingw-w64 \
    wine-binfmt \
    zstd \
  && \
  true
RUN \
    cd && \
    curl -L https://mirror.msys2.org/mingw/sources/mingw-w64-libgnurx-2.5.1-3.src.tar.zst -o mingw-w64-libgnurx-2.5.1-3.src.tar.zst && \
    tar xvfa mingw-w64-libgnurx-2.5.1-3.src.tar.zst && \
    cd mingw-w64-libgnurx && \
    tar xvfa mingw-libgnurx-2.5.1-src.tar.gz && \
    cd mingw-libgnurx-2.5.1 && \
    ./configure --prefix=/usr/x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --build=x86_64-pc-linux-gnu && \
    make all install && \
    cd ../.. && \
    rm -rf mingw-w64-libgnurx-2.5.1-3.src.tar.zst mingw-w64-libgnurx

USER jenkins
CMD ["/bin/bash", "-l"]
