#template dockerfile to build a centos-based build image
# run with "docker build --rm -t farm-centos-XXX Dockerfile.centos"

ARG distro=ubuntu
ARG version=hirsute
FROM ${distro}:${version}
MAINTAINER "Francesco Chemolli <kinkie@squid-cache.org>"
ADD local/* /usr/local/bin/
RUN \
	apt-get update && \
	apt-get upgrade --no-install-recommends -y && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y \
		autoconf \
		autoconf-archive \
		automake \
		bzip2 \
		ca-certificates \
		ccache \
		clang \
		clang-12 \
		curl \
		ed \
		g++ \
		g++-11 \
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
	useradd -u 1000 -g jenkins -m jenkins && \
	groupadd -g 1001 kinkie && \
	useradd -u 1001 -m -g kinkie kinkie && \
	true

USER jenkins
CMD ["/bin/bash", "-l"]

# old packages, not needed anymore
#		default-jre-headless \
