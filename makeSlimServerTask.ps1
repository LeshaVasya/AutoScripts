#Pun PS in non Ui session for windows core type
if (Test-Path "$env:windir\explorer.exe"){ 
    $PowerSlimCmd="C:\Tools\PsExec.exe -d -u RMAD\administrator -p ~123qwerty -i 1 -h -accepteula C:\PowerSlim\runSlimServer.cmd"
}
else{
    $PowerSlimCmd="C:\PowerSlim\runSlimServer.cmd"
}

schtasks /Create /TN PowerSlim /SC ONSTART /TR $PowerSlimCmd /RL HIGHEST /F /RU rmad\administrator /RP ~123qwerty
schtasks /End /TN PowerSlim
schtasks /Run /TN PowerSlim