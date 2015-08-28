# Run VS2012 as Administrator
#Install SQL Server Data Tools Download https://msdn.microsoft.com/en-us/data/hh297027
#SQL Server Data Tools for Visual Studio 2012 https://msdn.microsoft.com/en-us/jj650015
#Git
#Wix
#AWSPowershell
#7zip

param (
    $CodeBase='8-6',
    $Branch = '863release',
    $ReleaseTag = 'v8.6.3.6539',
    $RMADSrcRoot = 'Z:\RMAD',
    $RestoreNugetPackages = $true,
    $SyncLibs = $true,
    $SetVersion = $true,
    $ReleaseVersion = '8.6.3',
    $ReleaseBuildNumber = '6539',
    $SetVersionScriptName = 'set-version.ps1'
)

Import-Module AWSPowerShell

function Install-S3Zip {
    param (
        [string]$BucketName,
        [string]$ZipName,
        [string]$TargetPath
    )
    
    $tempFile = Join-Path ([System.IO.Path]::GetTempPath()) $ZipName
    Read-S3Object -BucketName $BucketName -Key $ZipName -File $tempFile | Out-Null
    if(-not (Test-Path -Path $TargetPath)) {
        New-Item -ItemType Directory -Path $TargetPath -Force | Out-Null
    }
    $outdir = "-o" + $TargetPath
    7z x $tempFile $outdir -aoa
    rm $tempFile
}

if(-not ( Test-Path $RMADSrcRoot)){
    New-Item -ItemType directory -Path $RMADSrcRoot
}

Set-Location -Path $RMADSrcRoot

Write-Host "Getting sources from GitHub"
if(-not ( Test-Path .git )){
    git init
    git remote add origin https://github.com/GitQuest/RMAD
}

git fetch origin --tags #fix errors
git checkout $ReleaseTag -B $Branch

if($SetVersion){
    Write-host "Setting version $ReleaseVersion.$ReleaseBuildNumber to sources"
    $currentScriptFolderPath = Split-Path $MyInvocation.MyCommand.Path
    $setVersionScript = Join-Path $currentScriptFolderPath $SetVersionScriptName
    if(Test-Path $setVersionScript){
        $command = "$setVersionScript -BuildVersion $ReleaseVersion -BuildNumber $ReleaseBuildNumber -RMADSrcRoot $RMADSrcRoot"
        Invoke-Expression $command
    }
    else{
        Write-Error "Script to set version $SetVersionScriptName not found"
    }
}

if($RestoreNugetPackages){
    Write-host "Restoring Nuget packages"
    $nuget = "$RMADSrcRoot\Tools\nuget.exe"
    Read-S3Object -BucketName RMAD -Key /Tools/nuget.exe -File $nuget | Out-Null
    & $nuget restore $RMADSrcRoot\Src\RecoveryManager.AD.sln
}

$SyncLibs = -not (Test-Path $RMADSrcRoot\Src\Boost)


if($SyncLibs){
    Write-host "Restoring Boost libs and sources"
    $zip
    switch ($CodeBase){
        "8-1" { 
            $zip = "BoostAndLib810.zip"
            $buildProps = "/p:Culture=en-US" 
            break 
        }
        "8-2" { 
            $zip = "BoostAndLib821.zip"
            $buildProps = "/p:Culture=en-US" 
            break 
        }
        "8-5" { 
            $zip = "BoostAndLib852.zip"
            $buildProps = "/p:Multilang=false", "/p:Cultures=en-US"
            Install-S3Zip -BucketName 'RMAD' -ZipName 'Builder/RMADHelp.8.5.zip' -TargetPath $RMADSrcRoot
            break 
        }
        "8-6" { 
            $zip = "BoostAndLib.zip"
            $buildProps = " /p:Multilang=true"
            Install-S3Zip -BucketName 'RMAD' -ZipName 'Builder/RMADHelp.8.6.zip' -TargetPath $RMADSrcRoot 
            break 
        }
        default { throw "No CodeBase selected" }
    }

    if( Test-Path Z:\BoostAndLib.zip ) { rm Z:\BoostAndLib.zip }
    Read-S3Object -BucketName RMAD -Key Builder/Boost/$zip -File Z:\BoostAndLib.zip | Out-Null
    $outdir = "-o" + $RMADSrcRoot
    7z x Z:\BoostAndLib.zip $outdir -aoa
    rm Z:\BoostAndLib.zip
}

Write-Host "Downloading signing certificate"
$signingDirectory = "$RMADSrcRoot\Signing"
Read-S3Object -BucketName 'RMAD' -KeyPrefix 'Builder/SigningCert/' -Folder $signingDirectory | Out-Null
Install-S3Zip -BucketName 'RMAD' -ZipName 'Builder/RMADHelp.8.6.zip' -TargetPath $RMADSrcRoot