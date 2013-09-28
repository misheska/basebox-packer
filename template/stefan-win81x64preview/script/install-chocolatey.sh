set -x

wget http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe
chmod +x ./dotNetFx40_Full_x86_x64.exe
./dotNetFx40_Full_x86_x64.exe /q /norestart

powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')); [Environment]::Exit(0)"

# Cleanup
rm -f dotNetFx40_Full_x86_x64.exe
