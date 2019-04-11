$yesno = Read-Host 'Do you need to log into Azure (only one time per powershell.exe session)?  [yes/no]';
if ('yes' -eq $yesno) { Connect-AzAccount -EnvironmentName AzureUSGovernment; }

$Subs = Get-AzSubscription | Where-object {$_.Name -like "OrgName-SubName*"}

foreach ($Sub in $Subs)
{

Select-AzSubscription -Subscription $Sub

Get-AzVirtualNetwork | Select-Object Name, @{ expression = { $_.AddressSpace.AddressPrefixes }; label = "AddressPrefix" } | Export-Csv -Path E:\Azure\AzureVNets.csv -NoTypeInformation -Append

}