@echo off

setlocal EnableDelayedExpansion EnableExtensions

if exist "%SystemDrive%\Program Files (x86)" (
  set SEVENZIP_INSTALL=7z922-x64.msi
  set VBOX_INSTALL=VBoxWindowsAdditions-amd64.exe
  set VMWARE_INSTALL=setup64.exe
) else (
  set SEVENZIP_INSTALL=7z922.msi
  set VBOX_INSTALL=VBoxWindowsAdditions-x86.exe
  set VMWARE_INSTALL=setup.exe
)

:: If TEMP is not defined in this shell instance, define it ourselves
if not defined TEMP set TEMP=%USERPROFILE%\AppData\Local\Temp
set SEVENZIP_URL=http://downloads.sourceforge.net/sevenzip/%SEVENZIP_INSTALL%
set SEVENZIP_INSTALL_LOCAL_PATH=%TEMP%\%SEVENZIP_INSTALL%

echo ==^> Downloadling %SEVENZIP_URL% to %SEVENZIP_INSTALL_LOCAL_PATH%
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('!SEVENZIP_URL!', '"!SEVENZIP_INSTALL_LOCAL_PATH!"')" <NUL
echo ==^> Download complete
echo ==^> Installing 7zip from "%SEVENZIP_INSTALL_LOCAL_PATH%"
msiexec /qb /i "%SEVENZIP_INSTALL_LOCAL_PATH%"

if "%PACKER_BUILDER_TYPE%" equ "vmware-iso" (
  echo ==^> Extracting the VMWare Tools installer
  "%SystemDrive%\Program Files\7-Zip\7z.exe" x %USERPROFILE%\windows.iso -o!TEMP!\vmware

  echo ==^> Installing VMware tools %VMWARE_INSTALL%
  "%TEMP%\vmware\!VMWARE_INSTALL!" /S /v "/qn REBOOT=R ADDLOCAL=ALL"

  echo ==^> Cleaning up VMware tools install
  del /F /S /Q "%TEMP%\vmware"
)

if "%PACKER_BUILDER_TYPE%" equ "virtualbox-iso" (
  echo ==^> Extracting the VirtualBox Guest Additions installer
  "%SystemDrive%\Program Files\7-Zip\7z.exe" x %USERPROFILE%\VBoxGuestAdditions.iso -o!TEMP!\virtualbox

  echo ==^> Installing Oracle certificate to keep install silent
  certutil -addstore -f "TrustedPublisher" a:\oracle-cert.cer

  echo ==^> Installing VirtualBox Guest Additions
  "!TEMP!\virtualbox\!VBOX_INSTALL!" /S

  echo ==^> Cleaning up VirtualBox Guest Additions install
  del /F /S /Q "!TEMP!\virtualbox"
)

echo ==^> Uninstalling 7zip
msiexec /qb /x "%SEVENZIP_INSTALL_LOCAL_PATH%"

del "%SEVENZIP_INSTALL_LOCAL_PATH%"
