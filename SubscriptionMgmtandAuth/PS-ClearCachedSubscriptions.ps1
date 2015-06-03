Function PS-ClearCachedSubscriptions {
Param(
[PSObject] $SubscriptionList
)
Import-Module Azure

Try {
    ForEach ($subscription in $SubscriptionList) {
        Remove-AzureSubscription -SubscriptionName $subscription.SubscriptionName -Force -WarningAction SilentlyContinue | Out-Null
        }
    }
Catch
    {
    Return $_
    }
}