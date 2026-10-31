param([string]$Product='edge530',[string]$SdkRoot=$env:CONNECTIQ_SDK,
      [string]$JavaHome=$env:JAVA_HOME,[string]$DeviceRoot=$env:CONNECTIQ_DEVICES,
      [string]$DeveloperKey=$(if($env:STRUKTUR_DEVELOPER_KEY){$env:STRUKTUR_DEVELOPER_KEY}else{$env:MSGDF_DEVELOPER_KEY}),[int]$TimeoutSeconds=120,
      [string]$Python=$(if($env:STRUKTUR_PYTHON){$env:STRUKTUR_PYTHON}else{$env:MSGDF_PYTHON}),
      [ValidateSet('Core','Memory','Placement')][string]$Suite='Core',[switch]$LogicOnly)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'sdk-runner.ps1')
$process=$null
$projectRoot=Split-Path $PSScriptRoot -Parent
$environment=& (Join-Path $PSScriptRoot 'check-environment.ps1') -SdkRoot $SdkRoot -JavaHome $JavaHome -DeviceRoot $DeviceRoot -DeveloperKey $DeveloperKey -RequireKey
$DeveloperKey=$environment.developer_key
& (Join-Path $PSScriptRoot 'check-properties.ps1') -SdkRoot $environment.sdk -JavaHome $environment.java_home
$targets=Get-Content -Raw -LiteralPath (Join-Path $projectRoot 'config\devices.json')|ConvertFrom-Json
if($Product -notin @($targets|ForEach-Object{$_.id})){throw 'Unknown product.'}
if($TimeoutSeconds -lt 1){throw 'A positive timeout is required.'}
if($LogicOnly -and $Suite -ne 'Core'){throw '-LogicOnly is a compatibility alias for Core; select one suite.'}
$suiteDefinitions=Get-Content -Raw -LiteralPath (Join-Path $projectRoot 'tests\suites.json')|ConvertFrom-Json
$definition=$suiteDefinitions.suites.$Suite
if(!$definition){throw 'Suite definition is missing.'}
# Test-enabled compilation consumes the same validated rendering resources.
# Reproducibility is checked by build/CI; this gate checks current semantics.
if(!$Python){
    $localPython=Join-Path $projectRoot '.local\font-venv\Scripts\python.exe'
    $Python=if(Test-Path -LiteralPath $localPython){$localPython}else{'python'}
}
if($Suite -eq 'Core'){
    & $Python (Join-Path $projectRoot 'tools\test_settings_layout.py')
    if($LASTEXITCODE -ne 0){throw 'Single-page settings presentation regression failed.'}
    & $Python (Join-Path $projectRoot 'tools\test_compile_package.py')
    if($LASTEXITCODE -ne 0){throw 'Package firmware/API compatibility regression failed.'}
    & (Join-Path $PSScriptRoot 'test-sdk-runner.ps1')
    & $Python (Join-Path $projectRoot 'tools\test_property_budget.py') --sdk $environment.sdk --java $environment.java_home
    if($LASTEXITCODE -ne 0){throw 'Property budget guard regression failed.'}
}
& $Python (Join-Path $projectRoot 'tools\check_test_suites.py')
if($LASTEXITCODE -ne 0){throw 'Suite inventory does not match compiler inputs.'}
& $Python (Join-Path $projectRoot 'tools\generate_display_limits.py') --check
if($LASTEXITCODE -ne 0){throw 'Display limits or clock-fit font capability do not match current inputs.'}
& $Python -c 'import sys; sys.path.insert(0,sys.argv[1]); from validate_fonts import validate_manifest; validate_manifest()' (Join-Path $projectRoot 'tools')
if($LASTEXITCODE -ne 0){throw 'Font semantic validation failed before test compilation.'}
& $Python (Join-Path $projectRoot 'tools\generate_temperature_qualification.py') --check
if($LASTEXITCODE -ne 0){throw 'Temperature qualification source/evidence check failed before test compilation.'}
New-Item -ItemType Directory -Path (Join-Path $projectRoot 'bin'),(Join-Path $projectRoot 'artifacts') -Force|Out-Null
$env:JAVA_HOME=$environment.java_home
$env:PATH=(Join-Path $environment.java_home 'bin')+[IO.Path]::PathSeparator+$env:PATH
$artifactName=$Product+'-'+$Suite.ToLowerInvariant()+'-tests'
$program=Join-Path $projectRoot ('bin\'+$artifactName+'.prg')
$jungle=$definition.jungle
$provenance=& (Join-Path $PSScriptRoot 'source-provenance.ps1')
$resultPath=Join-Path $projectRoot ('artifacts\'+$artifactName+'.json')
[pscustomobject]@{suite=$Suite;product=$Product;source_revision=$provenance.source_revision;status='running'}|ConvertTo-Json|Set-Content -LiteralPath $resultPath -Encoding UTF8
Push-Location -LiteralPath $projectRoot
try{
    & (Join-Path $environment.sdk 'bin\monkeyc.bat') -O 3z -f $jungle -d $Product -o $program -y $DeveloperKey --unit-test
    if($LASTEXITCODE -ne 0){throw 'Test-enabled compilation failed.'}
    # A display-capable simulator must already be running for the selected SDK.
    # A PowerShell child handles the SDK .bat file with separate arguments.
    $log=Join-Path $projectRoot ('artifacts\'+$artifactName+'.log')
    $err=Join-Path $projectRoot ('artifacts\'+$artifactName+'.stderr.log')
    $runner=Join-Path $environment.sdk 'bin\monkeydo.bat'
    $helper=Join-Path $PSScriptRoot 'execute-test-runner.ps1'
    $arguments=@('-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$helper+'"'),'-RunnerPath',('"'+$runner+'"'),'-Program',('"'+$program+'"'),'-Product',$Product)
    $runnerStartedUtc=[DateTime]::UtcNow
    $runnerTimer=[Diagnostics.Stopwatch]::StartNew()
    $process=Start-StrukturSdkRun -Arguments $arguments -Log $log -ErrorLog $err
    if(!$process.WaitForExit($TimeoutSeconds*1000)){
        # Terminate only this launched runner tree; no unrelated simulator process.
        $process.Stop()
        throw 'Simulator test runner timed out.'
    }
    $process.Stop() # Also close descendants left after a successful parent exit.
    $runnerTimer.Stop()
    $runnerFinishedUtc=[DateTime]::UtcNow
    $text=[string](Get-Content -Raw -LiteralPath $log)
    $requiredFiles=@($definition.files)
    $expectedNames=@($requiredFiles|ForEach-Object{[regex]::Matches((Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $projectRoot $_)),'\(:test\)\s*function\s+(\w+)\(')|ForEach-Object{$_.Groups[1].Value}})
    . (Join-Path $PSScriptRoot 'assert-test-results.ps1')
    $caseResults=@(Assert-StrukturTestResults -Text $text -RunnerExit $process.ExitCode -ExpectedNames $expectedNames)
    if($Suite -eq 'Core' -and ($text.Contains('FONT_MEMORY') -or $text.Contains('profileFontLoad') -or $text.Contains('full grid needs larger area'))){throw 'Core run included a memory probe or insufficient-area fallback.'}
    $fixtures=@($requiredFiles+@($definition.support)+@('tests\suites.json','tests\fixtures.json','config\acquisition-contracts.json')|ForEach-Object{[pscustomobject]@{path=$_;sha256=(Get-FileHash -LiteralPath (Join-Path $projectRoot $_) -Algorithm SHA256).Hash.ToLowerInvariant()}})
    [pscustomobject]@{suite=$Suite;product=$Product;source_revision=$provenance.source_revision;compiler=$environment.compiler_version;status='passed';test_count=$caseResults.Count;cases=$caseResults;executed_at=$runnerStartedUtc.ToString('o');finished_at=$runnerFinishedUtc.ToString('o');suite_duration_ms=[long]$runnerTimer.Elapsed.TotalMilliseconds;case_timing='SDK emits named result blocks but no per-case UTC/duration; executed_at is suite start and duration_ms is null per case.';fixture_hashes=$fixtures;runner_exit=$process.ExitCode;binary_sha256=(Get-FileHash -LiteralPath $program -Algorithm SHA256).Hash.ToLowerInvariant();log_sha256=(Get-FileHash -LiteralPath $log -Algorithm SHA256).Hash.ToLowerInvariant();scope=$definition.scope}|ConvertTo-Json -Depth 6|Set-Content -LiteralPath (Join-Path $projectRoot ('artifacts\'+$artifactName+'.json')) -Encoding UTF8
    $text|Write-Output
}catch{
    $failure=$_.Exception.Message
    $failedCases=@()
    if($log -and (Test-Path -LiteralPath $log)){
        $failedText=[string](Get-Content -Raw -LiteralPath $log)
        foreach($match in [regex]::Matches($failedText,'(?ms)^Executing test (\w+)\.\.\.\r?\n(.*?)(?=^-{10,}|\z)')){
            $body=$match.Groups[2].Value
            $caseStatus=if($body -match '(?m)^PASS\s*$' -and $body -notmatch '(?m)^(FAIL|ERROR)\b'){'passed'}else{'failed'}
            $failedCases += [pscustomobject]@{name=$match.Groups[1].Value;status=$caseStatus}
        }
    }
    [pscustomobject]@{suite=$Suite;product=$Product;source_revision=$provenance.source_revision;compiler=$environment.compiler_version;status='failed';error=$failure;cases=$failedCases;test_count=$failedCases.Count;executed_at=$(if($runnerStartedUtc){$runnerStartedUtc.ToString('o')}else{$null});suite_duration_ms=$(if($runnerTimer){[long]$runnerTimer.Elapsed.TotalMilliseconds}else{$null});binary_sha256=$(if(Test-Path -LiteralPath $program){(Get-FileHash -LiteralPath $program -Algorithm SHA256).Hash.ToLowerInvariant()}else{$null});log_sha256=$(if($log -and (Test-Path -LiteralPath $log)){(Get-FileHash -LiteralPath $log -Algorithm SHA256).Hash.ToLowerInvariant()}else{$null});log=$log;scope=$definition.scope;finished_at=[DateTime]::UtcNow.ToString('o')}|ConvertTo-Json -Depth 6|Set-Content -LiteralPath $resultPath -Encoding UTF8
    throw
}finally{if($null -ne $process){$process.Dispose()};Pop-Location}
if($Suite -eq 'Memory'){
    & $Python (Join-Path $projectRoot 'tools\test_memory_observation.py')
    if($LASTEXITCODE -ne 0){throw 'Memory observation/reporting regression failed.'}
    $report=Get-Content -Raw -LiteralPath $resultPath|ConvertFrom-Json
    $report.status='font_probes_passed_runtime_pending'
    $report|ConvertTo-Json -Depth 6|Set-Content -LiteralPath $resultPath -Encoding UTF8
    try{
        & (Join-Path $PSScriptRoot 'validate-memory.ps1') -Product $Product -SdkRoot $SdkRoot -JavaHome $JavaHome -DeviceRoot $DeviceRoot -DeveloperKey $DeveloperKey -Python $Python
        $report.status='passed'
    }catch{
        $report.status='runtime_failed'
        throw
    }finally{
        $report|Add-Member -NotePropertyName normal_runtime_report -NotePropertyValue ('artifacts/'+$Product+'-memory.json') -Force
        $report|ConvertTo-Json -Depth 6|Set-Content -LiteralPath $resultPath -Encoding UTF8
    }
}
