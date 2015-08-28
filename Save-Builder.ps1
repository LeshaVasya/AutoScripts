#Import-Module AWSPowerShell -Force
Import-module "C:\WorkSrc\Scripts\AWS\AWSHelper.psm1" -force
Set-DefaultAWSRegion "us-east-1"

$InstanceId = "i-566f4184"
Save-Instance -InstanceId $InstanceId -SaveLastAmi $true -Description "2012R2_DC1Core_RODC2Core" -CustomAmiName "rmad-at-2012r2-2dc-core-dc1core"

$InstanceId = "i-556f4187"
Save-Instance -InstanceId $InstanceId -SaveLastAmi $true -Description "2012R2_DC1Core_RODC2Core" -CustomAmiName "rmad-at-2012r2-2dc-core-dc2rocore"

$InstanceId = "i-2990bffb"
Save-Instance -InstanceId $InstanceId -SaveLastAmi $true -Description "2012R2_DC1Core_RODC2Core" -CustomAmiName "rmad-at-2012r2-2dc-core-ws1"
<#
$InstanceId = "i-3742fc9f"
Save-Instance -InstanceId $InstanceId -SaveLastAmi $false -Description "2012R2 2DC RODC Core Lab" -CustomAmiName "rmad-at-2012r2-2dc-core-dc1core"

$InstanceId = "i-eb42fc43"
Save-Instance -InstanceId $InstanceId -SaveLastAmi $false -Description "2012R2 2DC RODC Core Lab" -CustomAmiName "rmad-at-2012r2-2dc-core-dc2rocore"

$InstanceId = "i-3b42fc93"
Save-Instance -InstanceId $InstanceId -SaveLastAmi $false -Description "2012R2 2DC RODC Core Lab" -CustomAmiName "rmad-at-2012r2-2dc-core-ws1"
#>


<#
$InstanceId = "i-3e7a1896"
Save-Instance -InstanceId $InstanceId -SaveLastAmi $true -Description "2008R2_Core_lab" -CustomAmiName "rmad-at-2008r2-core-dc1core"


$InstanceId = "i-85efb62d"
Save-Instance -InstanceId $InstanceId -SaveLastAmi $false -Description "2008R2_Core_lab" -CustomAmiName "rmad-at-2008r2-core-ws1"



$InstanceId = "i-e1690949"
Save-Instance -InstanceId $InstanceId -SaveLastAmi $true -Description "Prod lab. It.spb.qsft" -CustomAmiName "rmad-at-ProdLab-2008R2-DC1"

$InstanceId = "i-0362f5ab"
Save-Instance -InstanceId $InstanceId -SaveLastAmi $true -Description "Prod lab. It.spb.qsft" -CustomAmiName "rmad-at-ProdLab-2003R2-DC2"

$InstanceId = "i-4463f4ec"
Save-Instance -InstanceId $InstanceId -SaveLastAmi $true -Description "Prod lab. It.spb.qsft" -CustomAmiName "rmad-at-ProdLab-2008R2-WS1"


$InstanceId = "i-984e034a"
Save-Instance -InstanceId $InstanceId -SaveLastAmi $false -Description "Occasionally resave" -CustomAmiName "rmad-at-2012r2-2dc-dc1"

$InstanceId = "i-7a4c01a8"
Save-Instance -InstanceId $InstanceId -SaveLastAmi $false -Description "Occasionally resave" -CustomAmiName "rmad-at-2012r2-2dc-dc2"

$InstanceId = "i-c64f0214"
Save-Instance -InstanceId $InstanceId -SaveLastAmi $False -Description "Occasionally resave" -CustomAmiName "rmad-at-2012r2-2dc-ws1"
#>

