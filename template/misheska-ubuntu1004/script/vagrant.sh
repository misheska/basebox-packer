date > /etc/vagrant_box_build_time

# Vagrant user
if id -u vagrant >/dev/null 2>&1; then
    /usr/sbin/groupadd vagrant
    /usr/sbin/useradd vagrant -g vagrant -G sudo -d /home/vagrant --create-home
    echo "vagrant:vagrant" | chpasswd
fi

# Set up sudo
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

# Install vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh
