Import-Module C:\WorkSrc\Scripts\AWS\AWSHelper.psm1 -force

$Region = 'us-east-1'
Set-DefaultAWSRegion $Region
$ProductDescriptions = "Windows (Amazon VPC)"
Get-InstanceType -Region $Region -ProductDescriptions $ProductDescriptions -EnhancedNetwork $true


