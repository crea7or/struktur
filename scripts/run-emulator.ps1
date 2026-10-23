param(
    [ValidateSet('edge530','edge540','edge550','edge830','edge840','edge850','edge1030','edge1040','edge1050','edge1060')]
    [string]$Product='edge530',
    [switch]$Build,
    [string]$SdkRoot=$env:CONNECTIQ_SDK,
    [string]$JavaHome=$env:JAVA_HOME,
    [ValidatePattern('^[A-Za-z0-9_-]*$')]
    [string]$SimulatorSettingsName=$(if($env:STRUKTUR_SIMULATOR_SETTINGS_NAME){$env:STRUKTUR_SIMULATOR_SETTINGS_NAME}else{$env:MSGDF_SIMULATOR_SETTINGS_NAME})
)
$ErrorActionPreference='Stop'
$projectRoot=Split-Path $PSScriptRoot -Parent
try {
    $localPath=Join-Path $projectRoot '.local\environment.json'
    if(Test-Path -LiteralPath $localPath) {
        $localConfig=Get-Content -Raw -LiteralPath $localPath | ConvertFrom-Json
        if(!$SdkRoot) { $SdkRoot=$localConfig.sdk_root }
        if(!$JavaHome) { $JavaHome=$localConfig.java_home }
        if(!$SimulatorSettingsName) { $SimulatorSettingsName=$localConfig.simulator_settings_name }
    }
    if(!$SdkRoot) { throw 'Set CONNECTIQ_SDK to the Garmin SDK directory or configure .local/environment.json.' }
    if(!$JavaHome) { throw 'Set JAVA_HOME to the Java installation or configure .local/environment.json.' }
    $simulator=Join-Path $SdkRoot 'bin\simulator.exe'
    $runnerJar=Join-Path $SdkRoot 'bin\monkeybrains.jar'
    $shell=Join-Path $SdkRoot 'bin\shell.exe'
    $java=Join-Path $JavaHome 'bin\java.exe'
    foreach($requiredPath in @($simulator,$runnerJar,$shell,$java)) {
        if(!(Test-Path -LiteralPath $requiredPath -PathType Leaf)) { throw ('Required tool not found: '+$requiredPath) }
    }
    $simulator=(Resolve-Path -LiteralPath $simulator).Path
    $env:JAVA_HOME=$JavaHome
    $env:PATH=(Join-Path $JavaHome 'bin')+[IO.Path]::PathSeparator+$env:PATH
    $program=Join-Path $projectRoot ('bin\'+$Product+'-debug.prg')
    $settingsFile=Join-Path $projectRoot ('bin\'+$Product+'-debug-settings.json')
    if($Build) {
        Write-Host ('Building Struktur for '+$Product+'...')
        & (Join-Path $PSScriptRoot 'build.ps1') -Mode debug -Product $Product -SdkRoot $SdkRoot -JavaHome $JavaHome
        if($LASTEXITCODE -ne 0) { throw ('Debug build failed with exit code '+$LASTEXITCODE+'; the app was not launched.') }
    }
    if(!(Test-Path -LiteralPath $program -PathType Leaf)) {
        throw ('Debug app not found. Run run-emulator.cmd '+$Product+' -Build first.')
    }
    if(!(Test-Path -LiteralPath $settingsFile -PathType Leaf)) {
        throw ('App settings description not found. Run run-emulator.cmd '+$Product+' -Build first.')
    }
    if($SimulatorSettingsName -and $SimulatorSettingsName -notmatch '^[A-Za-z0-9_-]+$') {
        throw 'SimulatorSettingsName must be a program basename containing only letters, digits, underscores or hyphens.'
    }
    $running=@(Get-Process -Name simulator -ErrorAction SilentlyContinue)
    if($running.Count -gt 0) {
        if(@($running | Where-Object { $_.Path -ne $simulator }).Count -gt 0) {
            throw 'A simulator from another SDK is open. Close it before launching this SDK.'
        }
        Write-Host 'Using the open Garmin simulator.'
    } else {
        Write-Host 'Opening the Garmin simulator...'
        Start-Process -FilePath $simulator -WorkingDirectory (Split-Path $simulator -Parent) -WindowStyle Normal | Out-Null
    }
    # SDK simulator.exe can start a child GUI process and exit immediately.
    # Wait for the actual simulator window rather than the bootstrap process.
    $startup=[Diagnostics.Stopwatch]::StartNew()
    do {
        $ready=@(Get-Process -Name simulator -ErrorAction SilentlyContinue | Where-Object {
            $_.Path -eq $simulator -and $_.MainWindowHandle -ne [IntPtr]::Zero
        })
        if($ready.Count -gt 0) { break }
        Start-Sleep -Milliseconds 250
    } while($startup.Elapsed.TotalSeconds -lt 20)
    if($ready.Count -eq 0) { throw 'Simulator window did not become ready within 20 seconds.' }
    Start-Sleep -Milliseconds 500
    Write-Host ('Running Struktur on '+$Product+'. Keep this launcher open while using the app.')
    Write-Host 'Configure fields: File > Edit Persistent Storage > Edit Application.Properties data'
    # The SDK 9.2 monkeydo additional-file option normalizes the destination into
    # Windows backslashes. Transfer directly to the simulator's forward-slash path.
    # The JSON describes editor controls and does not overwrite saved .SET values.
    $settingsNames=@([IO.Path]::GetFileNameWithoutExtension($program).ToUpperInvariant())
    # Garmin can retain the first installed filename for an application UUID.
    # Supply a host-configured alias without clearing other apps or saved values.
    if($SimulatorSettingsName) { $settingsNames+=$SimulatorSettingsName.ToUpperInvariant() }
    foreach($settingsName in @($settingsNames | Select-Object -Unique)) {
        $settingsDestination='0:/GARMIN/Settings/'+$settingsName+'-settings.json'
        $savedPreference=$ErrorActionPreference
        try {
            $ErrorActionPreference='Continue'
            # Match the SDK's Windows shell quoting so project paths may contain spaces.
            $transferOutput=& $shell push ('\"'+$settingsFile+'\"') ('\"'+$settingsDestination+'\"') 2>&1
            $transferCode=$LASTEXITCODE
        } finally { $ErrorActionPreference=$savedPreference }
        if($transferCode -ne 0 -or ($transferOutput -join "`n") -notmatch 'File pushed successfully') {
            $transferOutput | Write-Host
            throw 'App settings description could not be transferred to the simulator.'
        }
    }
    Write-Host 'App settings description transferred.'
    # Invoke the same Java entry point as monkeydo.bat, with separate arguments.
    $runnerArguments=@('-classpath',$runnerJar,'com.garmin.monkeybrains.monkeydodeux.MonkeyDoDeux',
        '-f',$program,'-d',$Product,'-s',$shell)
    # Normal Data Field runtime, without the SDK unit-test flag.
    & $java @runnerArguments
    if($LASTEXITCODE -ne 0) { throw ('Garmin app runner failed with exit code '+$LASTEXITCODE+'.') }
} catch {
    Write-Host ('Struktur launcher: '+$_.Exception.Message) -ForegroundColor Red
    exit 1
}
exit 0
