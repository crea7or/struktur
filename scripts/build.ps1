param([ValidateSet('check','debug','test','release','package','candidate','all')][string]$Mode='debug',
      [string]$Product='edge530', [string]$SdkRoot=$env:CONNECTIQ_SDK,
      [string]$JavaHome=$env:JAVA_HOME, [string]$DeviceRoot=$env:CONNECTIQ_DEVICES,
      [string]$DeveloperKey=$(if($env:STRUKTUR_DEVELOPER_KEY){$env:STRUKTUR_DEVELOPER_KEY}else{$env:MSGDF_DEVELOPER_KEY}),[string]$Python=$(if($env:STRUKTUR_PYTHON){$env:STRUKTUR_PYTHON}else{$env:MSGDF_PYTHON}))
$ErrorActionPreference='Stop'
$projectRoot=Split-Path $PSScriptRoot -Parent
$targets=Get-Content -Raw -LiteralPath (Join-Path $projectRoot 'config\devices.json')|ConvertFrom-Json
if($Mode -notin @('all','package','candidate') -and $Product -notin @($targets|ForEach-Object{$_.id})){throw ('Unknown candidate product: '+$Product)}
$environment=& (Join-Path $PSScriptRoot 'check-environment.ps1') -SdkRoot $SdkRoot -JavaHome $JavaHome -DeviceRoot $DeviceRoot -DeveloperKey $DeveloperKey -RequireKey:($Mode -ne 'check')
$DeveloperKey=$environment.developer_key
if($Mode -eq 'check'){$environment;exit 0}
if($Mode -eq 'test'){
    & (Join-Path $PSScriptRoot 'run-tests.ps1') -Product $Product -SdkRoot $SdkRoot -JavaHome $JavaHome -DeviceRoot $DeviceRoot -DeveloperKey $DeveloperKey -Python $Python
    return
}
if(!$Python){
    $localPython=Join-Path $projectRoot '.local\font-venv\Scripts\python.exe'
    $Python=if(Test-Path -LiteralPath $localPython){$localPython}else{'python'}
}
& $Python (Join-Path $projectRoot 'tools\generate_temperature_qualification.py') --check
if($LASTEXITCODE -ne 0){throw 'Temperature source qualification evidence/generation check failed.'}
& (Join-Path $PSScriptRoot 'check-fonts.ps1') -Python $Python
$provenance=& (Join-Path $PSScriptRoot 'source-provenance.ps1')
if($Mode -in @('release','package')){
    $baseline=Get-Content -Raw -LiteralPath (Join-Path $projectRoot 'requirements\baseline.json')|ConvertFrom-Json
    if(@($baseline.requirements|Where-Object{$_.status -ne 'approved'}).Count){throw 'Release requires approval of all current requirements.'}
    $decisions=Get-Content -Raw -LiteralPath (Join-Path $projectRoot 'config\decisions.json')|ConvertFrom-Json
    $open=@($decisions|Where-Object{$_.status -ne 'approved'})
    if($open.Count){throw ('Release is blocked by unresolved decisions: '+(($open|ForEach-Object{$_.id})-join ', '))}
    $qualificationPath=Join-Path $projectRoot 'artifacts\qualification.json'
    if(!(Test-Path -LiteralPath $qualificationPath)){throw 'Release requires reviewed nine-device simulator/hardware qualification evidence.'}
    $qualification=Get-Content -Raw -LiteralPath $qualificationPath|ConvertFrom-Json
    if($qualification.source_revision -ne $provenance.source_revision){throw 'Qualification evidence does not match current build inputs.'}
    foreach($target in $targets){
        $passed=@($qualification.products|Where-Object{$_.id -eq $target.id -and $_.status -eq 'passed' -and $_.evidence_revision -eq $qualification.source_revision})
        if($passed.Count -ne 1){throw ('Release evidence missing or failed: '+$target.id)}
    }
    if($qualification.review_status -ne 'approved'){throw 'Qualification evidence must be reviewed.'}
    foreach($requirement in @($baseline.requirements)){
        $passed=@($qualification.requirements|Where-Object{$_.id -eq $requirement.stable_id -and $_.version_seq -eq $requirement.head_change_seq -and $_.status -eq 'passed' -and $_.evidence_revision -eq $provenance.source_revision})
        if($passed.Count -ne 1){throw ('Requirement qualification missing or outdated: '+$requirement.stable_id)}
    }
}
$outputDir=Join-Path $projectRoot 'bin';$evidenceDir=Join-Path $projectRoot 'artifacts'
New-Item -ItemType Directory -Path $outputDir,$evidenceDir -Force|Out-Null
$provenance|ConvertTo-Json -Depth 8|Set-Content -LiteralPath (Join-Path $evidenceDir 'build-inputs.json') -Encoding UTF8
$env:JAVA_HOME=$environment.java_home
$env:PATH=(Join-Path $environment.java_home 'bin')+[IO.Path]::PathSeparator+$env:PATH
$packageMode=$Mode -in @('package','candidate')
$products=if($Mode -eq 'all'){@($targets|ForEach-Object{$_.id})}elseif($packageMode){@('all-products')}else{@($Product)}
$effectiveMode=if($Mode -eq 'all'){'debug'}else{$Mode}
$buildResults=@()
Push-Location -LiteralPath $projectRoot
try{
    foreach($target in $products){
        $jungle='monkey.jungle'
        $out=Join-Path $outputDir ($target+'-'+$effectiveMode+'.prg')
        $compilerArgs=@('-f',$jungle,'-d',$target,'-o',$out,'-y',$DeveloperKey)
        if($Mode -eq 'release'){$compilerArgs+='-r'}
        if($packageMode){
            # Candidates use the store binary format without asserting release qualification.
            $packageName=if($Mode -eq 'candidate'){'Struktur-candidate.iq'}else{'Struktur.iq'}
            $out=Join-Path $outputDir $packageName
            $compilerArgs=@('-f','monkey.jungle','-o',$out,'-y',$DeveloperKey,'-e','-r')
        }
        $savedPreference=$ErrorActionPreference
        try{
            $ErrorActionPreference='Continue'
            $output=& (Join-Path $environment.sdk 'bin\monkeyc.bat') @compilerArgs 2>&1
            $code=$LASTEXITCODE
        }finally{$ErrorActionPreference=$savedPreference}
        $output=@($output|ForEach-Object{$_.ToString()})
        $log=Join-Path $evidenceDir ($target+'-'+$effectiveMode+'-compiler.log')
        $output|Set-Content -LiteralPath $log -Encoding UTF8
        $output|Write-Output
        if($code -ne 0){throw ('Compilation failed for '+$target+'; exit '+$code)}
        if(!$packageMode){
            $buildResults += [pscustomobject]@{product=$target;mode=$effectiveMode;status='passed';compiler_exit=$code;binary=$out;binary_sha256=(Get-FileHash -LiteralPath $out -Algorithm SHA256).Hash.ToLowerInvariant();log=$log}
        }
    }
    $environment|ConvertTo-Json -Depth 8|Set-Content -LiteralPath (Join-Path $evidenceDir 'build-environment.json') -Encoding UTF8
    if(!$packageMode){
        [pscustomobject]@{source_revision=$provenance.source_revision;compiler=$environment.compiler_version;java=$environment.java_version;products=$buildResults;hardware_qualification='not run'}|ConvertTo-Json -Depth 8|Set-Content -LiteralPath (Join-Path $evidenceDir 'build-results.json') -Encoding UTF8
    }else{
        [pscustomobject]@{source_revision=$provenance.source_revision;compiler=$environment.compiler_version;mode=$Mode;status='compiled';release_qualified=($Mode -eq 'package');binary=$out;binary_sha256=(Get-FileHash -LiteralPath $out -Algorithm SHA256).Hash.ToLowerInvariant();products=@($targets|ForEach-Object{$_.id});log=$log;runtime_tests_run=$false;hardware_tests_run=$false}|ConvertTo-Json -Depth 8|Set-Content -LiteralPath (Join-Path $evidenceDir 'package-build.json') -Encoding UTF8
    }
}finally{Pop-Location}
