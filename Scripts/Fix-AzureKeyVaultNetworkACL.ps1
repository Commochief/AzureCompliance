$yesno = Read-Host 'Do you need to log into Azure (only one time per powershell.exe session)?  [yes/no]';
if ('yes' -eq $yesno) { Connect-AzAccount -EnvironmentName AzureUSGovernment; }

$SubscriptionName = 'OrgName-SubName-EnvName'
Select-AzSubscription -SubscriptionName $SubscriptionName

$KeyVaults = Get-AzKeyVault

ForEach ($KeyVault in $KeyVaults) {
    $Location = $KeyVault.Location
    #$ResourceGroupName = $KeyVault.ResourceGroupName
    $keyVaultName = $KeyVault.VaultName

    "Working on $keyVaultName in $Location`n"

    #Add-AzKeyVaultNetworkRule -VaultName $keyVaultName -IpAddressRange "111.222.333.444/24"
    Update-AzKeyVaultNetworkRuleSet -VaultName $keyVaultName -Bypass AzureServices -DefaultAction Deny -IpAddressRange "111.222.333.444/24"

    $VNETs = Get-AzVirtualNetwork -WarningAction SilentlyContinue | Where-object {$_.Location -eq $Location}

    ForEach ($VNET in $VNETs) {

        $Subnets = $Vnet.Subnets

        If ($Subnets -ne "") {
            
            ForEach ($Subnet in $Subnets) {

                $SubnetID = $Subnet.Id
                $SubnetName = $Subnet.Name
                $SubnetAddressPrefix = $Subnet.AddressPrefix
                
                If ($subnet.ServiceEndpoints.Count -ne '6') {

                    $vnetServiceEnpoint = Set-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetAddressPrefix -VirtualNetwork $vnet -ServiceEndpoint Microsoft.Storage, Microsoft.Sql, Microsoft.AzureCosmosDB, Microsoft.KeyVault, Microsoft.EventHub, Microsoft.ServiceBus
                    $vnetServiceEnpoint = Set-AzVirtualNetwork -VirtualNetwork $vnetServiceEnpoint
                }

                Add-AzKeyVaultNetworkRule -VaultName $keyVaultName -VirtualNetworkResourceId $SubnetID

            }
        }
    }
}
