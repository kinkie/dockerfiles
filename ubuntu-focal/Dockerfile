#template dockerfile to build a centos-based build image
# run with "docker build --rm -t farm-centos-XXX Dockerfile.centos"

ARG distro=ubuntu
ARG version=focal
FROM ${distro}:${version}
MAINTAINER "Francesco Chemolli <kinkie@squid-cache.org>"
ADD local/* /usr/local/bin/
# ENV http_proxy=""
#	sed -i~ 's!http://archive.ubuntu.com/ubuntu/!mirror://mirrors.ubuntu.com/mirrors.txt!' /etc/apt/sources.list && \
RUN \
	apt-get update && \
	apt-get upgrade -y apt && \
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
		curl \
		ed \
		g++ \
		git \
		gnutls-bin \
		icecc \
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
		make \
		nettle-dev \
		pkg-config \
		po4a \
		translate-toolkit \
		xz-utils \
	&& \
	apt-get autoremove -y && \
	apt-get clean -y && \
	if id ubuntu >/dev/null; then userdel -r ubuntu ; fi && \
	if getent group ubuntu >/dev/null; then groupdel ubuntu ; fi && \
	groupadd -g 1000 jenkins && \
	useradd -u 1000 -g jenkins -m jenkins && \
	groupadd -g 1001 kinkie && \
	useradd -u 1001 -m -g kinkie kinkie && \
	true

USER jenkins
CMD ["/bin/bash", "-l"]

# old packages, not needed anymore
#		default-jre-headless \
