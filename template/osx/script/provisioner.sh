#!/usr/bin/env bash

# Break on error
set -e
# Exit if we use any unset variable (use ${VAR:-} to test for unset var)
set -o nounset

install_chef()
{
  if [[ ${PROVISIONER_VERSION} == 'latest' ]]; then
    echo "Installing latest Chef version"
    curl -L https://www.opscode.com/chef/install.sh | sh
  else
    echo "Installing Chef version ${PROVISIONER_VERSION}"
    curl -L https://www.opscode.com/chef/install.sh | sh -s -- -v $PROVISIONER_VERSION
  fi
}

install_salt()
{
  if [[ ${PROVISIONER_VERSION} == 'latest' ]]; then
    echo "Installing latest Salt version"
    wget -O - http://bootstrap.saltstack.org | sudo sh
  else
    echo "Installing Salt version ${PROVISIONER_VERSION}"
    curl -L http://bootstrap.saltstack.org | sudo sh -s -- git ${PROVISIONER_VERSION}
  fi
}

install_puppet()
{
  # This uses Hashicorp's puppet-bootstrap script for OS X. We override
  # the URLs because they're probably more recent than those in the script.
  PUPPET=http://downloads.puppetlabs.com/mac/puppet-3.2.3.dmg
  FACTER=http://downloads.puppetlabs.com/mac/facter-1.7.2.dmg

  curl -Ok https://raw.github.com/hashicorp/puppet-bootstrap/master/mac_os_x.sh
  chmod +x mac_os_x.sh

  FACTER_PACKAGE_URL=$FACTER \
  PUPPET_PACKAGE_URL=$PUPPET \
  ./mac_os_x.sh

  rm mac_os_x.sh
}

# Set PROVISIONER & PROVISIONER_VERSION inside of Packer's template:
#
# Valid values for PROVISIONER are:
#   'provisionerless' -- build a box without a provisioner
#   'chef'            -- build a box with the Chef provisioner
#   'salt'            -- build a box with the Salt provisioner
#
# When $PROVISIONER != 'provisionerless' valid options for
# $PROVISIONER_VERSION are:
#   'x.y.z'           -- build a box with version x.y.z of the Chef provisioner
#   'x.y'             -- build a box with version x.y of the Salt provisioner
#   'latest'          -- build a box with the latest version of the provisioner

case "${PROVISIONER}" in
  'chef')
    install_chef
    ;;

  'salt')
    install_salt
    ;;

  'puppet')
    install_puppet
    ;;

  *)
    echo "Building box without a provisioner"
    ;;
esac
