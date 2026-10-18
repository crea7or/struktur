"""Check real project inputs; this is not Monkey C execution or device qualification."""
import hashlib
import json
import re
import xml.etree.ElementTree as ET
from pathlib import Path
from font_glyphs import glyph_contract
from validate_fonts import validate_manifest
from check_test_suites import validate_suites
from generate_display_limits import outputs as display_limit_outputs

ROOT=Path(__file__).resolve().parents[1]
def read(path):return json.loads((ROOT/path).read_text(encoding='utf-8-sig'))
def main():
    validate_suites()
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
    assert contracts['grade']==dict(maximum_samples=5,minimum_regression_samples=3,warmup_grade=0,canonical_decimal_places=2,stationary_reset_s=3,maximum_sample_gap_ms=2000,temporal_average_samples=3,temporal_average_period_s=1,temporal_average_warmup='mean of available estimates; regression warm-up zeros excluded',temporal_average_gap='clear on nonconsecutive elapsed-second buckets',display_decimal_places=1)
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
        description=by_id[field['requirement']]['description']
        assert field['label']==re.search(r'Label text:\s*`([^`]*)`',description)[1],field['requirement']
        header=re.search(r'Header text with units:\s*`([^`]*)`',description)
        expected=header[1] if header else None
        if expected=='""':expected=''
        assert field.get('header_with_units')==expected,field['requirement']
    catalogue_source=(ROOT/'source/Catalog.mc').read_text(encoding='utf-8')
    assert json.loads(re.search(r'const HEADERS_WITH_UNITS = (.*);',catalogue_source)[1])==[f.get('header_with_units') for f in fields]
    for field in fields:
        if field['format']=='text':continue
        assert field['label']==re.search(r'Label text:\s*`([^`]*)`',by_id[field['requirement']]['description']).group(1)
        assert 'unit_label' not in field
    expected={f'DVS-{i}' for i in [8,9,10,11,*range(18,38),39,47]} | {f'FUNC-{i}' for i in range(3,9)} | {'SPEC-253'}
    assert len(fields)==len({f['id'] for f in fields})==len(expected)==33
    assert [f['id'] for f in fields[26:32]]==['lap_distance','lap_time','lap_speed','lap_heart_rate','lap_power','lap_cadence']
    assert fields[22]['format']=='integer'
    assert {f['requirement'] for f in fields}==expected
    assert len(props)==142 and len({p['key'] for p in props})==142
    assert next(p for p in props if p['key']=='alignment')['default']==1
    assert all(next(p for p in props if p['key']==key)['default'] is True for key in ['hide_value_units','inverse_enlarged_theme'])
    assert 'grid_type' in by_id['APP-22']['description'] and '0 None, 1 Horizontal lines (default), 2 Full grid' in by_id['APP-22']['description']
    grid=next(p for p in props if p['key']=='grid_type')
    assert grid['default']==1 and grid['choices']==[0,1,2] and grid['identifiers']==['none','horizontal','full']
    assert all(next(p for p in props if p['key']==f'slot_{slot}_background_effects')['default'] is False for slot in range(1,11))
    assert 'slot_N_background_mode' in by_id['APP-49']['description'] and '0 None, 1 Label, 2 Whole cell' in by_id['APP-49']['description']
    assert {'field_count','use_units_as_labels','show_grid'}.isdisjoint(p['key'] for p in props)
    by_key={p['key']:p for p in props}
    for first in [p for p in props if not p['key'].startswith('second_') and p['key']!='settings_schema_version' and not p['key'].startswith('cadence_zone_')]:
        second=by_key['second_'+first['key']]
        for field in ['type','choices','identifiers']:
            assert first.get(field)==second.get(field),(first['key'],field)
    secondary=['power_3s','current_heart_rate','current_cadence','grade','lap_power','current_speed','lap_distance','lap_time','elevation','temperature']
    assert by_key['second_enlarged_field_count']['default']==1
    for i,identifier in enumerate(secondary,1):
        prop=by_key[f'second_slot_{i}_value']
        assert prop['identifiers'][prop['default']]==identifier
        assert by_key[f'second_slot_{i}_background_effects']['default']==(i<=4)
        assert f'| {i} | {identifier} |' in by_id['SPEC-209']['description']
    for first in [p for p in props if not p['key'].startswith('second_') and p['key']!='settings_schema_version' and not p['key'].startswith('cadence_zone_')]:
        if first['key'] in ['alignment','theme_mode','hide_value_units','inverse_enlarged_theme','grid_type']:
            assert by_key['second_'+first['key']]['default']==first['default']
    assert by_key['second_set_trigger']['choices']==[0,1,2,3,4] and by_key['second_set_trigger']['default']==3
    tree=ET.parse(ROOT/'resources/settings/properties.xml')
    xml={p.attrib['id']:p for p in tree.findall('.//property')}
    assert set(xml)=={p['key'] for p in props}
    for p in props:
        assert xml[p['key']].attrib['type']==p['type']
        expected_default=('true' if p['default'] else 'false') if p['type']=='boolean' else str(p['default'])
        assert xml[p['key']].text==expected_default
    settings=ET.parse(ROOT/'resources/settings/settings.xml')
    group=settings.find('.//group[@id="second_field_set"]');assert group is not None and group.attrib['id']=='second_field_set'
    assert [n.attrib['propertyKey'].split('.')[-1] for n in group.findall('setting')]==[p['key'] for p in props if p['key'].startswith('second_') and not p.get('hidden')]
    assert len(settings.findall('./settings/setting'))==56
    configured={s.attrib['propertyKey'].split('.')[-1]:s for s in settings.findall('.//setting')}
    assert set(configured)=={p['key'] for p in props if not p.get('hidden')}
    native_fonts=read('config/native-fonts.json')
    assert len(native_fonts['profiles'])==9 and all(not row['offered_aux'] for row in native_fonts['profiles'].values())
    assert native_fonts['logical_aux_codes']=={str(i):f'FONT_AUX{i}' for i in range(1,10)}
    for p in props:
        if p['key'].endswith('_team_font'):assert p['default']==0 and p['choices']==[0]
        if p['key'].endswith('_team_text'):assert p['default']=='TEAM' and p['type']=='string' and p['maxLength']==32
    native_fonts=read('config/native-fonts.json')
    assert len(native_fonts['profiles'])==9 and all(not row['offered_aux'] for row in native_fonts['profiles'].values())
    assert native_fonts['logical_aux_codes']=={str(i):f'FONT_AUX{i}' for i in range(1,10)}
    for p in props:
        if p['key'].endswith('_team_font'):assert p['default']==0 and p['choices']==[0]
        if p['key'].endswith('_team_text'):assert p['default']=='TEAM' and p['type']=='string' and p['maxLength']==32
    assert len(configured)==121 and len(props)-len(configured)==21
    assert by_key['settings_schema_version']['default']==0
    for p in props:
        if p['key'].endswith('_background_mode'):
            assert p['choices']==[0,1,2] and p['default']==-1 and p['factory_default'] in [0,1]
        if p['key'].endswith('_background_effects'):assert p['hidden'] and p['type']=='boolean'
    for p in props:
        if p.get('hidden'):continue
        entries=[x.attrib['value'] for x in configured[p['key']].findall('.//listEntry')]
        assert entries==[str(x) for x in p.get('choices',[])]
        if 'identifiers' in p:
            assert p['type']=='number'
            assert len(p['identifiers'])==len(p['choices'])
    assert [p['identifiers'][p['default']] for p in props if p['key'] in [f'slot_{i}_value' for i in range(1,11)]]==['current_speed','distance','activity_timer','time_of_day','current_heart_rate','power_3s','elevation','grade','total_ascent','temperature']
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
