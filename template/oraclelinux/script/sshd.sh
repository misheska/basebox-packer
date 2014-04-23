#!/bin/bash -eux

echo '==> Configuring sshd_config options'
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.orig

echo '==> Turning off sshd DNS lookup to prevent timeout delay'
echo "UseDNS no" >> /etc/ssh/sshd_config
echo '==> Disablng GSSAPI authentication to prevent timeout delay'
echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config
