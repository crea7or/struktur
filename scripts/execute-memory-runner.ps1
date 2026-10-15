param([Parameter(Mandatory=$true)][string]$RunnerPath,
      [Parameter(Mandatory=$true)][string]$Program,
      [Parameter(Mandatory=$true)][string]$Product)
$ErrorActionPreference='Stop'
# Normal Data Field runtime: deliberately no /t flag.
& $RunnerPath $Program $Product
exit $LASTEXITCODE
