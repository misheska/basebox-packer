setlocal EnableDelayedExpansion
setlocal EnableExtensions
title Disabling Shutdown Event Tracker. Please wait...

echo ==^> Disabling Shutdown Event Tracker
set MACHINE_GROUP_POLICY_DIR=%windir%\system32\GroupPolicy\Machine

if not exist "%MACHINE_GROUP_POLICY_DIR%" (
  mkdir "%MACHINE_GROUP_POLICY_DIR%"
)
copy a:\disable-shutdown-event-tracker.pol "%MACHINE_GROUP_POLICY_DIR%\registry.pol"
gpupdate /force
