setlocal EnableDelayedExpansion EnableExtensions

set url=%~1
set filename=%~2

if not defined url goto :eof

if not defined filename set filename=%TEMP%\%~nx1

for %%i in ("%filename%") do set basename=%%~nx

if not exist "a:\%basename%" goto download

echo ==^> Copying "a:\%basename%" to "%filename%"

copy /y "a:\%basename%" "%filename%"

goto :eof

:download

echo ==^> Downloading "%url%" to "%filename%"

set wget=
set bitsadmin=

path=a:\;%path%

for %%i in (wget.exe) do set wget=%%~$PATH:i
for %%i in (bitsadmin.exe) do set bitsadmin=%%~$PATH:i

:: if not defined wget if exist a:\wget.exe set wget=a:\wget.exe

if defined wget goto wget

if defined bitsadmin goto bitsadmin

powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%url%', '%filename%')" <NUL

goto :eof

:wget

"%wget%" --no-check-certificate --quiet -O "%filename%" "%url%"

goto :eof

:bitsadmin

for %%i in ("%filename%") do set jobname=%%~nxi

"%bitsadmin%" /transfer "%jobname%" "%url%" "%filename%"

goto :eof
