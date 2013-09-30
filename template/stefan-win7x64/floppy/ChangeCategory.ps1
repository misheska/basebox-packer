$NLMType = [Type]::GetTypeFromCLSID(‘DCB00C01-570F-4A9B-8D69-199FDBA5723B')
$INetworkListManager = [Activator]::CreateInstance($NLMType)

$NLM_ENUM_NETWORK_CONNECTED = 1
$NLM_NETWORK_CATEGORY_PUBLIC = 0x00
$NLM_NETWORK_CATEGORY_PRIVATE = 0x01


$identifying = 0
"Searching for networks"

do 
{
    $INetworks = $INetworkListManager.GetNetworks($NLM_ENUM_NETWORK_CONNECTED)
    
    foreach ($INetwork in $INetworks)
    {
        $Name = $INetwork.GetName()
        "$Name"

        if ($Name -eq "Identifying...")
        {
            $identifying = 1
            Start-Sleep -second 2
        }
        else
        {
            $identifying = 0
        }

        if (! $identifying)
        {
            if (! $INetwork.IsConnected)
            {
              "$Name is not connected"
              Start-Sleep -second 2
              $identifying = 1
            }

            if (! $identifying)
            {
                $Category = $INetwork.GetCategory()

                if ($INetwork.IsConnected -and ($Category -eq $NLM_NETWORK_CATEGORY_PUBLIC))
                {
                  "Set network '$Name' to private"
                  $INetwork.SetCategory($NLM_NETWORK_CATEGORY_PRIVATE)
                }
            }
        }
    }
} while ($identifying)

Start-Sleep -seconds 1

foreach ($INetwork in $INetworks)
{
  $Name = $INetwork.GetName()
  "Checking Network '$Name'"
  $Category = $INetwork.GetCategory()

  if ($INetwork.IsConnected -and ($Category -eq $NLM_NETWORK_CATEGORY_PUBLIC))
  {
    "Error! Network '$Name' is still public!"
  }
}
