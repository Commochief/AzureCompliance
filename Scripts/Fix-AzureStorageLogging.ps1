$yesno = Read-Host 'Do you need to log into Azure (only one time per powershell.exe session)?  [yes/no]';
if ('yes' -eq $yesno) { Connect-AzAccount -EnvironmentName AzureUSGovernment; }

$SubscriptionName = 'Subscription Name'
Select-AzSubscription -SubscriptionName $SubscriptionName

$SAS = Get-AzStorageAccount

ForEach ($SA in $SAS) {
    $StorageAccountName = $SA.StorageAccountName
    $Context = New-AzStorageContext -StorageAccountName $StorageAccountName -UseConnectedAccount
    "Working on $StorageAccountName"
    "Setting Blob Logging on $StorageAccountName"
    Set-AzStorageServiceLoggingProperty -ServiceType Blob -LoggingOperations Read, Write, Delete -RetentionDays 180 -Version 1.0 -Context $Context
    "Setting Queue Logging on $StorageAccountName"
    Set-AzStorageServiceLoggingProperty -ServiceType Queue -LoggingOperations Read, Write, Delete -RetentionDays 180 -Version 1.0 -Context $Context
}