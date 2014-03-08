# Grub tweaks - default to RedHat-compatible kernel
echo -n "Grub tweaks"
sed -i 's/^default=0/default=1/' /boot/grub/grub.conf

# reboot
echo "Rebooting the machine..."
reboot
sleep 60
