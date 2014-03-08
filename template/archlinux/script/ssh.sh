#!/usr/bin/env bash

arch-chroot /mnt <<ENDCHROOT
pacman -S --noconfirm openssh
# Make sure SSH is allowed
echo "sshd:        ALL" > /etc/hosts.allow
# And everything else isn't
echo "ALL:        ALL" > /etc/hosts.deny
# Make sure sshd starts on boot
systemctl enable sshd.service
/usr/bin/sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
ENDCHROOT
