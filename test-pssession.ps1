<#import-module C:\Scripts\aws\AWSHelper.psm1 -force
$creds = New-Credential -DomainName '' -UserName 'administrator' -Password '~123qwerty'
$machine  = 'ec2-174-129-163-222.compute-1.amazonaws.com'
New-PSSession -ComputerName $machine -Credential $creds
#>
import-module C:\worksrc\Scripts\aws\AWSHelper.psm1 -force
$creds = New-Credential -UserName 'administrator' -Password '~123qwerty' -DomainName 'second'
$machine  = 'ec2-54-167-111-160.compute-1.amazonaws.com'
$session = New-PSSession -ComputerName $machine -Credential $creds
$session
Remove-PSSession $session