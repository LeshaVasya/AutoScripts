$rmadPath = 'Recovery Manager for Active Directory'
$fe = 'Forest Edition'
$resultfe = 'C:\Program Files\Dell\Recovery Manager for Active Directory Forest Edition\ERDisk.exe'
$result = 'C:\Program Files\Dell\Recovery Manager for Active Directory\ERDisk.exe'
$regexp = "$([regex]::Escape($rmadPath))(\s)?($([regex]::Escape($fe)))?\\ERDisk\.exe"

$regx = "$rmadPath(\s$fe)?\\ERDisk\.exe"

Write-host "Matching RMAD"
$result -match $regx
$result
$Matches
Write-host ""
Write-host "Matching RMADFE"
$resultfe
$resultfe -match $regx
$Matches

