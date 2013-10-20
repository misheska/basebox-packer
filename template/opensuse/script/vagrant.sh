#
# postinstall.sh
#

date > /etc/vagrant_box_build_time

## Vagrant user
#/usr/sbin/groupadd vagrant
#/usr/sbin/useradd vagrant -g vagrant -G wheel -d /home/vagrant --create-home
#echo "vagrant:vagrant" | chpasswd

# install vagrant key
echo -e "\ninstall vagrant key ..."
mkdir -m 0700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate -O authorized_keys https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant.users /home/vagrant/.ssh

# update sudoers
echo -e "\nupdate sudoers ..."
echo -e "\n# added by veewee/postinstall.sh" >> /etc/sudoers
echo -e "vagrant ALL=(ALL) NOPASSWD: ALL\n" >> /etc/sudoers
