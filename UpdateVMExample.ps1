Import-Module Azure

$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

Get-AzureVM -ServiceName "MySvc1" -Name "MyVM3" | 
Set-AzureVMExtension -Publisher CloudLink.SecureVM -ExtensionName CloudLinkSecureVMLinuxAgent -Version 3.* -PublicConfigPath "$scriptDir\CloudLink.config" | 
Update-AzureVM