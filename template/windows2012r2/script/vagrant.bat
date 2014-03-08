@echo off

setlocal EnableExtensions
setlocal EnableDelayedExpansion

set VAGRANT_KEY_URL=https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub

echo ==^> Installing vagrant public key
mkdir "%USERPROFILE%\.ssh"
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('!VAGRANT_KEY_URL!', '%USERPROFILE%\.ssh\authorized_keys')" <NUL

echo ==^> Disabling vagrant account password expiration
wmic USERACCOUNT WHERE "Name='vagrant'" set PasswordExpires=FALSE
