powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%systemdrive%\chocolatey\bin
call cinst curl
call cinst virtualbox
call cinst vagrant
call cinst VirtualBox.ExtensionPack 
call cinst 7zip.commandline 
call curl -L -k https://dl.bintray.com/mitchellh/packer/0.3.8_windows_amd64.zip -o %TEMP%\packer.zip
cd /D %systemdrive%\chocolatey\bin
call 7za x %TEMP%\packer.zip
del /F %TEMP%\packer.zip
vagrant --version
packer --version
