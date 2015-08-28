$psexec = "C:\tools\PsExec.exe"
$username = "administrator"
$results = invoke-expression "$psexec \\localhost -s query session"
$id = $results | Select-String "$username\s+(\w+)" |Foreach {$_.Matches[0].Groups[1].Value}
$id