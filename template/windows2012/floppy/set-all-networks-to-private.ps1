# see http://blogs.msdn.com/b/powershell/archive/2009/04/03/setting-network-location-to-private.aspx

# Skip network location setting for pre-Vista operating systems
if([environment]::OSVersion.version.Major -lt 6) { return }

# Skip network location setting if local machine is joined to a domain.
if(1,3,4,5 -contains (Get-WmiObject win32_computersystem).DomainRole) { return }

# Get network connections
$networkListManager = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]"{DCB00C01-570F-4A9B-8D69-199FDBA5723B}"))
$connections = $networkListManager.GetNetworkConnections()

# Set network location to Private for all networks
$connections | % {$_.GetNetwork().SetCategory(1)}
