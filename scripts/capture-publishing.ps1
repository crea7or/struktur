param([int]$TimeoutSeconds=60)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'sdk-runner.ps1')
$projectRoot=Split-Path $PSScriptRoot -Parent
$environment=& (Join-Path $PSScriptRoot 'check-environment.ps1') -RequireKey
$env:JAVA_HOME=$environment.java_home
$env:PATH=(Join-Path $environment.java_home 'bin')+[IO.Path]::PathSeparator+$env:PATH
$definition=Get-Content -Raw -LiteralPath (Join-Path $projectRoot 'validation/publishing/configurations.json')|ConvertFrom-Json
$product=$definition.product
$targets=Get-Content -Raw -LiteralPath (Join-Path $projectRoot 'config/devices.json')|ConvertFrom-Json
$target=$targets|Where-Object{$_.id -eq $product}
$device=Get-Content -Raw -LiteralPath (Join-Path $environment.device_library ($product+'/simulator.json'))|ConvertFrom-Json
$location=$device.display.location
$python=Join-Path $projectRoot '.local/font-venv/Scripts/python.exe'
$provenance=& (Join-Path $PSScriptRoot 'source-provenance.ps1')
Push-Location -LiteralPath $projectRoot
try {
    & $python -X utf8 tools/prepare_publishing_screenshots.py
    if($LASTEXITCODE -ne 0){throw 'Publishing fixture preparation failed.'}
    New-Item -ItemType Directory -Path 'bin/publishing-preview','artifacts/publishing','dist/Struktur-publishing/screenshots' -Force|Out-Null
    Add-Type -AssemblyName System.Drawing
    Add-Type @'
using System;
using System.Text;
using System.Runtime.InteropServices;
public static class StoreCaptureWindows {
 public delegate bool WindowCallback(IntPtr hwnd,IntPtr arg);
 [DllImport("user32.dll")] public static extern bool EnumWindows(WindowCallback callback,IntPtr arg);
 [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr hwnd,out uint pid);
 [DllImport("user32.dll",CharSet=CharSet.Unicode)] public static extern int GetWindowText(IntPtr hwnd,StringBuilder text,int length);
 [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr hwnd);
 [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hwnd,int command);
 public static IntPtr SimulatorWindow(uint processId) {
  var found=IntPtr.Zero;
  EnumWindows((hwnd,arg)=>{
   uint owner;GetWindowThreadProcessId(hwnd,out owner);
   if(owner==processId) {
    var title=new StringBuilder(512);GetWindowText(hwnd,title,512);
    if(title.ToString().StartsWith("CIQ Simulator")) { found=hwnd;return false; }
   }
   return true;
  },IntPtr.Zero);
  // PrintWindow needs a rendered native surface. Reveal only this simulator,
  // without activating it or changing any other application window.
  if(found!=IntPtr.Zero && !IsWindowVisible(found)) ShowWindow(found,4);
  return found;
 }
 [StructLayout(LayoutKind.Sequential)] public struct POINT { public int x,y; }
 [DllImport("user32.dll")] public static extern bool ClientToScreen(IntPtr hwnd,ref POINT point);
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
    foreach($configuration in $definition.configurations){
        $id=$configuration.id
        $program=Join-Path $projectRoot ('bin/publishing-preview/'+$id+'.prg')
        $compilerLog=Join-Path $projectRoot ('artifacts/publishing/'+$id+'-compiler.log')
        $savedPreference=$ErrorActionPreference
        try {
            $ErrorActionPreference='Continue'
            $compilerOutput=& (Join-Path $environment.sdk 'bin/monkeyc.bat') -O 3z -f ('.local/publishing-preview/'+$id+'/preview.jungle') -d $product -o $program -y $environment.developer_key 2>&1
            $compilerExit=$LASTEXITCODE
        }finally{$ErrorActionPreference=$savedPreference}
        $compilerOutput|Set-Content -LiteralPath $compilerLog -Encoding UTF8
        if($compilerExit -ne 0){throw ('Publishing screenshot compilation failed: '+$id)}
        $log=Join-Path $projectRoot ('artifacts/publishing/'+$id+'-runtime.log')
        $err=Join-Path $projectRoot ('artifacts/publishing/'+$id+'-stderr.log')
        $java=Join-Path $environment.java_home 'bin/java.exe'
        $jar=Join-Path $environment.sdk 'bin/monkeybrains.jar'
        $sdkShell=Join-Path $environment.sdk 'bin/shell.exe'
        $arguments=@('-classpath',('"'+$jar+'"'),'com.garmin.monkeybrains.monkeydodeux.MonkeyDoDeux','-f',('"'+$program+'"'),'-d',$product,'-s',('"'+$sdkShell+'"'))
        $runner=[StrukturSdkRun]::Start($java,($arguments -join ' '),$projectRoot,$log,$err)
        $watch=[Diagnostics.Stopwatch]::StartNew();$selected=$false;$ready=$false;$simulator=$null;$window=[IntPtr]::Zero
        try {
            while($watch.Elapsed.TotalSeconds -lt $TimeoutSeconds){
                $simulator=Get-Process -Name simulator -ErrorAction SilentlyContinue|Where-Object{$_.Path -eq $sdkSimulator}|Select-Object -First 1
                if($simulator){$window=[StoreCaptureWindows]::SimulatorWindow([uint32]$simulator.Id)}
                if($window -ne [IntPtr]::Zero -and !$selected){
                    $command=[StoreCaptureWindows]::FullFieldCommand([StoreCaptureWindows]::GetMenu($window),'')
                    if($command -ge 0){[StoreCaptureWindows]::PostMessage($window,273,[IntPtr]$command,[IntPtr]::Zero)|Out-Null;$selected=$true}
                }
                $text=[string]$(if(Test-Path -LiteralPath $log){Get-Content -Raw -LiteralPath $log}else{''})
                if($text -match '(?m)^Error:|^Exception:'){throw ('Publishing screenshot runtime error: '+$id+'; '+$log)}
                $expected='STORE_OK id='+$id+' product='+$product+' width='+$target.design_width+' height='+$target.design_height+' fields='+$configuration.fields.Count
                if($window -ne [IntPtr]::Zero -and ![string]::IsNullOrEmpty($text) -and $text.Contains($expected)){$ready=$true;break}
                if($runner.HasExited){throw ('Publishing preview exited before a verified frame: '+$id)}
                Start-Sleep -Milliseconds 200
            }
            if(!$ready){throw ('No verified publishing frame: '+$id)}
            Start-Sleep -Milliseconds 1200
            $rect=New-Object StoreCaptureWindows+RECT
            $origin=New-Object StoreCaptureWindows+POINT
            if(![StoreCaptureWindows]::GetWindowRect($window,[ref]$rect) -or ![StoreCaptureWindows]::ClientToScreen($window,[ref]$origin)){throw 'Cannot resolve native screenshot rectangle.'}
            $bitmap=New-Object Drawing.Bitmap(($rect.right-$rect.left),($rect.bottom-$rect.top))
            $graphics=[Drawing.Graphics]::FromImage($bitmap);$hdc=$graphics.GetHdc()
            try{if(![StoreCaptureWindows]::PrintWindow($window,$hdc,2)){throw 'Publishing screenshot capture failed.'}}finally{$graphics.ReleaseHdc($hdc);$graphics.Dispose()}
            $image=Join-Path $projectRoot ('dist/Struktur-publishing/screenshots/'+$id+'.png')
            $full=Join-Path $projectRoot ('artifacts/publishing/'+$id+'-simulator.png')
            $x=$origin.x-$rect.left+$location.x;$y=$origin.y-$rect.top+$location.y
            if($x -lt 0 -or $y -lt 0 -or $x+$location.width -gt $bitmap.Width -or $y+$location.height -gt $bitmap.Height){throw 'Native image rectangle is outside simulator capture.'}
            $cropRect=New-Object Drawing.Rectangle($x,$y,$location.width,$location.height)
            $crop=$bitmap.Clone($cropRect,$bitmap.PixelFormat)
            try{$bitmap.Save($full,[Drawing.Imaging.ImageFormat]::Png);$crop.Save($image,[Drawing.Imaging.ImageFormat]::Png)}finally{$crop.Dispose();$bitmap.Dispose()}
            $images+=[pscustomobject]@{id=$id;product=$product;image=$image;image_sha256=(Get-FileHash -LiteralPath $image -Algorithm SHA256).Hash.ToLowerInvariant();source_capture=$full;source_sha256=(Get-FileHash -LiteralPath $full -Algorithm SHA256).Hash.ToLowerInvariant();crop_box=@($x,$y,($x+$location.width),($y+$location.height));width=$location.width;height=$location.height;visible_fields=$configuration.fields.Count;sample_binary=$program;sample_binary_sha256=(Get-FileHash -LiteralPath $program -Algorithm SHA256).Hash.ToLowerInvariant();log=$log;fields=$configuration.fields;settings=$configuration.settings}
            Write-Output ('Captured '+$id+': '+$configuration.fields.Count+' fields, '+$location.width+'x'+$location.height)
        }finally{
            $runner.Dispose()
        }
    }
    $current=& (Join-Path $PSScriptRoot 'source-provenance.ps1')
    if($current.source_revision -ne $provenance.source_revision){throw 'Source changed during publishing captures.'}
    [pscustomobject]@{source_revision=$provenance.source_revision;images=$images;runtime='normal Data Field display fixtures';scope=$definition.scope;memory_tests_run=0;placement_tests_run=0;captured_at=[DateTime]::UtcNow.ToString('o')}|ConvertTo-Json -Depth 9|Set-Content -LiteralPath artifacts/publishing-screenshots.json -Encoding UTF8
}finally{Pop-Location}
