

    $userData = @"
<powershell>

    $DnsIp="10.33.134.237"
    
    $NICs =  Get-WMIObject Win32_NetworkAdapterConfiguration |? {$_.IPEnabled -eq 'TRUE'}
    $NICs | %{ 
        $_.SetDNSServerSearchOrder($DnsIp)
        $_.SetDynamicDNSRegistration('TRUE')
    }|out-null

    Write-Host "Flushdns on DC2"
    ipconfig /flushdns
    
    Write-Host "Registerdns  on DC2"
    ipconfig /registerdns

</powershell>
<persist>false</persist>
"@