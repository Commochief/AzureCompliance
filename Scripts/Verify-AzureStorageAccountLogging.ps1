$yesno = Read-Host 'Do you need to log into Azure (only one time per powershell.exe session)?  [yes/no]';
if ('yes' -eq $yesno) { Connect-AzAccount -EnvironmentName AzureUSGovernment; }

$SubscriptionName = 'Subscription Name'
Select-AzSubscription -SubscriptionName $SubscriptionName

$StorageAccounts = Get-AzStorageAccount

ForEach ($StorageAccount in $StorageAccounts) {
    $StorageAccountName = $StorageAccount.StorageAccountName
    "Working on $StorageAccountName"
    
    $Context = New-AzStorageContext -StorageAccountName $StorageAccountName -UseConnectedAccount
    "Getting Blob Logging on $StorageAccountName"
    Get-AzStorageServiceLoggingProperty -Context $Context -ServiceType Blob
    "Getting Queue Logging on $StorageAccountName"
    Get-AzStorageServiceLoggingProperty -Context $Context -ServiceType Queue
}