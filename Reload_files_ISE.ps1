function Build {
    #Reload file
    $CurrentFile = $psise.CurrentFile
    $FilePath = $CurrentFile.FullPath
    $PsISE.CurrentPowerShellTab.Files.remove($CurrentFile)
    $PsISE.CurrentPowerShellTab.Files.add($FilePath)

    Invoke-Expression $PsISE.CurrentPowerShellTab.Files.Editor.Text
}

$psISE.CurrentPowerShellTab.AddOnsMenu.SubMenus.Clear()
$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Reload file and run",{Build},'f4')