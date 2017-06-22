<#
.NAME
       

.DESCRIPTION
       

.NOTES
    AUTHOR: Microsoft Services
    LASTEDIT: 

#>

###########################################################################################
#### VARIABLES
###########################################################################################
$RGName = 'RG-NSGTest'
$RGlocation = 'westus2'
$nsgName = 'NSG-Test'


###########################################################################################
#### SECTION 1: Log into Azure
###########################################################################################
    Write-Host 'Please log into Azure now' -foregroundcolor Green;
    Try {

        Get-AzureRmResource | Out-Null
    
    }

    Catch {

        Login-AzureRmAccount

    }
    $SubscriptionList = Get-AzureRmSubscription

    #Reset subscription number to zero in case of multiple runs of the script within the same session
    $SubscriptionNumber = 0

    #Reset the subscription object used to hold the enumerated subscriptions in case of multiple runs of the script within the same session
        [psobject]$subscriptionResults = $null


        ForEach($Subscription in $SubscriptionList){
            $SubscriptionNumber ++
    
            $SubscriptionProperties = @{'SubscriptionNumber'=$SubscriptionNumber;
                'SubscriptionName'=$Subscription.Name
                'SubscriptionID'=$Subscription.Id
            }
            $PSObject = New-Object -TypeName PSObject -Property $SubscriptionProperties
            $subscriptionResults += @($PSObject)
        }

    #Display a table of the available subscriptions to the user
    $subscriptionResults | FT -AutoSize @{label="Subscription Number";Expression={($_.subscriptionnumber)};align='center'},@{label="Subscription Name";Expression={($_.subscriptionname)}},
    @{label="Subscription ID";Expression={($_.subscriptionID)}}

    #Capture user input
    Write-Host
    $subSelection = Read-Host 'Please enter a subscription number and press enter'

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

###########################################################################################
#### SECTION 2: Evaluate if RG exists, create if missing
###########################################################################################

Write-Host 'Evaluate Resource Group for NSG build' -ForegroundColor Cyan

$rg = Get-AzureRmResourceGroup -Name $RGName -Location $RGlocation -ErrorAction SilentlyContinue

If (!$rg){

Write-Host "Resource group not detected - creating resource group $($rgname)" -ForegroundColor Green

$rg = New-AzureRmResourceGroup -Name $RGName -Location $RGlocation -Verbose -Force

}

If ($rg) {

Write-host "Resource group $($rgname) detected - skipping create resource group step" -ForegroundColor Cyan

}

$RGName = $rg.resourcegroupname

###########################################################################################
#### SECTION 3: Evaluate if NSG exists, create if missing
###########################################################################################
$nsg = Get-AzureRmNetworkSecurityGroup -Name $nsgName -ResourceGroupName $RGName -ErrorAction SilentlyContinue
 
If (!$nsg){

Write-Host "Network security group not detected - creating NSG $($nsgName)" -ForegroundColor Green

$nsg = New-AzureRmNetworkSecurityGroup -Name $nsgName -ResourceGroupName $RGName -Location $RGlocation -Verbose -Force

}

If ($nsg) {

Write-host "Network security group $($nsgName) detected - skipping create NSG step" -ForegroundColor Cyan

}


###########################################################################################
#### SECTION 4: Populate NSG with Rulesets
###########################################################################################





