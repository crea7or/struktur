"""Prepare six isolated simulator apps; production sources are copied verbatim."""
import hashlib
import json
import re
from pathlib import Path
from generate_display_limits import fits,metrics,units
from header_text import unit_header

ROOT=Path(__file__).resolve().parents[1]

def read(path):return json.loads((ROOT/path).read_text('utf-8-sig'))
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def mc(value):
    if isinstance(value,dict):return '{'+','.join(json.dumps(k)+'=>'+mc(v) for k,v in value.items())+'}'
    if isinstance(value,list):return '['+','.join(mc(v) for v in value)+']'
    return json.dumps(value,ensure_ascii=False,separators=(',',':'))

def main():
    definition=read('validation/publishing/configurations.json');product=definition['product']
    device=next(d for d in read('config/devices.json') if d['id']==product)
    fields=read('config/catalogue.json')['fields'];catalog={f['id']:f for f in fields}
    props={p['key']:p['default'] for p in read('config/catalogue.json')['properties']}
    defaults=[fields[props[f'slot_{i}_value']]['id'] for i in range(1,11)]
    fonts={f['id']:f for f in read('config/font-manifest.json')['fonts']}
    label=fonts['Label'+str(device['label_font_reference'])];lm=metrics(label)
    out=ROOT/'.local/publishing-preview';source=out/'source';source.mkdir(parents=True,exist_ok=True)
    sources=[]
    for path in sorted((ROOT/'source').glob('*.mc')):
        content=path.read_bytes()
        if path.name=='StrukturApp.mc':
            assert content.count(b'_view=new StrukturField();')==1
            content=content.replace(b'_view=new StrukturField();',b'_view=new StorePreviewField();')
        (source/path.name).write_bytes(content)
        sources.append(dict(path=path.relative_to(ROOT).as_posix(),production_sha256=sha(path),preview_sha256=hashlib.sha256(content).hexdigest(),factory_changed=path.name=='StrukturApp.mc'))
    manifest=(ROOT/'manifest.xml').read_text('utf-8');app_id=re.search(r'<iq:application\s+id="([^"]+)"',manifest)[1]
    identities=[];covered=set()
    for index,config in enumerate(definition['configurations']):
        key=config['id'];directory=out/key;directory.mkdir(parents=True,exist_ok=True)
        settings=dict(config['settings']);selected=config['fields'];big=settings.get('enlarged_field_count',0)
        assert len(selected)==2*device['design_rows']-3*big==len(config['expected_primary'])==len(config['expected_secondary'])
        assert selected==defaults if index==0 else True
        assert 'temperature' not in config['raw'] and 'power_zone' not in config['raw']
        assert all(field in catalog for field in selected);covered.update(selected)
        if index:
            settings.update({f'slot_{i+1}_value':field for i,field in enumerate(selected)})
        headers=[]
        for slot,field_id in enumerate(selected):
            field=catalog[field_id];unit=units(field,config['statute'])
            header=unit_header(field,unit,not settings.get('hide_value_units',props['hide_value_units']))
            if field_id=='time_of_day' and not config['clock24']:header+=' | pm'
            headers.append(header)
            custom=field_id in {'grade','temperature','current_heart_rate','average_heart_rate','heart_rate_3s','current_power','power_3s','average_power'}
            effect=settings.get(f'slot_{slot+1}_background_effects',False) and (not custom or config['expected_primary'][slot] is not None)
            enlarged=slot<big;size=device['regular_font_reference'] if not enlarged else int(re.search(r'BIG_SIZE=(\d+)',(ROOT/'profiles'/product/'DeviceProfile.mc').read_text('utf-8'))[1])
            w=device['design_width'] if enlarged else device['design_width']//2;h=(2 if enlarged else 1)*device['design_height']//device['design_rows']
            assert fits(config['expected_primary'][slot] or '--',config['expected_secondary'][slot],header,metrics(fonts['Value'+str(size)]),lm,label['line_height'],w,h,int(effect),effect and field_id!='grade'),(key,field_id,'does not fit')
        code='module StoreConfig {\n'
        for name,value in dict(ID=key,WIDTH=device['design_width'],HEIGHT=device['design_height'],DEFAULT=index==0,STATUTE=config['statute'],CLOCK24=config['clock24'],PRIMARY=config['expected_primary'],SECONDARY=config['expected_secondary'],HEADERS=headers).items():code+='const '+name+' = '+mc(value)+';\n'
        code+='function settings() { return '+mc(settings)+'; }\nfunction raw() { return '+mc(config['raw'])+'; }\n}\n'
        (directory/'StoreConfig.mc').write_text(code,'utf-8')
        seed=''.join(r['preview_sha256'] for r in sources)+sha(ROOT/'config/font-manifest.json')+sha(ROOT/'validation/publishing/StorePreview.mc')+code+product
        preview_id=hashlib.sha256((app_id+seed).encode()).hexdigest()[:32]
        (directory/'manifest.xml').write_text(manifest.replace('id="'+app_id+'"','id="'+preview_id+'"',1),'utf-8')
        (directory/'preview.jungle').write_text('project.manifest = manifest.xml\nbase.sourcePath = ../source;../../../validation/publishing;.\nbase.resourcePath = ../../../resources/strings;../../../resources/settings;../../../resources/drawables\nbase.excludeAnnotations = test;testSupport\n'+product+'.sourcePath = $(base.sourcePath);../../../profiles/'+product+'\n'+product+'.resourcePath = $(base.resourcePath);../../../profiles/'+product+'/fonts\n','utf-8')
        identities.append(dict(id=key,application_id=preview_id,visible_fields=len(selected),jungle=(directory/'preview.jungle').relative_to(ROOT).as_posix(),headers=headers))
    assert len(identities)==6 and len({r['application_id'] for r in identities})==6 and covered==set(catalog)
    record=dict(product=product,scope=definition['scope'],sources=sources,configurations=identities,covered_fields=sorted(covered),unavailable_fields=['temperature','power_zone'],fixture_sha256=sha(ROOT/'validation/publishing/StorePreview.mc'),definition_sha256=sha(ROOT/'validation/publishing/configurations.json'))
    (ROOT/'artifacts/publishing-preview-inputs.json').write_text(json.dumps(record,indent=2)+'\n','utf-8')
    print('Prepared six isolated configurations; all 32 field types covered and every expected value/header fits.')

if __name__=='__main__':main()
