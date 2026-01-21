#PLATFORMS amd64

FROM ghcr.io/kinkie/buildfarm-fedora-43:latest AS base
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

FROM base AS final
ARG cppunit_src="cppunit-1.15.1.tar.gz"
ARG cppunit_repo="http://dev-www.libreoffice.org/src"
ARG cppunit_prefix="/usr/x86_64-w64-mingw32/sys-root/mingw/"
ENV cppunit_src=${cppunit_src:-problem}
ENV cppunit_repo=${cppunit_repo:-problem}
ENV cppunit_prefix=${cppunit_prefix:-problem}

RUN \
    curl -L -O curl -L -O ${cppunit_repo}/${cppunit_src} && \
    tar xfz ${cppunit_src} && \
    cd cppunit-1.15.1 && \
    ./configure --host=x86_64-w64-mingw32 --prefix=${cppunit_prefix} && \
    make install-pkgconfigDATA && \
    test -e ${cppunit_prefix}/lib/pkgconfig/cppunit.pc && \
    make -j`nproc` -C src/cppunit/ install && make -C include install && \
    cd .. && rm -rf cppunit-1.15.1 ${cppunit_src} && \
    test -e ${cppunit_prefix}/include/cppunit && \
    true

USER jenkins
CMD ["/bin/bash", "-l"]

