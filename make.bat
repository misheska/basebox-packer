@echo off
setlocal
set CUR=%~dp0
set FAVOR=%~p1
if "listx" == "%1x" goto list
if "vmware" == "%FAVOR:~-7,6%" set FAVOR=vmware
if "virtualbox" == "%FAVOR:~-11,10%" set FAVOR=virtualbox
if "%FAVOR%" == "vmware" goto make
if "%FAVOR%" == "virtualbox" goto make
echo Wrong usage. Try a make list first, then make favor/template
goto done

:make
cd %CUR%
if not exist %~dp0\log mkdir %~dp0\log
set TEMPLATE=%~n1
if not exist %FAVOR% mkdir %FAVOR%
cd template\%TEMPLATE%\
if exist output-%FAVOR% del /S /Q /F output-%FAVOR%
if exist output-%FAVOR% rmdir output-%FAVOR%
set LOGNAME=log\packer-%FAVOR%-%TEMPLATE%.log
set PACKER_LOG_PATH=%~dp0\%LOGNAME%
set PACKER_LOG=1
packer build -only=%FAVOR% template.json
echo.
echo A log file of this step could be found at %LOGNAME%
call parselog.bat %PACKER_LOG_PATH%
goto done

:list
cd %CUR%
echo Choose one of the following favor/template. Then call make favor/template
for /F " usebackq delims==" %%i in (`dir /b template`) do @echo virtualbox/%%i
for /F " usebackq delims==" %%i in (`dir /b template`) do @echo vmware/%%i
:done
