param([Parameter(Mandatory=$true)][string]$RunnerPath,
      [Parameter(Mandatory=$true)][string]$Program,
      [Parameter(Mandatory=$true)][string]$Product)
$ErrorActionPreference='Stop'
# PowerShell invokes the SDK batch file with separate arguments. No command is
# assembled from paths, and the signing key is never passed to this runner.
& $RunnerPath $Program $Product /t
exit $LASTEXITCODE
