$userName = 'rmad\administrator'
$password = '~123qwerty'

Write-Host "Allow replication with divergent and corrupt partner for all DCs in the whole forest"
$command = "repadmin /regkey * +allowDivergent /u:$userName /pw:$password"
Invoke-Expression -Command $command

$i = 0
do {
    repadmin /syncall /AdeP /u:$userName /pw:$password
    #Check if replication was successfull
    $replicationErrors = repadmin /showrepl * /csv /u:$userName /pw:$password | ConvertFrom-Csv | ? {$_.'Number Of Failures' -ne '0' }   
    if($replicationErrors -eq $null) {
        Write-host "No Replication Errors. Allow Divergent."
        break;
    }
    Write-host "Divergent Replication Errors: $replicationErrors"
    Start-Sleep -Seconds 2
}
while ($i++ -lt 60)

Write-Host "Deny replication with divergent and corrupt partner for all DCs in the whole forest"
$command = "repadmin /regkey * -allowDivergent /u:$userName /pw:$password"
Invoke-Expression -Command $command

$i = 0
do {
    repadmin /syncall /AdeP /u:$userName /pw:$password
    #Check if replication was successfull
    $replicationErrors = repadmin /showrepl * /csv /u:$userName /pw:$password | ConvertFrom-Csv | ? {$_.'Number Of Failures' -ne '0' }   
    if($replicationErrors -eq $null) {
        Write-host "No Replication Errors. No Divergent."
        break;
    }
    Write-host " Replication Errors: $replicationErrors"
    Start-Sleep -Seconds 2
}
while ($i++ -lt 60)