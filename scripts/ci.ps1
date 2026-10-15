param([string]$Python='python',[string]$SdkRoot=$env:CONNECTIQ_SDK,
      [string]$JavaHome=$env:JAVA_HOME,[string]$DeviceRoot=$env:CONNECTIQ_DEVICES,
      [string]$DeveloperKey=$(if($env:STRUKTUR_DEVELOPER_KEY){$env:STRUKTUR_DEVELOPER_KEY}else{$env:MSGDF_DEVELOPER_KEY}),
      [ValidateSet('Core','Memory','Placement')][string]$Suite='Core')
$ErrorActionPreference='Stop'
$projectRoot=Split-Path $PSScriptRoot -Parent
if($Python -eq 'python' -and (Test-Path -LiteralPath (Join-Path $projectRoot '.local\font-venv\Scripts\python.exe'))){
    $Python=Join-Path $projectRoot '.local\font-venv\Scripts\python.exe'
}
& (Join-Path $PSScriptRoot 'check-fonts.ps1') -Python $Python -NegativeFixtures
& $Python (Join-Path $projectRoot 'tools\check_project.py')
if($LASTEXITCODE -ne 0){throw 'Project consistency checks failed.'}
& (Join-Path $PSScriptRoot 'build.ps1') -Mode all -SdkRoot $SdkRoot -JavaHome $JavaHome -DeviceRoot $DeviceRoot -DeveloperKey $DeveloperKey -Python $Python
$targets=Get-Content -Raw -LiteralPath (Join-Path $projectRoot 'config\devices.json')|ConvertFrom-Json
foreach($target in $targets){
    & (Join-Path $PSScriptRoot 'run-tests.ps1') -Suite $Suite -Product $target.id -SdkRoot $SdkRoot -JavaHome $JavaHome -DeviceRoot $DeviceRoot -DeveloperKey $DeveloperKey -Python $Python
}
Write-Output ('Compilation and '+$Suite+' tests completed. Other suites and physical-device qualification remain separate.')
