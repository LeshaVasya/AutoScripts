
Function Get-FireWallRule {
    Param(
        $Name,
        $Direction, 
        $Enabled, 
        $Protocol, 
        $Profile, 
        $Action, 
        $Grouping
    )
    $rules=(New-object –comObject HNetCfg.FwPolicy2).rules
    If ($Name)      {$rules= $rules | where-object {$_.name     –like "*$Name*"}}
    If ($Direction) {$rules= $rules | where-object {$_.direction  –eq $Direction}}
    If ($Enabled)   {$rules= $rules | where-object {$_.enabled    –eq $Enabled}}
    If ($Protocol)  {$rules= $rules | where-object {$_.protocol  -eq  $Protocol}}
    If ($Profile)   {$rules= $rules | where-object {$_.profiles -bAND $Profile}}
    If ($Action)    {$rules= $rules | where-object {$_.action     -eq $Action}}
    If ($Grouping)  {$rules= $rules | where-object {$_.grouping -like $Grouping}}
    $rules
}

