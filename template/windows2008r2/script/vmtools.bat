@echo off

setlocal EnableDelayedExpansion EnableExtensions

if "%ProgramFiles%" equ "%SystemDrive%\Program Files (x86)" (
  set SEVENZIP_INSTALL=7z922-x64.msi
  set VBOX_INSTALL=VBoxWindowsAdditions-amd64.exe
  set VMWARE_INSTALL=setup64.exe
) else (
  set SEVENZIP_INSTALL=7z922.msi
  set VBOX_INSTALL=VBoxWindowsAdditions-x86.exe
  set VMWARE_INSTALL=setup.exe
)

:: TEMP is not defined in this shell instance, so define it ourselves
set LOCAL_TEMP=%USERPROFILE%\AppData\Local\Temp
set SEVENZIP_URL=http://downloads.sourceforge.net/sevenzip/%SEVENZIP_INSTALL%
set SEVENZIP_INSTALL_LOCAL_PATH=%LOCAL_TEMP%\%SEVENZIP_INSTALL%

echo ==^> Downloadling %SEVENZIP_URL% to %SEVENZIP_INSTALL_LOCAL_PATH%
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%SEVENZIP_URL%', '%SEVENZIP_INSTALL_LOCAL_PATH%')" <NUL
echo ==^> Download complete
echo ==^> Installing 7zip from %SEVENZIP_INSTALL_LOCAL_PATH%
msiexec /qb /i %SEVENZIP_INSTALL_LOCAL_PATH%

if "%PACKER_BUILDER_TYPE%" equ "vmware" (
  echo ==^> Extracting the VMWare Tools installer
  "%SystemDrive%\Program Files\7-Zip\7z.exe" x %USERPROFILE%\windows.iso -o%LOCAL_TEMP%\vmware

  echo ==^> Installing VMware tools
  "%LOCAL_TEMP%\vmware\%VMWARE_INSTALL%" /S /v "/qn REBOOT=R ADDLOCAL=ALL"

  echo ==^> Cleaning up VMware tools install
  del /F /S /Q "%LOCAL_TEMP%\vmware"
)

if "%PACKER_BUILDER_TYPE%" equ "virtualbox" (
  echo ==^> Extracting the VirtualBox Guest Additions installer
  "%SystemDrive%\Program Files\7-Zip\7z.exe" x %USERPROFILE%\VBoxGuestAdditions.iso -o%LOCAL_TEMP%\virtualbox

  echo ==^> Installing Oracle certificate to keep install silent
  certutil -addstore -f "TrustedPublisher" a:\oracle-cert.cer

  echo ==^> Installing VirtualBox Guest Additions
  %LOCAL_TEMP%\virtualbox\%VBOX_INSTALL% /S

  echo ==^> Cleaning up VirtualBox Guest Additions install
  del /F /S /Q "%LOCAL_TEMP%\virtualbox"
)

echo ==^> Uninstalling 7zip
msiexec /qb /x %SEVENZIP_INSTALL_LOCAL_PATH%

endlocal
