#!/bin/bash -eux

echo "==> Disabling CDROM entries to avoid prompts to insert a disk"
sed -i "/^deb cdrom:/s/^/#/" /etc/apt/sources.list

apt-get -y update
apt-get -y upgrade
apt-get -y install curl wget
apt-get clean
