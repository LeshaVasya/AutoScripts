$computers = Get-Content -path C:\fso\computers.txt
$user = "aUser"
$password = "MyNewPassword!"
Foreach($computer in $computers)
{
 $user = [adsi]"WinNT://$computer/$user,user"
 $user.SetPassword($Password)
 $user.SetInfo()
}


#create user

$cn = [ADSI]"WinNT://edlt"

$user = $cn.Create("User","vasyamfx")

$user.SetPassword("paradise")

$user.setinfo()

$user.description = "Alexey Vasiliev"

$user.SetInfo()

#add user to the group
# Get the servers from a file named listOfServers.txt, skip lines 
# either commented with a # or blank.
$serverList = Get-Content -Path C:\temp\listOfServers.txt | where {($_ -notlike "*#*") -and ($_ -notmatch "^\s*$")}  
# Cycle throught the servers adding the user to the Administrators group.
foreach ($server in $serverList) {
   $computer = [ADSI]("WinNT://" + $server + ",computer")  
   $group = $computer.psbase.children.find("Administrators") 
   $group.Add("WinNT://yourDomainName/" + $user)
}