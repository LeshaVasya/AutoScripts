#get ami from description 'ami-[^ ]+'
Import-Module C:\WorkSrc\Scripts\AWS\AWSHelper.psm1 -force
$tags = @{'team' = 'rmad'}
$tagsFilter = Convert-TagsToTagsFilter -Tags $tags
$Region = 'us-east-1'
$rmadSnapshotIdList = Get-EC2Snapshot -Filter $tagsFilter -Region $Region -OwnerId self|?{$_.State -eq 'completed'}|Select-Object -ExpandProperty SnapshotId
Write-host "Snapshots with tag team = rmad: $($rmadSnapshotIdList.count)"
$rmadAmis = Get-Ami -Tags $tags #BlockDeviceMappings.ebs.SnapshotId 
Write-host "Amis with tag team = rmad:  $($rmadAmis.count)"
$rmadAmiSnapList = New-Object -TypeName System.Collections.ArrayList
$rmadAmis|%{
    $ebsDisks = $_.BlockDeviceMappings
    $ebsDisks|%{
        $snapId = $_.Ebs.SnapshotId
        if ($snapId){
           $rmadAmiSnapList.Add($snapId)|out-null 
        }       
    }
}
Write-host "Snapshots assotiated with Rmad Amis: $($rmadAmiSnapList.Count)"
$snapshotToRemoveList = New-Object -TypeName System.Collections.ArrayList
$rmadSnapshotIdList|%{
    if ($rmadAmiSnapList -notcontains $_){
        $snapshotToRemoveList.add($_)|out-null
    }
}
Write-host "RMAD Snapshots to be deleted: $($snapshotToRemoveList.Count)"
$rmadAmiSnapWithoutTagsList = New-Object -TypeName System.Collections.ArrayList
$rmadAmiSnapList|%{
    $snap = Get-EC2Snapshot -SnapshotId $_ -Region $Region
    $snaptags = $snap.Tags
    if (-not (Get-TagValue -Tags $snaptags -Key "team")){
        $rmadAmiSnapWithoutTagsList.Add($_)|out-null
    }
}
Write-host "Rmad snapshots without tags: $($rmadAmiSnapWithoutTagsList.Count)"
