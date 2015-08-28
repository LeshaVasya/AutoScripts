param(
    $RMADSrcRoot
)

if(-not $RMADSrcRoot){
   $RMADSrcRoot = Split-Path $MyInvocation.MyCommand.Path
   Write-host "RMAD\FE source directory not specified by user. Default is: $RMADSrcRoot"
}

$Configuration = 'Release'
$Sign = $true
$solutionPath = Join-Path $RMADSrcRoot "\Src\RecoveryManager.AD.sln"
$MSBuild = "$env:SystemDrive\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
$MsBuildArgs="/clp:PerformanceSummary;Summary;ShowTimestamp /verbosity:detailed /m"

$buildLogPath = "$RMADSrcRoot\BuildLogs"
if(-not ( Test-Path $buildLogPath)){
    New-Item -ItemType directory -Path $buildLogPath
}

$setupSolutionPath = Join-Path $RMADSrcRoot "\Src\RecoveryManager.AD.Setup.sln"
$buildProps = "/p:Multilang=true"
$signingDirectory = "$RMADSrcRoot\Signing"

#Coping Common targets file
Copy-Item -Path "$RMADSrcRoot\Microsoft.Common.targets" -Destination "$env:SystemDrive\Windows\Microsoft.NET\Framework\v4.0.30319" -Force

write-host "Building x86 Solution. Build log file: $buildLogPath\x86compile.log"
cmd /c $msbuild $solutionPath /p:Win32FirstPassCompile=1 /p:Platform=Win32 /p:Configuration=$Configuration  /p:OutDir=$RMADSrcRoot\Build\Win32\$Configuration\ /p:RunCodeAnalysis=False $MsBuildArgs > "$buildLogPath\x86compile.log"

write-host "Building x64 Solution. Build log file: $buildLogPath\x64compile.log"
cmd /c $msbuild $solutionPath /p:Platform=x64 /p:Configuration=$Configuration  /p:OutDir=$RMADSrcRoot\Build\x64\$Configuration\ /p:RunCodeAnalysis=False $MsBuildArgs > "$buildLogPath\x64compile.log"

#Copyng Bootstrapper packages
#Copy-Item -Path "$RMADSrcRoot\Bootstrapper\*" -Destination "$env:SystemDrive\Program Files (x86)\Microsoft SDKs\Windows\v8.0A\Bootstrapper\Packages" -Recurse -Force

#Copying Unity files
Copy-Item -Path "$RMADSrcRoot\Bin\Microsoft.Practices.Unity.Configuration.dll" -Destination "$RMADSrcRoot\Build\Win32\Release" -Force
Copy-Item -Path "$RMADSrcRoot\Bin\Microsoft.Practices.Unity.dll" -Destination "$RMADSrcRoot\Build\Win32\Release" -Force
Copy-Item -Path "$RMADSrcRoot\Bin\Microsoft.Practices.ObjectBuilder2.dll" -Destination "$RMADSrcRoot\Build\Win32\Release" -Force

write-host "Building x86 Setups. Build log file: $buildLogPath\x86setup.log"
cmd /c $msbuild $setupSolutionPath /p:Configuration=Setup /p:Platform=Win32 /p:SignFiles=$Sign /p:SigningDirectory=$signingDirectory /p:OutDir=$RMADSrcRoot\\Build\Win32\Setup\ /p:EnableBootstrapper=false $buildProps $MsBuildArgs > "$buildLogPath\x86setup.log"

write-host "Building x64 Setups. Build log file: $buildLogPath\x64setup.log"
cmd /c $msbuild $setupSolutionPath /p:Configuration=Setup /p:Platform=x64 /p:SignFiles=$Sign /p:SigningDirectory=$signingDirectory /p:OutDir=$RMADSrcRoot\\Build\x64\Setup\ $buildProps $MsBuildArgs > "$buildLogPath\x64setup.log"

Write-host "RMAD setups are located in $RMADSrcRoot\Build\Setup\RMAD\CD\Setup. "
Write-Host "RMADFE setups are located in $RMADSrcRoot\Build\Setup\RMADFE\CD\Setup."