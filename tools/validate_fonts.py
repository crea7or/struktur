"""SPEC-176/177 semantic atlas checks and reproducible regeneration gate."""
import argparse
import hashlib
import json
import platform
import re
import shutil
import tempfile
from pathlib import Path
from PIL import Image, ImageChops, ImageDraw, ImageFont, __version__ as pillow_version
from font_glyphs import ROOT, glyph_contract, input_inventory
from generate_fonts import HASHES, generate


class FontValidationError(ValueError):
    def __init__(self, code, context, detail):
        self.code = code
        super().__init__(f'{code}: {context}: {detail}')


def require(condition, code, context, detail):
    if not condition:
        raise FontValidationError(code, context, detail)


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def codepoints(values):
    return ', '.join(f'U+{value:04X}' for value in sorted(values)) or 'none'


def characters(path, context=None):
    context = context or path.stem
    rows = {}
    for line in path.read_text(encoding='utf-8').splitlines():
        if line.startswith('char '):
            row = {key: int(value) for key, value in re.findall(r'(\w+)=(-?\d+)', line)}
            require(set(['id','x','y','width','height','xoffset','yoffset','xadvance','page','chnl']) <= set(row),
                    'record', context, 'incomplete character record')
            require(row['id'] not in rows, 'duplicate', context, codepoints([row['id']]))
            rows[row['id']] = row
    return rows


def validate_font(root, item, contract, baseline=None):
    name = item['id']
    role = 'numeric' if name.startswith('Value') else 'label'
    context = f'{role}/{name}'
    expected = {ord(ch) for ch in contract[role+'_glyphs']}
    fnt = root/'resources/fonts'/(name+'.fnt')
    png = fnt.with_suffix('.png')
    rows = characters(fnt, context)
    missing, surplus = expected-set(rows), set(rows)-expected
    require(not missing and not surplus, 'coverage', context,
            f'missing [{codepoints(missing)}]; surplus [{codepoints(surplus)}]')
    require(item['role'] == role and item['glyphs'] == contract[role+'_glyphs']
            and item['generated_codepoints'] == sorted(expected),
            'inventory', context, 'manifest role/code points differ from traced role union')
    data = png.read_bytes()
    require(data[:8] == b'\x89PNG\r\n\x1a\n' and data[24:26] == bytes([1,3]),
            'encoding', context, 'expected one-bit indexed PNG')
    with Image.open(png) as image:
        rgba = image.convert('RGBA')
    alpha = rgba.getchannel('A')
    require(rgba.size == (item['width'],item['height']), 'bounds', context, 'PNG dimensions differ from manifest')
    require({value for _,value in alpha.getcolors()} <= {0,255}, 'encoding', context, 'nonbinary alpha')
    source = 'Roboto_Condensed_Black.ttf' if role == 'numeric' else 'Roboto_Condensed_SemiBold.ttf'
    require(item['source_font'] == source, 'source', context, 'incorrect source font role')
    font = ImageFont.truetype(root/'assets/fonts'/source,item['size'],layout_engine=ImageFont.Layout.BASIC)
    ascent, descent = font.getmetrics()
    common_lines = [line for line in fnt.read_text().splitlines() if line.startswith('common ')]
    require(len(common_lines) == 1, 'header', context, 'expected one common record')
    common = {key:int(value) for key,value in re.findall(r'(\w+)=(-?\d+)',common_lines[0])}
    require(common == dict(lineHeight=ascent+descent,base=ascent,scaleW=item['width'],scaleH=item['height'],pages=1,packed=0)
            and item['line_height'] == ascent+descent and item['ascent'] == ascent,
            'header', context, 'common metrics/dimensions do not match source font')
    text = fnt.read_text()
    require(re.findall(r'^chars count=(\d+)$',text,re.M) == [str(len(rows))]
            and re.findall(r'^page id=0 file="([^"]+)"$',text,re.M) == [png.name]
            and len(re.findall(r'^page ',text,re.M)) == 1,
            'header', context, 'character count or page declaration mismatch')
    coverage = Image.new('L',rgba.size,0)
    covered = ImageDraw.Draw(coverage)
    rectangles = []
    # Geometry is checked in a separate pass so an overlap reports that defect
    # before an altered rectangle can cause a misleading source-mask failure.
    for code,row in rows.items():
        glyph = f'{context} {codepoints([code])}'
        x,y,w,h = (row[key] for key in ['x','y','width','height'])
        require(w >= 0 and h >= 0 and x >= 1 and y >= 1
                and x+w < rgba.width and y+h < rgba.height,
                'bounds', glyph, 'rectangle exceeds padded atlas bounds')
        require(row['page'] == 0 and row['chnl'] == 15, 'record', glyph, 'unsupported page/channel')
        if w and h:
            for ox,oy,ow,oh in rectangles:
                require(x+w <= ox or ox+ow <= x or y+h <= oy or oy+oh <= y,
                        'overlap', glyph, 'intersects another glyph rectangle')
            rectangles.append((x,y,w,h))
            covered.rectangle((x,y,x+w-1,y+h-1),fill=255)
    for code,row in rows.items():
        glyph = f'{context} {codepoints([code])}'
        x,y,w,h = (row[key] for key in ['x','y','width','height'])
        left,top,right,bottom = font.getbbox(chr(code))
        require((w,h,row['xoffset'],row['yoffset'],row['xadvance']) ==
                (right-left,bottom-top,left,top,round(font.getlength(chr(code)))),
                'metrics', glyph, 'does not match specified source font')
        if w and h:
            reference = Image.new('L',(w,h))
            ImageDraw.Draw(reference).text((-left,-top),chr(code),font=font,fill=255)
            reference = reference.point(lambda value:255 if value >= 128 else 0)
            require(alpha.crop((x,y,x+w,y+h)).tobytes() == reference.tobytes(),
                    'mask', glyph, 'glyph pixels differ from specified source font')
    undeclared = ImageChops.subtract(alpha,coverage).getbbox()
    require(undeclared is None, 'opaque_padding', context,
            f'opaque pixels outside declared glyph rectangles at {undeclared}')
    # Semantic checks precede cached hashes, including for updated-hash fixtures.
    require(item.get('advances') == [rows[ord(ch)]['xadvance'] for ch in item['glyphs']],
            'metrics', context, 'cached fitting advances do not match the font resource')
    require(sha256(fnt) == item['fnt_sha256'] and sha256(png) == item['png_sha256'],
            'output_hash', context, 'generated resource hashes differ from manifest')
    comparison = None
    if baseline:
        before = characters(baseline/fnt.name)
        with Image.open(baseline/png.name) as image:
            old_alpha = image.convert('RGBA').getchannel('A')
        shared = set(before)&set(rows)
        for code in shared:
            old,new = before[code],rows[code]
            keys = ['width','height','xoffset','yoffset','xadvance']
            require([old[key] for key in keys] == [new[key] for key in keys], 'baseline_metrics', context, codepoints([code]))
            def box(row):return row['x'],row['y'],row['x']+row['width'],row['y']+row['height']
            require(old_alpha.crop(box(old)).tobytes() == alpha.crop(box(new)).tobytes(), 'baseline_mask', context, codepoints([code]))
        comparison = dict(font=name,preserved_glyphs=len(shared),removed=len(set(before)-set(rows)),added=len(set(rows)-set(before)))
    return dict(font=name,role=role,glyphs=len(rows),width=item['width'],height=item['height'],
                missing=[],unused=[],opaque_padding='transparent',encoding='one-bit indexed PNG',
                metrics_and_pixels='exact source-font match'),comparison


def validate_manifest(root=ROOT, baseline=None):
    manifest = json.loads((root/'config/font-manifest.json').read_text(encoding='utf-8-sig'))
    contract = glyph_contract(root)
    if manifest['glyph_contract'] != contract:
        # A text change can add/remove reachable glyphs before regeneration.
        # Identify its actual resource/code-point defect before stale metadata.
        for item in manifest['fonts']:
            role = 'numeric' if item['id'].startswith('Value') else 'label'
            context = role+'/'+item['id']
            ids = set(characters(root/'resources/fonts'/(item['id']+'.fnt'),context))
            expected = set(contract['expected_codepoints'][role])
            require(ids == expected, 'coverage', context,
                    f'missing [{codepoints(expected-ids)}]; surplus [{codepoints(ids-expected)}]; traced presentation changed')
    require(manifest['glyph_contract'] == contract, 'inventory', 'manifest', 'source text/rules changed; regenerate resources')
    require(manifest['inventory_inputs'] == input_inventory(root), 'input_hash', 'manifest', 'traced input revisions changed; regenerate resources')
    specification={r['stable_id']:r for r in json.loads((root/'requirements/workspace-snapshot.json').read_text(encoding='utf-8-sig'))}
    expected_refs={key:dict(revision=specification[key]['head_change_seq'],description_sha256=hashlib.sha256(specification[key]['description'].encode()).hexdigest()) for key in ['APP-24','APP-28','APP-34','SPEC-154']}
    require(manifest.get('requirement_refs')==expected_refs,'inventory','requirements','font-generation provenance differs from current specifications')
    require(manifest['pillow'] == pillow_version and manifest['python'] == platform.python_version(),
            'toolchain', 'manifest', 'Python/Pillow differ from recorded generation versions')
    require((root/'tools/requirements.txt').read_text().strip() == 'Pillow=='+pillow_version,
            'toolchain', 'manifest', 'Pillow does not match dependency pin')
    for source,expected in HASHES.items():
        require(sha256(root/'assets/fonts'/source) == expected == manifest['assets'][source]['sha256'],
                'source', source, 'approved source-font hash changed')
    profiles=json.loads((root/'config/devices.json').read_text(encoding='utf-8-sig'))
    require(set(manifest.get('profile_metrics',{}))=={d['id'] for d in profiles},'inventory','profile metrics','missing profile tables')
    for profile,record in manifest['profile_metrics'].items():
        path=root/record['path']
        require(path.is_file() and sha256(path)==record['sha256'],'output_hash',profile,'profile metric table differs from generated output')
        references=(root/'profiles'/profile/'DeviceProfile.mc').read_text()
        sizes={role:int(re.search(role+r'=(\d+)',references).group(1)) for role in ['BIG_SIZE','REGULAR_SIZE','LABEL_SIZE']}
        require(record['numeric_sizes']==sorted({sizes['BIG_SIZE'],sizes['REGULAR_SIZE']}) and record['label_sizes']==[sizes['LABEL_SIZE']],
                'inventory',profile,'expected exactly the three APP-24 font roles')
        declaration=root/record['resource_path']
        require(declaration.is_file() and sha256(declaration)==record['resource_sha256'],'output_hash',profile,'profile font declaration changed')
        names=re.findall(r'<font id="([^"]+)"',declaration.read_text())
        require(len(names)==3 and set(names)=={f"Value{sizes['BIG_SIZE']}",f"Value{sizes['REGULAR_SIZE']}",f"Label{sizes['LABEL_SIZE']}"},
                'inventory',profile,'expected exactly three declared resources')
    names = [item['id'] for item in manifest['fonts']]
    require(len(names) == len(set(names)) and not (root/'resources/fonts/fonts.xml').exists(),
            'inventory', 'manifest', 'duplicate or shared font declarations bypass three-font profile policy')
    require({path.stem for path in (root/'resources/fonts').glob('*.fnt')} == set(names)
            and {path.stem for path in (root/'resources/fonts').glob('*.png')} == set(names),
            'inventory', 'manifest', 'undeclared/missing atlas resources')
    results,comparison = [],[]
    for item in manifest['fonts']:
        result,compared = validate_font(root,item,contract,baseline)
        results.append(result)
        if compared:comparison.append(compared)
    return dict(status='passed',glyph_contract=contract,inventory_inputs=manifest['inventory_inputs'],
                fonts=results,baseline_comparison=comparison,
                garmin_runtime_memory='separate simulator probe; full app/hardware qualification incomplete')


def copy_inputs(root, destination):
    for relative in [*input_inventory(root),*['assets/fonts/'+name for name in HASHES]]:
        target = destination/relative
        target.parent.mkdir(parents=True,exist_ok=True)
        shutil.copyfile(root/relative,target)


def output_hashes(root):
    paths = [path.relative_to(root) for path in (root/'resources/fonts').iterdir() if path.is_file()]
    paths += [Path(path) for path in ['config/font-manifest.json','source/FontSelection.mc','source/FontMetrics.mc',
              'resources/drawables/launcher.png','resources/drawables/drawables.xml','assets/fonts/PROVENANCE.txt']]
    paths += [path.relative_to(root) for path in (root/'profiles').glob('*/FontData.mc')]
    paths += [path.relative_to(root) for path in (root/'profiles').glob('*/fonts/fonts.xml')]
    return {path.as_posix():sha256(root/path) for path in sorted(paths)}


def compare_regeneration(first, second, current):
    differing = lambda a,b: ', '.join(sorted(path for path in set(a)|set(b) if a.get(path) != b.get(path)))
    require(first == second, 'nondeterminism', 'regeneration', differing(first,second))
    require(first == current, 'regeneration', 'resources', differing(first,current))


def verify_regeneration(root=ROOT):
    (ROOT/'.local').mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='font-repro-',dir=ROOT/'.local') as temporary:
        copies = [Path(temporary)/name for name in ['first','second']]
        for target in copies:
            copy_inputs(root,target)
            generate(target)
        first,second,current = [output_hashes(target) for target in [*copies,root]]
        compare_regeneration(first,second,current)
    return dict(status='passed',runs=2,outputs=first,python=platform.python_version(),pillow=pillow_version)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--baseline',type=Path)
    args = parser.parse_args()
    report = validate_manifest(baseline=args.baseline)
    report['regeneration'] = verify_regeneration()
    (ROOT/'artifacts').mkdir(parents=True, exist_ok=True)
    (ROOT/'artifacts/font-glyph-audit.json').write_text(json.dumps(report,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
    print(f"PASS: {len(report['fonts'])} exact glyph atlases, transparent padding, source metrics/masks and two reproducible regenerations.")


if __name__ == '__main__':
    main()
