param([string]$SdkRoot=$env:CONNECTIQ_SDK, [string]$JavaHome=$env:JAVA_HOME,
      [string]$DeviceRoot=$env:CONNECTIQ_DEVICES, [switch]$RequireKey,
      [string]$DeveloperKey=$(if($env:STRUKTUR_DEVELOPER_KEY){$env:STRUKTUR_DEVELOPER_KEY}else{$env:MSGDF_DEVELOPER_KEY}))
$ErrorActionPreference='Stop'
$projectRoot=Split-Path $PSScriptRoot -Parent
$localConfigPath=Join-Path $projectRoot '.local\environment.json'
if(Test-Path -LiteralPath $localConfigPath){
    $localConfig=Get-Content -Raw -LiteralPath $localConfigPath|ConvertFrom-Json
    if(!$SdkRoot){$SdkRoot=$localConfig.sdk_root}
    if(!$JavaHome){$JavaHome=$localConfig.java_home}
    if(!$DeviceRoot){$DeviceRoot=$localConfig.device_root}
    if(!$DeveloperKey){$DeveloperKey=$localConfig.developer_key}
}
$failures=[System.Collections.Generic.List[string]]::new()
$sdkPath=$null;$javaPath=$null;$devicePath=$null
if(!$SdkRoot){$failures.Add('Set CONNECTIQ_SDK or pass -SdkRoot to the chosen SDK directory.')}
elseif(!(Test-Path -LiteralPath (Join-Path $SdkRoot 'bin\monkeyc.bat'))){$failures.Add('SDK directory must contain bin\monkeyc.bat.')}
else{$sdkPath=(Resolve-Path -LiteralPath $SdkRoot).Path}
if(!$JavaHome){$failures.Add('Set JAVA_HOME or pass -JavaHome to a supported Java installation.')}
elseif(!(Test-Path -LiteralPath (Join-Path $JavaHome 'bin\java.exe'))){$failures.Add('Java directory must contain bin\java.exe.')}
else{$javaPath=(Resolve-Path -LiteralPath $JavaHome).Path}
$targets=Get-Content -Raw -LiteralPath (Join-Path $projectRoot 'config\devices.json')|ConvertFrom-Json
if(!$DeviceRoot){$failures.Add('Set CONNECTIQ_DEVICES or pass -DeviceRoot to the SDK Manager device library.')}
elseif(!(Test-Path -LiteralPath $DeviceRoot)){$failures.Add('Device library directory does not exist.')}
else{
    $devicePath=(Resolve-Path -LiteralPath $DeviceRoot).Path
    foreach($target in $targets){
        if(!(Test-Path -LiteralPath (Join-Path $devicePath $target.id))){$failures.Add('Missing required device package: '+$target.id)}
    }
}
if($RequireKey -and (!$DeveloperKey -or !(Test-Path -LiteralPath $DeveloperKey))){$failures.Add('Set STRUKTUR_DEVELOPER_KEY or pass -DeveloperKey to an external developer signing key.')}
if($failures.Count){throw ("Struktur environment is not ready:`n"+($failures -join "`n")+"`nNo compiler or simulator result is asserted.")}
$env:JAVA_HOME=$javaPath
$env:PATH=(Join-Path $javaPath 'bin')+[IO.Path]::PathSeparator+$env:PATH
function Read-ToolVersion([string]$Program,[string]$VersionArgument){
    # Windows PowerShell wraps native stderr as errors even when exit status is 0.
    # Java writes its version there; use the process exit code to judge success.
    $savedPreference=$ErrorActionPreference
    try{
        $ErrorActionPreference='Continue'
        $output=& $Program $VersionArgument 2>&1
        $code=$LASTEXITCODE
    }finally{$ErrorActionPreference=$savedPreference}
    if($code -ne 0){throw ('Tool version check failed; exit '+$code+': '+$Program)}
    return (($output|ForEach-Object{$_.ToString()}) -join "`n").Trim()
}
$javaVersion=Read-ToolVersion (Join-Path $javaPath 'bin\java.exe') '-version'
$compilerVersion=Read-ToolVersion (Join-Path $sdkPath 'bin\monkeyc.bat') '-v'
$pinned=Get-Content -Raw -LiteralPath (Join-Path $projectRoot 'config\toolchain.json')|ConvertFrom-Json
$compilerHash=(Get-FileHash -LiteralPath (Join-Path $sdkPath 'bin\monkeybrains.jar') -Algorithm SHA256).Hash.ToLowerInvariant()
if($compilerVersion -ne ('Connect IQ Compiler version: '+$pinned.sdk_version) -or $compilerHash -ne $pinned.compiler_jar_sha256){
    throw 'Compiler differs from the pinned SDK version/hash in config/toolchain.json.'
}
$deviceInputs=@{}
$deviceDisplays=@{}
foreach($target in $targets){
    $simulatorConfig=Get-Content -Raw -LiteralPath (Join-Path (Join-Path $devicePath $target.id) 'simulator.json')|ConvertFrom-Json
    $display=$simulatorConfig.display.location
    if($display.width -ne $target.design_width -or $display.height -ne $target.design_height){
        throw ('Device display mismatch for '+$target.id+': SDK '+$display.width+'x'+$display.height+'; project '+$target.design_width+'x'+$target.design_height+'. Correct the profile before building or testing.')
    }
    $deviceDisplays[$target.id]=[pscustomobject]@{width=[int]$display.width;height=[int]$display.height;matches_project=$true}
    $deviceInputs[$target.id]=@{}
    foreach($name in @('compiler.json','simulator.json',($target.id+'.bin'))){
        $deviceInputs[$target.id][$name]=(Get-FileHash -LiteralPath (Join-Path (Join-Path $devicePath $target.id) $name) -Algorithm SHA256).Hash.ToLowerInvariant()
    }
}
[pscustomobject]@{sdk=$sdkPath;java_home=$javaPath;java_version=$javaVersion;compiler_version=$compilerVersion;
    compiler_jar_sha256=$compilerHash;simulator_sha256=(Get-FileHash -LiteralPath (Join-Path $sdkPath 'bin\simulator.exe') -Algorithm SHA256).Hash.ToLowerInvariant();device_inputs=$deviceInputs;
    device_library=$devicePath;device_displays=$deviceDisplays;developer_key=$DeveloperKey;products=@($targets|ForEach-Object{$_.id});status='Pinned compiler and actual SDK device dimensions verified; target builds and compatibility tracked separately'}
