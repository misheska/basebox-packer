cmd /c bitsadmin /transfer InstallDotNet40 /download /priority normal http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe %TEMP%\dotNetFx40_Full_x86_x64.exe
%TEMP%\dotNetFx40_Full_x86_x64.exe /q /norestart

cmd /c bitsadmin /transfer InstallChocolateyCmd /download /priority normal https://github.com/ferventcoder/chocolatey/raw/master/chocolateyInstall/installChocolatey.cmd %TEMP%\installChocolatey.cmd

cmd /c bitsadmin /transfer InstallChocolateyPs1 /download /priority normal https://github.com/ferventcoder/chocolatey/raw/master/chocolateyInstall/InstallChocolatey.ps1 %TEMP%\installChocolatey.ps1

call %TEMP%\installChocolatey.cmd
