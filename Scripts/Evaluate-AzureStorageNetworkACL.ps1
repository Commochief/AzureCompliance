Select-AzureRmSubscription -SubscriptionName "SubName"

$SAS = Get-AzureRmStorageAccount

ForEach($SA in $SAS){
    $Location = $SA.Location
    $ResourceGroupName = $SA.ResourceGroupName
    $StorageAccountName = $SA.StorageAccountName

    If ($SA.NetworkRuleSet.DefaultAction = "Allow") {

        "The following Storage Account is vulverable: $StorageAccountName in $Location`n"
    }
}