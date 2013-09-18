cmd /c bitsadmin /transfer ChefClient /download /priority normal http://www.opscode.com/chef/install.msi %TEMP%\chef-client.msi

REM run the installation
cmd /C msiexec /qn /i %TEMP%\chef-client.msi

REM cleanup
del /F %TEMP%\chef-client.msi

