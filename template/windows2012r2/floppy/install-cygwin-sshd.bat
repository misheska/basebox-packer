@echo off

setlocal

:: Force ARCH to 64-bit - 32-bit seems to crash a lot on Windows 2012
set ARCH=x86_64
set CYGWIN_SETUP_URL=http://cygwin.com/setup-%ARCH%.exe
set CYGWIN_SETUP_LOCAL_PATH=%TEMP%\cygwin-setup.exe
set CYGWIN_HOME=%SystemDrive%\cygwin
set CYGWIN_PACKAGES=openssh,wget
set CYGWIN_MIRROR_URL=http://mirrors.kernel.org/sourceware/cygwin

PATH=%PATH%;%CYGWIN_HOME%\bin

title Installing Cygwin and %CYGWIN_PACKAGES% to %CYGWIN_HOME%. Please wait...

cd /D "%TEMP%"

echo ==^> Downloading the Cygwin installer
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%CYGWIN_SETUP_URL%', '%CYGWIN_SETUP_LOCAL_PATH%')"

echo ==^> Installing Cygwin
"%CYGWIN_SETUP_LOCAL_PATH%" -a %ARCH% -q -R %CYGWIN_HOME% -P %CYGWIN_PACKAGES% -s %CYGWIN_MIRROR_URL%

echo ==^> Stopping the ssh service
cygrunsrv -E sshd

echo ==^> Opening firewall port 22 for the sshd service
netsh advfirewall firewall add rule name="SSHD" dir=in action=allow program="%CYGWIN_HOME%\usr\sbin\sshd.exe" enable=yes
netsh advfirewall firewall add rule name="ssh" dir=in action=allow protocol=TCP localport=22

echo ==^> Make user home directories default to their windows profile directory
bash -c 'ln -s "$(dirname $(cygpath -D))" /home/$USERNAME'
bash -c 'mkpasswd -l -p "$(cygpath -H)" >/etc/passwd'

echo ==^> Creating /etc/group (required by sshd)
bash -c 'mkgroup -l >/etc/group'

echo ==^> set up sshd config files
bash -c 'ssh-host-config -y -c "ntsecbinmode mintty nodosfilewarning" -w "abc&&123!!" '

echo ==^> Deleting the Cygwin installer and downloaded packages
del /s /q "%TEMP%\*.*"

echo ==^> Fixing corrupt recycle bin - see http://www.winhelponline.com/blog/fix-corrupted-recycle-bin-windows-7-vista/
rd /s /q %SystemDrive%\$Recycle.bin

echo ==^> Starting the ssh service
net start sshd

endlocal
