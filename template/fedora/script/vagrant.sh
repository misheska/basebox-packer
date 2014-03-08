#!/bin/bash -eux

# Vagrant specific
date > /etc/vagrant_box_build_time

# Add vagrant user
if ! id -u vagrant >/dev/null 2>&1; then
    /usr/sbin/groupadd vagrant
    /usr/sbin/useradd vagrant -g vagrant
    echo "vagrant"|passwd --stdin vagrant
fi

# Give Vagrant user permission to sudo
echo 'Defaults:vagrant !requiretty' > /etc/sudoers.d/vagrant
echo '%vagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/vagrant
chmod 440 /etc/sudoers.d/vagrant

# Install vagrant authorized ssh key
mkdir -pm 700 /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown vagrant:vagrant -R /home/vagrant/.ssh
chcon -R unconfined_u:object_r:user_home_t:s0 /home/vagrant/.ssh

# Customize the message of the day
echo 'Welcome to your Packer-built virtual machine.' > /etc/motd
