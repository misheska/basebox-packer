#!/bin/bash

# Add the Docker repository to your apt sources list.
echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list

# Update your sources
apt-get update

# Install, you will see another warning that the package cannot be authenticated. Confirm install.
apt-get install -y --force-yes lxc-docker

# Enable memory and swap accounting
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"/' /etc/default/grub
update-grub
