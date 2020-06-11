#!/bin/bash

echo "Installing criu $(yes | dnf install criu) criu installed\ninstalling dependencies &(yes | dnf install container-selinux containerd libbsd libnet runc) dependencies installed.\nInstalling moby-engine.$(yes | dnf install moby-engine)moby-engine installed."

version = $(cat /etc/fedora-release | grep "31")
if [ $version = 31 ]
then
	echo "Enabling backwards compatibility for cgroups\n$(grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0")"
fi

if [ $version = 32 ]
then
	echo "Enabling backwards compatibility for cgroups\n$(grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0")"
else
	echo "Skipping cgroups backwards compatibility."
fi

echo "$(systemctl start docker)"

echo "$(sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose)"

echo "$(sudo chmod +x /usr/local/bin/docker-compose)"

echo "Beginning owncloud install"

echo "$(mkdir owncloud-docker-server && cd owncloud-docker-server)"

echo "$(wget https://raw.githubusercontent.com/owncloud/docs/master/modules/admin_manual/examples/installation/docker/docker-compose.yml)"
user=$1
pass=$2
echo $'OWNCLOUD_VERSION=10.5\nOWNCLOUD_DOMAIN=localhost\nADMIN_USERNAME='$user$'\nADMIN_PASSWORD='$pass$'\nHTTP_PORT=8080\nEOF' > .env
echo "$(docker-compose up -d)"


