"""Prepare a normal Data Field qualification build, preserving production files."""
import hashlib
import json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]

def digest(path):return hashlib.sha256(path.read_bytes()).hexdigest()

def main():
    output=ROOT/'.local/memory-source';output.mkdir(parents=True,exist_ok=True)
    records=[]
    for source in sorted((ROOT/'source').glob('*.mc')):
        content=source.read_bytes()
        if source.name=='StrukturApp.mc':
            original=b'_view=new StrukturField();'
            assert content.count(original)==1
            content=content.replace(original,b'_view=new MemoryValidationField();')
        target=output/source.name
        target.write_bytes(content)
        records.append(dict(production_path=source.relative_to(ROOT).as_posix(),
                            production_sha256=digest(source),qualification_sha256=digest(target),
                            changed=source.name=='StrukturApp.mc'))
    manifest=ROOT/'.local/memory-manifest.xml'
    manifest.write_bytes((ROOT/'manifest.xml').read_bytes())
    jungle=['project.manifest = .local/memory-manifest.xml',
            'base.sourcePath = .local/memory-source;validation/memory',
            'base.resourcePath = resources/strings;resources/settings;resources/drawables','base.excludeAnnotations = test']
    for product in json.loads((ROOT/'config/devices.json').read_text(encoding='utf-8-sig')):
        jungle.append(f'{product["id"]}.sourcePath = $(base.sourcePath);profiles/{product["id"]}')
        jungle.append(f'{product["id"]}.resourcePath = $(base.resourcePath);profiles/{product["id"]}/fonts')
    (ROOT/'memory.jungle').write_text('\n'.join(jungle)+'\n',encoding='utf-8')
    record=dict(runtime='normal datafield; no unit-test compiler/runner flags',
                factory_change='StrukturApp.getInitialView selects MemoryValidationField, a StrukturField subclass',
                production_sources=records,manifest_sha256=digest(manifest),
                jungle_sha256=digest(ROOT/'memory.jungle'),
                probe_sha256=digest(ROOT/'validation/memory/MemoryValidation.mc'),
                instrumentation='Same normal Data Field allocation; bounded counters/scenario driver; no bitmap buffer')
    (ROOT/'artifacts/datafield-memory-inputs.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
    print('Prepared normal Data Field qualification build; production files unchanged.')

if __name__=='__main__':main()
