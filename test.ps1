Import-module "C:\WorkSrc\Scripts\AWS\AWSHelper.psm1" -force
Set-DefaultAWSRegion "us-east-1"
$BuilderAmiName = "rmad-builder"
$BuilderInstanceId = "i-cdbf3133"
Save-Builder -InstanceId $BuilderInstanceId -SaveLastBuilderAmi $true -Description "Added several Jenkins Plugins"