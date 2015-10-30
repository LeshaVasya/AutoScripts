    $test_known_error_events = @()


    function global:GetErrorEventsWithExclude($expectedErrorEvents) {
        $validators = [scriptblock[]]@();
        $validators += $expectedErrorEvents;
        Get-ErrorEvents | ? {
            $curr = $_;
            ($validators | % { $validatorCurr = $_; @($curr) | % $validatorCurr; } | % { -not $_ } | measure-object -sum | select -expandProperty sum) -eq 0
        }
    }


    function global:Get-ErrorEvents() {
        $entryTypes = @("Error", "Warning");
        Get-EventsByTypes $entryTypes
    }

        function global:Get-EventsByTypes($entryTypes) {
        Get-EventLog -List | % {
                Get-Events -logName $_.Log -entryTypes $entryTypes
        }    
    }

        function global:Get-Events($entryTypes, $logName) {
        $after = [DateTime]::ParseExact($suiteStartTime, "H:mm:ss", $null);
        
        
        # Determine cmdlet used to extract event-log entries:
        #  - get-winevent is not working on 2003
        #  - get-eventlog is not returning messages on 2012 and 2012r2 lab
        $canRunGetWinEvent = $false;
        try
        {
            Get-WinEvent -LogName Application -MaxEvents 1 | Out-Null
            # can run Get-WinEvent without issues
            $canRunGetWinEvent = $true;
        }
        catch
        {
            $error.Clear();
            # can't run Get-WinEvent, possibly due to 2003
            $canRunGetWinEvent = $false
        }
        
        # Extract event-log entries
        if($canRunGetWinEvent)
        {
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
                #Write-Host "Querying '$LogName' by '$condition'"
                Get-WinEvent -LogName $LogName -FilterXPath $condition -ea Stop | % {
                    $eventLevelDisplayName = $_.LevelDisplayName;
                    $eventKeywordsDisplayNames = $_.KeywordsDisplayNames
                    $eventKeywordsDisplayName = (@($eventKeywordsDisplayNames) | select -f 1)
                    $eventEntryType = switch($eventKeywordsDisplayName)
                    {
                        "Classic" { $eventLevelDisplayName; }
                        "Audit Success" { "SuccessAudit"; }
                        "Audit Failure" { "FailureAudit"; }
                        default { $null; }
                    }
                    $eventReplacementStrings = @($_.Properties) | % { $_.Value };
                    
                    @{
                        "_Raw" = $_;
                        "Id" = $_.Id; 
                        "LogName" = $LogName;
                        "EntryType" = $eventEntryType;
                        "Category" = $_.TaskDisplayName;
                        "Source" = $_.ProviderName;
                        "Message" = $_.Message;
                        "Strings" = $eventReplacementStrings;
                        "TimeGenerated" = $_.TimeCreated.ToLocalTime()
                    }
                }
            } catch [Exception] {
                if($_.Exception.Message -like "No events were found that match the specified selection criteria.") {
                    $error.Clear();
                } else {
                    throw;
                }
            }
        }
        else
        {
            try {
                Get-EventLog -LogName $logName -EntryType $entryTypes -After $after -ea Stop | % {
                    @{
                        "_Raw" = $_
                        "Id" = $_.EventId;
                        "LogName" = $logName;
                        "EntryType" = $_.EntryType;
                        "Category" = $_.Category;
                        "Source" = $_.Source;
                        "Message" = $_.Message;
                        "Strings" = [array]$_.ReplacementStrings;
                        "TimeGenerated" = $_.TimeGenerated
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




