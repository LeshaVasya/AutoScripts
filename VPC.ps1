#Launching a Spot Instance in a VPC

#The following command requests a Spot Instance in the specified subnet. The security group must be one you created for the VPC that contains the specified subnet.

$interface1 = New-Object Amazon.EC2.Model.InstanceNetworkInterfaceSpecification
$interface1.DeviceIndex = 0
$interface1.SubnetId = 'subnet-aeb451d9' #subnetid
$interface1.PrivateIpAddress = '10.0.1.5'
$interface1.Groups.Add('sg-c7b433a2') #RMADVPC
$interface1.AssociatePublicIpAddress = $true
$interface1.NetworkInterfaceId = 'vpc-78f0301d' #vpc-id
Request-EC2SpotInstance - -LaunchSpecification_SubnetId $subnetid -SpotPrice 0.007 -InstanceCount 1 -Type one-time -LaunchSpecification_ImageId ami-7527031c -LaunchSpecification_InstanceType m1.small -Region us-west-2 -LaunchSpecification_NetworkInterfaces $interface1


-SubnetId subnet-56738b33 -AssociatePublicIp $true 
Get-EC2Subnet
Get-EC2Vpc
Get-EC2SecurityGroup


Import-Module Z:\Scripts\AWS\AWSHelper.psm1 -force
$configuration = [string](Get-Content "Z:\Scripts\AWS\2008r2-dc1ws1.json") | ConvertFrom-Json 

$Machines = Get-Machines -Configuration $configuration -Owner "Avasilie" -LabId "My VPC Lab Id" -Identity "2008R2" -NetworkMode "VPC"
if($Machines[0].VpcId -and $Machines[0].SubnetId){
Write-host "Starting machine in VPC"
}
else{Write-host "Starting machine in EC2Classic"

}
start-host -Machine $Machines[0]