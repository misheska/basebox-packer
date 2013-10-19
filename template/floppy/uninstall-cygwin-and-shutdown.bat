ping -n 2 127.0.0.1 >nul
cd /D %SystemDrive%\
rmdir /s /q "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\cygwin"
del /F /Q C:\Users\Public\Desktop\Cygwin*
takeown /r /d y /f cygwin
icacls cygwin /t /grant Everyone:F

cygwin\bin\cygrunsrv -E sshd
cygwin\bin\cygrunsrv -R sshd
rmdir /s /q cygwin

rem close firewall on port 22
cmd /c if exist %Systemroot%\system32\netsh.exe netsh advfirewall firewall delete rule name="SSHD"
cmd /c if exist %Systemroot%\system32\netsh.exe netsh advfirewall firewall delete rule name="ssh"

shutdown /s /t 10 /f /d p:4:1 /c "Packer Shutdown"
