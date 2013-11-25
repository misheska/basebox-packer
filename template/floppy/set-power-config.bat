REM Set power configuration to High Performance
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
REM Monitor timeout
powercfg -Change -monitor-timeout-ac 0
powercfg -Change -monitor-timeout-dc 0

rem turn off Windows 8.1 CPU load tasks
rem schtasks /Change /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /DISABLE
rem schtasks /Change /TN "\Microsoft\Windows\Application Experience\AitAgent" /DISABLE
rem schtasks /Change /TN "\Microsoft\Windows\Application Experience\StartupAppTask" /DISABLE
rem cmd /c sc config "AeLookupSvc" start= disabled
rem cmd /c sc config "WinDefend" start= disabled
