#!/bin/bash

USERNAME=vagrant
LIGHTDM_CONFIG=/etc/lightdm/lightdm.conf

# Configure lightdm autologin.

if [ -f $LIGHTDM_CONFIG ]; then
    echo "" >> $LIGHTDM_CONFIG
    echo "autologin-user=${USERNAME}" >> $LIGHTDM_CONFIG
    echo "autologin-user-timeout=0" >> $LIGHTDM_CONFIG
fi
