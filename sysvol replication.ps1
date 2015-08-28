wmic.exe /namespace:\\root\microsoftdfs path DfsrMachineConfig get MaxOfflineTimeInDays
wmic.exe /namespace:\\root\microsoftdfs path DfsrMachineConfig set MaxOfflineTimeInDays=120

Get-WmiObject microsoftdfs | Get-Member -MemberType Methods | Format-List

$MaxOfflineTimeInDays = (Get-CimInstance -Namespace ROOT/microsoftdfs -ClassName DfsrMachineConfig).MaxOfflineTimeInDays

#or < v3

$MaxOfflineTimeInDays = (Get-WmiObject -Namespace ROOT/microsoftdfs -Query "Select MaxOfflineTimeInDays from DfsrMachineConfig").MaxOfflineTimeInDays
$MaxOfflineTimeInDays+=3
Set-CimInstance -Namespace ROOT/microsoftdfs -Query "Select MaxOfflineTimeInDays from DfsrMachineConfig" -Property @{MaxOfflineTimeInDays=$MaxOfflineTimeInDays} -ComputerName localhost
Restart-Service -Name DFSR -Force


$successDFSReplicationEvent = Get-Eventlog -LogName 'DFS Replication' -Newest 8 | ?{$_.EventID -eq '1210'}
$failedDFSReplicationEvent = Get-Eventlog -LogName 'DFS Replication' -Newest 8 | ?{$_.EventID -eq '4012'}