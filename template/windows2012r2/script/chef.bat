@echo on

setlocal EnableExtensions EnableDelayedExpansion

:: TEMP is not defined in this shell instance, so define it ourselves
set LOCAL_TEMP=%USERPROFILE%\AppData\Local\Temp
set REMOTE_SOURCE_MSI_URL=https://www.opscode.com/chef/install.msi
set LOCAL_DESTINATION_MSI_PATH=%LOCAL_TEMP%\chef-client-latest.msi
set FALLBACK_QUERY_STRING=?DownloadContext=PowerShell

if NOT "%CHEF_VERSION%" == "provisionerless" (
  echo ==^> Downloading Chef client %CHEF_VERSION%
  powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%REMOTE_SOURCE_MSI_URL%%FALLBACK_QUERY_STRING%', '%LOCAL_DESTINATION_MSI_PATH%')" <NUL

  echo ==^> Installing Chef client %CHEF_VERSION%
  msiexec /qb /i "%LOCAL_DESTINATION_MSI_PATH%"

  echo ==^> Cleaning up Chef install
  del /F /Q "%LOCAL_DESTINATION_MSI_PATH%"
) else (
  echo ==^> This install is provisionerless.  Use the vagrant-omnibus plugin
  echo ==^> to install Chef.
)

endlocal
