#!/bin/bash -eux

if test -f linux.iso ; then
    cd /tmp
    mkdir -p /mnt/cdrom
    mount -o loop /home/vagrant/linux.iso /mnt/cdrom
    tar zxf /mnt/cdrom/VMwareTools-*.tar.gz -C /tmp/
    /tmp/vmware-tools-distrib/vmware-install.pl -d
    rm /home/vagrant/linux.iso
    umount /mnt/cdrom
    rmdir /mnt/cdrom
elif test -f .vbox_version ; then
    echo -e "\ninstall the virtualbox guest additions ..."
    zypper --non-interactive remove `rpm -qa virtualbox-guest-*`
    VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
    cd /tmp
    wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
    #wget http://192.168.178.10/VBoxGuestAdditions_$VBOX_VERSION.iso
    mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
    sh /mnt/VBoxLinuxAdditions.run
    umount /mnt
    rm -f VBoxGuestAdditions_$VBOX_VERSION.iso
fi
