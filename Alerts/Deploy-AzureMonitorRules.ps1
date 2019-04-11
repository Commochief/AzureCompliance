$yesno = Read-Host 'Do you need to log into Azure (only one time per powershell.exe session)?  [yes/no]';
if ('yes' -eq $yesno) { Connect-AzAccount -EnvironmentName AzureUSGovernment; }

$SubscriptionName = 'Subscription Name'
Select-AzSubscription -SubscriptionName $SubscriptionName
$RGName = "default-activitylogalerts"
$ruletemplates = Get-Item "C:\Users\jastaley\OneDrive - Federal Bureau of Investigation\Source\Repos\AzureGov-GL-SecAuto\AlertRules\SubName-PPD\ModifyNSGRuleAlert-SubName-PPD.json"

ForEach($template in $ruletemplates){
    $templatepath = $template.PSPath
    $templateName = $template.BaseName

    New-AzResourceGroupDeployment -Name $templateName -ResourceGroupName $RGName -TemplateFile $templatepath

}