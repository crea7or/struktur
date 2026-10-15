param([string]$Python=$(if($env:STRUKTUR_PYTHON){$env:STRUKTUR_PYTHON}else{$env:MSGDF_PYTHON}),[switch]$NegativeFixtures)
$ErrorActionPreference='Stop'
$projectRoot=Split-Path $PSScriptRoot -Parent
if(!$Python){
    $localPython=Join-Path $projectRoot '.local\font-venv\Scripts\python.exe'
    $Python=if(Test-Path -LiteralPath $localPython){$localPython}else{'python'}
}
& $Python (Join-Path $projectRoot 'tools\validate_fonts.py')
if($LASTEXITCODE -ne 0){throw 'Font semantic/reproducibility validation failed.'}
if($NegativeFixtures){
    & $Python (Join-Path $projectRoot 'tools\test_font_validation.py')
    if($LASTEXITCODE -ne 0){throw 'Font negative-fixture verification failed.'}
}
