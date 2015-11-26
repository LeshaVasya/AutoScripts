#https://technet.microsoft.com/en-us/library/ff730967.aspx
$objOU = New-Object System.DirectoryServices.DirectoryEntry("LDAP://OU=Rmad,dc=iclone,dc=local")
$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$strFilter = "(&(objectCategory=User)(!(description=*)))"
$objSearcher.SearchRoot = $objOU
$objSearcher.PageSize = 1000
$objSearcher.Filter = $strFilter
$objSearcher.SearchScope = "Subtree" #Onelevel, Base
$objSearcher.FindAll()