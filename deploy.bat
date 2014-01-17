@echo off
setlocal
set CUR=%~dp0
set FAVOR=%~p1
if "vmware" == "%FAVOR:~-7,6%" set FAVOR=vmware
if "virtualbox" == "%FAVOR:~-11,10%" set FAVOR=virtualbox
if "%FAVOR%" == "vmware" goto deploy
if "%FAVOR%" == "virtualbox" goto deploy
echo Wrong usage. Try a make list first, then make favor/template
goto :EOF

:deploy
if exist %1.box (
  echo vagrant box remove %~n1
  vagrant box remove %~n1
  echo Copy box to basebox folder
  copy /y %FAVOR%\%~n1.box e:\basebox
) else (
  echo Box %1.box does not exist!
)

