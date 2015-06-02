Function PS-SetActiveSubscription {
Param(
[object] $SubscriptionToSetActive
)

Import-Module Azure

Try{

$subscriptionIDToSetActive = $subscriptionToSetActive.SubscriptionID
$subscriptionNameToSetActive = $subscriptionToSetActive.subscriptionName

Write-Host "Setting $subscriptionNameToSetActive as the active subscription..."
Select-AzureSubscription -SubscriptionId $subscriptionIDToSetActive
Write-Host "$subscriptionNameToSetActive is set as the active subscription."
}

Catch{
    Write-Host 'Error occured while attempting to create Storage Account'
    #Return the error message
    Return $_.
}

Finally{
    Clear-Variable -Name subscriptionIDToSetActive -ErrorAction SilentlyContinue
    Clear-Variable -Name subscriptionNameToSetActive -ErrorAction SilentlyContinue
}

}