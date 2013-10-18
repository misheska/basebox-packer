#!/bin/bash -eux

if [ $PACKER_BUILDER_TYPE == 'vmware' ]; then
    echo "Installing VMware Tools"
    apt-get install -y linux-headers-$(uname -r) build-essential perl

    cd /tmp
    mkdir -p /mnt/cdrom
    mount -o loop /home/vagrant/linux.iso /mnt/cdrom
    tar zxf /mnt/cdrom/VMwareTools-*.tar.gz -C /tmp/

    if [[ -f /mnt/cdrom/VMwareTools-9.2.2-893683.tar.gz ]]
    then
        # VMware Tools 9.2.2 build-893683 will fail to find the header files
        # Link to a place where it can find them
        pushd /lib/modules/$(uname -r)/build/include/linux
        ln -s ../generated/utsrelease.h
        ln -s ../generated/autoconf.h
        ln -s ../generated/uapi/linux/version.h
        popd -

        mkdir -p /mnt/floppy
        modprobe floppy
        mount -t vfat /dev/fd0 /mnt/floppy

        cd /tmp/vmware-tools-distrib

        # Patch vmhgfs so it will compile using the 3.8 header files
        pushd lib/modules/source
        if [ ! -f vmhgfs.tar.orig ]
        then
            cp vmhgfs.tar vmhgfs.tar.orig
        fi
        rm -rf vmhgfs-only
        tar xf vmhgfs.tar
        pushd vmhgfs-only/shared
        patch -p1 < /mnt/floppy/vmware9.compat_mm.patch
        popd
        tar cf vmhgfs.tar vmhgfs-only
        rm -rf vmhgfs-only
        popd

        # Patch vmci so it will compile using the 3.8 header files
        pushd lib/modules/source
        if [ ! -f vmci.tar.orig ]
        then
            cp vmci.tar vmci.tar.orig
        fi
        rm -rf vmci-only
        tar xf vmci.tar
        pushd vmci-only
        patch -p1 < /mnt/floppy/vmware9.k3.8rc4.patch
        popd
        tar cf vmci.tar vmci-only
        rm -rf vmci-only
        popd
    elif [[ -f /mnt/cdrom/VMwareTools-9.2.3-1031360.tar.gz ]]
    then
        mkdir -p /mnt/floppy
        modprobe floppy
        mount -t vfat /dev/fd0 /mnt/floppy

        cd /tmp/vmware-tools-distrib

        # Patch vmhgfs so it will compile using the 3.8 header files
        pushd lib/modules/source
        if [ ! -f vmhgfs.tar.orig ]
        then
            cp vmhgfs.tar vmhgfs.tar.orig
        fi
        rm -rf vmhgfs-only
        tar xf vmhgfs.tar
        pushd vmhgfs-only
        patch -p1 < /mnt/floppy/vmtools.inode.c.patch
        popd
        tar cf vmhgfs.tar vmhgfs-only
        rm -rf vmhgfs-only
        popd
    fi

    /tmp/vmware-tools-distrib/vmware-install.pl -d
    rm /home/vagrant/linux.iso
    umount /mnt/cdrom
    rmdir /mnt/cdrom

    apt-get -y remove linux-headers-$(uname -r) build-essential perl
    apt-get -y autoremove
elif [ $PACKER_BUILDER_TYPE == 'virtualbox' ]; then
    echo "Installing VirtualBox guest additions"

    apt-get install -y linux-headers-$(uname -r) build-essential perl
    apt-get install -y dkms

    VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
    mount -o loop /home/vagrant/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
    sh /mnt/VBoxLinuxAdditions.run --nox11
    umount /mnt
    rm /home/vagrant/VBoxGuestAdditions_$VBOX_VERSION.iso
fi
