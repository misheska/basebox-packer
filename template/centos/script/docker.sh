#!/bin/bash

echo "==> Adding EPEL repository definitions"
yum install -y http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

echo "==> Installing docker"
yum install -y docker-io
