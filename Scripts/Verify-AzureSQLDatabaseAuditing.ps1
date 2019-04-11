$yesno = Read-Host 'Do you need to log into Azure (only one time per powershell.exe session)?  [yes/no]';
if ('yes' -eq $yesno) { Connect-AzAccount -EnvironmentName AzureUSGovernment; }

$SubscriptionName = 'Subscription Name'
Select-AzSubscription -SubscriptionName $SubscriptionName

$SQLServers = Get-AzSqlServer

ForEach ($SQLServer in $SQLServers) {
        $SQLServerName = $SQLServer.ServerName
        $SQLRGName = $SQLServer.ResourceGroupName

        $Databases = Get-AzSqlDatabase -ServerName $SQLServerName -ResourceGroupName $SQLRGName
        ForEach($Database in $Databases){
            $SQLDatabaseName = $Database.DatabaseName
            Get-AzSqlDatabaseAuditing -ResourceGroupName $SQLRGName -ServerName $SQLServerName -BlobStorage -WarningAction SilentlyContinue -DatabaseName $SQLDatabaseName
            Get-AzSqlDatabaseAuditing -ResourceGroupName $SQLRGName -ServerName $SQLServerName -LogAnalytics -WarningAction SilentlyContinue -DatabaseName $SQLDatabaseName
        }
}