FROM gentoo/stage3:latest
LABEL maintainer="Francesco Chemolli <kinkie@squid-cache.org>"
ADD local/* /usr/local/bin/
RUN \
  echo 'USE="-X -alsa* -apache2* -fortran -office_implementation_libreoffice -ada* -lcd* -libreoffice* -video* -xtables* -perl"' >>/etc/portage/make.conf && \
  if [ "`uname -m`" = "armv7l" ]; then \
    echo 'EMERGE_DEFAULT_OPTS="--jobs 1"' >> /etc/portage/make.conf ; \
    echo 'MAKEOPTS="-j2"' >> /etc/portage/make.conf; \
  fi && \
  true
RUN \
  emerge-webrsync && \
  emaint sync -ay >/dev/null && \
  eselect news read >/dev/null && \
  true
RUN \
  emerge -q \
    dev-util/ccache \
    dev-util/cppunit \
    dev-vcs/git \
    gentoolkit \
    net-nds/openldap \
    sys-apps/ed \
    sys-devel/clang \
    sys-libs/libcap \
    sys-libs/tdb \
    && \
  emerge --depclean && \
  eclean --deep distfiles && eclean-pkg && \
  ln -s /usr/lib/llvm/*/bin/* /usr/local/bin && \
  rm -rf /var/db/repos/gentoo && \
  true
RUN \
  groupadd -g 1000 jenkins && \
  useradd -u 1000 -g jenkins -m jenkins && \
  groupadd -g 1001 kinkie && \
  useradd -u 1001 -m -g kinkie kinkie && \
  groupadd -g 3128 jenk && \
  useradd -u 3128 -g jenk -m jenk && \
  true

#    app-text/pandoc \ # pandoc required ghc which fails building on an internal error 
USER jenkins
CMD ["/bin/bash", "-l"]

