setlocal EnableDelayedExpansion EnableExtensions

:: bitsadmin can't download http://users.ugent.be/~bpuype/cgi-bin/fetch.pl?dl=wget/wget.exe
set url=http://users.ugent.be/~bpuype/wget/wget.exe

set basename=wget.exe

set filename=%windir%\System32\%basename%

if exist "a:\%basename%" (
  copy /y "a:\%basename%" "%filename%"
  goto :eof
)

title Downloading "%url%" to "%filename%". Please wait...
echo ==^> Downloading "%url%" to "%filename%"

path=%path%;a:\

for %%i in (_download.cmd) do set _download=%%~$PATH:i

if defined _download (
  call "%_download%" "%url%" "%filename%"
  goto :eof
)

for %%i in (bitsadmin.exe) do set bitsadmin=%%~$PATH:i

if defined bitsadmin goto bitsadmin

powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%url%', '%filename%')" <NUL

if ERRORLEVEL 1 echo ==^> Command returned errorlevel %ERRORLEVEL%

goto :eof

:bitsadmin

for %%i in ("%filename%") do set jobname=%%~nxi

"%bitsadmin%" /transfer "%jobname%" "%url%" "%filename%"

if ERRORLEVEL 1 echo ==^> Command returned errorlevel %ERRORLEVEL%

goto :eof
