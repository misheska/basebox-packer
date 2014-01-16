setlocal EnableDelayedExpansion EnableExtensions

set SSH_SERVICE=

sc query sshd >nul 2>nul
if not errorlevel 1 set SSH_SERVICE=sshd

sc query opensshd >nul 2>nul
if not errorlevel 1 set SSH_SERVICE=opensshd

echo ==^> Starting the %SSH_SERVICE% service

sc start %SSH_SERVICE%
