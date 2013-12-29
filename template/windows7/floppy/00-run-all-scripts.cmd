@echo off
setlocal enableextensions
setlocal disabledelayedexpansion

CD /D %~dp0

PATH=%~dp0;%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\WindowsPowerShell\v1.0;%PATH%

echo|time|findstr "current" >>"%TEMP%\%~n0.log"
echo %0: started. >>"%TEMP%\%~n0.log"
title %0: started

for /F %%I in ('dir /b /on *.bat *.cmd') do (
  if /I not "%%~nxI" == "%~nx0" (
    echo|time|findstr "current" >>"%TEMP%\%~n0.log"
    echo %0: executing %%~I >>"%TEMP%\%~n0.log"

    title Executing %%~I...
    if exist tee.exe (
      cmd /c "%%~nxI" 2>&1 | tee "%TEMP%\%%~nI.log"
    ) else (
      cmd /c "%%~nxI"
    )
    set EL=%ERRORLEVEL%

    echo %%~I returned error %EL% >>"%TEMP%\%~n0.log"
  )
)

echo|time|findstr "current" >>"%TEMP%\%~n0.log"
echo %0: finished. >>"%TEMP%\%~n0.log"
title %0: finished

pause
