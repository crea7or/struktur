"""Prepare a normal Data Field qualification build, preserving production files."""
import argparse
import hashlib
import json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]

def digest(path):return hashlib.sha256(path.read_bytes()).hexdigest()

def main():
    parser=argparse.ArgumentParser();parser.add_argument("--scenario",choices=["native","matrix","switching"],default="matrix");scenario=parser.parse_args().scenario
    field={"native":"MemoryNativeField","matrix":"MemoryValidationField","switching":"MemorySwitchingField"}[scenario]
    folder={'native':'memory-native-source','matrix':'memory-source','switching':'memory-switching-source'}[scenario]
    output=ROOT/'.local'/folder;output.mkdir(parents=True,exist_ok=True)
    # Drop stale generated source files after production renames.
    for stale in output.glob('*.mc'):
        if not (ROOT/'source'/stale.name).is_file():stale.unlink()
    records=[]
    for source in sorted((ROOT/'source').glob('*.mc')):
        content=source.read_bytes()
        if source.name=='StrukturApp.mc':
            original=b'_view=new StrukturField();'
            assert content.count(original)==1
            content=content.replace(original,('_view=new '+field+'();').encode())
        target=output/source.name
        target.write_bytes(content)
        records.append(dict(production_path=source.relative_to(ROOT).as_posix(),
                            production_sha256=digest(source),qualification_sha256=digest(target),
                            changed=source.name=='StrukturApp.mc'))
    manifest=ROOT/'.local/memory-manifest.xml'
    manifest.write_bytes((ROOT/'manifest.xml').read_bytes())
    jungle=['project.manifest = .local/memory-manifest.xml',
            'base.sourcePath = .local/'+folder+';validation/memory',
            'base.resourcePath = resources/strings;resources/settings;resources/drawables','base.excludeAnnotations = test;'+{'native':'memoryMatrix;memorySwitch;memoryFixture','matrix':'memorySwitch;memoryNative','switching':'memoryMatrix;memoryNative'}[scenario]]
    for product in json.loads((ROOT/'config/devices.json').read_text(encoding='utf-8-sig')):
        jungle.append(f'{product["id"]}.sourcePath = $(base.sourcePath);profiles/{product["id"]}')
        jungle.append(f'{product["id"]}.resourcePath = $(base.resourcePath);profiles/{product["id"]}/fonts')
    jungle_path=ROOT/{'native':'memory-native.jungle','matrix':'memory.jungle','switching':'memory-switching.jungle'}[scenario]
    jungle_path.write_text('\n'.join(jungle)+'\n',encoding='utf-8')
    record=dict(runtime='normal datafield; no unit-test compiler/runner flags',
                scenario=scenario,factory_change='StrukturApp.getInitialView selects '+field+', a StrukturField subclass',
                production_sources=records,manifest_sha256=digest(manifest),
                jungle_path=jungle_path.name,jungle_sha256=digest(jungle_path),qualification_source_folder='.local/'+folder,
                probe_sha256=digest(ROOT/'validation/memory/MemoryValidation.mc'),
                switching_probe_sha256=digest(ROOT/'validation/memory/MemorySwitching.mc'),
                observer_sha256=digest(ROOT/'validation/memory/MemoryObservation.mc'),
                native_probe_sha256=digest(ROOT/'validation/memory/MemoryNative.mc'),
                instrumentation='Same normal Data Field allocation; bounded counters/scenario driver; no bitmap buffer')
    (ROOT/'artifacts'/('datafield-memory-'+scenario+'-inputs.json')).write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
    print('Prepared normal Data Field qualification build; production files unchanged.')

if __name__=='__main__':main()
