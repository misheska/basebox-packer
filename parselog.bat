@echo off
setlocal
set LOGFILE=%1
if not exist %LOGFILE% exit /b 1

rem grep start time
for /f "tokens=2 usebackq" %%i in (`findstr /r "Packer.Version:" %LOGFILE%`) do (
set STARTTIME=%%i
)



rem grep first ssh session
for /F "tokens=2 usebackq" %%i IN (`findstr /r opening.new.ssh.session %LOGFILE%`) DO (
  set STARTSSHTIME=%%i
  goto sshdone
)
:sshdone

for /f "tokens=2 usebackq" %%i in (`findstr /r "VM.shut.down" %LOGFILE%`) do (
set VMSHUTTIME=%%i
)

for /f "tokens=2 usebackq" %%i in (`findstr /r "Builds.completed" %LOGFILE%`) do (
set ENDTIME=%%i
)
call :calcduration %STARTTIME% %STARTSSHTIME%  "Install VM to first SSH login"
call :calcduration %STARTSSHTIME% %VMSHUTTIME% "Provisioning                 "
call :calcduration %VMSHUTTIME% %ENDTIME%      "Exporting VM to basebox      "
call :calcduration %STARTTIME% %ENDTIME%       "Total duration               "
goto :EOF

:calcduration
setlocal
set STARTTIME=%1
set ENDTIME=%2
rem convert STARTTIME and ENDTIME to centiseconds
set /A STARTTIME=(1%STARTTIME:~0,2%-100)*360000 + (1%STARTTIME:~3,2%-100)*6000 + (1%STARTTIME:~6,2%-100)*100 + (1%STARTTIME:~9,2%-100)
set /A ENDTIME=(1%ENDTIME:~0,2%-100)*360000 + (1%ENDTIME:~3,2%-100)*6000 + (1%ENDTIME:~6,2%-100)*100 + (1%ENDTIME:~9,2%-100)

rem calculating the duratyion is easy
set /A DURATION=%ENDTIME%-%STARTTIME%

rem we might have measured the time inbetween days
if %ENDTIME% LSS %STARTTIME% set set /A DURATION=%STARTTIME%-%ENDTIME%

rem now break the centiseconds down to hors, minutes, seconds and the remaining centiseconds
set /A DURATIONH=%DURATION% / 360000
set /A DURATIONM=(%DURATION% - %DURATIONH%*360000) / 6000
set /A DURATIONS=(%DURATION% - %DURATIONH%*360000 - %DURATIONM%*6000) / 100
set /A DURATIONHS=(%DURATION% - %DURATIONH%*360000 - %DURATIONM%*6000 - %DURATIONS%*100)

rem some formatting
if %DURATIONH% LSS 10 set DURATIONH=0%DURATIONH%
if %DURATIONM% LSS 10 set DURATIONM=0%DURATIONM%
if %DURATIONS% LSS 10 set DURATIONS=0%DURATIONS%
if %DURATIONHS% LSS 10 set DURATIONHS=0%DURATIONHS%

echo %~3 %DURATIONH%:%DURATIONM%:%DURATIONS%,%DURATIONHS%
exit /b
