$ErrorActionPreference='Stop'
$projectRoot=Split-Path $PSScriptRoot -Parent
$files=@()
foreach($relative in @('manifest.xml','monkey.jungle','memory.jungle','tests.jungle','logic-tests.jungle','memory-tests.jungle','placement-tests.jungle','source','profiles','resources','config','tests','validation','scripts','tools','assets','requirements\supporting-approved-baseline.json','requirements\supporting-approved-snapshot.json','requirements\baseline.json','requirements\workspace-snapshot.json','requirements\traceability.json')){
    $path=Join-Path $projectRoot $relative
    if(Test-Path -LiteralPath $path -PathType Container){$files+=@(Get-ChildItem -LiteralPath $path -File -Recurse)}
    else{$files+=Get-Item -LiteralPath $path}
}
$records=@($files|Where-Object{$_.FullName -notmatch '[\\/]__pycache__[\\/]' -and $_.Extension -notin @('.pem','.key','.der','.pyc')}|ForEach-Object{
    [PSCustomObject]@{path=$_.FullName.Substring($projectRoot.Length+1).Replace('\','/');sha256=(Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant()}
}|Sort-Object path)
$canonical=($records|ForEach-Object{$_.path+"`t"+$_.sha256})-join "`n"
$algorithm=[Security.Cryptography.SHA256]::Create()
try{$revision=[BitConverter]::ToString($algorithm.ComputeHash([Text.Encoding]::UTF8.GetBytes($canonical))).Replace('-','').ToLowerInvariant()}
finally{$algorithm.Dispose()}
[PSCustomObject]@{source_revision=$revision;files=$records;scope='Build inputs and current working requirement snapshot with recorded states; generated outputs and signing secrets excluded.'}
