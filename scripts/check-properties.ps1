param([Parameter(Mandatory=$true)][string]$SdkRoot,[Parameter(Mandatory=$true)][string]$JavaHome)
$ErrorActionPreference='Stop'
$root=Split-Path $PSScriptRoot -Parent
$result=& (Join-Path $JavaHome 'bin/java.exe') -cp (Join-Path $SdkRoot 'bin/monkeybrains.jar') (Join-Path $root 'tools/PropertyBudget.java') (Join-Path $root 'resources/settings/properties.xml') 8000
if($LASTEXITCODE -ne 0){throw 'SDK property serialization budget validation failed.'}
$report=$result|ConvertFrom-Json
New-Item -ItemType Directory -Path (Join-Path $root 'artifacts') -Force|Out-Null
$report|ConvertTo-Json|Set-Content -LiteralPath (Join-Path $root 'artifacts/property-budget.json') -Encoding UTF8
Write-Output ('Property settings: '+$report.properties+' keys, '+$report.default_bytes+' default / '+$report.maximum_bytes+' maximum bytes; budget '+$report.limit_bytes+'.')
