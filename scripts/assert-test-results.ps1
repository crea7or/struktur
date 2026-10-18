function Assert-StrukturTestResults {
    param([string]$Text,[int]$RunnerExit,[string[]]$ExpectedNames)
    if(!$ExpectedNames -or @($ExpectedNames|Select-Object -Unique).Count -ne $ExpectedNames.Count){
        throw 'Required test inventory must be nonempty and unique.'
    }
    $countMatch=[regex]::Match($Text,'Ran\s+([1-9][0-9]*)\s+tests?\b')
    $passedMatch=[regex]::Match($Text,'PASSED\s*\(passed=([1-9][0-9]*),\s*failed=0,\s*errors=0\)')
    if($RunnerExit -ne 0 -or !$countMatch.Success -or !$passedMatch.Success -or
       [int]$countMatch.Groups[1].Value -ne $ExpectedNames.Count -or
       $countMatch.Groups[1].Value -ne $passedMatch.Groups[1].Value){
        throw 'Missing/failed/nonempty test-results confirmation or required test count mismatch.'
    }
    if($Text -match 'Unable to serialize app data|Out Of Memory|Stack Overflow'){
        throw 'Simulator reported a persistence or runtime resource error despite test assertions.'
    }
    $caseResults=@()
    foreach($match in [regex]::Matches($Text,'(?ms)^Executing test (\w+)\.\.\.\r?\n(.*?)(?=^-{10,}|\z)')){
        $body=$match.Groups[2].Value
        if($body -notmatch '(?m)^PASS\s*$' -or $body -match '(?m)^(FAIL|ERROR)\b'){
            throw 'A named test block did not pass.'
        }
        $caseResults+=[pscustomobject]@{name=$match.Groups[1].Value;status='passed';duration_ms=$null}
    }
    if($caseResults.Count -ne $ExpectedNames.Count -or
       @($caseResults.name|Select-Object -Unique).Count -ne $caseResults.Count -or
       @(Compare-Object ($ExpectedNames|Sort-Object) ($caseResults.name|Sort-Object)).Count){
        throw 'Named results differ from the required compiled test fixtures.'
    }
    return $caseResults
}
