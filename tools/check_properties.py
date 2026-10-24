"""Check compact property owners and their field relations; no emulator."""
import json
import re
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
def validate_properties():
    def read(path):return json.loads((ROOT/path).read_text(encoding='utf-8-sig'))
    catalog=read('config/catalogue.json');binding=read('config/property-contracts.json')
    props={p['key']:p for p in catalog['properties']};fields={f['requirement'] for f in catalog['fields']}
    by={r['stable_id']:r for name in ['requirements/workspace-snapshot.json','requirements/supporting-approved-snapshot.json'] for r in read(name)}
    assert len(props)==75 and set(props)==set(binding['properties'])
    assert len({b['requirement'] for b in binding['properties'].values()})==75
    edges={(r['source_client_ref'][5:],r['target_client_ref'][5:],r['relation_code']) for r in read('requirements/export/workspace-spec-package.json')['relations']}
    for key,p in props.items():
        assert re.fullmatch('[a-z][a-z0-9_]{0,7}',key) and not p.get('hidden')
        b=binding['properties'][key];owner=b['requirement'];desc=by[owner]['description']
        assert by[owner]['work_item_type_code']=='requirement' and p['requirement']==owner
        assert f'Key: `{key}`.' in desc and f'Caption: {p["title"]}.' in desc
        assert 'Default: `'+json.dumps(p['default'])+'`.' in desc
        allowed='Boolean' if p['type']=='boolean' else ('String' if p['type']=='string' else 'Integer '+('..'.join([str(p['min']),str(p['max'])]) if 'min' in p else ', '.join(map(str,p['choices']))))
        assert 'Type/values: '+allowed+'.' in desc
        expected=set(b['fields']);assert expected and expected<=fields
        linked={t for s,t,k in edges if s==owner and k=='uses' and t in fields}
        mentions=set(re.findall(r'\[\[([A-Z]+-\d+)\]\]',desc))
        assert expected==linked==mentions&fields,('Property applicability drift',key)
        assert b['shared'] in mentions and (owner,b['shared'],'uses') in edges
        assert (binding['test'],owner,'verifies') in edges
    code=by[binding['field_codes']]['description']
    for n,f in enumerate(catalog['fields']):
        assert f'| {n} | {f["id"]} | [[{f["requirement"]}]] |' in code
        assert (binding['field_codes'],f['requirement'],'uses') in edges
    document=next(d for d in read('requirements/export/requirements.json')['documents'] if d['stable_id']==binding['document'])
    def placed(nodes):return [key for n in nodes for key in ([n.get('work_item_stable_id')]+placed(n['children'])) if key]
    assert {key for key in placed(document['outline']) if by[key]['status']!='obsolete'}=={binding['field_codes']}|{b['requirement'] for b in binding['properties'].values()}
    assert not set(placed(document['outline']))&fields
    return dict(properties=len(props),document=binding['document'],status='passed')
if __name__=='__main__':print(json.dumps(validate_properties(),indent=2))
