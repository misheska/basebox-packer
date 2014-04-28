#!/bin/bash -eux

echo '==> Configuring settings for vagrant'

VAGRANT_USER=${VAGRANT_USER:-vagrant}
VAGRANT_HOME=${VAGRANT_HOME:-/home/${VAGRANT_USER}}
VAGRANT_SSH_KEY_URL=${VAGRANT_SSH_KEY_URL:-https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub}

# Add vagrant user (if it doesn't already exist)
if ! id -u $VAGRANT_USER >/dev/null 2>&1; then
    echo '==> Creating Vagrant user'
    /usr/sbin/groupadd $VAGRANT_USER
    /usr/sbin/useradd $VAGRANT_USER -g $VAGRANT_USER -G sudo -d $VAGRANT_HOME --create-home
    echo "${VAGRANT_USER}:${VAGRANT_USER}" | chpasswd
fi

# Set up sudo.  Be careful to set permission BEFORE copying file to sudoers.d
( cat <<EOP
%$VAGRANT_USER ALL=NOPASSWD:ALL
EOP
) > /tmp/vagrant
chmod 0440 /tmp/vagrant
mv /tmp/vagrant /etc/sudoers.d/

# Install vagrant keys
echo '==> Installing Vagrant SSH key'
mkdir -pm 700 $VAGRANT_HOME/.ssh
echo "==> Downloading SSH key from ${VAGRANT_SSH_KEY_URL}"
echo "==> Saving to ${VAGRANT_HOME}/.ssh/authorized_keys"
wget --no-check-certificate "${VAGRANT_SSH_KEY_URL}" -O $VAGRANT_HOME/.ssh/authorized_keys
chmod 600 $VAGRANT_HOME/.ssh/authorized_keys
chown -R $VAGRANT_USER $VAGRANT_HOME/.ssh

echo '==> Recording box config date'
date > /etc/vagrant_box_build_time
