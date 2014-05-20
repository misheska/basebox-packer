@if not defined PACKER_DEBUG echo off

setlocal EnableExtensions EnableDelayedExpansion

:: If TEMP is not defined in this shell instance, define it ourselves
if not defined TEMP set TEMP=%USERPROFILE%\AppData\Local\Temp

if "%PROVISIONER%" == "chef" goto chef
if "%PROVISIONER%" == "puppet" goto puppet
if "%PROVISIONER%" == "provisionerless" goto provisionerless

echo ==^> ERROR: Unknown provisioner: "%PROVISIONER%"

goto :eof

:chef

set REMOTE_SOURCE_MSI_URL=https://www.opscode.com/chef/install.msi
set LOCAL_DESTINATION_MSI_PATH=%TEMP%\chef-client-latest.msi
set FALLBACK_QUERY_STRING=?DownloadContext=PowerShell

:: Always latest, for now
echo ==^> Downloading Chef client %PROVISIONER_VERSION%
PATH=%PATH%;a:\
for %%i in (_download.cmd) do set _download=%%~$PATH:i
if defined _download (
  call "%_download%" "%REMOTE_SOURCE_MSI_URL%" "%LOCAL_DESTINATION_MSI_PATH%"
) else (
  powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%REMOTE_SOURCE_MSI_URL%%FALLBACK_QUERY_STRING%', '%LOCAL_DESTINATION_MSI_PATH%')" <NUL
)

echo ==^> Installing Chef client %PROVISIONER_VERSION%
msiexec /qb /i "%LOCAL_DESTINATION_MSI_PATH%"

echo ==^> Cleaning up Chef install
del /F /Q "%LOCAL_DESTINATION_MSI_PATH%"

goto finish

:puppet
:: If TEMP is not defined in this shell instance, define it ourselves
if not defined PROVISIONER_VERSION set PROVISIONER_VERSION=3.6.0
if "%PROVISIONER_VERSION%" == "latest" set PROVISIONER_VERSION=3.6.0
set REMOTE_SOURCE_MSI_URL=http://downloads.puppetlabs.com/windows/puppet-!PROVISIONER_VERSION!.msi
set LOCAL_DESTINATION_MSI_PATH=!TEMP!\puppet-!PROVISIONER_VERSION!.msi
set FALLBACK_QUERY_STRING=

echo ==^> Downloading Puppet client !PROVISIONER_VERSION!
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('!REMOTE_SOURCE_MSI_URL!!FALLBACK_QUERY_STRING!', '"!LOCAL_DESTINATION_MSI_PATH!"')" <NUL

echo ==^> Installing puppet client !PROVISIONER_VERSION!
msiexec /qb /i "!LOCAL_DESTINATION_MSI_PATH!"

echo ==^> Cleaning up Puppet install
del /F /Q "!LOCAL_DESTINATION_MSI_PATH!"

goto :finish

:provisionerless

echo ==^> Building box without a provisioner.

goto finish

:finish

exit 0

