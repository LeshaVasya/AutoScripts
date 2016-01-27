
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
    If ($name)      {$rules= $rules | where-object {$_.name     –like $name}}
    If ($direction) {$rules= $rules | where-object {$_.direction  –eq $direction}}
    If ($Enabled)   {$rules= $rules | where-object {$_.Enabled    –eq $Enabled}}
    If ($protocol)  {$rules= $rules | where-object {$_.protocol  -eq  $protocol}}
    If ($Profile)   {$rules= $rules | where-object {$_.Profiles -bAND $Profile}}
    If ($Action)    {$rules= $rules | where-object {$_.Action     -eq $Action}}
    If ($Grouping)  {$rules= $rules | where-object {$_.Grouping -Like $Grouping}}
    $rules
}

Get-firewallRule -enabled $true | sort direction,applicationName,name |
format-table -wrap -autosize -property Name, @{Label=”Action”; expression={$Fwaction[$_.action]}},
@{label="Direction";expression={ $fwdirection[$_.direction]}},
@{Label=”Protocol”; expression={$FwProtocols[$_.protocol]}} , localPorts,applicationname


$rule = Get-FireWallRule
$rule|get-member
$rule[0]|Get-Member