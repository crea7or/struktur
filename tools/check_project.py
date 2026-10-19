"""Check real project inputs; this is not Monkey C execution or device qualification."""
from field_metadata import field_attributes
import hashlib
import json
import re
import xml.etree.ElementTree as ET
from pathlib import Path
from font_glyphs import glyph_contract
from validate_fonts import validate_manifest
from check_test_suites import validate_suites
from check_properties import validate_properties
from check_requirement_ownership import validate_ownership
from generate_display_limits import outputs as display_limit_outputs

ROOT=Path(__file__).resolve().parents[1]
def read(path):return json.loads((ROOT/path).read_text(encoding='utf-8-sig'))
def main():
    validate_suites()
    validate_properties()
    validate_ownership()
    for name, expected in display_limit_outputs().items():
        assert (ROOT/name).read_text(encoding='utf-8')==expected, 'Stale display limits: '+name
    items=read('requirements/workspace-snapshot.json');baseline=read('requirements/baseline.json')
    by_id={i['stable_id']:i for i in items}
    assert len(by_id)==len(items)==baseline['requirement_count']
    assert all(i['work_item_type_code']=='requirement' and i['status'] in {'approved','draft','obsolete'} for i in items)
    assert {entry['stable_id'] for entry in baseline['requirements']}==set(by_id)
    assert hashlib.sha256((ROOT/'requirements/workspace-snapshot.json').read_bytes()).hexdigest()==baseline['snapshot_sha256']
    for entry in baseline['requirements']:
        item=by_id[entry['stable_id']]
        assert entry['head_change_seq']==item['head_change_seq']
        assert item['status']==entry['status']
        assert entry['description_sha256']==hashlib.sha256(item['description'].encode()).hexdigest()
    # Development can track reviewed changes in Draft; build.ps1 separately
    # requires every current requirement to be Approved for release/package.
    contracts=read('config/acquisition-contracts.json')
    assert contracts['requirement_revisions']=={k:by_id[k]['head_change_seq'] for k in ['DVS-29','DVS-34','DVS-39']}
    assert contracts['grade']==dict(maximum_samples=5,minimum_regression_samples=3,warmup_grade=0,canonical_decimal_places=2,stationary_reset_s=3,maximum_sample_gap_ms=2000,display_decimal_places=1,temporal_average_samples=5,temporal_average_initial_value=0,temporal_average_divisor=5,sample_basis='distinct_distance',same_distance='replace_latest_altitude_without_advancing_windows',replacement_preserves_admission_time=True)
    assert contracts['temperature']==dict(background_interval_s=300,maximum_read_cache_age_s=360,onboard_only=True,unverified_source='unavailable')
    supporting=read('requirements/supporting-approved-snapshot.json')
    support_baseline=read('requirements/supporting-approved-baseline.json')
    assert len(supporting)==support_baseline['record_count']
    assert hashlib.sha256((ROOT/'requirements/supporting-approved-snapshot.json').read_bytes()).hexdigest()==support_baseline['snapshot_sha256']
    support_by_id={r['stable_id']:r for r in supporting}
    for entry in support_baseline['records']:
        item=support_by_id[entry['stable_id']]
        assert item['status']==entry['status'] and item['head_change_seq']==entry['head_change_seq']
        assert hashlib.sha256(item['description'].encode()).hexdigest()==entry['description_sha256']
    assert {'SPEC-176','SPEC-177'} <= set(by_id)
    trace=read('requirements/traceability.json')
    assert len(trace)==len(by_id) and {row['requirement'] for row in trace}==set(by_id)
    assert all(row['version_seq']==by_id[row['requirement']]['head_change_seq'] for row in trace)
    assert all(row.get('status')==by_id[row['requirement']]['status'] for row in trace)
    assert all((ROOT/path).exists() for row in trace for group in ['source','verification'] for path in row.get(group,[]))
    glyph_trace=[row for row in trace if row['requirement'] in {'SPEC-176','SPEC-177'}]
    assert {row['requirement'] for row in glyph_trace}=={'SPEC-176','SPEC-177'}
    assert all((ROOT/path).exists() for row in glyph_trace for group in ['source','verification'] for path in row[group])
    catalogue=read('config/catalogue.json');fields=catalogue['fields'];props=catalogue['properties']
    for field in fields:
        if field['format']=='text':
            assert field['id']=='team' and field['label']=='team' and field['rendered_label']=='team' and field['unit']=='';continue
        attrs=field_attributes(by_id[field['requirement']])
        assert field['label']==attrs['LABEL'],field['requirement']
        expected=attrs['LABEL_AND_UNIT'] or None
        if expected=='""':expected=''
        assert field.get('header_with_units')==expected,field['requirement']
    catalogue_source=(ROOT/'source/Catalog.mc').read_text(encoding='utf-8')
    assert json.loads(re.search(r'const HEADERS_WITH_UNITS = (.*);',catalogue_source)[1])==[f.get('header_with_units') for f in fields]
    for field in fields:
        if field['format']=='text':continue
        assert field['label']==field_attributes(by_id[field['requirement']])['LABEL']
        assert 'unit_label' not in field
    expected={f'DVS-{i}' for i in [8,9,10,11,*range(18,38),39,47]} | {f'FUNC-{i}' for i in range(3,9)} | {'SPEC-253'}
    assert len(fields)==len({f['id'] for f in fields})==len(expected)==33
    assert [f['id'] for f in fields[26:32]]==['lap_distance','lap_time','lap_speed','lap_heart_rate','lap_power','lap_cadence']
    assert fields[22]['format']=='integer'
    assert {f['requirement'] for f in fields}==expected
    assert len(props)==len({p['key'] for p in props})==63
    assert all(re.fullmatch('[a-z][a-z0-9_]{0,7}',p['key']) and not p.get('hidden') for p in props)
    by_key={p['key']:p for p in props}
    for first in [p for p in props if re.match(r'a(?:_|[0-9])',p['key'])]:
        second=by_key['b'+first['key'][1:]]
        for attr in ['type','choices','identifiers']:assert first.get(attr)==second.get(attr)
    assert by_key['a_align']['default']==1 and by_key['b_big']['default']==1
    assert by_key['trig']['choices']==[0,1,2,3,4] and by_key['trig']['default']==3
    tree=ET.parse(ROOT/'resources/settings/properties.xml');xml={p.attrib['id']:p for p in tree.findall('.//property')}
    assert set(xml)==set(by_key)
    settings=ET.parse(ROOT/'resources/settings/settings.xml');controls=settings.findall('.//setting')
    configured={s.attrib['propertyKey'].split('.')[-1]:s for s in controls}
    assert len(controls)==63 and set(configured)==set(by_key)
    group=settings.find('.//group[@id="second_field_set"]')
    assert [s.attrib['propertyKey'].split('.')[-1] for s in group.findall('setting')]==[p['key'] for p in props if p['key'] in ['trig','p_on','p_off','hr_on','hr_off'] or p['key'].startswith('b')]
    shared=['team','tsrc'];order=list(configured)
    assert [p['key'] for p in props if p.get('shared')]==shared
    assert order[6:8]==shared and all(order.index(k)<order.index('a1') for k in shared)
    assert [p['key'] for p in props if p['type']=='string']==['team']
    strings={x.attrib['id']:x.text for x in ET.parse(ROOT/'resources/strings/strings.xml').findall('.//string')}
    for p in props:
        key=p['key'];control=configured[key]
        assert xml[key].attrib['type']==p['type']
        assert xml[key].text==(str(p['default']).lower() if p['type']=='boolean' else str(p['default']))
        assert [x.attrib['value'] for x in control.findall('.//listEntry')]==[str(x) for x in p.get('choices',[])]
        match=re.fullmatch(r'([ab])(\d+)(_bg)?',key)
        if match:assert strings[control.attrib['title'].split('.')[-1]]==('Second set: ' if match[1]=='b' else '')+'Slot '+match[2]+(': background' if match[3] else ': value')
        if key.endswith('_bg'):assert p['choices']==[0,1,2] and p['default']==(1 if key in ['b1_bg','b2_bg','b3_bg','b4_bg'] else 0)
    assert [by_key['a'+str(i)]['identifiers'][by_key['a'+str(i)]['default']] for i in range(1,11)]==['current_speed','distance','activity_timer','time_of_day','current_heart_rate','power_3s','elevation','grade','total_ascent','temperature']
    assert [by_key['b'+str(i)]['identifiers'][by_key['b'+str(i)]['default']] for i in range(1,11)]==['power_3s','current_heart_rate','current_cadence','grade','lap_power','current_speed','lap_distance','lap_time','elevation','temperature']
    assert by_key['team']['maxLength']==32 and 'tfont' not in by_key
    devices=read('config/devices.json');manifest=ET.parse(ROOT/'manifest.xml');ns={'iq':'http://www.garmin.com/xml/connectiq'}
    app=manifest.find('iq:application',ns);assert app.attrib['type']=='datafield'
    assert {p.attrib['id'] for p in app.findall('iq:products/iq:product',ns)}=={p['id'] for p in devices}
    assert len(devices)==9 and all(d['datafield_ceiling_bytes']==131072 and not d['release_supported'] for d in devices)
    for d in devices:
        assert (ROOT/'profiles'/d['id']/'DeviceProfile.mc').exists()
        profile=(ROOT/'profiles'/d['id']/'DeviceProfile.mc').read_text(encoding='utf-8')
        table=re.search(r'\| Edge '+d['id'][4:]+r' \|[^\n]+',by_id['APP-24']['description']).group(0).split('|')
        expected=dict(DESIGN_ROWS=int(table[4].strip()),BIG_SIZE=int(table[5].strip().removesuffix('px')),
                      REGULAR_SIZE=int(table[6].strip().removesuffix('px')),LABEL_SIZE=int(table[7].strip().removesuffix('px')))
        for name,value in expected.items():
            assert int(re.search(name+r'=(\d+)',profile).group(1))==value,(d['id'],name,value)
        assert d['regular_font_reference']==expected['REGULAR_SIZE'] and d['label_font_reference']==expected['LABEL_SIZE']
        assert f'{d["id"]}.sourcePath' in (ROOT/'monkey.jungle').read_text()
        assert f'{d["id"]}.sourcePath' in (ROOT/'tests.jungle').read_text()
    fonts=read('config/font-manifest.json')
    expected_fonts=set()
    for d in devices:
        profile=(ROOT/'profiles'/d['id']/'DeviceProfile.mc').read_text(encoding='utf-8')
        for role,prefix in [('BIG_SIZE','Value'),('REGULAR_SIZE','Value'),('LABEL_SIZE','Label')]:
            expected_fonts.add(prefix+re.search(role+r'=(\d+)',profile).group(1))
    assert {f['id'] for f in fonts['fonts']}==expected_fonts
    validate_manifest()
    contract=glyph_contract()
    for name,metadata in fonts['assets'].items():assert hashlib.sha256((ROOT/'assets/fonts'/name).read_bytes()).hexdigest()==metadata['sha256']
    for font in fonts['fonts']:
        fnt=ROOT/'resources/fonts'/(font['id']+'.fnt');png=ROOT/'resources/fonts'/(font['id']+'.png')
        assert hashlib.sha256(fnt.read_bytes()).hexdigest()==font['fnt_sha256']
        assert hashlib.sha256(png.read_bytes()).hexdigest()==font['png_sha256']
        text=fnt.read_text();assert 'pages=1' in text and 'unicode=1' in text
        ids={int(x) for x in re.findall(r'^char id=(\d+)',text,re.M)}
        assert ids=={ord(ch) for ch in font['glyphs']}
        role='numeric' if font['id'].startswith('Value') else 'label'
        assert ids=={ord(ch) for ch in contract[role+'_glyphs']}
        assert png.read_bytes()[24:26]==bytes([1,3])
        assert all(int(x)+int(w)<=font['width'] for x,w in re.findall(r'\bx=(\d+) .*?width=(\d+)',text))
    for path in (ROOT/'resources').rglob('*.xml'):ET.parse(path)
    strings=ET.parse(ROOT/'resources/strings/strings.xml').findall('.//string')
    assert all(s.attrib.get('scope')=='settings' for s in strings if s.attrib['id']!='AppName')
    assert all(x.get('execution_result') for x in trace)
    tests='\n'.join(path.read_text() for path in (ROOT/'tests').glob('*.mc'))
    test_names=re.findall(r'\(:test\)\s*function\s+(\w+)\(',tests)
    assert len(test_names)==len(set(test_names))
    regression_cases=read('tests/correctness-cases.json')
    assert {row['fixture'] for row in regression_cases} <= set(test_names)
    font_tests=(ROOT/'tests/FontTests.mc').read_text()
    assert 'FontSelection.info(DeviceProfile.BIG_SIZE,false)' in font_tests
    assert 'FontSelection.info(DeviceProfile.REGULAR_SIZE,false)' in font_tests
    assert 'FontSelection.info(DeviceProfile.LABEL_SIZE,true)' in font_tests
    assert all(len(r['numeric_sizes'])==2 and len(r['label_sizes'])==1 for r in fonts['profile_metrics'].values())
    production='\n'.join(p.read_text(encoding='utf-8') for p in (ROOT/'source').glob('*.mc'))
    assert 'Toybox.Weather' not in production
    for path in (ROOT/'source').glob('*.mc'):
        if path.name!='Temperature.mc':assert 'Sensor.getInfo(' not in path.read_text(encoding='utf-8')
    temperature=(ROOT/'source/Temperature.mc').read_text(encoding='utf-8')
    assert '(:background)\nclass TemperatureService' in temperature
    assert temperature.count('Sensor.getInfo(')==1
    assert 'enableSensorEvents' not in production and 'setEnabledSensors' not in production
    app_source=(ROOT/'source/StrukturApp.mc').read_text(encoding='utf-8')
    assert 'function onStart(state) {}' in app_source
    assert app_source.index('new TemperatureCache()')>app_source.index('function onBackgroundData')
    assert {p.attrib['id'] for p in app.findall('iq:permissions/iq:uses-permission',ns)}=={'UserProfile','Background','Sensor'}
    assert 'Math.abs(' not in production+tests
    assert 'Graphics.COLOR_CYAN' not in production
    assert 'loadResource' not in production.split('function draw(dc,snapshot,settings) {',1)[1].split('\n}',1)[0]
    draw=(ROOT/'source/FieldRenderer.mc').read_text(encoding='utf-8').split('function draw(dc,snapshot,settings) {',1)[1]
    assert not any(call in draw for call in ['Math.','FontMetrics.','Formatting.','MaskedText.prepare(', 'color(', 'effectiveNight(', 'fitRun(', 'getWidth(', 'getHeight(', 'getSystemStats('])
    assert 'var enabled=false;' in (ROOT/'source/RuntimeMetrics.mc').read_text(encoding='utf-8')
    assert 'RuntimeMetrics.enabled=true;' in (ROOT/'validation/memory/MemoryValidation.mc').read_text(encoding='utf-8')
    assert all((ROOT/path).exists() for row in trace for path in row['source'])
    assert 'const PAD_LEADING_MINUTES = null' in production or 'const PAD_LEADING_MINUTES = true' in production or 'const PAD_LEADING_MINUTES = false' in production
    result=dict(status='passed project input consistency checks',reviewed_workspace_requirements=len(by_id),approved_requirements=sum(r['status']=='approved' for r in by_id.values()),approved_supporting_records=sum(r['status']=='approved' for r in supporting),draft_requirements=[r['stable_id'] for r in by_id.values() if r['status']=='draft'],candidate_products=9,
                settings=len(props),selectable_values=len(fields),verified_font_assets=2,generated_font_atlases=len(fonts['fonts']),
                planned_monkeyc_test_functions=tests.count('(:test)'),monkeyc_compilation='not run',
                simulator_tests='not run',physical_tests='not run',resource_memory='not measured')
    proof_path=ROOT/'artifacts/build-results.json'
    inputs_path=ROOT/'artifacts/build-inputs.json'
    if proof_path.exists() and inputs_path.exists():
        proof=read('artifacts/build-results.json');inputs=read('artifacts/build-inputs.json')
        current=proof['source_revision']==inputs['source_revision'] and all(hashlib.sha256((ROOT/f['path']).read_bytes()).hexdigest()==f['sha256'] for f in inputs['files'])
        if current:
            built=[p for p in proof['products'] if p['status']=='passed' and hashlib.sha256(Path(p['binary']).read_bytes()).hexdigest()==p['binary_sha256']]
            result['monkeyc_compilation']=dict(passed_products=[p['product'] for p in built],compiler=proof['compiler'])
            suites=[]
            for device in devices:
                report=ROOT/'artifacts'/(device['id']+'-core-tests.json')
                if report.exists():
                    suite=json.loads(report.read_text(encoding='utf-8-sig'))
                    if suite['source_revision']==proof['source_revision'] and suite['status']=='passed':suites.append(dict(product=device['id'],tests=suite['test_count']))
            result['simulator_tests']=dict(passed_suites=suites,scope='Current-revision core/typography/presentation/acquisition logic suites. FontTests.mc excluded; no memory tests. Full native scenario and physical qualification remain separate.')
        else:
            result['monkeyc_compilation']='previous evidence exists; current inputs differ'
    output=ROOT/'artifacts';output.mkdir(exist_ok=True)
    (output/'project-checks.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(result,indent=2))

if __name__=='__main__':main()
