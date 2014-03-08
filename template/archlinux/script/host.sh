#!/usr/bin/env bash

arch-chroot /mnt <<ENDCHROOT
echo 'vagrant-arch.vagrantup.com' > /etc/hostname
/usr/bin/ln -s /usr/share/zoneinfo/UTC /etc/localtime
echo 'KEYMAP=us' > /etc/vconsole.conf
/usr/bin/sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
/usr/bin/locale-gen
/usr/bin/mkinitcpio -p linux
# https://wiki.archlinux.org/index.php/Network_Configuration#Device_names
/usr/bin/ln -s /dev/null /etc/udev/rules.d/80-net-name-slot.rules
/usr/bin/ln -s '/usr/lib/systemd/system/dhcpcd@.service' '/etc/systemd/system/multi-user.target.wants/dhcpcd@eth0.service'
/usr/bin/sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
ENDCHROOT
