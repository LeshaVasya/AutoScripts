function Global:Start-AgentOperation ($params, $dc = 'dc1.rmad.local')
{
    $op = New-Object -TypeName QuestSoftware.RecoveryManager.AD.Agents.AgentManagement.AgentOperation -ArgumentList @($dc, $cred, $cred, $params)
    $op.Start() | Out-Null
    return $op
} 

$instalPath =   'C:\Program Files\Dell\Recovery Manager for Active Directory Forest Edition'
    [System.Environment]::CurrentDirectory = $instalPath
    [System.Reflection.Assembly]::LoadFrom("$instalPath\QuestSoftware.RecoveryManager.AD.Agents.dll") | Out-Null
    [System.Reflection.Assembly]::LoadFrom("$instalPath\ForestRecovery.BusinessLogic.dll") | Out-Null
    $agentFactory = New-Object -TypeName QuestSoftware.RecoveryManager.AD.Agents.AgentFactory -ErrorAction Stop
    
    #$cred = $adminCredentials.GetNetworkCredential()
    $cred = New-Object System.Management.Automation.PSCredential($("RMAD\administrator" -split '\\' | select -Last 1), (ConvertTo-SecureString "~123qwerty" -asPlainText -Force) )
    #$dc1ad = New-Object -TypeName QuestSoftware.RecoveryManager.AD.Agents.AgentAccessData -ArgumentList @('dc1.rmad.local', $cred, $cred)
    $dc1ad = New-Object -TypeName QuestSoftware.RecoveryManager.AD.Agents.AgentAccessData -ArgumentList @('chillddc1.second.rmad.local', $cred, $cred)
    $agentFactory.EnsureAgentIsWorking($dc1ad, $true)
    
    #for AgentOperation class
    [System.Reflection.Assembly]::LoadFrom("$instalPath\QuestSoftware.RecoveryManager.AD.Agents.dll") | Out-Null
    [System.Reflection.Assembly]::LoadFrom("$instalPath\ForestRecovery.RecoveryLogic.dll") | Out-Null


    $dcs = [string[]]@('dc1.rmad.local')

    $guids = [system.guid[]] @([system.guid]::NewGuid())

    $domains =[string[]] @('dc=rmad,dc=local')

    $params = New-Object -TypeName QuestSoftware.RecoveryManager.AD.ForestRecovery.Agent.Operations.AdjustAdParams -ArgumentList @($dcs, $guids, $domains)

    $agentOp = Start-AgentOperation $params 'chillddc1.second.rmad.local'
    $agentOp.Status