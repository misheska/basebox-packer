#!/bin/bash -eux

# Vagrant specific
date > /etc/vagrant_box_build_time

VAGRANT_USER=vagrant
VAGRANT_HOME=/home/$VAGRANT_USER
VAGRANT_KEY_URL=https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub

# Add vagrant user (if it doesn't already exist)
if ! id -u $VAGRANT_USER >/dev/null 2>&1; then
    /usr/sbin/groupadd $VAGRANT_USER
    /usr/sbin/useradd $VAGRANT_USER -g $VAGRANT_USER -G wheel
    echo "${VAGRANT_USER}"|passwd --stdin $VAGRANT_USER
    echo "${VAGRANT_USER}        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
fi

# Installing vagrant keys
mkdir -pm 700 $VAGRANT_HOME/.ssh
wget --no-check-certificate "${VAGRANT_KEY_URL}" -O $VAGRANT_HOME/.ssh/authorized_keys
chmod 0600 $VAGRANT_HOME/.ssh/authorized_keys
chown -R $VAGRANT_USER:$VAGRANT_USER $VAGRANT_HOME/.ssh

# Customize the message of the day
echo 'Welcome to your Packer-built virtual machine.' > /etc/motd
