#!/bin/bash -eux

# VMware Fusion specific items
if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
    TMPMOUNT=$(/usr/bin/mktemp -d /tmp/vmware-tools.XXXX)
    hdiutil attach /Users/vagrant/darwin.iso -mountpoint "$TMPMOUNT"
    installer -pkg "$TMPMOUNT/Install VMware Tools.app/Contents/Resources/VMware Tools.pkg" -target /
    # This usually fails
    hdiutil detach "$TMPMOUNT"
    rm -rf "$TMPMOUNT"
    rm -f /Users/vagrant/darwin.iso

    # Point Linux shared folder root to that used by OS X guests,
    # useful for the Hashicorp vmware_fusion Vagrant provider plugin
    mkdir /mnt
    ln -sf /Volumes/VMware\ Shared\ Folders /mnt/hgfs
fi
