if([string]::IsNullOrEmpty($env:NetworkMode)) {
    $config = [string](get-content ([System.IO.Path]::Combine($env:Scripts, "AWS", $env:ConfigurationFile)))
    $configJson = $config | ConvertFrom-Json
    $env:NetworkMode = $configJson.NetworkModeSpecificSettings.Default
    if([string]::IsNullOrEmpty($env:NetworkMode)) {
        if(IsVpcInstance(Get-InstanceId)) {
            $env:NetworkMode = 'VPC'
        } else {
            $env:NetworkMode = 'EC2Classic'
        }
    }
}