@echo off
setlocal
set CUR=%~dp0
set FAVOR=%~p1
if "listx" == "%1x" goto list
if "cleanx" == "%1x" goto clean
if "fixx" == "%1x" goto fix
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
if exist output-%FAVOR% rmdir /S /Q output-%FAVOR%-iso
set LOGNAME=log\packer-%FAVOR%-%TEMPLATE%.log
if "%PACKER_CACHE_DIR%x" == "x" set "PACKER_CACHE_DIR=%CUR%\packer_cache"
set PACKER_LOG_PATH=..\..\%LOGNAME%
set PACKER_LOG=1
if "%PACKER_TEMP_DIR%x" == "x" set "PACKER_TEMP_DIR=%CUR%\packer_temp"
set TEMP=%PACKER_TEMP_DIR%
set TMP=%PACKER_TEMP_DIR%
if not exist "%PACKER_TEMP_DIR%" mkdir "%PACKER_TEMP_DIR%"
packer build -only=%FAVOR%-iso template.json
cd /D "%CUR%"
echo.
echo A log file of this step could be found at %LOGNAME%
call parselog.bat %LOGNAME%
goto done

:fix
set PACKER_LOG=
set PACKER_LOG_PATH=
cd /D "%CUR%"
echo Fixing all templates...
for /F " usebackq delims==" %%i in (`dir /b template`) do (
  if exist template\%%i\template.json (
    packer fix template\%%i\template.json >template\%%i\template.json.new
    copy /y template\%%i\template.json.new template\%%i\template.json
    del template\%%i\template.json.new
  )
)
goto done

:list
cd /D "%CUR%"
echo Choose one of the following favor/template. Then call make favor/template
for /F " usebackq delims==" %%i in (`dir /b template`) do @if exist template\%%i\template.json echo virtualbox/%%i
for /F " usebackq delims==" %%i in (`dir /b template`) do @if exist template\%%i\template.json echo vmware/%%i
goto done

:clean
cd /D "%CUR%"
echo Deleting all template/*/output-* directories
for /F " usebackq delims==" %%i in (`dir /b template`) do @if exist template\%%i\output-virtualbox-iso rmdir /s /q template\%%i\output-virtualbox-iso
for /F " usebackq delims==" %%i in (`dir /b template`) do @if exist template\%%i\output-vmware-iso rmdir /s /q template\%%i\output-vmware-iso
goto done

:done
