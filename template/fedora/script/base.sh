# Base install

# Make ssh quicker in disconnected situations.
echo 'UseDNS no' >> /etc/ssh/sshd_config

# Ensure NFS mounts work properly
yum install -y nfs-utils
