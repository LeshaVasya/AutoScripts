param(
    $Owner = 'Avasilie',
    $Branch="scripts",
    $GitUserName = 'leshavasya',
    $GitUserMail = 'leshavasya@gmail.com',
    $SpotPrice = '0.22',
    $InstanceType = 'c3.large',
    $Region = 'us-east-1',
    $AvailabilityZone = 'us-east-1e',
    $AmiName = 'rmad-builder',
    [ValidateSet('Resharper', 'VA')]
    [Array]
    $Install,
    $PreBuildBranch = 'Do not build',
    $CustomScript
)
