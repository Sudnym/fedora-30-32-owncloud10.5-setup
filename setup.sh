#!/bin/bash

echo "Installing dependencies $(yes | dnf install criu) $(yes | dnf install container-selinux containerd libbsd libnet runc) $(yes | dnf install moby-engine)"

if [ "$3" = yes ]
then
	echo "Enabling backwards compatibility for cgroups$(grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0")"
else
	echo "Skipping cgroups backwards compatibility."
fi

echo "$(systemctl start docker)"

echo "$(sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose)"

echo "$(sudo chmod +x /usr/local/bin/docker-compose)"

echo "Beginning owncloud install"

echo "$(mkdir owncloud-docker-server)"

echo "$(cd owncloud-docker-server && wget https://raw.githubusercontent.com/owncloud/docs/master/modules/admin_manual/examples/installation/docker/docker-compose.yml)"
user=$1
pass=$2
echo "$(cd owncloud-docker-server && echo $'OWNCLOUD_VERSION=10.5\nOWNCLOUD_DOMAIN=localhost\nADMIN_USERNAME='"$user"$'\nADMIN_PASSWORD='"$pass"$'\nHTTP_PORT=8080\n' > .env)"
echo "$(cd owncloud-docker-server && docker-compose up -d)"


