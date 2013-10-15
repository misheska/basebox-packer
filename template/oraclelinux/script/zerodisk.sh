# Create file containing only zeros as big as there is free space available,
# so that compression will eliminate the useless data that is actually zero
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
