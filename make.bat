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
cd /D "%CUR%"
if not exist "%CUR%\log" mkdir "%CUR%\log"
set TEMPLATE=%~n1
if not exist %FAVOR% mkdir %FAVOR%
cd /D template\%TEMPLATE%\
if exist output-%FAVOR% rmdir /S /Q output-%FAVOR%
set LOGNAME=log\packer-%FAVOR%-%TEMPLATE%.log
if "%PACKER_CACHE_DIR%x" == "x" set PACKER_CACHE_DIR=%CUR%\packer_cache
set PACKER_LOG_PATH=..\..\%LOGNAME%
set PACKER_LOG=1
packer build -only=%FAVOR% template.json
cd /D "%CUR%"
echo.
echo A log file of this step could be found at %LOGNAME%
call parselog.bat %LOGNAME%
goto done

:list
cd /D "%CUR%"
echo Choose one of the following favor/template. Then call make favor/template
for /F " usebackq delims==" %%i in (`dir /b template`) do @echo virtualbox/%%i
for /F " usebackq delims==" %%i in (`dir /b template`) do @echo vmware/%%i
:done
