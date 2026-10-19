$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'sdk-runner.ps1')
$root=Split-Path $PSScriptRoot -Parent
$dir=Join-Path $root ('artifacts/runner cleanup-'+[Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $dir | Out-Null
$child=Join-Path $dir 'child.ps1'
'param([string]$PidFile); $PID | Set-Content -LiteralPath $PidFile; Start-Sleep -Seconds 120' | Set-Content -LiteralPath $child
$parent=Join-Path $dir 'parent.ps1'
'param([string]$Child,[string]$PidFile,[int]$Code,[switch]$Wait)
Start-Process -FilePath (Join-Path $PSHOME "powershell.exe") -ArgumentList @("-NoProfile","-ExecutionPolicy","Bypass","-File",("`""+$Child+"`""),"-PidFile",("`""+$PidFile+"`"")) -WindowStyle Hidden | Out-Null
while(!(Test-Path -LiteralPath $PidFile)){Start-Sleep -Milliseconds 50}
Write-Output "runner-output"
[Console]::Error.WriteLine("runner-error")
if($Wait){Start-Sleep -Seconds 120}
exit $Code' | Set-Content -LiteralPath $parent
$sentinel=Start-Process -FilePath (Join-Path $PSHOME 'powershell.exe') -ArgumentList @('-NoProfile','-Command','Start-Sleep -Seconds 120') -WindowStyle Hidden -PassThru
try {
 foreach($case in @('success','failure','timeout','dispose')) {
  $pidFile=Join-Path $dir ($case+'.pid');$log=Join-Path $dir ($case+'.log');$err=Join-Path $dir ($case+'.err')
  $code=if($case -eq 'failure'){42}else{0}
  $arguments=@('-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$parent+'"'),'-Child',('"'+$child+'"'),'-PidFile',('"'+$pidFile+'"'),'-Code',$code)
  if($case -in @('timeout','dispose')){$arguments+='-Wait'}
  $run=Start-StrukturSdkRun -Arguments $arguments -Log $log -ErrorLog $err
  try {
   $watch=[Diagnostics.Stopwatch]::StartNew()
   while(!(Test-Path -LiteralPath $pidFile) -and $watch.Elapsed.TotalSeconds -lt 10){Start-Sleep -Milliseconds 50}
   if(!(Test-Path -LiteralPath $pidFile)){throw 'Child did not start'}
   $ownedId=[int](Get-Content -LiteralPath $pidFile)
   if($case -in @('success','failure')){
    if(!$run.WaitForExit(10000) -or $run.ExitCode -ne $code){throw 'Runner exit code was lost'}
    $run.Stop();if($run.ExitCode -ne $code){throw 'Cleanup changed completed exit code'}
   } elseif($case -eq 'timeout') {
    if($run.WaitForExit(100)){throw 'Timeout fixture exited early'}
    $run.Stop()
   }
  } finally {$run.Dispose()}
  $watch.Restart()
  while((Get-Process -Id $ownedId -ErrorAction SilentlyContinue) -and $watch.Elapsed.TotalSeconds -lt 5){Start-Sleep -Milliseconds 50}
  if(Get-Process -Id $ownedId -ErrorAction SilentlyContinue){throw 'Owned descendant survived cleanup'}
  if($sentinel.HasExited){throw 'Unrelated process was terminated'}
  foreach($path in @($log,$err)){$file=[IO.File]::Open($path,'Open','ReadWrite','None');$file.Dispose()}
  if($case -in @('success','failure') -and (Get-Content -Raw $log) -notmatch 'runner-output'){throw 'Output lost'}
  Write-Output ('PASS SDK cleanup '+$case)
 }
} finally {if(!$sentinel.HasExited){$sentinel.Kill()};$sentinel.Dispose()}
