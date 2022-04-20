#!/bin/bash

# to be tested

set -eo pipefail

dir=$(basedir $0)

apt purge -y snap 
apt -y update 
apt -y upgrade
apt -y install \
	cpufrequtils \
	docker.io \
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
useradd -u 1000 -g 1000 -G docker -s /bin/bash -m jenkins
setup_ssh_user jenkins

# kinkie
useradd -u 1001 -g 1001 -G docker -s /bin/bash -m kinkie
setup_ssh_user kinkie

# passwords
echo "password for jenkins"
passwd jenkins

echo "password for kinkie"
passwd kinkie
