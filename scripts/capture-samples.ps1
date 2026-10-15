param([string]$Product='all',[int]$TimeoutSeconds=60)
$ErrorActionPreference='Stop'
$projectRoot=Split-Path $PSScriptRoot -Parent
$environment=& (Join-Path $PSScriptRoot 'check-environment.ps1') -RequireKey
$env:JAVA_HOME=$environment.java_home
$env:PATH=(Join-Path $environment.java_home 'bin')+[IO.Path]::PathSeparator+$env:PATH
$targets=Get-Content -Raw -LiteralPath (Join-Path $projectRoot 'config/devices.json')|ConvertFrom-Json
if($Product -ne 'all' -and $Product -notin @($targets.id)){throw 'Unknown product.'}
if($Product -ne 'all'){$targets=@($targets|Where-Object{$_.id -eq $Product})}
$python=Join-Path $projectRoot '.local/font-venv/Scripts/python.exe'
$provenance=& (Join-Path $PSScriptRoot 'source-provenance.ps1')
Push-Location -LiteralPath $projectRoot
try {
    & $python -X utf8 tools/prepare_sample_preview.py
    if($LASTEXITCODE -ne 0){throw 'Sample fixture preparation failed.'}
    Add-Type -AssemblyName System.Drawing
    Add-Type @'
using System;
using System.Text;
using System.Runtime.InteropServices;
public static class SampleCaptureWindows {
 [StructLayout(LayoutKind.Sequential)] public struct RECT { public int left,top,right,bottom; }
 [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hwnd,out RECT rect);
 [DllImport("user32.dll")] public static extern bool PrintWindow(IntPtr hwnd,IntPtr hdc,uint flags);
 [DllImport("user32.dll")] public static extern IntPtr GetMenu(IntPtr hwnd);
 [DllImport("user32.dll")] public static extern IntPtr GetSubMenu(IntPtr menu,int position);
 [DllImport("user32.dll")] public static extern int GetMenuItemCount(IntPtr menu);
 [DllImport("user32.dll")] public static extern uint GetMenuItemID(IntPtr menu,int position);
 [DllImport("user32.dll",CharSet=CharSet.Unicode)] public static extern int GetMenuString(IntPtr menu,uint position,StringBuilder text,int size,uint flags);
 [DllImport("user32.dll")] public static extern bool PostMessage(IntPtr hwnd,uint message,IntPtr wparam,IntPtr lparam);
 public static int FullFieldCommand(IntPtr menu,string path) {
  for(int i=0;i<GetMenuItemCount(menu);i++) {
   var text=new StringBuilder(256); GetMenuString(menu,(uint)i,text,256,1024);
   var next=path+text.ToString().Replace("&",""); var sub=GetSubMenu(menu,i);
   if(sub!=IntPtr.Zero) { var command=FullFieldCommand(sub,next+" > "); if(command>=0)return command; }
   else if(next=="Data Fields > Layout > 1 Field") return (int)GetMenuItemID(menu,i);
  }
  return -1;
 }
}
'@
    $sdkSimulator=Join-Path $environment.sdk 'bin/simulator.exe'
    if(!(Get-Process -Name simulator -ErrorAction SilentlyContinue)){
        Start-Process -FilePath $sdkSimulator -WorkingDirectory (Split-Path $sdkSimulator -Parent) -WindowStyle Hidden|Out-Null
    }
    $images=@()
    foreach($target in $targets){
        $id=$target.id
        $program=Join-Path $projectRoot ('bin/'+$id+'-sample-preview.prg')
        $compileLog=Join-Path $projectRoot ('artifacts/'+$id+'-sample-compiler.log')
        $saved=$ErrorActionPreference
        try{$ErrorActionPreference='Continue';$compilerOutput=& (Join-Path $environment.sdk 'bin/monkeyc.bat') -f ('.local/sample-preview-'+$id+'.jungle') -d $id -o $program -y $environment.developer_key 2>&1;$compilerExit=$LASTEXITCODE}finally{$ErrorActionPreference=$saved}
        $compilerOutput|Set-Content -LiteralPath $compileLog -Encoding UTF8
        if($compilerExit -ne 0){throw ('Sample compilation failed: '+$id)}
        $log=Join-Path $projectRoot ('artifacts/'+$id+'-sample-preview.log')
        $err=Join-Path $projectRoot ('artifacts/'+$id+'-sample-preview.stderr.log')
        $java=Join-Path $environment.java_home 'bin/java.exe'
        $jar=Join-Path $environment.sdk 'bin/monkeybrains.jar';$shell=Join-Path $environment.sdk 'bin/shell.exe'
        $arguments=@('-classpath',('"'+$jar+'"'),'com.garmin.monkeybrains.monkeydodeux.MonkeyDoDeux','-f',('"'+$program+'"'),'-d',$id,'-s',('"'+$shell+'"'))
        $runner=Start-Process -FilePath $java -ArgumentList $arguments -PassThru -WindowStyle Hidden -RedirectStandardOutput $log -RedirectStandardError $err
        $watch=[Diagnostics.Stopwatch]::StartNew();$selected=$false;$frame=$null;$simulator=$null
        try {
            while($watch.Elapsed.TotalSeconds -lt $TimeoutSeconds){
                $simulator=Get-Process -Name simulator -ErrorAction SilentlyContinue|Where-Object{$_.Path -eq $sdkSimulator -and $_.MainWindowHandle -ne [IntPtr]::Zero}|Select-Object -First 1
                if($simulator -and !$selected){
                    $command=[SampleCaptureWindows]::FullFieldCommand([SampleCaptureWindows]::GetMenu($simulator.MainWindowHandle),'')
                    if($command -ge 0){[SampleCaptureWindows]::PostMessage($simulator.MainWindowHandle,273,[IntPtr]$command,[IntPtr]::Zero)|Out-Null;$selected=$true}
                }
                $text=[string]$(if(Test-Path -LiteralPath $log){Get-Content -Raw -LiteralPath $log}else{''})
                if($text -match '(?m)^Error:|^Exception:'){throw ('Sample runtime error: '+$id+'; '+$log)}
                $frameMatches=[regex]::Matches($text,('SAMPLE_FRAME product='+$id+' width=(\d+) height=(\d+) fields=(\d+)'))
                if($frameMatches.Count){
                    $latest=$frameMatches[$frameMatches.Count-1]
                    if($simulator -and [int]$latest.Groups[1].Value -eq $target.design_width -and [int]$latest.Groups[2].Value -eq $target.design_height -and [int]$latest.Groups[3].Value -eq 2*$target.design_rows-3 -and $text.Contains('SAMPLE_DATA clock=13:05 temperature=24.50 enlarged=1 field=power_3s power=245')){$frame=$latest;break}
                }
                if($runner.HasExited){throw ('Sample runner exited before a full native frame: '+$id)}
                Start-Sleep -Milliseconds 250
            }
            if(!$frame){throw ('No complete native sample grid: '+$id+'; '+$log)}
            Start-Sleep -Milliseconds 1200
            $imagePath=Join-Path $projectRoot ('artifacts/'+$id+'-sample.png')
            $rect=New-Object SampleCaptureWindows+RECT
            if(![SampleCaptureWindows]::GetWindowRect($simulator.MainWindowHandle,[ref]$rect)){throw 'Cannot read simulator window bounds.'}
            $bitmap=New-Object Drawing.Bitmap(($rect.right-$rect.left),($rect.bottom-$rect.top))
            $graphics=[Drawing.Graphics]::FromImage($bitmap);$hdc=$graphics.GetHdc()
            try{if(![SampleCaptureWindows]::PrintWindow($simulator.MainWindowHandle,$hdc,2)){throw 'Simulator image capture failed.'}}finally{$graphics.ReleaseHdc($hdc);$graphics.Dispose()}
            try{$bitmap.Save($imagePath,[Drawing.Imaging.ImageFormat]::Png)}finally{$bitmap.Dispose()}
            $images+=[pscustomobject]@{product=$id;image=$imagePath;image_sha256=(Get-FileHash -LiteralPath $imagePath -Algorithm SHA256).Hash.ToLowerInvariant();sample_binary_sha256=(Get-FileHash -LiteralPath $program -Algorithm SHA256).Hash.ToLowerInvariant();width=[int]$frame.Groups[1].Value;height=[int]$frame.Groups[2].Value;visible_fields=[int]$frame.Groups[3].Value;enlarged_fields=1;enlarged_metric='power_3s';units_shown=$true;alignment='right';theme='day';data='synthetic sample ride; production formatting and renderer';log=$log}
            Write-Output ('Captured '+$id+': '+$frame.Groups[3].Value+' fields, '+$frame.Groups[1].Value+'x'+$frame.Groups[2].Value)
        } finally {
            if(!$runner.HasExited){
                $cleanupPreference=$ErrorActionPreference
                try{$ErrorActionPreference='Continue';& (Join-Path $env:SystemRoot 'System32/taskkill.exe') /PID $runner.Id /T /F 2>&1|Out-Null}finally{$ErrorActionPreference=$cleanupPreference}
            }
        }
    }
    $current=& (Join-Path $PSScriptRoot 'source-provenance.ps1')
    if($current.source_revision -ne $provenance.source_revision){throw 'Source changed during sample captures.'}
    [pscustomobject]@{source_revision=$provenance.source_revision;images=$images;runtime='normal Data Field sample fixture';production_builds_unchanged=$true;memory_tests_run=0;placement_tests_run=0;physical_acquisition='not qualified by synthetic samples';captured_at=[DateTime]::UtcNow.ToString('o')}|ConvertTo-Json -Depth 7|Set-Content -LiteralPath artifacts/sample-images.json -Encoding UTF8
} finally {Pop-Location}
