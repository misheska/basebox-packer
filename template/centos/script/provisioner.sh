#!/bin/sh -eux

# Set $PROVISIONER & $PROVISIONER_VERSION inside of Packer's template:
#
# Valid values for $PROVISIONER are:
#   'provisionerless' -- build a box without a provisioner
#   'chef'            -- build a box with the Chef provisioner
#
# When $PROVISIONER != 'provisionerless' valid options for
# $PROVISIONER_VERSION are:
#   'x.y.z'           -- build a box with version x.y.z of the provisioner
#   'latest'          -- build a box with the latest version of the provisioner

if [ $PROVISIONER == 'chef' ]; then
  if [ $PROVISIONER_VERSION == 'latest' ]; then
    echo "Installing latest Chef version"
    sh <(curl -L https://www.opscode.com/chef/install.sh)
  else
    echo "Installing Chef version $PROVISIONER_VERSION"
    sh <(curl -L https://www.opscode.com/chef/install.sh) -v $PROVISIONER_VERSION
  fi
else
  echo "Building a box without a provisioner"
fi
