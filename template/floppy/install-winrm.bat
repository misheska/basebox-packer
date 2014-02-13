cmd /c winrm quickconfig -q
cmd /c winrm quickconfig -transport:http # needs to be auto no questions asked
cmd /c winrm set winrm/config @{MaxTimeoutms="1800000"}
cmd /c winrm set winrm/config/winrs @{MaxMemoryPerShellMB="300"}
cmd /c winrm set winrm/config/service @{AllowUnencrypted="true"}
cmd /c winrm set winrm/config/service/auth @{Basic="true"}
cmd /c winrm set winrm/config/listener?Address=*+Transport=HTTP @{Port="5985"}
cmd /c netsh advfirewall firewall set rule group="remote administration" new enable=yes
cmd /c netsh advfirewall firewall add portopening TCP 5985 "Port 5985"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-NetFirewallRule -DisplayGroup 'Windows Remote Management' -Enabled True"
netsh advfirewall firewall add rule name="Windows Remote Management (HTTP-In) for vagrant" description="Allow Windows Remote Management even on public networks for vagrant boxes" dir=in action=allow protocol=tcp localport=5985

cmd /c net stop winrm
cmd /c net start winrm
cmd /c sc config "WinRM" start= auto

cmd /c reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v ScreenSaveActive /t REG_SZ /d 0 /f
cmd /c reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v ScreenSaveIsSecure /t REG_SZ /d 0 /f

net accounts /MaxPWAge:unlimited
