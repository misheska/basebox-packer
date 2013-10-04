cd /D %SystemDrive%\windows\temp
set URL=http://www.freesshd.com/freeSSHd.exe

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

net start FreeSSHDService

rem But packer does not connect to freeSSHD 
rem 2013/10/04 22:09:28 C:\Packer\packer-builder-virtualbox.exe: 2013/10/04 22:09:28 Opening conn for SSH to tcp 127.0.0.1:3499
rem 2013/10/04 22:09:28 C:\Packer\packer-builder-virtualbox.exe: 2013/10/04 22:09:28 Attempting SSH connection...
rem 2013/10/04 22:09:28 C:\Packer\packer-builder-virtualbox.exe: 2013/10/04 22:09:28 reconnecting to TCP connection for SSH
rem 2013/10/04 22:09:28 C:\Packer\packer-builder-virtualbox.exe: 2013/10/04 22:09:28 Opening conn for SSH to tcp 127.0.0.1:3499
rem 2013/10/04 22:09:28 C:\Packer\packer-builder-virtualbox.exe: 2013/10/04 22:09:28 handshaking with SSH
rem 2013/10/04 22:09:58 C:\Packer\packer-builder-virtualbox.exe: 2013/10/04 22:09:58 handshake error: handshake failed: ssh: no common algorithms
rem 2013/10/04 22:09:58 C:\Packer\packer-builder-virtualbox.exe: 2013/10/04 22:09:58 SSH handshake err: handshake failed: ssh: no common algorithms
rem freeSSHD seems to support only vulnerable algorithms as listed in
rem http://stackoverflow.com/questions/18998473/failed-to-dial-handshake-failed-ssh-no-common-algorithms-error-in-ssh-client
