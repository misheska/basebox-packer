#!/usr/bin/env bash

if [ $PACKER_BUILDER_TYPE == 'vmware' ]; then
    echo "Installing VMware Tools"
    echo "The official VMware Tools do not currently support Arch Linux,"
    echo "and the open-vm-tools do not support the 3.11 kernel."
    echo "You will see an error about HGFS not being installed and shared"
    echo "folders will not work, but otherwise the box will work without"
    echo "the VMware Tools being installed."
elif [ $PACKER_BUILDER_TYPE == 'virtualbox' ]; then
    echo "Installing VirtualBox guest additions"
arch-chroot /mnt <<ENDCHROOT
/usr/bin/pacman -S --noconfirm linux-headers virtualbox-guest-utils virtualbox-guest-dkms
echo -e 'vboxguest\nvboxsf\nvboxvideo' > /etc/modules-load.d/virtualbox.conf
guest_version=\$(/usr/bin/pacman -Q virtualbox-guest-dkms | awk '{ print \$2 }' | cut -d'-' -f1)
kernel_version="\$(/usr/bin/pacman -Q linux | awk '{ print \$2 }')-ARCH"
/usr/bin/dkms install "vboxguest/\${guest_version}" -k "\${kernel_version}/x86_64"
/usr/bin/systemctl enable dkms.service
/usr/bin/systemctl enable vboxservice.service
ENDCHROOT
fi
