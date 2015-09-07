import-module C:\Scripts\aws\AWSHelper.psm1 -force
$creds = New-Credential -DomainName 'rmad' -UserName 'administrator' -Password '~123qwerty'
$machine  = 'ec2-174-129-163-222.compute-1.amazonaws.com'
New-PSSession -ComputerName $machine -Credential $creds

import-module C:\Scripts\aws\AWSHelper.psm1 -force
$creds = New-Credential -UserName 'administrator' -Password '~123qwerty'
$machine  = 'ec2-52-20-113-149.compute-1.amazonaws.com'
$session = New-PSSession -ComputerName $machine -Credential $creds
$session
Remove-PSSession $session