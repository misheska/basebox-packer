set -x

VAGRANT_HOME=/cygdrive/c/Users/vagrant
# Install ssh certificates
mkdir $VAGRANT_HOME/.ssh
chmod 700 $VAGRANT_HOME/.ssh
cd $VAGRANT_HOME/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chown -R vagrant $VAGRANT_HOME/.ssh
cd ..

cd $VAGRANT_HOME

cat <<'EOF' > /bin/sudo
#!/usr/bin/bash
exec "$@"
EOF
chmod 755 /bin/sudo

