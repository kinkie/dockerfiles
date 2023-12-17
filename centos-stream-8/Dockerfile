#template dockerfile to build a centos-based build image
# run with "docker build --rm -t farm-centos-XXX Dockerfile.centos"

FROM quay.io/centos/centos:stream8
MAINTAINER "Francesco Chemolli <kinkie@squid-cache.org>"
ADD local/* /usr/local/bin/
RUN \
	dnf -y install dnf-plugins-core && \
	dnf install -y epel-release 'dnf-command(config-manager)' && \
	dnf config-manager --set-enabled powertools && \
	dnf update -y && \
	dnf makecache && \
	dnf install -y \
		autoconf \
		automake \
		bzip2 \
		ccache \
		clang \
		cppunit \
		cppunit-devel \
		curl \
		ed \
		expat-devel \
		file \
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
	(cd /usr/lib64; ln -s libatomic.so.1 libatomic.so) && \
	ln -s `rpm -ql libatomic-static | grep -F libatomic.a` /usr/lib64/libatomic.a && \
	ldconfig -v
RUN \
	groupadd -g 3128 jenk && \
	useradd -u 3128 -g jenk -m jenk && \
	groupadd -g 1000 jenkins && \
	useradd -u 1000 -m -g jenkins -G ccache jenkins && \
	groupadd -g 1001 kinkie && \
	useradd -u 1001 -m -g kinkie -G ccache kinkie && \
	true

USER jenkins
CMD ["/bin/bash", "-l"]
