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


lv-RecycledObjectsRestore

param(
    $Owner = 'Avasilie',
    $Branch="lv-RecycledObjectsRestore",
    $GitUserName = 'leshavasya',
    $GitUserMail = 'leshavasya@gmail.com',
    $SpotPrice = '0.22',
    $InstanceType = 'c3.large',
    $Region = 'us-east-1',
    $AvailabilityZone = '',
    $AmiName = 'Avas-Builder',
    [ValidateSet('Resharper', 'VA')]
    [Array]
    $Install =  @('Resharper', 'VA'),
    $PreBuildBranch = 'Do not build',
    $CustomScript
)