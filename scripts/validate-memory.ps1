param([string]$Product='all',[string]$Python=$(if($env:STRUKTUR_PYTHON){$env:STRUKTUR_PYTHON}else{$env:MSGDF_PYTHON}),
      [string]$SdkRoot=$env:CONNECTIQ_SDK,[string]$JavaHome=$env:JAVA_HOME,
      [string]$DeviceRoot=$env:CONNECTIQ_DEVICES,[string]$DeveloperKey=$(if($env:STRUKTUR_DEVELOPER_KEY){$env:STRUKTUR_DEVELOPER_KEY}else{$env:MSGDF_DEVELOPER_KEY}),
      [int]$TimeoutSeconds=600)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'sdk-runner.ps1')
$projectRoot=Split-Path $PSScriptRoot -Parent
if(!$Python){$Python=Join-Path $projectRoot '.local\font-venv\Scripts\python.exe'}
$environment=& (Join-Path $PSScriptRoot 'check-environment.ps1') -SdkRoot $SdkRoot -JavaHome $JavaHome -DeviceRoot $DeviceRoot -DeveloperKey $DeveloperKey -RequireKey
$env:JAVA_HOME=$environment.java_home
$env:PATH=(Join-Path $environment.java_home 'bin')+[IO.Path]::PathSeparator+$env:PATH
# Preserve prior raw evidence before regenerating qualification inputs or logs.
$previousPattern=if($Product -eq 'all'){'*-memory*'}else{$Product+'-memory*'}
$previous=@(Get-ChildItem -LiteralPath (Join-Path $projectRoot 'artifacts') -File -Filter $previousPattern -ErrorAction SilentlyContinue)
if($previous.Count){
    $archive=Join-Path $projectRoot ('artifacts/history/memory/'+[DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffffff')+'-'+$Product)
    New-Item -ItemType Directory -Path $archive -Force|Out-Null
    $previous+=@(Get-ChildItem -LiteralPath (Join-Path $projectRoot 'artifacts') -File -Filter 'datafield-memory*.json' -ErrorAction SilentlyContinue)
    foreach($evidence in $previous){Copy-Item -LiteralPath $evidence.FullName -Destination (Join-Path $archive $evidence.Name)}
}
& (Join-Path $PSScriptRoot 'check-fonts.ps1') -Python $Python
foreach($scenario in @('matrix','switching')){
    & $Python (Join-Path $projectRoot 'tools\prepare_memory_validation.py') --scenario $scenario
    if($LASTEXITCODE -ne 0){throw 'Could not prepare memory qualification inputs.'}
}
$provenance=& (Join-Path $PSScriptRoot 'source-provenance.ps1')
$provenance|ConvertTo-Json -Depth 8|Set-Content -LiteralPath (Join-Path $projectRoot 'artifacts\datafield-memory-source.json') -Encoding UTF8
$devices=Get-Content -Raw -LiteralPath (Join-Path $projectRoot 'config\devices.json')|ConvertFrom-Json
if($Product -ne 'all' -and $Product -notin @($devices.id)){throw 'Unknown product.'}
$targets=if($Product -eq 'all'){@($devices)}else{@($devices|Where-Object{$_.id -eq $Product})}
$ownedSimulator=$null
if(!(Get-Process simulator -ErrorAction SilentlyContinue)){
    $ownedSimulator=Start-Process -FilePath (Join-Path $environment.sdk 'bin\simulator.exe') -WindowStyle Hidden -PassThru
    Start-Sleep -Seconds 3
}
$results=@()
Push-Location -LiteralPath $projectRoot
try{
    foreach($target in $targets){
        $id=$target.id
        $scenarios=@()
        foreach($scenario in @('matrix','switching')){
        $stem=if($scenario -eq 'matrix'){'memory'}else{'memory-switching'}
        $jungle=if($scenario -eq 'matrix'){'memory.jungle'}else{'memory-switching.jungle'}
        $reportStem=if($scenario -eq 'matrix'){'memory-matrix'}else{$stem}
        $program=Join-Path $projectRoot ('bin\'+$id+'-'+$stem+'.prg')
        $compilerLog=Join-Path $projectRoot ('artifacts\'+$id+'-'+$stem+'-compiler.log')
        $log=Join-Path $projectRoot ('artifacts\'+$id+'-'+$stem+'.log')
        $err=Join-Path $projectRoot ('artifacts\'+$id+'-'+$stem+'.stderr.log')
        $process=$null
        try{
            $savedPreference=$ErrorActionPreference
            try{
                $ErrorActionPreference='Continue'
                $compilerOutput=& (Join-Path $environment.sdk 'bin\monkeyc.bat') -O 3z -f $jungle -d $id -o $program -y $environment.developer_key 2>&1
                $compilerExit=$LASTEXITCODE
            }finally{$ErrorActionPreference=$savedPreference}
            $compilerOutput|Set-Content -LiteralPath $compilerLog -Encoding UTF8
            if($compilerExit -ne 0){throw 'Normal Data Field compilation failed.'}
            $helper=Join-Path $PSScriptRoot 'execute-memory-runner.ps1'
            $runner=Join-Path $environment.sdk 'bin\monkeydo.bat'
            $arguments=@('-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$helper+'"'),'-RunnerPath',('"'+$runner+'"'),'-Program',('"'+$program+'"'),'-Product',$id)
            $process=Start-StrukturSdkRun -Arguments $arguments -Log $log -ErrorLog $err
            $watch=[Diagnostics.Stopwatch]::StartNew()
            $done=$false
            while($watch.Elapsed.TotalSeconds -lt $TimeoutSeconds){
                Start-Sleep -Milliseconds 500
                $text=''
                if(Test-Path -LiteralPath $log){
                    $stream=[IO.FileStream]::new($log,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite)
                    $reader=[IO.StreamReader]::new($stream)
                    try{$text=$reader.ReadToEnd()}finally{$reader.Dispose()}
                }
                if($text -match 'DF_MEMORY_FAIL|Encountered an app crash|Unhandled Exception|Out Of Memory|OutOfMemory|Stack Overflow|StackOverflow|Watchdog Tripped|Code Executed Too Long'){throw 'Runtime allocation/stack failure or crash; inspect memory logs.'}
                $completion=if($scenario -eq 'matrix'){'DF_MEMORY_DONE'}else{'DF_SWITCH_MEMORY_DONE'}
                if($text -match ($completion+' product='+$id+' ')){$done=$true;break}
                if($process.HasExited){throw 'Runner exited without a completed normal-runtime memory record.'}
            }
            if(!$done){throw 'Normal Data Field memory run timed out before completion.'}
            # Freeze the completed console evidence before hashing/parsing it.
            $process.Stop()
            & $Python (Join-Path $projectRoot 'tools\report_memory_validation.py') -Product $id --scenario $scenario
            if($LASTEXITCODE -ne 0){throw 'Normal Data Field evidence/limit verification failed.'}
            $scenarios+=Get-Content -Raw -LiteralPath (Join-Path $projectRoot ('artifacts\'+$id+'-'+$reportStem+'.json'))|ConvertFrom-Json
            Write-Output ('PASS normal Data Field memory: '+$id+' '+$scenario)
        }catch{
            $failure=[pscustomobject]@{product=$id;scenario=$scenario;status='failed';reason=$_.Exception.Message;log=$log;source_revision=$provenance.source_revision}
            $failure|ConvertTo-Json -Depth 6|Set-Content -LiteralPath (Join-Path $projectRoot ('artifacts\'+$id+'-'+$reportStem+'.json')) -Encoding UTF8
            $scenarios+=$failure
            Write-Output ('FAIL normal Data Field memory: '+$id+' '+$scenario+' '+$_.Exception.Message)
        }finally{
            if($null -ne $process){$process.Dispose()}
        }
        }
        $status=if(@($scenarios|Where-Object{$_.status -ne 'passed'}).Count){'failed'}else{'passed'}
        $combined=[pscustomobject]@{product=$id;status=$status;source_revision=$provenance.source_revision;runtime='two separate normal simulator Data Field runs; matrix and second-set switching';scenarios=$scenarios;physical_device_memory='unrun'}
        if($status -eq 'passed'){
            $combined|Add-Member -NotePropertyName published_limit_bytes -NotePropertyValue 131072
            $combined|Add-Member -NotePropertyName max_sampled_used_bytes -NotePropertyValue (($scenarios|Measure-Object max_sampled_used_bytes -Maximum).Maximum)
            $combined|Add-Member -NotePropertyName min_sampled_free_bytes -NotePropertyValue (($scenarios|Measure-Object min_sampled_free_bytes -Minimum).Minimum)
        }
        $combined|ConvertTo-Json -Depth 10|Set-Content -LiteralPath (Join-Path $projectRoot ('artifacts\'+$id+'-memory.json')) -Encoding UTF8
        $results+=$combined
    }
}finally{
    Pop-Location
    if($null -ne $ownedSimulator -and !$ownedSimulator.HasExited){Stop-Process -Id $ownedSimulator.Id}
}
$environment|ConvertTo-Json -Depth 10|Set-Content -LiteralPath (Join-Path $projectRoot 'artifacts\datafield-memory-environment.json') -Encoding UTF8
[pscustomobject]@{source_revision=$provenance.source_revision;runtime='normal simulator Data Field';products=$results;physical_devices='not run'}|ConvertTo-Json -Depth 10|Set-Content -LiteralPath (Join-Path $projectRoot 'artifacts\datafield-memory-results.json') -Encoding UTF8
if(@($results|Where-Object{$_.status -ne 'passed'}).Count){throw 'One or more normal Data Field memory profiles failed.'}
