#one option
$fileXmlContent = [xml](Get-Content 'C:\Program Files\Amazon\Ec2ConfigService\Settings\config.xml')
$neededNode = $fileXmlContent.SelectNodes("//Plugin") | ?{$_.Name -eq 'Ec2HandleUserData'}
$neededNode.State = 'Enabled'
$fileXmlContent.Save('C:\Program Files\Amazon\Ec2ConfigService\Settings\config.xml')

#Another variant
$EC2SettingsFile="C:\Program Files\Amazon\Ec2ConfigService\Settings\Config.xml"
$xml = [xml](get-content $EC2SettingsFile)
$xmlElement = $xml.get_DocumentElement()
$xmlElementToModify = $xmlElement.Plugins

foreach ($element in $xmlElementToModify.Plugin)
{
    if ($element.name -eq "Ec2SetPassword")
    {
        $element.State="Enabled"
    }
    elseif ($element.name -eq "Ec2HandleUserData")
    {
        $element.State="Enabled"
    }
}
$xml.Save($EC2SettingsFile)


#Option 3 from EC2Config 2.1.10
<powershell>
    insert script here
</powershell>
<persist>true</persist>


Function Enable-UserDataRun{
    param(
        $MachineAddress,
        $MachineCredentials,
        $EC2ConfigFile = 'C:\Program Files\Amazon\Ec2ConfigService\Settings\config.xml',
        $UserDataCompleteFile = 'C:\UserDataCompleted.tmp'         
    )
    Write-host "Enabling User Data script run on next instance start for $MachineAddress"
    Invoke-Command -ComputerName $MachineAddress -Credential $MachineCredentials -ScriptBlock{
        param(
            $configFile,
            $completeFile
        )
        #Enable UserData
        $fileXmlContent = [xml](Get-Content $configFile)
        $neededNode = $fileXmlContent.SelectNodes("//Plugin") | ?{$_.Name -eq 'Ec2HandleUserData'}
        $neededNode.State = 'Enabled'
        $fileXmlContent.Save($configFile)

        #Remove UserData complete file if Userdata is  running
        If (Test-path -Path $completeFile){Remove-Item -Path $completeFile -Force}
    }-ArgumentList $EC2ConfigFile, $UserDataCompleteFile | Out-Null
}