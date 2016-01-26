    $suiteStartTime = '16:47:46'
    function global:Get-Events {
        param(
        $logName,
        $entryTypes
        )
        $after = [DateTime]::ParseExact($suiteStartTime, "H:mm:ss", $null);
        
        # Determine cmdlet used to extract event-log entries:
        #  - get-winevent can be run only on 2008 and later
        #  - get-eventlog is not returning messages on 2012 and 2012r2 lab; it looses message texts of some system events

        $versionOS = [environment]::OSVersion.Version
        if($versionOS -ge (new-object 'Version' 6,0)) {  
            # convert entry type to condition
            $conditionOnEntryTypesArray = $entryTypes | % {
                $converter = @{
                    'Information' = '(Keywords = 36028797018963968) and ((Level = 0) or (Level = 4))';
                    'Success' =  '(Keywords = 36028797018963968) and (Level = 4)';
                    'Error' = '(Keywords = 36028797018963968) and (Level = 2)';
                    'Warning' = '(Keywords = 36028797018963968) and (Level = 3)';
                    'SuccessAudit' = '(Keywords = -9214364837600034816) and (Level = 0)';
                    'FailureAudit' = '(Keywords = -9218868437227405312) and (Level = 0)'
                };
                $converter[$_];
            }
            $conditionOnEntryTypes = "({0})" -f ($conditionOnentryTypesArray -join ") or (");
            $condition = ("*[System[({0}) and TimeCreated[@SystemTime>='{1}']]]" -f ($conditionOnEntryTypes, ($after.ToUniversalTime().ToString("O"))));

            # extract events
            try {
                Write-Host "Querying '$LogName' by '$condition'"
                Get-WinEvent -LogName $LogName -FilterXPath $condition -ea Stop | % {
                    $eventLevelDisplayName = $_.LevelDisplayName;
                    $eventKeywordsDisplayNames = $_.KeywordsDisplayNames
                    $eventKeywordsDisplayName = (@($eventKeywordsDisplayNames) | select -f 1)
                    $eventEntryType = switch($eventKeywordsDisplayName) {
                        "Classic" { $eventLevelDisplayName; }
                        "Audit Success" { "SuccessAudit"; }
                        "Audit Failure" { "FailureAudit"; }
                        default { $null; }
                    }
                    $eventReplacementStrings = @($_.Properties) | % { $_.Value };
				
                    $result = @{
                        "_Raw" = $_;
                        "Id" = $_.Id; 
                        "LogName" = $LogName;
                        "EntryType" = $eventEntryType;
                        "Category" = $_.TaskDisplayName;
                        "Source" = $_.ProviderName;
                        "Message" = $_.Message;
                        "Strings" = $eventReplacementStrings;
                        "TimeGenerated" = $_.TimeCreated.ToLocalTime();
                        "UserName" = "";
                    }
                    if ($_.UserId) {
                        $result.UserName = $_.UserId.Translate( [System.Security.Principal.NTAccount] ).Value
                    }

                    $result
                }
            } catch [Exception] {
                if($_.Exception.Message -like "No events were found that match the specified selection criteria.") {
                    $error.Clear();
                } else {
                    throw;
                }
            }
        } else {
            try {
                # Get-EventLog treat "after" parameter via -gt, not -ge operator, thus same second events
                # are not returned
                Get-EventLog -LogName $logName -EntryType $entryTypes -After ($after - [TimeSpan]::FromSeconds(1)) -ea Stop | % {
                    @{
                        "_Raw" = $_
                        "Id" = $_.EventId;
                        "LogName" = $logName;
                        "EntryType" = $_.EntryType;
                        "Category" = $_.Category;
                        "Source" = $_.Source;
                        "Message" = $_.Message;
                        "Strings" = [array]$_.ReplacementStrings;
                        "TimeGenerated" = $_.TimeGenerated;
                        "UserName" = $_.UserName
                    }
                }
            } catch [Exception] {
                if($_.Exception.Message -eq "No matches found") { 
                    $error = $null;
                } else {  
                    throw;
                }
            }
	}  
    }

$events = Get-Events -logName 'Directory Service' -entryTypes @("Error", "Warning", "Information", "SuccessAudit")
$lingeringEvents = $events | ? {$_.Id -eq 1945}
$lingeringEvents