#On the remote Powershell console, enable remote desktop and firewall using the following cmdlets:
# Enable Remote Desktop
set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0

# Allow incoming RDP on firewall
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Enable secure RDP authentication
set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1   

#disable firewall
netsh advfirewall set allprofiles state off
 netsh advfirewall set allprofiles state on

#Get installed programs list
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |Select-Object DisplayName, DisplayVersion, Publisher, InstallDate, HelpLink, UninstallString
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |Select-Object DisplayName, DisplayVersion, Publisher, InstallDate, HelpLink, UninstallString

#Create new user
$cn = [ADSI]"WinNT://edlt"
$user = $cn.Create("User","root")
$user.SetPassword("1221")
$user.setinfo()
$user.description = "Another local admin"
$user.SetInfo()

#One more attempt
$computername = $env:computername   # place computername here for remote access
$username = 'root'
$password = '~123qwerty'
$desc = 'Another local admin'


$computer = [ADSI]"WinNT://$computername,computer"
$user = $computer.Create("user", $username)
$user.SetPassword($password)
$user.Setinfo()
$user.description = $desc
$user.setinfo()
$user.UserFlags = 65536
$user.SetInfo()
$group = [ADSI]("WinNT://$computername/administrators,group")
$group.add("WinNT://$username,user")
$group = [ADSI]("WinNT://$computername/Remote desktop users,group")
$group.add("WinNT://$username,user")


#reset admin pwd
$newpwd = ConvertTo-SecureString -String "~123qwerty" -AsPlainText –Force

$computerName = $env:computername
$adminPassword = "~123qwerty"
$adminUser = [ADSI] "WinNT://$computerName/Administrator,User"
$adminUser.SetPassword($adminPassword)

Set-ADAccountPassword jfrost -NewPassword $newpwd –Reset


#Step 1
Rename-Computer -NewName DC1
Restart-Computer -Force 

#Step 2
Get-NetIpaddress #To get InterfaceIndex
New-NetIPAddress –InterfaceIndex 12 –IPAddress 192.168.2.3 -PrefixLength 24
Set-DNSClientServerAddress –InterfaceIndex 12 -ServerAddresses 10.30.40.89

#Step 3
Add-Computer -DomainName iclone.local -Credential (Get-Credential)
Restart-Computer -Force

#Step 4
Install-WindowsFeature -Name AD-Domain-Services

#2008R2
dism /online /enable-feature /featurename:NetFx2-ServerCore
dism /online /enable-feature /featurename:NetFx3-ServerCore
dism /online /enable-feature /featurename:DirectoryServices-DomainController-ServerFoundation
dism /online /enable-feature /featurename:MicrosoftWindowsPowerShell 
dism /online /enable-feature /featurename:ActiveDirectory-PowerShell

#dcpromo 2008R2
[DCInstall]
NewDomain=forest
NewDomainDNSName=rmad.local
ReplicaorNewDomain=domain
InstallDNS=Yes
ConfirmGC=Yes
DatabasePath=C:\Windows\NTDS
LogPath=C:\Windows\NTDS
SYSVOLPath=C:\Windows\SYSVOL
SafeModeAdminPassword=~123qwerty
RebootonSuccess=Yes

dcpromo.exe /unattend:C:\users\administrator\dcpromo.txt 

#Step 4.5 Install new forest
$Password = ConvertTo-SecureString -AsPlainText -String ~123qwerty -Force
Install-ADDSForest -DomainName rmad.local -SafeModeAdministratorPassword $Password `
-DomainNetbiosName rmad -DomainMode Win2012R2 -ForestMode Win2012R2 -DatabasePath "%SYSTEMROOT%\NTDS" `
-LogPath "%SYSTEMROOT%\NTDS" -SysvolPath "%SYSTEMROOT%\SYSVOL" -NoRebootOnCompletion -InstallDns -Force


#Step 5 Install new dc
$Password = ConvertTo-SecureString -AsPlainText -String ~123qwerty -Force
Install-ADDSDomainController -DomainName iclone.local -DatabasePath "%SYSTEMROOT%\NTDS" `
-LogPath "%SYSTEMROOT%\NTDS" -SysvolPath "%SYSTEMROOT%\SYSVOL" -InstallDns `
-ReplicationSourceDC 2012r2dc.iclone.local -SafeModeAdministratorPassword $Password `
-NoRebootOnCompletion

#Step 5 Install additional rodc
$Password = ConvertTo-SecureString -AsPlainText -String ~123qwerty -Force
Install-ADDSDomainController -DomainName rmad.local -DatabasePath "%SYSTEMROOT%\NTDS" `
-LogPath "%SYSTEMROOT%\NTDS" -SysvolPath "%SYSTEMROOT%\SYSVOL" -Readonlyreplica `
-ReplicationSourceDC DC1.rmad.local -Sitename "RW" -SafeModeAdministratorPassword $Password `
-NoRebootOnCompletion -Credential (Get-Credential)

#Step 6
Restart-Computer -Force

#Get all the Domain Controllers
Get-ADGroupMember "Domain Controllers"