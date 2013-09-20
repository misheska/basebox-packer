@echo off
setlocal
set LOGFILE=%1
if not exist %LOGFILE% exit /b 1

rem grep start time
findstr /r "Packer.Version:" %LOGFILE%

rem grep first ssh session
for /F "usebackq delims==" %%i IN (`findstr /r opening.new.ssh.session %LOGFILE%`) DO (
  echo %%i
  goto sshdone
)
:sshdone

findstr /r "VM.shut.down" %LOGFILE%
findstr /r "Builds.completed" %LOGFILE%

