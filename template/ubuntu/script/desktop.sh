#!/bin/bash

USERNAME=vagrant
LIGHTDM_CONFIG=/etc/lightdm/lightdm.conf

echo "==> Configuring lightdm autologin"
if [ -f $LIGHTDM_CONFIG ]; then
    echo "" >> $LIGHTDM_CONFIG
    echo "autologin-user=${USERNAME}" >> $LIGHTDM_CONFIG
    echo "autologin-user-timeout=0" >> $LIGHTDM_CONFIG
fi

echo "==> Checking version of Ubuntu"
. /etc/lsb-release

if [[ $DISTRIB_RELEASE == 14.04 ]]; then
    echo "==> Installing ubunut-desktop"
    apt-get install -y ubuntu-desktop
fi
