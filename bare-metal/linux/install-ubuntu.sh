#!/bin/bash

# to be tested

set -eo pipefail

dir=$(basedir $0)

apt purge -y snap 
apt -y update 
apt -y upgrade
apt -y install \
	apt-config-auto-update \
	cpufrequtils \
	docker.io \
	duplicity \
    fancontrol \
	lftp \
    lm-sensors \
	mosh \
	openjdk-11-jre-headless \
	rcs \
	unattended-upgrades \
	vim

# system
cp $dir/files/50unattended-upgrades /etc/apt/apt.conf.d

setup_ssh_user () {
	local u=$1
	mkdir -m 700 ~${u}/.ssh
	chown ${u}:${u} ~${u}/.ssh
	cp $dir/files/${u}-authorized-keys ~${u}/.ssh/authorized_keys
	chown ${u}:${u} ~${u}/.ssh/authorized_keys
	chmod 600 ~${u}/.ssh/authorized_keys
}

# jenkins
useradd -u 3128 -g 3128 -G docker -s /bin/bash -m jenkins
setup_ssh_user jenkins
su - jenkins -c '\
	mkdir -p workspace docker-imags/homedir && \
	touch workspace/CACHEDIR.TAG docker-imags/homedir/CACHEDIR.TAG && \
	true'

# kinkie
useradd -u 1001 -g 1001 -G docker -s /bin/bash -m kinkie
setup_ssh_user kinkie
setup_ssh_user root

sensors-detect --auto
pwmconfig

# passwords
echo "password for jenkins"
passwd jenkins

echo "password for kinkie"
passwd kinkie
