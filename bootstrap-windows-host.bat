powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%systemdrive%\chocolatey\bin
call cinst curl
call cinst virtualbox
call cinst vagrant
rem call cinst VirtualBox.ExtensionPack 
call cinst 7zip.commandline 
call cinst packer
vagrant --version
packer --version
