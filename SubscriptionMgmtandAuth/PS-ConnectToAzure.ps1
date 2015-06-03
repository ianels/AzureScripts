Function PS-ConnectToAzure {
Param(
[Parameter(Mandatory=$true)][string] $AzureUserName,
[Parameter(Mandatory=$true)][System.Security.SecureString]$AzurePassword
)
Import-Module Azure

$azureCred = New-Object System.Management.Automation.PSCredential($AzureUserName,$AzurePassword)

Try {
Write-Host '\\\\\\\\\\\'
Write-Host 'Connecting to Azure...'

Add-AzureAccount -Credential $azureCred
 
Write-Host 'Connection to Azure established'
Write-Host '///////////'
}

Catch [system.exception] {
Write-Host 'Unable to authenticate to Azure. Check your settings and try again or contact your subscription administrator.'
Write-Host '///////////'
}

return $azureCred | Out-Null
}