if(-not ('StrukturSdkRun' -as [type])) { Add-Type -Path (Join-Path $PSScriptRoot 'SdkRun.cs') }
function Start-StrukturSdkRun([string[]]$Arguments,[string]$Log,[string]$ErrorLog) {
    [StrukturSdkRun]::Start((Join-Path $PSHOME 'powershell.exe'),($Arguments -join ' '),(Split-Path $PSScriptRoot -Parent),$Log,$ErrorLog)
}
