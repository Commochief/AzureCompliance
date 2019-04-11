$yesno = Read-Host 'Do you need to log into Azure (only one time per powershell.exe session)?  [yes/no]';
if ('yes' -eq $yesno) { Connect-AzAccount -EnvironmentName AzureUSGovernment; }

$SubscriptionName = 'Subscription Name'
Select-AzSubscription -SubscriptionName $SubscriptionName

$SQLServers = Get-AzSqlServer

ForEach ($SQLServer in $SQLServers) {
    $SQLServerName = $SQLServer.ServerName
    $SQLRGName = $SQLServer.ResourceGroupName
    $ProtectionState = Get-AzSqlServerAdvancedThreatProtectionPolicy -ResourceGroupName $SQLRGName -ServerName $SQLServerName -WarningAction SilentlyContinue
    If ($ProtectionState.IsEnabled -eq $False){
        Enable-AzSqlServerAdvancedThreatProtection -ResourceGroupName $SQLRGName -ServerName $SQLServerName
    }
}