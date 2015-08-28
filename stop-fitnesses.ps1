import-module C:\\Scripts\\AWS\\AWSHelper.psm1 -Force
$owner = Get-InstanceOwner
$ownerlabs = Get-OwnRunningLabId -owner $owner
$portToLabId = (Get-ChildItem "C:\Jenkins\*" -Include lab.html -Recurse |? {$_.directory.Name -notmatch "workspace"} ).directoryName
$labsId = (Get-Item $portToLabId).Name
$notRunLabsId = $labsId | ? { $ownerlabs -notcontains $_ }
foreach ($lab in $notRunLabsId) {
    $LabPath = (Get-ChildItem "C:\Jenkins\*" -Include $lab -Recurse).fullName     
     Stop-FitnesseProccessByLabPath -FilePath "$LabPath\lab.html"
}