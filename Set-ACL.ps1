$folder="path"
$acl = get-acl $folder
$acl.access

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("everyone","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.setAccessRule($rule)
$acl | Set-Acl $folder

(get-acl $folder).access 