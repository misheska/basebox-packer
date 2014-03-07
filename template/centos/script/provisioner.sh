#!/bin/bash -eux

# Bash options enabled:
#   - Break on error
#   - Exit if we use any unset variable (use ${VAR:-} to test for unset var)
#   - Be verbose

# Set ${PROVISIONER} & ${PROVISIONER_VERSION} inside of Packer's template.
# if ${PROVISIONER_VERSION} isn't defined, set it to 'latest'
PROVISIONER_VERSION=${PROVISIONER_VERSION:-latest}

# Valid values for $PROVISIONER are:
#   'provisionerless' -- build a box without a provisioner
#   'chef'            -- build a box with the Chef provisioner
#   'salt'            -- build a box with the Salt provisioner
#   'puppet'          -- build a box with the Puppet provisioner
#
# When $PROVISIONER != 'provisionerless' valid options for
# ${PROVISIONER_VERSION} are:
#   'x.y.z'           -- build a box with version x.y.z of the Chef provisioner
#   'x.y'             -- build a box with version x.y of the Salt provisioner
#   'latest'          -- build a box with the latest version of the provisioner

case "${PROVISIONER}" in
  'chef')
    if [[ ${PROVISIONER_VERSION} == 'latest' ]]; then
      echo "Installing latest Chef version"
      curl -L https://www.opscode.com/chef/install.sh | sh
    else
      echo "Installing Chef version ${PROVISIONER_VERSION}"
      curl -L https://www.opscode.com/chef/install.sh | sh -s -- -v ${PROVISIONER_VERSION}
    fi
    ;;

  'salt')
    if [[ ${PROVISIONER_VERSION} == 'latest' ]]; then
      echo "Installing latest Salt version"
      wget -O - http://bootstrap.saltstack.org | sudo sh
    else
      echo "Installing Salt version ${PROVISIONER_VERSION}"
      curl -L http://bootstrap.saltstack.org | sudo sh -s -- git ${PROVISIONER_VERSION}
    fi
    ;;

  'puppet')
    OS_MAJRELEASE=$(cat /etc/redhat-release | perl -n -e'/release ([\d]*)/ && print $1')

    echo "Installing Puppet Labs repositories"
    rpm -ipv "http://yum.puppetlabs.com/puppetlabs-release-el-${OS_MAJRELEASE}.noarch.rpm"

    if [[ ${PROVISIONER_VERSION:-} == 'latest' ]]; then
      echo "Installing latest Puppet version"
      yum -y install puppet
    else
      echo "Installing Puppet version ${PROVISIONER_VERSION}"
      yum -y install "puppet-${PROVISIONER_VERSION}"
    fi
    ;;

  *)
    echo "Building box without a provisioner"
    ;;
esac
