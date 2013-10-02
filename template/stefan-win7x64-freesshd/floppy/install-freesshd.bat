cd /D %SystemDrive%\windows\temp
set URL=http://www.freesshd.com/freeSSHd.exe
rem for https  [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadFile('%URL%','freesshd.exe'))"
freesshd.exe /VERYSILENT /NOICON /SUPPRESSMSGBOXES 
net stop FreeSSHDService

%comspec% /c "%ProgramFiles(x86)%\freeSSHD\FreeSSHDService.exe" /regserver
%comspec% /c "%ProgramFiles(x86)%\freeSSHD\FreeSSHDService.exe" /service
%comspec% /c sc config FreeSSHDService start= auto

cmd /c if exist %Systemroot%\system32\netsh.exe netsh advfirewall firewall add rule name="SSHD" dir=in action=allow program="%ProgramFiles(x86)%\freeSSHD\FreeSSHDService.exe" enable=yes
cmd /c if exist %Systemroot%\system32\netsh.exe netsh advfirewall firewall add rule name="ssh" dir=in action=allow protocol=TCP localport=22

copy /Y A:\FreeSSHDService.ini "%ProgramFiles(x86)%\freeSSHD\FreeSSHDService.ini"
mkdir "%ProgramFiles(x86)%\freeSSHD\keys"
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadFile('https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub','%ProgramFiles(x86)%\freeSSHD\keys\vagrant'))"
rem copy /Y A:\vagrant "%ProgramFiles(x86)\freeSSHD\keys\vagrant"
rem net start FreeSSHDService

rem sleep
ping -n 1800 127.0.0.1 >nul
