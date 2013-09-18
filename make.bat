@echo off
setlocal
set CUR=%~dp0
set FAVOR=%~p1
if "listx" == "%1x" goto list
if "vmware" == "%FAVOR:~-7,6%" set FAVOR=vmware
if "virtualbox" == "%FAVOR:~-11,10%" set FAVOR=virtualbox
set TEMPLATE=%~n1
if not exist %FAVOR% mkdir %FAVOR%
cd template\%TEMPLATE%\
if exist output-%FAVOR% del /S /Q /F output-%FAVOR%
if exist output-%FAVOR% rmdir output-%FAVOR%
set PACKER_LOG_PATH=.\packer.log
set PACKER_LOG=1
packer build -only=%FAVOR% template.json
cd %CUR%
goto done

:list
for /F " usebackq delims==" %%i in (`dir /b template`) do @echo virtualbox/%%i
for /F " usebackq delims==" %%i in (`dir /b template`) do @echo vmware/%%i
:done
