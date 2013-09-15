set -x

wget http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe
dotNetFx40_Full_x86_x64.exe /q /norestart

wget --no-check-certificate https://github.com/ferventcoder/chocolatey/raw/master/chocolateyInstall/installChocolatey.cmd
wget --no-check-certificate https://github.com/ferventcoder/chocolatey/raw/master/chocolateyInstall/installChocolatey.ps1

installChocolatey.cmd

# Cleanup
rm -f dotNetFx40_Full_x86_x64.exe
rm -f installChocolatey.cmd
rm -f installChocolatey.ps1
