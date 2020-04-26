#template dockerfile to build a centos-based build image
# run with "docker build --rm -t farm-centos-XXX Dockerfile.centos"

ARG distro=ubuntu
ARG version=trusty
FROM ${distro}:${version}
MAINTAINER "Francesco Chemolli <kinkie@squid-cache.org>"
ADD openjdk-r-ppa-trusty.list /etc/apt/sources.list.d/
ADD local/* /usr/local/bin/
RUN \
	apt-get update && \
	apt-get upgrade --no-install-recommends -y && \
	DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y --force-yes \
		autoconf \
		autoconf-archive \
		automake \
		bzip2 \
		ccache \
		clang \
		curl \
		ed \
		g++ \
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
