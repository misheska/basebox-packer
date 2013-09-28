set -x

VAGRANT_HOME=/cygdrive/c/Users/vagrant
cd $VAGRANT_HOME

#Rather than do the manual install of ruby and chef, just use the opscode msi
# curl -L http://www.opscode.com/chef/install.msi -o chef-client-latest.msi
wget http://www.opscode.com/chef/install.msi
msiexec /qb /i install.msi

#Making aliases
cat <<EOF > /home/vagrant/.bash_profile
alias chef-client="chef-client.bat"
alias gem="gem.bat"
alias ruby="ruby.exe"
alias puppet="puppet.bat"
alias ohai="ohai.bat"
alias irb="irb.bat"
alias facter="facter.bat" 
EOF

# Cleanup
rm -f install.msi
