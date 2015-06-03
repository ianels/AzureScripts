Function PS-GetSubscriptions {

Try {

    Import-Module Azure

    $subscriptionList = Get-AzureSubscription

    ForEach ($subscription in $subscriptionList) {
        $subscriptionNumber ++

        $properties = @{'SubscriptionNumber'=$subscriptionNumber;
            'SubscriptionName'=$subscription.SubscriptionName
            'SubscriptionID'=$subscription.SubscriptionId
            }
        $PSObject = New-Object -TypeName PSObject -Property $properties
        $subscriptionResults += @($PSObject)
        }

    return $subscriptionResults

    }

    Catch [system.exception] {
    Write-Output 'Unable to retrieve Azure Subscriptions. Check your settings and try again or contact your subscription administrator.'
    }

}
