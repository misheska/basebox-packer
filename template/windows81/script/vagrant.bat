@echo off

setlocal EnableExtensions EnableDelayedExpansion

set VAGRANT_USER=vagrant
set VAGRANT_HOME=%SystemDrive%\Users\%VAGRANT_USER%
set VAGRANT_KEY_URL=https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub

echo ==^> Installing vagrant public key
mkdir "%VAGRANT_HOME%\.ssh"
REM bash -c 'wget --no-check-certificate "%VAGRANT_KEY_URL%" -O "%VAGRANT_HOME%\.ssh\authorized_keys"'
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%VAGRANT_KEY_URL%', '%VAGRANT_HOME%\.ssh\authorized_keys')"<NUL

endlocal
