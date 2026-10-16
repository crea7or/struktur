"""Isolated semantic rejection fixtures for SPEC-177; no production mutations."""
import json
import re
import shutil
import tempfile
from pathlib import Path
from PIL import Image
from font_glyphs import ROOT, glyph_contract, input_inventory
from generate_fonts import atlas, generate
from validate_fonts import (FontValidationError, characters, compare_regeneration,
                            copy_inputs, output_hashes, sha256, validate_manifest)


def fixture(root):
    copy_inputs(ROOT,root)
    outputs=['resources','source/FontSelection.mc','source/FontMetrics.mc','config/font-manifest.json','assets/fonts/PROVENANCE.txt']
    outputs += [p.relative_to(ROOT).as_posix() for p in (ROOT/'profiles').glob('*/FontData.mc')]
    outputs += [p.relative_to(ROOT).as_posix() for p in (ROOT/'profiles').glob('*/fonts/fonts.xml')]
    for folder in outputs:
        source=ROOT/folder;target=root/folder
        if source.is_dir():shutil.copytree(source,target)
        else:
            target.parent.mkdir(parents=True,exist_ok=True)
            shutil.copyfile(source,target)


def refresh_hashes(root):
    path=root/'config/font-manifest.json'
    manifest=json.loads(path.read_text(encoding='utf-8-sig'))
    for item in manifest['fonts']:
        item['fnt_sha256']=sha256(root/'resources/fonts'/(item['id']+'.fnt'))
        item['png_sha256']=sha256(root/'resources/fonts'/(item['id']+'.png'))
    path.write_text(json.dumps(manifest,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')


def replace_record(path,code,changes):
    rows=characters(path);row=rows[code];row.update(changes)
    line='char '+' '.join(f'{key}={value}' for key,value in row.items())
    text=path.read_text()
    path.write_text(re.sub(r'^char id='+str(code)+r' .*$',line,text,flags=re.M),encoding='utf-8')


def palette_pixel(path,point):
    with Image.open(path) as image:modified=image.copy()
    modified.putpixel(point,1-modified.getpixel(point))
    modified.save(path,bits=1,transparency=0,optimize=True)


def mutate(root,name):
    label=root/'resources/fonts/Label21.fnt'
    numeric=root/'resources/fonts/Value55.fnt'
    if name in ['missing_ft_f','missing_seconds_0','missing_seconds_dot','missing_header_pipe']:
        code={'missing_ft_f':102,'missing_seconds_0':48,'missing_seconds_dot':46,'missing_header_pipe':124}[name]
        text=re.sub(r'^char id='+str(code)+r' .*\n','',label.read_text(),flags=re.M)
        text=re.sub(r'chars count=(\d+)',lambda m:'chars count='+str(int(m[1])-1),text)
        label.write_text(text,encoding='utf-8')
    elif name=='surplus_numeric_A':
        path=root/'config/font-manifest.json'
        manifest=json.loads(path.read_text(encoding='utf-8-sig'))
        item=next(item for item in manifest['fonts'] if item['id']=='Value55')
        item.update(atlas(root/'assets/fonts/Roboto_Condensed_Black.ttf',55,
                          item['glyphs']+'A',numeric.parent,'Value55'))
        path.write_text(json.dumps(manifest),encoding='utf-8')
    elif name=='opaque_padding':palette_pixel(numeric.with_suffix('.png'),(0,0))
    elif name=='duplicate_id':
        record=next(line for line in numeric.read_text().splitlines() if line.startswith('char '))
        numeric.write_text(numeric.read_text()+record+'\n',encoding='utf-8')
    elif name=='bad_bounds':replace_record(numeric,48,dict(x=999999))
    elif name=='overlap':
        other=characters(numeric)[49]
        replace_record(numeric,48,dict(x=other['x'],y=other['y']))
    elif name=='changed_metrics':replace_record(numeric,48,dict(xadvance=999))
    elif name=='changed_mask':
        row=characters(numeric)[48]
        palette_pixel(numeric.with_suffix('.png'),(row['x'],row['y']))
    elif name=='changed_cached_advance':
        path=root/'config/font-manifest.json'
        manifest=json.loads(path.read_text(encoding='utf-8'))
        manifest['fonts'][0]['advances'][0]+=1
        path.write_text(json.dumps(manifest),encoding='utf-8')
    elif name=='stale_input':
        path=root/'source/Formatting.mc'
        path.write_text(path.read_text()+'\n// changed recorded input\n',encoding='utf-8')
    elif name in ['profile_extra_font','profile_wrong_fontsize']:
        path=root/'config/font-manifest.json';manifest=json.loads(path.read_text(encoding='utf-8'))
        record=manifest['profile_metrics']['edge1040'];declaration=root/record['resource_path']
        text=declaration.read_text(encoding='utf-8')
        if name=='profile_extra_font':text=text.replace('</fonts>','<font id="Value95" filename="../../../resources/fonts/Value95.fnt" antialias="false"/></fonts>')
        else:text=text.replace('Value55','Value95')
        declaration.write_text(text,encoding='utf-8');record['resource_sha256']=sha256(declaration)
        path.write_text(json.dumps(manifest),encoding='utf-8')
    else:raise ValueError(name)
    # Matching cached hashes prove failures come from semantic checks.
    refresh_hashes(root)


def expect_failure(action,code):
    try:action()
    except FontValidationError as error:
        assert error.code==code, f'Expected {code}, got {error}'
        return str(error)
    raise AssertionError('Invalid fixture was accepted: '+code)


def main():
    reviewed=json.loads((ROOT/'tests/glyph-inventory.json').read_text(encoding='utf-8-sig'))
    contract=glyph_contract()
    for role in ['numeric','label']:
        assert contract[role+'_glyphs']==reviewed[role+'_glyphs'], 'Role union differs from independently reviewed inventory: '+role
    assert set(reviewed['required_units'])<=set(contract['units'])
    assert contract['clock_header']==reviewed['clock_header']
    assert set(''.join(reviewed['secondary_duration']))<=set(contract['duration_secondary_glyphs'])
    cases=dict(missing_ft_f='coverage',missing_seconds_0='coverage',missing_seconds_dot='coverage',missing_header_pipe='coverage',surplus_numeric_A='coverage',opaque_padding='opaque_padding',
               duplicate_id='duplicate',bad_bounds='bounds',overlap='overlap',
               changed_metrics='metrics',changed_cached_advance='metrics',changed_mask='mask',stale_input='input_hash',
               profile_extra_font='inventory',profile_wrong_fontsize='inventory')
    results=[]
    (ROOT/'.local').mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='font-fixtures-',dir=ROOT/'.local') as temporary:
        for name,expected in cases.items():
            root=Path(temporary)/name;fixture(root);mutate(root,name)
            diagnostic=expect_failure(lambda:validate_manifest(root),expected)
            if name=='missing_ft_f':assert 'label/Label21' in diagnostic and 'U+0066' in diagnostic
            if name=='missing_header_pipe':assert 'label/Label21' in diagnostic and 'U+007C' in diagnostic
            if name=='surplus_numeric_A':assert 'numeric/Value55' in diagnostic and 'U+0041' in diagnostic
            results.append(dict(fixture=name,status='passed',expected=expected,diagnostic=diagnostic,output_hashes='updated to match fixture'))
        root=Path(temporary)/'presentation_change';fixture(root)
        before=glyph_contract(root)
        catalogue=root/'config/catalogue.json'
        content=json.loads(catalogue.read_text(encoding='utf-8-sig'))
        content['fields'][-1]['label']+=' Z'
        catalogue.write_text(json.dumps(content),encoding='utf-8')
        after=glyph_contract(root)
        assert ord('Z') not in before['expected_codepoints']['label']
        assert ord('Z') in after['expected_codepoints']['label']
        assert before['expected_codepoints']['numeric']==after['expected_codepoints']['numeric']
        diagnostic=expect_failure(lambda:validate_manifest(root),'coverage')
        assert 'label/Label21' in diagnostic and 'U+005A' in diagnostic
        old_outputs=output_hashes(root);generate(root);validate_manifest(root)
        new_outputs=output_hashes(root)
        assert all(old_outputs[path]!=new_outputs[path] for path in old_outputs if path.startswith('resources/fonts/Label') and path.endswith('.fnt'))
        assert all(old_outputs[path]==new_outputs[path] for path in old_outputs if path.startswith('resources/fonts/Value'))
        results.append(dict(fixture='presentation_change',status='passed',diagnostic=diagnostic,
                            added_label_codepoint='U+005A',numeric_resources='unchanged',label_resources='regenerated and valid'))
        root=Path(temporary)/'lf_checkout';fixture(root);generate(root)
        generated=output_hashes(root)
        for relative in generated:
            path=root/relative
            if path.suffix in {'.fnt','.json','.mc','.txt','.xml'}:
                data=path.read_bytes()
                assert b'\r\n' not in data, 'Generator violates Git LF checkout policy: '+relative
                path.write_bytes(data.replace(b'\r\n',b'\n'))
        validate_manifest(root)
        assert output_hashes(root)==generated, 'Git LF checkout changed generated bytes or hashes'
        inputs=input_inventory(root)
        for relative in inputs:
            path=root/relative
            path.write_bytes(path.read_bytes().replace(b'\r\n',b'\n').replace(b'\n',b'\r\n'))
        assert input_inventory(root)==inputs, 'CRLF checkout changed canonical input hashes'
        validate_manifest(root)
        generate(root)
        assert output_hashes(root)==generated, 'CRLF inputs changed reproducible font outputs'
        results.append(dict(fixture='lf_checkout',status='passed',
                            generated_text='LF, including on Windows',checkout_hashes='unchanged for LF and CRLF inputs'))
        sample={'resources/fonts/Value55.png':'first'}
        diagnostic=expect_failure(lambda:compare_regeneration(sample,{'resources/fonts/Value55.png':'second'},sample),'nondeterminism')
        results.append(dict(fixture='nondeterministic_outputs',status='passed',diagnostic=diagnostic))
        diagnostic=expect_failure(lambda:compare_regeneration(sample,sample,{'resources/fonts/Value55.png':'stale'}),'regeneration')
        results.append(dict(fixture='stale_regenerated_outputs',status='passed',diagnostic=diagnostic))
    report=dict(status='passed',requirements=['SPEC-176','SPEC-177'],cases=results,reviewed_inventory=reviewed,
                reviewed_inventory_sha256=sha256(ROOT/'tests/glyph-inventory.json'),
                scope='isolated semantic fixtures and controlled inventory change; no physical-device claims')
    (ROOT/'artifacts/font-validation-tests.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print(f'PASS: {len(results)} font validation fixtures, including updated-hash missing f, surplus A and opaque padding.')


if __name__=='__main__':main()
