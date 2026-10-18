"""Fail-closed evidence check for the normal Data Field memory runner."""
import argparse
import hashlib
import json
import re
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]

def digest(path):return hashlib.sha256(path.read_bytes()).hexdigest()

def read(path):return json.loads((ROOT/path).read_text(encoding='utf-8-sig'))

def main():
    parser=argparse.ArgumentParser();parser.add_argument('-Product',required=True);parser.add_argument('--scenario',choices=['matrix','switching'],default='matrix')
    args=parser.parse_args();product=args.Product;scenario=args.scenario
    stem='memory' if scenario=='matrix' else 'memory-switching'
    source=read('artifacts/datafield-memory-source.json')
    for item in source['files']:
        assert digest(ROOT/item['path'])==item['sha256'], 'Source changed during memory run: '+item['path']
    inputs=read('artifacts/datafield-memory-'+scenario+'-inputs.json')
    assert inputs['manifest_sha256']==digest(ROOT/'manifest.xml')
    assert inputs['jungle_sha256']==digest(ROOT/inputs['jungle_path'])
    assert inputs['probe_sha256']==digest(ROOT/'validation/memory/MemoryValidation.mc')
    assert inputs['switching_probe_sha256']==digest(ROOT/'validation/memory/MemorySwitching.mc')
    for item in inputs['production_sources']:
        assert digest(ROOT/item['production_path'])==item['production_sha256']
        assert digest(ROOT/inputs['qualification_source_folder']/Path(item['production_path']).name)==item['qualification_sha256']
        if not item['changed']:assert item['production_sha256']==item['qualification_sha256']
    log=ROOT/'artifacts'/(product+'-'+stem+'.log')
    text=log.read_text(encoding='utf-8-sig')
    assert not re.search(r'DF_MEMORY_FAIL|Encountered an app crash|Unhandled Exception|Out Of Memory|OutOfMemory|Stack Overflow|StackOverflow|Watchdog Tripped|Code Executed Too Long',text,re.I)
    done=re.findall((r'DF_MEMORY_DONE product=' if scenario=='matrix' else r'DF_SWITCH_MEMORY_DONE product=')+re.escape(product)+r' ([^\r\n]+)',text)
    assert len(done)==1, 'Missing or repeated completion record'
    metrics={key:int(value) for key,value in re.findall(r'(\w+)=(\d+)',done[0])}
    package=Path.home()/'AppData/Roaming/Garmin/ConnectIQ/Devices'/product/'compiler.json'
    package_data=json.loads(package.read_text(encoding='utf-8-sig'))
    limit=next(item['memoryLimit'] for item in package_data['appTypes'] if item['type']=='datafield')
    if scenario=='switching':
        assert metrics['transitions']==1000 and metrics['settings']==200
        assert 'DF_SECOND_SET_DONE transitions=1000 settings=200' in text
        assert metrics['native_compute']>=10 and metrics['native_draw']>=3 and metrics['elapsed_ms']>=30000
        checkpoints=[dict(transitions=int(n),used=int(u)) for n,u in re.findall(r'DF_SECOND_SET_CHECKPOINT transitions=(\d+) used=(\d+)',text)]
        assert [r['transitions'] for r in checkpoints]==[500,1000]
        assert checkpoints[1]['used']<=checkpoints[0]['used'], 'Retained switching growth'
        settings_returns=[dict(changes=int(n),used=int(u)) for n,u in re.findall(r'DF_SECOND_SET_SETTINGS_RETURN count=(\d+) used=(\d+)',text)]
        assert [r['changes'] for r in settings_returns]==[48,96,144,192]
        growth=0
        for before,after in zip(settings_returns,settings_returns[1:]):
            growth=growth+1 if after['used']>before['used'] else 0
            assert growth<2, 'Sustained retained settings growth'
        assert metrics['max_fonts']==3
        assert 0<metrics['total_low']<=metrics['total_high']<=limit
        assert metrics['max_used']<=metrics['total_low'] and metrics['min_free']>=0
        row=dict(product=product,status='passed',scenario=scenario,source_revision=source['source_revision'],published_limit_bytes=limit,runtime='normal simulator Data Field; no --unit-test or /t',max_sampled_used_bytes=metrics['max_used'],min_sampled_free_bytes=metrics['min_free'],runtime_total_min_bytes=metrics['total_low'],runtime_total_max_bytes=metrics['total_high'],second_set_switches=metrics['transitions'],second_set_settings_changes=metrics['settings'],samples=metrics['samples'],maximum_cached_font_roles=metrics['max_fonts'],native_compute_callbacks=metrics['native_compute'],native_draw_callbacks=metrics['native_draw'],elapsed_ms=metrics['elapsed_ms'],binary_sha256=digest(ROOT/'bin'/(product+'-'+stem+'.prg')),log_sha256=digest(log),physical_device_memory='unrun',sampling='Observed stages; transient peaks between samples not proven absent; driver overhead included.')
        row.update(switch_checkpoints=checkpoints,same_configuration_settings_returns=settings_returns,sustained_retained_growth='not observed')
        (ROOT/'artifacts'/(product+'-'+stem+'.json')).write_text(json.dumps(row,indent=2)+'\n',encoding='utf-8')
        print(f'{product} switching: peak sampled {metrics["max_used"]} / {limit} bytes; minimum free {metrics["min_free"]}')
        return
    assert metrics['cycles']==3 and metrics['cases']==648 and metrics['samples']>=2592
    assert metrics['native_compute']>=10 and metrics['native_draw']>=3 and metrics['elapsed_ms']>=30000
    assert metrics['full_grids']>=54 and metrics['max_fonts']==3, 'Fixed font/full grid coverage missing'
    assert metrics['fields_seen']==len(read('config/catalogue.json')['fields']), 'Not all selectable fields were drawn in fitting roles'
    assert 0<metrics['total_low']<=metrics['total_high']<=limit, 'Not the bounded normal Data Field allocation'
    assert metrics['max_used']<=min(metrics['total_low'],limit) and metrics['min_free']>=0
    bounds=re.findall(r'DF_MEMORY_BOUNDS product='+product+r' width=(\d+) height=(\d+)',text)
    assert bounds, 'No native Data Field drawing bounds observed'
    returns=[dict(cycle=int(cycle),minimum_used=int(used)) for cycle,used in re.findall(r'DF_MEMORY_RETURN product='+product+r' cycle=(\d+) used=(\d+)',text)]
    assert [item['cycle'] for item in returns]==[0,1,2]
    assert metrics['growth_returns']<2, 'Used-memory minima grew on both repeated returns to the same configuration'
    row=dict(product=product,status='passed',runtime='normal simulator Data Field; no --unit-test or /t',
             source_revision=source['source_revision'],published_limit_bytes=limit,
             runtime_total_min_bytes=metrics['total_low'],runtime_total_max_bytes=metrics['total_high'],
             max_sampled_used_bytes=metrics['max_used'],min_sampled_free_bytes=metrics['min_free'],
             headroom_to_published_limit_bytes=limit-metrics['max_used'],
             samples=metrics['samples'],matrix_cases=metrics['cases'],matrix_cycles=metrics['cycles'],
             full_native_grid_cases=metrics['full_grids'],maximum_cached_font_roles=metrics['max_fonts'],
             visible_field_types=metrics['fields_seen'],unsupported_regular_header_substitutions=metrics['unsupported_headers'],
             native_compute_callbacks=metrics['native_compute'],native_draw_callbacks=metrics['native_draw'],
             elapsed_ms=metrics['elapsed_ms'],native_drawing_bounds=[dict(width=int(w),height=int(h)) for w,h in sorted(set(bounds))],
             same_configuration_returns=returns,sustained_return_growth='not observed over three cycles',
             sampling='after initialization, native compute/layout/startup drawing, and fixture compute/layout/drawing/lifecycle; synthetic renderer presentation is discarded before native producer frames; transient peaks between samples not proven absent',
             instrumentation='bounded counters and scenario subclass in the same normal Data Field allocation; production routines/resources reused; overhead included in observed usage',
             configurations=dict(layout_totals={'four_rows':[8,5,2],'five_rows':[10,7,4]},legacy_count_inputs_ignored=[1,4,8,10],enlarged=[0,1,2],alignment=['center','right'],themes=['auto','day','night'],
                                 areas=['native full bounds'],
                                 selected_fields='all 33 drawn in fitting roles; duplicates, unknown labels and independent per-slot effects',
                                 unsupported_headers='Headers without regular-cell clearance use current power in those roles. All 33 fields must still be drawn in fitting roles. Unsupported regular placement is checked by Placement.'),
             fixture_scope='synthetic values and controlled lifecycle/settings callbacks; production effects use validated synthetic zone metadata; this does not establish physical acquisition provenance',
             unit_settings='native simulator device unit settings; metric/statute and 12/24-hour delivery not exhaustively changed by this runner',
             binary_sha256=digest(ROOT/'bin'/(product+'-memory.prg')),log_sha256=digest(log),device_compiler_json_sha256=digest(package),
             physical_device_memory='unrun',full_APP48_qualification='incomplete: representative hardware, native multi-field layout/settings delivery and additional unit/sensor scenarios remain')
    (ROOT/'artifacts'/(product+'-memory-matrix.json')).write_text(json.dumps(row,indent=2)+'\n',encoding='utf-8')
    print(f'{product}: peak sampled {metrics["max_used"]} / {limit} bytes; minimum free {metrics["min_free"]}; normal total {metrics["total_low"]}..{metrics["total_high"]}')

if __name__=='__main__':main()
