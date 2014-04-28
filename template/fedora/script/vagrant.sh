#!/bin/bash -eux

echo "==> Configuring settings for vagrant"

VAGRANT_USER=${VAGRANT_USER:-vagrant}
VAGRANT_HOME=${VAGRANT_HOME:-/home/${VAGRANT_USER}}
VAGRANT_SSH_KEY_URL=${VAGRANT_SSH_KEY_URL:-https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub}

# Add vagrant user
if ! id -u $VAGRANT_USER >/dev/null 2>&1; then
    echo '==> Creating Vagrant user'
    /usr/sbin/groupadd $VAGRANT_USER
    /usr/sbin/useradd $VAGRANT_USER -g $VAGRANT_USER
    echo "${VAGRANT_USER}"|passwd --stdin $VAGRANT_USER
fi

# Give Vagrant user permission to sudo
echo "Defaults:${VAGRANT_USER} !requiretty" > /etc/sudoers.d/vagrant
echo "%$VAGRANT_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
chmod 440 /etc/sudoers.d/vagrant

# Installing vagrant key
echo "==> Installing Vagrant SSH key"
mkdir -pm 700 $VAGRANT_HOME/.ssh
wget --no-check-certificate "${VAGRANT_SSH_KEY_URL}" -O $VAGRANT_HOME/.ssh/authorized_keys
chmod 0600 $VAGRANT_HOME/.ssh/authorized_keys
chown $VAGRANT_USER:$VAGRANT_USER -R $VAGRANT_HOME/.ssh
chcon -R unconfined_u:object_r:user_home_t:s0 /home/vagrant/.ssh

echo "==> Recording box config date"
date > /etc/vagrant_box_build_time

echo "==> Customizing message of the day"
echo 'Welcome to your Packer-built virtual machine.' > /etc/motd
