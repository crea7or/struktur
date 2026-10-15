param([switch]$All,[string]$Product='edge1040',[ValidateSet('Core','Memory','Placement')][string]$Suite='Core')
# Compile regression sources without starting the simulator or recording passes.
$ErrorActionPreference='Stop'
$root=Split-Path $PSScriptRoot -Parent
$environment=& (Join-Path $PSScriptRoot 'check-environment.ps1') -RequireKey
& (Join-Path $PSScriptRoot 'check-fonts.ps1')
$env:JAVA_HOME=$environment.java_home
$targets=Get-Content -Raw -LiteralPath (Join-Path $root 'config/devices.json')|ConvertFrom-Json
if(!$All -and $Product -notin @($targets.id)){throw 'Unknown product.'}
$products=if($All){@($targets.id)}else{@($Product)}
$definitions=Get-Content -Raw -LiteralPath (Join-Path $root 'tests/suites.json')|ConvertFrom-Json
$jungle=$definitions.suites.$Suite.jungle
$provenance=& (Join-Path $PSScriptRoot 'source-provenance.ps1')
$results=@()
New-Item -ItemType Directory -Path (Join-Path $root 'bin'),(Join-Path $root 'artifacts') -Force|Out-Null
Push-Location -LiteralPath $root
try {
    foreach($target in $products) {
        $out=Join-Path $root ('bin/'+$target+'-'+$Suite.ToLowerInvariant()+'-tests.prg')
        $saved=$ErrorActionPreference
        try {
            $ErrorActionPreference='Continue'
            $output=& (Join-Path $environment.sdk 'bin/monkeyc.bat') -f $jungle -d $target -o $out -y $environment.developer_key --unit-test 2>&1
            $code=$LASTEXITCODE
        } finally {$ErrorActionPreference=$saved}
        $output|Set-Content -LiteralPath (Join-Path $root ('artifacts/'+$target+'-test-compile.log')) -Encoding UTF8
        if($code -ne 0){$output|Write-Output;throw ('Test compilation failed: '+$target)}
        $results += [pscustomobject]@{product=$target;compilation='passed';execution='not run';binary_sha256=(Get-FileHash -LiteralPath $out -Algorithm SHA256).Hash.ToLowerInvariant()}
        Write-Output ('Test sources compiled: '+$target+'; execution not run')
    }
    [pscustomobject]@{source_revision=$provenance.source_revision;products=$results;simulator_started=$false;memory_tests_run=$false}|ConvertTo-Json -Depth 5|Set-Content -LiteralPath (Join-Path $root 'artifacts/test-compilation.json') -Encoding UTF8
} finally {Pop-Location}
