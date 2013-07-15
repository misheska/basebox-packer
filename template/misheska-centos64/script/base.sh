# Base install

# Update root certs (otherwise Chef client won't install)
wget -O/etc/pki/tls/certs/ca-bundle.crt http://curl.haxx.se/ca/cacert.pem

# Disable fastest mirrors plugin
sed -i "s|enabled=1|enabled=0|" /etc/yum/pluginconf.d/fastestmirror.conf

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
sed -i "s/^\(.*env_keep = \"\)/\1PATH /" /etc/sudoers
