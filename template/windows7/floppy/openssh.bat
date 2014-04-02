@echo off

title Installing Openssh. Please wait...

setlocal EnableDelayedExpansion EnableExtensions

:: If TEMP is not defined in this shell instance, define it ourselves
if not defined TEMP set TEMP=%USERPROFILE%\AppData\Local\Temp

if exist "%SystemDrive%\Program Files (x86)" (
  set OPENSSH_INSTALL="setupssh-6.4p1-1(x64).exe"
) else (
  set OPENSSH_INSTALL="setupssh-6.4p1-1.exe"
)

set OPENSSH_URL=http://www.mls-software.com/files/%OPENSSH_INSTALL%
set OPENSSH_EXE=%TEMP%\openssh.exe

:: setup openssh
echo ==^> Downloadng %OPENSSH_URL% to %OPENSSH_EXE%
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%OPENSSH_URL%', '%OPENSSH_EXE%')"
echo ==^> Download complete
echo ==^> Installing "%OPENSSH_EXE%"
cmd /c "%OPENSSH_EXE%" /S /port=22 /privsep=1 /password=D@rj33l1ng

echo ==^> Stopping opensshd
sc stop opensshd

echo ==^> Ensuring vagrant can login
mkdir "%USERPROFILE%\.ssh"
cmd /c %windir%\System32\icacls.exe "%USERPROFILE%" /grant %USERNAME%:(OI)(CI)F
cmd /c %windir%\System32\icacls.exe "%ProgramFiles%\OpenSSH\bin" /grant %USERNAME%:(OI)RX
cmd /c %windir%\System32\icacls.exe "%ProgramFiles%\OpenSSH\usr\sbin" /grant %USERNAME%:(OI)RX
powershell -Command "(Get-Content '%ProgramFiles%\OpenSSH\etc\passwd') | Foreach-Object { $_ -replace '/home/(\w+)', '/cygdrive/c/Users/$1' } | Set-Content '%ProgramFiles%\OpenSSH\etc\passwd'"

echo ==^> Fixing opensshd to not be strict
powershell -Command "(Get-Content '%ProgramFiles%\OpenSSH\etc\sshd_config') | Foreach-Object { $_ -replace 'StrictModes yes', 'StrictModes no' } | Set-Content '%ProgramFiles%\OpenSSH\etc\sshd_config'"
powershell -Command "(Get-Content '%ProgramFiles%\OpenSSH\etc\sshd_config') | Foreach-Object { $_ -replace '#PubkeyAuthentication yes', 'PubkeyAuthentication yes' } | Set-Content '%ProgramFiles%\OpenSSH\etc\sshd_config'"
powershell -Command "(Get-Content '%ProgramFiles%\OpenSSH\etc\sshd_config') | Foreach-Object { $_ -replace '#PermitUserEnvironment no', 'PermitUserEnvironment yes' } | Set-Content '%ProgramFiles%\OpenSSH\etc\sshd_config'"
powershell -Command "(Get-Content '%ProgramFiles%\OpenSSH\etc\sshd_config') | Foreach-Object { $_ -replace '#UseDNS yes', 'UseDNS no' } | Set-Content '%ProgramFiles%\OpenSSH\etc\sshd_config'"
powershell -Command "(Get-Content '%ProgramFiles%\OpenSSH\etc\sshd_config') | Foreach-Object { $_ -replace 'Banner /etc/banner.txt', '#Banner /etc/banner.txt' } | Set-Content '%ProgramFiles%\OpenSSH\etc\sshd_config'"

echo ==^> Setting temp location
rd /S /Q "%ProgramFiles%\OpenSSH\tmp"
cmd /c ""%ProgramFiles%\OpenSSH\bin\junction.exe" /accepteula "%ProgramFiles%\OpenSSH\tmp" C:\Windows\Temp"
cmd /c %windir%\System32\icacls.exe "%TEMP%" /grant %USERNAME%:(OI)(CI)F
powershell -Command "Add-Content %USERPROFILE%\.ssh\environment 'APPDATA=%SystemDrive%\Users\%USERNAME%\AppData\Roaming'"
powershell -Command "Add-Content %USERPROFILE%\.ssh\environment 'CommonProgramFiles=%SystemDrive%\Program Files\Common Files'"
powershell -Command "Add-Content %USERPROFILE%\.ssh\environment 'LOCALAPPDATA=%SystemDrive%\Users\%USERNAME%\AppData\Local'"
powershell -Command "Add-Content %USERPROFILE%\.ssh\environment 'ProgramData=%SystemDrive%\ProgramData'"
powershell -Command "Add-Content %USERPROFILE%\.ssh\environment 'ProgramFiles=%SystemDrive%\Program Files'"
powershell -Command "Add-Content %USERPROFILE%\.ssh\environment 'PSModulePath=%SystemDrive%\Windows\system32\WindowsPowerShell\v1.0\Modules\'"
powershell -Command "Add-Content %USERPROFILE%\.ssh\environment 'PUBLIC=%SystemDrive%\Users\Public'"
powershell -Command "Add-Content %USERPROFILE%\.ssh\environment 'SESSIONNAME=Console'"
powershell -Command "Add-Content %USERPROFILE%\.ssh\environment 'TEMP=%windir%\Temp'"
powershell -Command "Add-Content %USERPROFILE%\.ssh\environment 'TMP=%windir%\Temp'"
:: to override "cyg_server":
powershell -Command "Add-Content %USERPROFILE%\.ssh\environment 'USERNAME=%USERNAME%'"

if exist "%SystemDrive%\Program Files (x86)" (
   powershell -Command "Add-Content %USERPROFILE%\.ssh\environment 'CommonProgramFiles(x86)=%SystemDrive%\Program Files (x86)\Common Files'"
   powershell -Command "Add-Content %USERPROFILE%\.ssh\environment 'CommonProgramW6432=%SystemDrive%\Program Files\Common Files'"
   powershell -Command "Add-Content %USERPROFILE%\.ssh\environment 'ProgramFiles(x86)=%SystemDrive%\Program Files (x86)'"
   powershell -Command "Add-Content %USERPROFILE%\.ssh\environment 'ProgramW6432=%SystemDrive%\Program Files'"
)

echo ==^> Record the path for use by provisioners
<nul set /p ".=%PATH%" > %TEMP%\PATH

echo ==^> Configuring firewall
netsh advfirewall firewall add rule name="SSHD" dir=in action=allow service=OpenSSHd enable=yes
netsh advfirewall firewall add rule name="SSHD" dir=in action=allow program="%ProgramFiles%\OpenSSH\usr\sbin\sshd.exe" enable=yes
netsh advfirewall firewall add rule name="ssh" dir=in action=allow protocol=TCP localport=22

echo ==^> Deleting "%OPENSSH_EXE%"
del "%OPENSSH_EXE%"
