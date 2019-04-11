$yesno = Read-Host 'Do you need to log into Azure (only one time per powershell.exe session)?  [yes/no]';
if ('yes' -eq $yesno) { Connect-AzAccount -EnvironmentName AzureUSGovernment; }

$SubscriptionName = 'Subscription Name'
Select-AzSubscription -SubscriptionName $SubscriptionName
$workspaceid = (Get-AzOperationalInsightsWorkspace | Where-Object {$_.Name -like "OrgName-*"}).ResourceId
$SQLServers = Get-AzSqlServer

ForEach ($SQLServer in $SQLServers) {
    $SQLServerName = $SQLServer.ServerName
    $SQLRGName = $SQLServer.ResourceGroupName
    
    Set-AzSqlServerAuditing -ResourceGroupName $SQLRGName -ServerName $SQLServerName -WarningAction SilentlyContinue -LogAnalytics -WorkspaceResourceId $workspaceid -State Enabled
}