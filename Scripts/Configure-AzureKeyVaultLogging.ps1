$yesno = Read-Host 'Do you need to log into Azure (only one time per powershell.exe session)?  [yes/no]';
if ('yes' -eq $yesno) { Connect-AzAccount -EnvironmentName AzureUSGovernment; }

$SubscriptionName = 'Subscription Name'
Select-AzSubscription -SubscriptionName $SubscriptionName

$KeyVaults = Get-AzKeyVault

ForEach ($KeyVault in $KeyVaults) {
    $Location = $KeyVault.Location
    #Get Location Specific diagnostic account
    If ($Location -eq "USGovVirginia"){
        $sa = Get-AzStorageAccount | Where-Object {$_.StorageAccountName -like "*vasgdiag"}
    }ElseIf($Location -eq "USGovArizona"){
        $sa = Get-AzStorageAccount | Where-Object {$_.StorageAccountName -like "*azsgdiag"}
    }Else{Return}

    Set-AzDiagnosticSetting -ResourceId $KeyVault.ResourceId -StorageAccountId $sa.Id -Enabled $true -Category AuditEvent -RetentionEnabled $True -RetentionInDays 365 -WarningAction SilentlyContinue
}