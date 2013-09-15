@echo off
setlocal
set CUR=%~dp0
set FAVOR=%~p1
if "vmware" == "%FAVOR:~-7,6%" set FAVOR=vmware
if "virtualbox" == "%FAVOR:~-11,10%" set FAVOR=virtualbox
set TEMPLATE=%~n1
cd template\%TEMPLATE%\
if exist output-%FAVOR% del /S /Q /F output-%FAVOR%
packer build -only=%FAVOR% template.json
cd %CUR%
