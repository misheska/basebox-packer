@echo off
setlocal EnableDelayedExpansion EnableExtensions

set SSH_SERVICE=

sc query sshd
if not errorlevel 1 set SSH_SERVICE=sshd

sc query opensshd
if not errorlevel 1 set SSH_SERVICE=opensshd

echo ==^> Starting the %SSH_SERVICE% service

sc start %SSH_SERVICE%
