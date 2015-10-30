Register-PSSessionConfiguration -Name Microsoft.PowerShell -Force 

$userPassword = '~123qwerty'
$userName = 'rmad\administrator'
$credential = new-object System.Management.Automation.PSCredential($userName, (ConvertTo-SecureString $userPassword -asPlainText -Force))
Invoke-Command -ComputerName $env:computername -Credential $credential -scriptBlock {
    winrm quickconfig
    Enable-PSRemoting -Force
} 