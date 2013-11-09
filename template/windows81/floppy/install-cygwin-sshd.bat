echo on

REM inspired by http://webcache.googleusercontent.com/search?q=cache:SjoPPpuQxuoJ:www.tcm.phy.cam.ac.uk/~mr349/cygwin_install.html+install+cygwin+ssh+commandline&cd=2&hl=nl&ct=clnk&gl=be&source=www.google.be

REM comma-separated list of Cygwin packages to install
set PACKAGES=openssh,wget

REM if "%PROCESSOR_ARCHITECTURE%" == "AMD64" (set ARCH=x86_64) else (set ARCH=x86)
rem the x86_64 version currently appears to have some issues, so let's use the x86 version, for now:
set ARCH=x86

REM the directory to install Cygwin into
set CYGWIN_HOME=%SystemDrive%\cygwin

title Installing Cygwin and %PACKAGES% to %CYGWIN_HOME%. Please wait...

REM goto a temp directory
cd /D "%temp%"

REM add Cygwin bin directory to search path
PATH=%PATH%;%CYGWIN_HOME%\bin

REM download the Cygwin installer
bitsadmin /transfer CygwinSetupExe /download /priority normal http://cygwin.com/setup-%ARCH%.exe "%temp%\cygwin-setup.exe"

REM run the Cygwin installer
"%temp%\cygwin-setup" -a %ARCH% -q -R %CYGWIN_HOME% -P %PACKAGES% -s http://mirrors.kernel.org/sourceware/cygwin/

REM stop the ssh service
bash -c 'cygrunsrv -E sshd'

REM push hole in Windows firewall for sshd service
netsh advfirewall firewall add rule name="SSHD" dir=in action=allow program="%CYGWIN_HOME%\usr\sbin\sshd.exe" enable=yes

REM push hole in Windows firewall for ssh port 22
netsh advfirewall firewall add rule name="ssh" dir=in action=allow protocol=TCP localport=22

REM link c:/Users/vagrant to /home/vagrant
bash -c 'ln -s "$(dirname $(cygpath -D))" /home/$USERNAME'

REM put local users home directories in the Windows Profiles directory
bash -c 'mkpasswd -l -p "$(cygpath -H)" >/etc/passwd'

REM create /etc/group (required by sshd)
bash -c 'mkgroup -l >/etc/group'

REM set up sshd config files
bash -c 'ssh-host-config -y -c "ntsecbinmode mintty nodosfilewarning" -w "abc&&123!!" '

REM delete the Cygwin installer, and downloaded packages
del /s /q "%temp%\*.*"

REM fix corrupt recycle bin - see http://www.winhelponline.com/blog/fix-corrupted-recycle-bin-windows-7-vista/
rd /s /q %SystemDrive%\$Recycle.bin

REM start the ssh service
net start sshd
