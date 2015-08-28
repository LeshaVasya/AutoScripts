#http://blogs.technet.com/b/heyscriptingguy/archive/2012/12/18/use-powershell-to-find-non-starting-automatic-services.aspx


#get-service -Name Jenkins |Stop-Service
get-service -Name Jenkins
Stop-Service -Name Jenkins -Force
Start-Service -Name Jenkins
Get-Service -Name Jenkins
Set-service -Name Jenkins -StartupType Automatic
Get-WmiObject win32_service -Filter "name = 'Jenkins' AND state = 'running'" | Select-Object -ExpandProperty exitcode

#Get-CimInstance win32_service | Sort state | select name, state, exitcode
#Get-CimInstance win32_service -Filter "startmode = 'auto' AND state = 'running'" | select name, startname, exitcode
