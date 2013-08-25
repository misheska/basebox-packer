#!/bin/bash -eux

if test -f linux.iso ; then
    echo "Installing VMware Tools"
    apt-get install -y linux-headers-$(uname -r) build-essential perl

    cd /tmp
    mkdir -p /mnt/cdrom
    mount -o loop /home/packer/linux.iso /mnt/cdrom
    tar zxf /mnt/cdrom/VMwareTools-*.tar.gz -C /tmp/
    /tmp/vmware-tools-distrib/vmware-install.pl -d
    rm /home/packer/linux.iso
    umount /mnt/cdrom
    rmdir /mnt/cdrom

    apt-get -y remove linux-headers-$(uname -r) build-essential perl
    apt-get -y autoremove
elif test -f .vbox_version ; then
    echo "Installing VirtualBox guest additions"

    apt-get install -y linux-headers-$(uname -r) build-essential perl
    apt-get install -y dkms

    VBOX_VERSION=$(cat /home/packer/.vbox_version)
    mount -o loop /home/packer/VBoxGuestAdditions.iso /mnt
    sh /mnt/VBoxLinuxAdditions.run
    umount /mnt
    rm /home/packer/VBoxGuestAdditions.iso
fi
