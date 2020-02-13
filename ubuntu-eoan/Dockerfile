#template dockerfile to build a centos-based build image
# run with "docker build --rm -t farm-centos-XXX Dockerfile.centos"

ARG distro=ubuntu
ARG version=eoan
FROM ${distro}:${version}
MAINTAINER "Francesco Chemolli <kinkie@squid-cache.org>"
ADD local/* /usr/local/bin/
RUN \
	apt-get update && \
	apt-get upgrade --no-install-recommends -y && \
	apt-get install --no-install-recommends -y \
		autoconf \
		autoconf-archive \
		automake \
		bzip2 \
		ccache \
		clang \
		curl \
		default-jre-headless \
		g++ \
		g++-8 \
		git \
		gnutls-bin \
		libcap-dev \
		libcppunit-dev \
		libexpat-dev \
		libgnutls28-dev \
		libltdl-dev \
		libssl-dev \
		libtdb-dev \
		libtool \
		libtool-bin \
		libxml2-dev \
		lsb-release \
		make \
		nettle-dev \
		pkg-config \
		po4a \
		translate-toolkit \
		xz-utils \
	&& \
	apt-get autoremove -y && \
	apt-get clean -y && \
	groupadd -g 1000 jenkins && \
	useradd -u 1000 -m -g jenkins jenkins

USER jenkins
CMD ["/bin/bash", "-l"]
