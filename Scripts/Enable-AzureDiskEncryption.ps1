#Login to Azure Gov
Login-AzureRmAccount -EnvironmentName AzureUSGovernment

#Define Subscription information
$SubscriptionName = "Subscription Name"

#Select the correct subscription
$sub = Get-AzSubscription -SubscriptionName $SubscriptionName
Select-AzSubscription -SubscriptionId $sub.Id

$VMrgName = 'SubsName-VA-AppName-RG';
$KVrgName = 'SubsName-VA-RG';
$vmName = 'Server00003';
$KeyVaultName = 'SubsName-VA-KeyVault-GroupName';
$keyEncryptionKeyName = 'SubsName-VA-AppName-RG-KEK';
$KeyVault = Get-AzKeyVault -VaultName $KeyVaultName -ResourceGroupName $KVrgName;
$diskEncryptionKeyVaultUrl = $KeyVault.VaultUri;
$KeyVaultResourceId = $KeyVault.ResourceId;
Add-AzKeyVaultKey -VaultName $KeyVaultName -Name $keyEncryptionKeyName -Destination HSM ;
$keyEncryptionKeyUrl = (Get-AzKeyVaultKey -VaultName $KeyVaultName -Name $keyEncryptionKeyName).Key.kid;

Set-AzVMDiskEncryptionExtension -ResourceGroupName $VMrgName -VMName $vmName -DiskEncryptionKeyVaultUrl $diskEncryptionKeyVaultUrl -DiskEncryptionKeyVaultId $KeyVaultResourceId -KeyEncryptionKeyUrl $keyEncryptionKeyUrl -KeyEncryptionKeyVaultId $KeyVaultResourceId;

Get-AzVmDiskEncryptionStatus -ResourceGroupName $VMrgName -VMName $vmName
