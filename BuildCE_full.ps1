param(
    $RMADSrcRoot = 'Z:\RMAD'
)

$Configuration = 'Release'
$Sign = $true
$solutionPath = Join-Path $RMADSrcRoot "\Src\RecoveryManager.AD.sln"
$MSBuild = "$env:SystemDrive\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
$MsBuildArgs="/clp:PerformanceSummary;Summary;ShowTimestamp /verbosity:detailed /m"


#Coping Common targets file
Copy-Item -Path "$RMADSrcRoot\Microsoft.Common.targets" -Destination "$env:SystemDrive\Windows\Microsoft.NET\Framework\v4.0.30319" -Force

Set-Location -Path $RMADSrcRoot

$x86ArgumentSet = @($solutionPath, "/p:Win32FirstPassCompile=1","/p:Configuration=$Configuration", "/p:Platform=Win32",  "/p:OutDir=$RMADSrcRoot\Build\Win32\$Configuration\", "/p:RunCodeAnalysis=False", "/verbosity:detailed", "/m", "/clp:PerformanceSummary;Summary;ShowTimestamp")
$x64ArgumentSet = @($solutionPath, "/p:Configuration=$Configuration", "/p:Platform=x64",  "/p:OutDir=$RMADSrcRoot\Build\x64\$Configuration\", "/p:RunCodeAnalysis=False", "/verbosity:detailed", "/m", "/clp:PerformanceSummary;Summary;ShowTimestamp")

write-host "Building x86 Solution"
#& $MSBuild $x86ArgumentSet > C:\compilex86.log
cmd /c $msbuild $solutionPath /p:Win32FirstPassCompile=1 /p:Platform=Win32 /p:Configuration=$Configuration  /p:OutDir=$RMADSrcRoot\Build\Win32\$Configuration\ /p:RunCodeAnalysis=False $MsBuildArgs > C:\compilex86.log

write-host "Building x64 Solution"
#& $MSBuild $x64ArgumentSet > C:\compilex64.log
cmd /c $msbuild $solutionPath /p:Platform=x64 /p:Configuration=$Configuration  /p:OutDir=$RMADSrcRoot\Build\x64\$Configuration\ /p:RunCodeAnalysis=False $MsBuildArgs > C:\compilex64.log

$setupSolutionPath = Join-Path $RMADSrcRoot "\Src\RecoveryManager.AD.Setup.sln"
$buildProps = "/p:Multilang=true"
$signingDirectory = "$RMADSrcRoot\Signing"

$x86SetupOptions = @($setupSolutionPath, "/p:Configuration=Setup", "/p:Platform=Win32", "/p:SignFiles=$Sign", "/p:SigningDirectory=$signingDirectory", "/p:OutDir=$RMADSrcRoot\Build\Win32\Setup\", "$buildProps", "/verbosity:detailed", "/m", "/clp:PerformanceSummary;Summary;ShowTimestamp")

$x64SetupOptions = @($setupSolutionPath, "/p:Configuration=Setup", "/p:Platform=x64", "/p:SignFiles=$Sign", "/p:SigningDirectory=$signingDirectory", "/p:OutDir=$RMADSrcRoot\Build\x64\Setup\", "$buildProps", "/verbosity:detailed", "/m", "/clp:PerformanceSummary;Summary;ShowTimestamp")

#Copyng Bootstrapper packages
Copy-Item -Path "$RMADSrcRoot\Bootstrapper\*" -Destination "$env:SystemDrive\Program Files (x86)\Microsoft SDKs\Windows\v8.0A\Bootstrapper\Packages" -Recurse -Force

#Copying Unity files
Copy-Item -Path "$RMADSrcRoot\Bin\Microsoft.Practices.Unity.Configuration.dll" -Destination "$RMADSrcRoot\Build\Win32\Release" -Force
Copy-Item -Path "$RMADSrcRoot\Bin\Microsoft.Practices.Unity.dll" -Destination "$RMADSrcRoot\Build\Win32\Release" -Force
Copy-Item -Path "$RMADSrcRoot\Bin\Microsoft.Practices.ObjectBuilder2.dll" -Destination "$RMADSrcRoot\Build\Win32\Release" -Force


write-host "Building x86 Setups"
#& $msbuild $x86SetupOptions > c:\x86setup.log

cmd /c $msbuild $setupSolutionPath /p:Configuration=Setup /p:Platform=Win32 /p:SignFiles=$Sign /p:SigningDirectory=$signingDirectory /p:OutDir=$RMADSrcRoot\\Build\Win32\Setup\ $buildProps $MsBuildArgs > c:\x86setup.log

write-host "Building x64 Setups"
#& $msbuild $x64SetupOptions > C:\x64setup.log

cmd /c $msbuild $setupSolutionPath /p:Configuration=Setup /p:Platform=x64 /p:SignFiles=$Sign /p:SigningDirectory=$signingDirectory /p:OutDir=$RMADSrcRoot\\Build\x64\Setup\ $buildProps $MsBuildArgs > C:\x64setup.log

Write-host "RMAD setups are located in $RMADSrcRoot\Build\Setup\RMAD\CD\Setup. "
Write-Host "RMADFE setups are located in $RMADSrcRoot\Build\Setup\RMADFE\CD\Setup."