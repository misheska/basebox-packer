# Grub tweaks - default to RedHat-compatible kernel
echo -n "Grub tweaks"
sed -i 's/^default=1/default=2/' /boot/grub/grub.conf

# reboot
echo "Rebooting the machine..."
reboot
sleep 60
