#!/bin/sh -eux

# Set $PROVISIONER & $PROVISIONER_VERSION inside of Packer's template:
#
# Valid values for $PROVISIONER are:
#   'provisionerless' -- build a box without a provisioner
#   'chef'            -- build a box with the Chef provisioner
#   'salt'            -- build a box with the Salt provisioner
#
# When $PROVISIONER != 'provisionerless' valid options for
# $PROVISIONER_VERSION are:
#   'x.y.z'           -- build a box for Chef with version x.y.z of the provisioner
#   'x.y'             -- build a box for Salt with version x.y of the provisioner
#   'latest'          -- build a box with the latest version of the provisioner

case "$PROVISIONER" in
  ("chef")
    if [ $PROVISIONER_VERSION == 'latest' ]; then
      echo "Installing latest Chef version"
      curl -L https://www.opscode.com/chef/install.sh | sh
    else
      echo "Installing Chef version $PROVISIONER_VERSION"
      curl -L https://www.opscode.com/chef/install.sh | sh -s -- -v $PROVISIONER_VERSION
    fi
    ;;
  ("salt")
    if [ $PROVISIONER_VERSION == 'latest' ]; then
      echo "Installing latest Salt version"
      wget -O - http://bootstrap.saltstack.org | sudo sh
    else
      echo "Installing Salt version $PROVISIONER_VERSION"
      curl -L http://bootstrap.saltstack.org | sudo sh -s -- git $PROVISIONER_VERSION
    fi
    ;;
  (*)
    echo "Building a box without a provisioner"
    ;;
esac
