#
# base.sh
#

# speed-up remote logins
echo -e "\nspeed-up remote logins ..."
echo -e "\n# added by veewee/postinstall.sh" >> /etc/ssh/sshd_config
echo -e "UseDNS no\n" >> /etc/ssh/sshd_config

# remove zypper locks, preventing installation of additional packages,
# present because of the autoinst <software><remove-packages>
echo -e "\nremove zypper package locks ..."
rm -f /etc/zypp/locks
