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
    parser=argparse.ArgumentParser();parser.add_argument('-Product',required=True)
    product=parser.parse_args().Product
    source=read('artifacts/datafield-memory-source.json')
    for item in source['files']:
        assert digest(ROOT/item['path'])==item['sha256'], 'Source changed during memory run: '+item['path']
    inputs=read('artifacts/datafield-memory-inputs.json')
    assert inputs['manifest_sha256']==digest(ROOT/'manifest.xml')
    assert inputs['jungle_sha256']==digest(ROOT/'memory.jungle')
    assert inputs['probe_sha256']==digest(ROOT/'validation/memory/MemoryValidation.mc')
    for item in inputs['production_sources']:
        assert digest(ROOT/item['production_path'])==item['production_sha256']
        assert digest(ROOT/'.local/memory-source'/Path(item['production_path']).name)==item['qualification_sha256']
        if not item['changed']:assert item['production_sha256']==item['qualification_sha256']
    log=ROOT/'artifacts'/(product+'-memory.log')
    text=log.read_text(encoding='utf-8-sig')
    assert not re.search(r'DF_MEMORY_FAIL|Encountered an app crash|Unhandled Exception|Out Of Memory|OutOfMemory|Stack Overflow|StackOverflow',text,re.I)
    done=re.findall(r'DF_MEMORY_DONE product='+re.escape(product)+r' ([^\r\n]+)',text)
    assert len(done)==1, 'Missing or repeated completion record'
    metrics={key:int(value) for key,value in re.findall(r'(\w+)=(\d+)',done[0])}
    package=Path.home()/'AppData/Roaming/Garmin/ConnectIQ/Devices'/product/'compiler.json'
    package_data=json.loads(package.read_text(encoding='utf-8-sig'))
    limit=next(item['memoryLimit'] for item in package_data['appTypes'] if item['type']=='datafield')
    assert metrics['cycles']==3 and metrics['cases']==648 and metrics['samples']>=2592
    assert metrics['native_compute']>=10 and metrics['native_draw']>=3 and metrics['elapsed_ms']>=30000
    assert metrics['full_grids']>=54 and metrics['max_fonts']==3, 'Fixed font/full grid coverage missing'
    assert metrics['fields_seen']==32, 'Not all selectable fields were drawn in fitting roles'
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
             sampling='after initialization, native compute/layout/startup drawing, and fixture compute/layout/drawing/lifecycle; transient peaks between samples not proven absent',
             instrumentation='bounded counters and scenario subclass in the same normal Data Field allocation; production routines/resources reused; overhead included in observed usage',
             configurations=dict(layout_totals={'four_rows':[8,5,2],'five_rows':[10,7,4]},legacy_count_inputs_ignored=[1,4,8,10],enlarged=[0,1,2],alignment=['center','right'],themes=['auto','day','night'],
                                 areas=['native full bounds'],
                                 selected_fields='all 32 drawn in fitting roles; duplicates, unknown labels and independent per-slot effects',
                                 unsupported_headers='Headers without regular-cell clearance use current power in those roles. All 32 fields must still be drawn in fitting roles. Unsupported regular placement is checked by Placement.'),
             fixture_scope='synthetic values and controlled lifecycle/settings callbacks; horizon/band allocation does not establish physical acquisition provenance',
             unit_settings='native simulator device unit settings; metric/statute and 12/24-hour delivery not exhaustively changed by this runner',
             binary_sha256=digest(ROOT/'bin'/(product+'-memory.prg')),log_sha256=digest(log),device_compiler_json_sha256=digest(package),
             physical_device_memory='unrun',full_APP48_qualification='incomplete: representative hardware, native multi-field layout/settings delivery and additional unit/sensor scenarios remain')
    (ROOT/'artifacts'/(product+'-memory.json')).write_text(json.dumps(row,indent=2)+'\n',encoding='utf-8')
    print(f'{product}: peak sampled {metrics["max_used"]} / {limit} bytes; minimum free {metrics["min_free"]}; normal total {metrics["total_low"]}..{metrics["total_high"]}')

if __name__=='__main__':main()
