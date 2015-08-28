$outputFolder = 'C:\Windows\SYSVOL\sysvol\rmad.local'

$minSize = 1 #kb
$maxSize = 10 #kb
$fileCount = 10000 

New-Item -ItemType 'Directory' -Path $outputFolder -Force 
for($i = 0; $i -lt $fileCount; $i++) {
    $fileName = [System.IO.Path]::GetRandomFileName()
    $fileSize = Get-Random -Minimum ($minSize * 1024) -Maximum ($maxSize * 1024)
    $bytes = New-Object Byte[] $fileSize
    $randomizer = New-Object "System.Random"
    $randomizer.NextBytes($bytes)
    [System.IO.File]::WriteAllBytes("$outputFolder\$fileName", $bytes)
}
(Get-ChildItem $outputFolder).Count