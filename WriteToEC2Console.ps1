#http://blog.brianbeach.com/2014/07/writing-to-ec2-console.html

Stop-Service Ec2Config
$Port = New-Object System.IO.Ports.SerialPort
$Port.PortName = "COM1"
$Port.BaudRate = 0x1c200
$Port.Parity = [System.IO.Ports.Parity]::None
$Port.DataBits = 8
$Port.StopBits = [System.IO.Ports.StopBits]::One
$Port.Open()
$Port.WriteLine("This was written directly to the serial port");
$Port.Close()


#Stop the EC2 Config Service
Stop-Service Ec2Config
#Ensure the log file exists or you will get an error
New-Item -ItemType File -Force -Path 'C:\Windows\system32\WindowsPowerShell\v1.0\Logs\Ec2ConfigLog.txt'
#Load the Ec2Config Library
[System.Reflection.Assembly]::LoadFrom("C:\Program Files\Amazon\Ec2ConfigService\Ec2ConfigLibrary.dll")
#Write to the Console
[ConsoleLibrary.ConsoleLibrary]::Instance().WriteToConsole("This was written using the Ec2ConfigLibrary", $true)

function Write-InstanceSystemLog{
    param(
        $string
    )
    Stop-Service Ec2Config
    New-Item -ItemType File -Force -Path 'C:\Windows\system32\WindowsPowerShell\v1.0\Logs\Ec2ConfigLog.txt'
    [System.Reflection.Assembly]::LoadFrom('C:\Program Files\Amazon\Ec2ConfigService\Ec2ConfigLibrary.dll')
    [ConsoleLibrary.ConsoleLibrary]::Instance().WriteToConsole($string, $true)
}