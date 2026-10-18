"""Prepare a sample-data Data Field using otherwise identical production code."""
import hashlib
import json
import re
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]


def main():
    output=ROOT/'.local/sample-source';output.mkdir(parents=True,exist_ok=True)
    # Drop stale generated source files after production renames.
    for stale in output.glob('*.mc'):
        if not (ROOT/'source'/stale.name).is_file():stale.unlink()
    records=[]
    for source in sorted((ROOT/'source').glob('*.mc')):
        content=source.read_bytes()
        if source.name=='StrukturApp.mc':
            assert content.count(b'_view=new StrukturField();')==1
            content=content.replace(b'_view=new StrukturField();',b'_view=new SamplePreviewField();')
        target=output/source.name;target.write_bytes(content)
        records.append(dict(path=source.relative_to(ROOT).as_posix(),production_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),sample_sha256=hashlib.sha256(content).hexdigest(),factory_changed=source.name=='StrukturApp.mc'))
    manifest=(ROOT/'manifest.xml').read_text('utf-8')
    original=re.search(r'<iq:application\s+id="([^"]+)"',manifest)[1]
    jungle=['base.sourcePath = sample-source;../validation/visual',
            'base.resourcePath = ../resources/strings;../resources/settings;../resources/drawables',
            'base.excludeAnnotations = test;testSupport']
    devices=json.loads((ROOT/'config/devices.json').read_text('utf-8'))
    for device in devices:
        jungle.extend([device['id']+'.sourcePath = $(base.sourcePath);../profiles/'+device['id'],device['id']+'.resourcePath = $(base.resourcePath);../profiles/'+device['id']+'/fonts'])
    # Isolate the simulator's app/resource caches across devices and revisions.
    seed=''.join(r['sample_sha256'] for r in records)+(ROOT/'config/font-manifest.json').read_text('utf-8')
    seed+=(ROOT/'validation/visual/SamplePreview.mc').read_text('utf-8')
    identities={}
    for device in devices:
        product=device['id'];profile=(ROOT/'profiles'/product/'DeviceProfile.mc').read_text('utf-8')
        sample_id=hashlib.sha256((original+':sample-preview-v2:'+product+seed+profile).encode()).hexdigest()[:32]
        identities[product]=sample_id
        name='sample-manifest-'+product+'.xml'
        (ROOT/'.local'/name).write_text(manifest.replace('id="'+original+'"','id="'+sample_id+'"',1),'utf-8')
        (ROOT/'.local'/('sample-preview-'+product+'.jungle')).write_text('\n'.join(['project.manifest = '+name]+jungle)+'\n','utf-8')
    result=dict(scope='Synthetic sample ride; normal Data Field runtime using production formatting/rendering. No memory probes, physical acquisition qualification or persisted settings writes.',sample_application_ids=identities,sources=records,fixture_sha256=hashlib.sha256((ROOT/'validation/visual/SamplePreview.mc').read_bytes()).hexdigest())
    (ROOT/'artifacts').mkdir(exist_ok=True)
    (ROOT/'artifacts/sample-preview-inputs.json').write_text(json.dumps(result,indent=2)+'\n','utf-8')
    print('Prepared sample preview; production code unchanged except isolated view-factory substitution.')


if __name__=='__main__':main()
