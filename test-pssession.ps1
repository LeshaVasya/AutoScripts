<#import-module C:\Scripts\aws\AWSHelper.psm1 -force
$creds = New-Credential -DomainName '' -UserName 'administrator' -Password '~123qwerty'
$machine  = 'ec2-174-129-163-222.compute-1.amazonaws.com'
New-PSSession -ComputerName $machine -Credential $creds
#>
import-module C:\worksrc\Scripts\aws\AWSHelper.psm1 -force
$creds = New-Credential -UserName 'administrator' -Password '~123qwerty' -DomainName 'rmad'
$machine  = 'ec2-52-91-59-54.compute-1.amazonaws.com'
$session = New-PSSession -ComputerName $machine -Credential $creds
$session
Remove-PSSession $session