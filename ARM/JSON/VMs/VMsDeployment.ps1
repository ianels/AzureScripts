#Use a try catch block to detect if the current session is authenicated to Azure
Try {

    Get-AzureRmResource | Out-Null
    
}

Catch {

    Login-AzureRmAccount

}


#Storage Account Information
$ResourceGroupName = "rg-VM-Admin"
$location = 'East US 2'

$subList = Get-AzureRmSubscription

#Reset subscription number to zero in case of multiple runs of the script within the same session
[int]$subNumber = 0

#Reset the subscription object used to hold the enumerated subscriptions in case of multiple runs of the script within the same session
[psobject]$subscriptionResults = $null

#Add a Subscription Number to the list of subscriptions
ForEach ($sub in $subList) {
    
    $subNumber++

        $subProperties = @{'SubscriptionNumber'=$subNumber;
        'SubscriptionName'=$sub.SubscriptionName
        'SubscriptionID'=$sub.SubscriptionId
        }
    $PSObject = New-Object -TypeName PSObject -Property $subProperties
    $subscriptionResults += @($PSObject)

}

#Display a table of the available subscriptions to the user
$subscriptionResults | FT -AutoSize @{label="Subscription Number";Expression={($_.subscriptionnumber)}},@{label="Subscription Name";Expression={($_.subscriptionname)}},
@{label="Subscription ID";Expression={($_.subscriptionID)}}

#Capture user input
#$subSelection = Read-Host 'Pick a subscription and press enter'
$subSelection = 1

#Set the selected subscription object to a variable
$selectedSubscription = $subscriptionResults | Where-Object {$_.subscriptionnumber -eq $subSelection}

#Set selected subscription to active
Try{

Write-Host "Setting $($selectedSubscription.subscriptionName) as the active subscription..."
Select-AzureRMSubscription -SubscriptionId $selectedSubscription.SubscriptionID | Out-Null
Write-Host "$($selectedSubscription.subscriptionName) is set as the active subscription."
}

Catch{
    Write-Host 'Error occured while attempting to set the Active Subscription'
    #Return the error message
    Return $_
}

Finally{
    Clear-Variable -Name selectedSubscription -ErrorAction SilentlyContinue
}

Write-Host 'Create Resource Group fo JSON template deployment'

$rg = Get-AzureRmResourceGroup -Name $ResourceGroupName -Location $location -ErrorAction SilentlyContinue

If (!$rg){
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $location -Verbose -Force
}

$templatefile = "$($PSScriptRoot)\vm.json"
$parametersfile = "$($psscriptroot)\vm.parameters.json"

$vNet = Get-AzureRmVirtualNetwork -Name vn-az-ea2-ius-01 -ResourceGroupName rg-network-admin

$storageAccount = Get-AzureRmStorageAccount -Name saazea2iuslrs0001 -ResourceGroupName rg-storage-admin



Write-Host 'Start of JSON template'

New-AzureRmResourceGroupDeployment -Name "VMDeployment" -ResourceGroupName $ResourceGroupName -Mode Incremental -Force -TemplateFile $templatefile -TemplateParameterFile $parametersfile -StorageAccountName $storageAccount.StorageAccountName -VirtualNetworkID $vnet.ID

Write-Host 'End of JSON template'