#Raise forest functional level to at least 2008 R2
Import-module ActiveDirectory
Set-ADForestMode –Identity domainName.ext -ForestMode Windows2008R2Forest

Set-AdDomainMode -identity rmad.local -server dc1.rmad.local -domainmode Windows2008R2Domain 
Set-AdForestMode -identity rmad.local -server dc1.rmad.local -forestmode Windows2008R2Forest 

Enable-ADOptionalFeature "Recycle Bin Feature" -server ((Get-ADForest -Current LocalComputer).DomainNamingMaster) -Scope ForestOrConfigurationSet -Target (Get-ADForest -Current LocalComputer)



#Enable AD recycle Bin
#http://blogs.technet.com/b/askds/archive/2009/08/27/the-ad-recycle-bin-understanding-implementing-best-practices-and-troubleshooting.aspx
Enable-ADOptionalFeature –Identity ‘CN=Recycle Bin Feature,CN=Optional Features,CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration, DC=domainName,DC=ext’ –Scope ForestOrConfigurationSet –Target ‘domainName.ext’

Enable-ADOptionalFeature "Recycle Bin Feature" -server ((Get-ADForest -Current LocalComputer).DomainNamingMaster) -Scope ForestOrConfigurationSet -Target (Get-ADForest -Current LocalComputer)

#Set deleted objects lifetime
Set-ADObject -Identity "CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration,DC=<your forest root domain>" -Partition "CN=Configuration,DC=<your forest root domain>" -Replace:@{"msDS-DeletedObjectLifetime" = <value in days>}

#Get AD deleted objects
Get-ADObject -filter 'isdeleted -eq $true -and name -ne "Deleted Objects"' -includeDeletedObjects -property *
Get-ADObject -filter 'isdeleted -eq $true -and name -ne "Deleted Objects"' -includeDeletedObjects -property * | Format-List samAccountName,displayName,lastknownParent
Get-ADObject -filter 'isdeleted -eq $true -and name -ne "Deleted Objects"' -includeDeletedObjects -property * | Format-Table msds-lastKnownRdn,lastknownParent -auto -wrap
$changedate = New-Object Datetime(2009, 8, 22, 1, 40, 00) #1:40:00 AM, August 22, 2009
Get-ADObject -filter 'whenChanged -gt $changedate -and isDeleted -eq $true' -includeDeletedObjects -property * | Format-Table samaccountname,lastknownparent -auto -wrap

#Restore AD object
Get-ADObject -Filter 'samaccountname -eq "SaraDavis"' -IncludeDeletedObjects | Restore-ADObject
Get-ADObject -filter 'lastKnownParent -eq "OU=Sales,DC=Contoso,DC=com"' -includeDeletedObjects | restore-adobject
