$yesno = Read-Host 'Do you need to log into Azure (only one time per powershell.exe session)?  [yes/no]';
if ('yes' -eq $yesno) { Connect-AzAccount -EnvironmentName AzureUSGovernment; }

$SubscriptionName = 'Subscription Name'
Select-AzSubscription -SubscriptionName $SubscriptionName

$SAS = Get-AzStorageAccount

ForEach($SA in $SAS){
    $Location = $SA.Location
    $ResourceGroupName = $SA.ResourceGroupName
    $StorageAccountName = $SA.StorageAccountName

    #$ServiceEndpoints = Get-AzVirtualNetworkAvailableEndpointService -Location $location

    If ($SA.NetworkRuleSet.DefaultAction = "Allow") {

        "Working on $StorageAccountName in $Location`n"

        $VNETs = Get-AzVirtualNetwork -WarningAction SilentlyContinue | Where-object {$_.Location -eq $Location}
        $networkruleadd = @()

        ForEach ($VNET in $VNETs) {

            $Subnets = $Vnet.Subnets

            If ($Subnets -ne "") {
                
                ForEach ($Subnet in $Subnets){

                    $SubnetID = $Subnet.Id
                    $SubnetName = $Subnet.Name
                    $SubnetAddressPrefix = $Subnet.AddressPrefix
                    
                    If ($subnet.ServiceEndpoints.Count -ne '6') {

                        $vnetServiceEnpoint = Set-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetAddressPrefix -VirtualNetwork $vnet -ServiceEndpoint Microsoft.Storage, Microsoft.Sql, Microsoft.AzureCosmosDB, Microsoft.KeyVault, Microsoft.EventHub, Microsoft.ServiceBus
                        $vnetServiceEnpoint = Set-AzVirtualNetwork -VirtualNetwork $vnetServiceEnpoint
                    }

                    $networkruleadd += [Microsoft.Azure.Commands.Management.Storage.Models.PSVirtualNetworkRule]@{
                        'VirtualNetworkResourceId' = $SubnetID;
                        'Action'                   = 'allow';
                    }

                }
            }

        }

        $ipRules = [Microsoft.Azure.Commands.Management.Storage.Models.PSIpRule]@{
            IPAddressOrRange = "111.222.333.444/24";
            Action           = "Allow"
        }

        $networkRuleSet = [Microsoft.Azure.Commands.Management.Storage.Models.PSNetworkRuleSet]@{
            bypass              = "AzureServices";
            DefaultAction       = "Deny";
            ipRules             = $ipRules
            virtualNetworkRules = $networkruleadd
        }
        Set-AzStorageAccount -Name $StorageAccountName -ResourceGroupName $ResourceGroupName -EnableHttpsTrafficOnly $True -NetworkRuleSet $networkruleset
    }
}