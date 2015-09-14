<#Fix WSMAN SPN creation issue 
Code="2150858909" Machine="dc1.RMAD.local"><f:Message>WinRM cannot process the 
request. The following error with errorcode 0x80090350 occurred while using 
Negotiate authentication: An unknown security error occurred. 
#>
$computerDnsName = [System.Net.Dns]::GetHostEntry([string]$env:computername).HostName
setspn -S "WSMAN/$env:computername" $env:computername
setspn -S "WSMAN/$computerDnsName" $env:computername