param([string]$Product='all',[string]$Python=$(if($env:STRUKTUR_PYTHON){$env:STRUKTUR_PYTHON}else{$env:MSGDF_PYTHON}),
      [string]$SdkRoot=$env:CONNECTIQ_SDK,[string]$JavaHome=$env:JAVA_HOME,
      [string]$DeviceRoot=$env:CONNECTIQ_DEVICES,[string]$DeveloperKey=$(if($env:STRUKTUR_DEVELOPER_KEY){$env:STRUKTUR_DEVELOPER_KEY}else{$env:MSGDF_DEVELOPER_KEY}),
      [int]$TimeoutSeconds=240)
$ErrorActionPreference='Stop'
$projectRoot=Split-Path $PSScriptRoot -Parent
if(!$Python){$Python=Join-Path $projectRoot '.local\font-venv\Scripts\python.exe'}
$environment=& (Join-Path $PSScriptRoot 'check-environment.ps1') -SdkRoot $SdkRoot -JavaHome $JavaHome -DeviceRoot $DeviceRoot -DeveloperKey $DeveloperKey -RequireKey
$env:JAVA_HOME=$environment.java_home
$env:PATH=(Join-Path $environment.java_home 'bin')+[IO.Path]::PathSeparator+$env:PATH
& (Join-Path $PSScriptRoot 'check-fonts.ps1') -Python $Python
& $Python (Join-Path $projectRoot 'tools\prepare_memory_validation.py')
if($LASTEXITCODE -ne 0){throw 'Could not prepare memory qualification inputs.'}
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
        $program=Join-Path $projectRoot ('bin\'+$id+'-memory.prg')
        $compilerLog=Join-Path $projectRoot ('artifacts\'+$id+'-memory-compiler.log')
        $log=Join-Path $projectRoot ('artifacts\'+$id+'-memory.log')
        $err=Join-Path $projectRoot ('artifacts\'+$id+'-memory.stderr.log')
        $process=$null
        try{
            $savedPreference=$ErrorActionPreference
            try{
                $ErrorActionPreference='Continue'
                $compilerOutput=& (Join-Path $environment.sdk 'bin\monkeyc.bat') -f memory.jungle -d $id -o $program -y $environment.developer_key 2>&1
                $compilerExit=$LASTEXITCODE
            }finally{$ErrorActionPreference=$savedPreference}
            $compilerOutput|Set-Content -LiteralPath $compilerLog -Encoding UTF8
            if($compilerExit -ne 0){throw 'Normal Data Field compilation failed.'}
            $helper=Join-Path $PSScriptRoot 'execute-memory-runner.ps1'
            $runner=Join-Path $environment.sdk 'bin\monkeydo.bat'
            $arguments=@('-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$helper+'"'),'-RunnerPath',('"'+$runner+'"'),'-Program',('"'+$program+'"'),'-Product',$id)
            $process=Start-Process -FilePath (Join-Path $PSHOME 'powershell.exe') -ArgumentList $arguments -PassThru -WindowStyle Hidden -RedirectStandardOutput $log -RedirectStandardError $err
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
                if($text -match 'DF_MEMORY_FAIL|Encountered an app crash|Unhandled Exception|Out Of Memory|OutOfMemory'){throw 'Runtime allocation failure/crash; inspect memory logs.'}
                if($text -match ('DF_MEMORY_DONE product='+$id+' ')){$done=$true;break}
                if($process.HasExited){throw 'Runner exited without a completed normal-runtime memory record.'}
            }
            if(!$done){throw 'Normal Data Field memory run timed out before completion.'}
            # Freeze the completed console evidence before hashing/parsing it.
            if(!$process.HasExited){
                & (Join-Path $env:SystemRoot 'System32\taskkill.exe') /PID $process.Id /T /F | Out-Null
                $process.WaitForExit()
            }
            & $Python (Join-Path $projectRoot 'tools\report_memory_validation.py') -Product $id
            if($LASTEXITCODE -ne 0){throw 'Normal Data Field evidence/limit verification failed.'}
            $results+=Get-Content -Raw -LiteralPath (Join-Path $projectRoot ('artifacts\'+$id+'-memory.json'))|ConvertFrom-Json
            Write-Output ('PASS normal Data Field memory: '+$id)
        }catch{
            $failure=[pscustomobject]@{product=$id;status='failed';reason=$_.Exception.Message;log=$log;source_revision=$provenance.source_revision}
            $failure|ConvertTo-Json -Depth 6|Set-Content -LiteralPath (Join-Path $projectRoot ('artifacts\'+$id+'-memory.json')) -Encoding UTF8
            $results+=$failure
            Write-Output ('FAIL normal Data Field memory: '+$id+' '+$_.Exception.Message)
        }finally{
            if($null -ne $process -and !$process.HasExited){
                # Stop only our runner tree after the explicit completion record.
                & (Join-Path $env:SystemRoot 'System32\taskkill.exe') /PID $process.Id /T /F | Out-Null
            }
        }
    }
}finally{
    Pop-Location
    if($null -ne $ownedSimulator -and !$ownedSimulator.HasExited){Stop-Process -Id $ownedSimulator.Id}
}
$environment|ConvertTo-Json -Depth 10|Set-Content -LiteralPath (Join-Path $projectRoot 'artifacts\datafield-memory-environment.json') -Encoding UTF8
[pscustomobject]@{source_revision=$provenance.source_revision;runtime='normal simulator Data Field';products=$results;physical_devices='not run'}|ConvertTo-Json -Depth 10|Set-Content -LiteralPath (Join-Path $projectRoot 'artifacts\datafield-memory-results.json') -Encoding UTF8
if(@($results|Where-Object{$_.status -ne 'passed'}).Count){throw 'One or more normal Data Field memory profiles failed.'}
