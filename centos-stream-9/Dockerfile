#template dockerfile to build a centos-based build image
# run with "docker build --rm -t farm-centos-XXX Dockerfile.centos"

FROM quay.io/centos/centos:stream9
MAINTAINER "Francesco Chemolli <kinkie@squid-cache.org>"
ADD local/* /usr/local/bin/
RUN \
    dnf -y install dnf-plugins-core && \
	dnf install -y epel-release 'dnf-command(config-manager)' && \
    dnf config-manager --set-enabled crb && \
	dnf update -y && \
    dnf install -y \
        autoconf \
        automake \
        bzip2 \
        ccache \
        clang \
        cppunit \
        cppunit-devel \
        ed \
        expat-devel \
        file \
        git \
        gnutls-devel \
        gnutls-utils \
        libatomic \
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
        perl-Perl-MinimumVersion \
        screen \
        vim \
        xz \
	&& \
	dnf clean all && \
	rm -f /etc/profile.d/ccache* && \
	true
RUN \
    test -e /usr/lib64/libatomic.so.1 -a ! -e /usr/lib64/libatomic.so && \
    ln -s /usr/lib64/libatomic.so.1 /usr/lib64/libatomic.so && \
    ldconfig
RUN \
	groupadd -g 1000 jenkins && \
	useradd -u 1000 -m -g jenkins -G ccache jenkins && \
	groupadd -g 1001 kinkie && \
	useradd -u 1001 -m -g kinkie -G ccache kinkie && \
	true

USER jenkins
CMD ["/bin/bash", "-l"]
