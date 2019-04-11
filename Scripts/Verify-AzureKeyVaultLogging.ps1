$yesno = Read-Host 'Do you need to log into Azure (only one time per powershell.exe session)?  [yes/no]';
if ('yes' -eq $yesno) { Connect-AzAccount -EnvironmentName AzureUSGovernment; }

$SubscriptionName = 'Subscription Name'
Select-AzSubscription -SubscriptionName $SubscriptionName

$KeyVaults = Get-AzKeyVault

ForEach ($KeyVault in $KeyVaults) {
    Get-AzDiagnosticSetting -ResourceId $KeyVault.ResourceId -WarningAction SilentlyContinue | Select-Object Id,Logs | Format-List
}