
<powershell>

function Set-VolumeToDrive {
    param (
        $VolumeName,
        $DriveLetter
    )
    $driveConfigName = "C:\Program Files\Amazon\Ec2ConfigService\Settings\DriveLetterConfig.xml"
    [xml]$driveConfig = gc $driveConfigName

    $MappingElement = $driveConfig.CreateElement("Mapping", $driveConfig.DocumentElement.NamespaceURI)
    $VolumeNameElement = $driveConfig.CreateElement("VolumeName", $driveConfig.DocumentElement.NamespaceURI)
    $VolumeNameElement.InnerXML = $VolumeName
    $DriveLetterElement = $driveConfig.CreateElement("DriveLetter", $driveConfig.DocumentElement.NamespaceURI)
    $DriveLetterElement.InnerXML = $DriveLetter + ":"

    $MappingElement.AppendChild($VolumeNameElement) | Out-Null
    $MappingElement.AppendChild($DriveLetterElement) | Out-Null
    $driveConfig.DocumentElement.appendChild($MappingElement) | Out-Null

    $driveConfig.save($driveConfigName)
}


set HOME C:\Users\Administrator
setx HOME C:\Users\Administrator

git config --f C:\Users\Administrator\.gitconfig --unset user.email
git config --f C:\Users\Administrator\.gitconfig --unset user.name
git config --f C:\Users\Administrator\.gitconfig --add user.email "ci@software.dell.com"
git config --f C:\Users\Administrator\.gitconfig --add user.name "ci"

Set-VolumeToDrive "rmad-ci" "P"
Set-VolumeToDrive "rmad-symbols" "S"

Add-EC2Volume -InstanceId (Invoke-WebRequest -Uri "http://169.254.169.254/latest/meta-data/instance-id").Content -VolumeId "vol-562e2014" -Device "/dev/sdh" -Region "us-east-1" 
Add-EC2Volume -InstanceId (Invoke-WebRequest -Uri "http://169.254.169.254/latest/meta-data/instance-id").Content -VolumeId "vol-fef85db9" -Device "/dev/xvdf" -Region "us-east-1" 

while(!(Test-Path P:\)) { 
    sleep 1 
}

while(!(Test-Path S:\)) { 
    sleep 1 
}

Set-Location P:\Scripts
    
git fetch origin scripts
git remote set-head origin scripts
git reset --hard
git pull
git checkout -f scripts

cmd /c mklink /d Z:\Scripts P:\Scripts

Z:\Scripts\AWS\UserData\init-ci-builder.ps1 -Branch "master" -Owner "rmad-team"

</powershell>
<persist>false</persist>
