#PLATFORMS amd64 arm arm64
# i386 disabled because in docker uname -m returns wrong arch, confusing blake3
# See https://packages.gentoo.org/packages/dev-libs/blake3
ARG distro=gentoo
FROM ${distro}/stage3:latest
ARG distro
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
LABEL org.opencontainers.image.source="https://github.com/kinkie/dockerfiles/${distro}"
LABEL description="${distro} userland used to build Squid"
RUN \
  echo 'FEATURES="-ipc-sandbox -network-sandbox -pid-sandbox"' >>/etc/portage/make.conf && \
  echo 'USE="-X -fortran -objc -objc++ -rust -readline -xattr -nls -office_implementation_libreoffice minimal"' >>/etc/portage/make.conf && \
  emerge-webrsync && \
  emaint sync -ay >/dev/null && \
  eselect news read >/dev/null && \
  true

RUN \
  emerge -j`nproc` -l`nproc` -q \
    dev-util/ccache \
    dev-util/cppunit \
    dev-vcs/git \
    gentoolkit \
    net-nds/openldap \
    sys-apps/ed \
    llvm-core/clang \
    sys-libs/libcap \
    sys-libs/tdb \
    && \
  emerge --depclean && \
  eclean --deep distfiles && eclean-pkg && \
  ln -s /usr/lib/llvm/*/bin/* /usr/local/bin && \
  rm -rf /var/db/repos/gentoo && \
  true
RUN \
  groupadd -g 3128 jenkins && \
  useradd -u 3128 -g jenkins -m jenkins && \
  groupadd -g 1001 kinkie && \
  useradd -u 1001 -m -g kinkie kinkie && \
  groupadd -g 1000 jenk && \
  useradd -u 1000 -g jenk -m jenk && \
  true

#    app-text/pandoc \ # pandoc required ghc which fails building on an internal error
USER jenkins
CMD ["/bin/bash", "-l"]

