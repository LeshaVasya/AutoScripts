
function Save-AWSCredentials {
  param (
    [string]$AccessKey,
    [string]$SecretKey,
    [string]$CredentialsName,
    [string]$Region
  )
  if(-not $Region){$Region = Get-InstanceRegion}
  Set-AWSCredentials -AccessKey $AccessKey -SecretKey $SecretKey -StoreAs $CredentialsName
  Initialize-AWSDefaults -StoredCredentials $CredentialsName -Region $Region
}

function Get-InstanceRegion
{
  $currentRegion = Get-DefaultAWSRegion
  if ($currentRegion -eq $null){
    try{
      $region = Invoke-RestMethod 'http://169.254.169.254/latest/meta-data/placement/availability-zone' -TimeoutSec 5
      $region = $region -replace '.$'
    }
    catch{
      Write-error 'Get-InstanceRegion: Your machine is not AWS machine'
      $region = $null
    }
  }
  else{
    $region = $currentRegion
  }
  $region
}

Save-AWSCredentials -AccessKey AKIAJFHXZAGPMFZ6TPOA -SecretKey UEh38ZSDARC+MMIsNTQ18u3lkSBJILCFDNWYrv4F -CredentialsName LV -Region "us-east-1"
Read-S3Object -BucketName "RMAD" -Key "Avasilie/Enable_MSI_Logging.reg" -File "C:\distr\Enable_MSI_Logging.reg"
Read-S3Object -BucketName "RMAD" -Key "/Licenses/RMADFE-8.x-ongoing.asc" -File "C:\distr\RMADFE-8.x-ongoing.asc"
Read-S3Object -BucketName "RMAD" -Key "Avasilie/RMADFE863.zip" -File "C:\distr\RMADFE863.zip"