#!/usr/bin/env bash

DISK='/dev/sda'
ROOT_PARTITION=${DISK}1

echo "==> clearing partition table on ${DISK}"
/usr/bin/sgdisk --zap ${DISK}

echo "==> destroying magic strings and signatures on ${DISK}"
/usr/bin/dd if=/dev/zero of=${DISK} bs=512 count=2048
/usr/bin/wipefs --all ${DISK}

echo "==> creating /root partition on ${DISK}"
/usr/bin/sgdisk --new=1:0:0 ${DISK}

echo "==> setting ${DISK} as bootable"
/usr/bin/sgdisk ${DISK} --attributes=1:set:2

echo '==> creating /root filesystem (ext4)'
/usr/bin/mkfs.ext4 -F -m 0 -q -L root ${ROOT_PARTITION}

echo "==> mounting ${ROOT_PARTITION} to /mnt"
/usr/bin/mount -o noatime,errors=remount-ro ${ROOT_PARTITION} /mnt

echo '==> bootstrapping the base system'
/usr/bin/pacstrap /mnt base base-devel
/usr/bin/arch-chroot /mnt pacman -S --noconfirm gptfdisk openssh syslinux
/usr/bin/arch-chroot /mnt syslinux-install_update -i -a -m
/usr/bin/sed -i 's/sda3/sda1/' "/mnt/boot/syslinux/syslinux.cfg"
/usr/bin/sed -i 's/TIMEOUT 50/TIMEOUT 10/' "${TARGET_DIR}/boot/syslinux/syslinux.cfg"

echo '==> generating the filesystem table'
/usr/bin/genfstab -p /mnt >> /mnt/etc/fstab
