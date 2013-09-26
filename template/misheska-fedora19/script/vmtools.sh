#!/bin/bash -eux

if test -f linux.iso ; then
    # Uninstall fuse to fake out the vmware install so it won't try to
    # enable the VMware blocking filesystem
    yum erase -y fuse
    # Assume that we've installed all the prerequisites:
    # kernel-headers-$(uname -r) kernel-devel-$(uname -r) gcc make perl
    # from the install media via ks.cfg

    cd /tmp
    mkdir -p /mnt/cdrom
    mount -o loop /home/vagrant/linux.iso /mnt/cdrom
    tar zxf /mnt/cdrom/VMwareTools-*.tar.gz -C /tmp/

    if [[ -f /mnt/cdrom/VMwareTools-9.2.2-893683.tar.gz ]]
    then
        # VMware Tools 9.2.2 build-893683 will fail to find the header files
        # Copy them to a place where it can find them
        ln -s /usr/src/kernels/$(uname -r)/include/generated/uapi/linux/version.h /usr/src/kernels/$(uname -r)/include/linux/version.h

        mkdir -p /mnt/floppy
        modprobe floppy
        mount -t vfat /dev/fd0 /mnt/floppy
        
        cd /tmp/vmware-tools-distrib

        # Patch vmci so it will compile using the 3.9 header files
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

        # Patch vmhgfs so it will compile using the 3.9 header files
        pushd lib/modules/source
        if [ ! -f vmhgfs.tar.orig ]
        then
            cp vmhgfs.tar vmhgfs.tar.orig
        fi
        rm -rf vmhgfs-only
        tar xf vmhgfs.tar
        pushd vmhgfs-only
        patch -p1 < /mnt/floppy/vmware9.k3.9.vmhgfs.patch
        popd
        pushd vmhgfs-only/shared
        patch -p1 < /mnt/floppy/vmware9.compat_mm.patch
        popd
        tar cf vmhgfs.tar vmhgfs-only
        rm -rf vmhgfs-only
        popd
        
        umount /mnt/floppy
        rmdir /mnt/floppy

        /tmp/vmware-tools-distrib/vmware-install.pl --clobber-kernel-modules=vmci -d
    else
        /tmp/vmware-tools-distrib/vmware-install.pl -d
    fi

    rm /home/vagrant/linux.iso
    umount /mnt/cdrom
    rmdir /mnt/cdrom
elif test -f .vbox_version ; then
    echo "Installing VirtualBox guest additions"

    # Assume that we've installed all the prerequisites:
    # kernel-headers-$(uname -r) kernel-devel-$(uname -r) gcc make perl
    # from the install media via ks.cfg

    VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
    mount -o loop /home/vagrant/VBoxGuestAdditions.iso /mnt
    sh /mnt/VBoxLinuxAdditions.run
    umount /mnt
    rm -rf /home/vagrant/VBoxGuestAdditions.iso
fi
