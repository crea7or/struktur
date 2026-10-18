"""Deterministic BMFont text/PNG atlases from the exact workspace TTF assets.

Pillow is pinned in tools/requirements.txt. Font compiler compatibility and device
memory remain unverified until an actual Connect IQ build and runtime measurement.
"""
import hashlib
import json
import platform
import re
import struct
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, __version__ as pillow_version
from font_glyphs import glyph_contract, input_inventory

ROOT=Path(__file__).resolve().parents[1]
# Match .gitattributes on Windows: reproducible text outputs always use LF.
HASHES={'Roboto_Condensed_Black.ttf':'a365617457f4e9800347655478132461565b28c563076f38a6294f6403b1fba9',
        'Roboto_Condensed_SemiBold.ttf':'dd9178d15b5e84f849ed158d336ae7184289488b114b891fb3a83fe11728d6d3'}
def names(path):
    """Preserve embedded font copyright/license metadata; do not invent provenance."""
    data=path.read_bytes(); tables=struct.unpack_from('>H',data,4)[0]
    offset=None
    for i in range(tables):
        tag,_,start,_=struct.unpack_from('>4sIII',data,12+16*i)
        if tag==b'name': offset=start
    if offset is None:return []
    _,count,storage=struct.unpack_from('>HHH',data,offset);out=[]
    for i in range(count):
        platform,encoding,language,name_id,length,start=struct.unpack_from('>HHHHHH',data,offset+6+12*i)
        if name_id not in (0,1,2,13,14):continue
        text=data[offset+storage+start:offset+storage+start+length].decode('utf-16-be' if platform in (0,3) else 'mac_roman',errors='replace')
        row=dict(name_id=name_id,text=text)
        if row not in out:out.append(row)
    return out

def pack(rectangles):
    """Deterministic height-sorted shelf packing; trim both dimensions exactly.

    Keep dimensions within the previous 512x2048 maximum for older targets.
    Try every feasible width and choose minimum encoded one-bit plane size.
    """
    ordered=sorted(rectangles,key=lambda item:(-item[2],-item[1],ord(item[0])))
    choices=[]
    for limit in range(max(item[1] for item in rectangles)+2,513):
        x=y=1;row_height=0;right=1;positions={}
        for ch,w,h in ordered:
            if x+w+1>limit:x=1;y+=row_height+2;row_height=0
            positions[ch]=(x,y)
            right=max(right,x+w+1);row_height=max(row_height,h);x+=w+2
        height=y+row_height+1
        if height<=2048:choices.append((((right+7)//8)*height,right*height,height,right,positions))
    if not choices:raise ValueError('Font rectangles exceed the supported atlas bounds.')
    _,_,height,width,positions=min(choices,key=lambda item:item[:4])
    return width,height,positions

def atlas(path,size,glyphs,output,name):
    font=ImageFont.truetype(path,size,layout_engine=ImageFont.Layout.BASIC)
    ascent,descent=font.getmetrics();line=ascent+descent
    metrics=[]
    for ch in glyphs:
        left,top,right,bottom=font.getbbox(ch)
        w=max(0,right-left);h=max(0,bottom-top)
        metrics.append((ch,w,h,left,top,round(font.getlength(ch))))
    width,height,positions=pack([(ch,w,h) for ch,w,h,_,_,_ in metrics])
    cells=[(ch,*positions[ch],w,h,left,top,advance) for ch,w,h,left,top,advance in metrics]
    mask=Image.new('L',(width,height),0);draw=ImageDraw.Draw(mask)
    for ch,x,y,w,h,left,top,advance in cells:
        draw.text((x-left,y-top),ch,font=font,fill=255)
    # Two palette indices: transparent black and opaque white. The PNG pixel
    # plane is genuinely one bit; preserve exact binary glyph shapes/metrics.
    png=mask.point(lambda pixel:1 if pixel>=128 else 0).convert('P')
    png.putpalette([0,0,0,255,255,255]+[0]*762)
    png.save(output/(name+'.png'),bits=1,transparency=0,optimize=True)
    header=[f'info face="Roboto Condensed" size={size} bold=0 italic=0 charset="" unicode=1 stretchH=100 smooth=0 aa=1 padding=0,0,0,0 spacing=0,0',
            f'common lineHeight={line} base={ascent} scaleW={width} scaleH={height} pages=1 packed=0',
            f'page id=0 file="{name}.png"',f'chars count={len(cells)}']
    header.extend(f'char id={ord(ch)} x={x} y={y} width={w} height={h} xoffset={left} yoffset={top} xadvance={advance} page=0 chnl=15' for ch,x,y,w,h,left,top,advance in cells)
    (output/(name+'.fnt')).write_text('\n'.join(header)+'\n',encoding='utf-8',newline='\n')
    ink_bounds=[]
    for ch,x,y,w,h,left,top,advance in cells:
        bounds=png.crop((x,y,x+w,y+h)).getbbox() if w and h else None
        ink_bounds.append([top+bounds[1],top+bounds[3]] if bounds else [0,0])
    return dict(id=name,size=size,line_height=line,ascent=ascent,glyphs=glyphs,ink_bounds=ink_bounds,advances=[c[7] for c in cells],width=width,height=height,
                role='numeric' if name.startswith('Value') else 'label',
                source_font=path.name,generated_codepoints=[ord(ch) for ch in glyphs],
                png_format='indexed PNG; one-bit pixels; transparent index 0',one_bit_atlas_bytes=((width+7)//8)*height,
                glyph_bitmap_one_bit_bytes=sum((w*h+7)//8 for _,_,_,w,h,_,_,_ in cells),
                fnt_sha256=hashlib.sha256((output/(name+'.fnt')).read_bytes()).hexdigest(),png_sha256=hashlib.sha256((output/(name+'.png')).read_bytes()).hexdigest())

def generate(root=ROOT):
    output=root/'resources/fonts';output.mkdir(parents=True,exist_ok=True)
    for folder in ['config','source','resources/drawables']:
        (root/folder).mkdir(parents=True,exist_ok=True)
    provenance={}
    for name,expected in HASHES.items():
        path=root/'assets/fonts'/name;actual=hashlib.sha256(path.read_bytes()).hexdigest()
        if actual!=expected:raise SystemExit(f'Approved font hash mismatch: {name}')
        provenance[name]=dict(sha256=actual,embedded_names=names(path))
    contract=glyph_contract(root)
    label_glyphs=contract['label_glyphs'];numeric_glyphs=contract['numeric_glyphs']
    manifest=[]
    devices=json.loads((root/'config/devices.json').read_text(encoding='utf-8-sig'))
    requirements={r['stable_id']:r for r in json.loads((root/'requirements/workspace-snapshot.json').read_text(encoding='utf-8-sig'))}
    requirement_refs={key:dict(revision=requirements[key]['head_change_seq'],description_sha256=hashlib.sha256(requirements[key]['description'].encode()).hexdigest()) for key in ['APP-24','APP-25','APP-34','SPEC-154']}
    references_by_profile={}
    for device in devices:
        references=(root/'profiles'/device['id']/'DeviceProfile.mc').read_text(encoding='utf-8')
        references_by_profile[device['id']]={name:int(re.search(name+r'=(\d+)',references).group(1)) for name in ['BIG_SIZE','REGULAR_SIZE','LABEL_SIZE']}
        row=re.search(r'\| Edge '+device['id'][4:]+r' \|[^\n]+',requirements['APP-24']['description'])
        if row is None:raise ValueError('Missing APP-24 profile: '+device['id'])
        cells=row.group(0).split('|')
        expected_sizes={role:int(cells[column].strip().removesuffix('px')) for role,column in [('BIG_SIZE',5),('REGULAR_SIZE',6),('LABEL_SIZE',7)]}
        if references_by_profile[device['id']]!=expected_sizes:raise ValueError('Profile font sizes disagree with APP-24: '+device['id'])
    numeric_sizes=sorted({p[role] for p in references_by_profile.values() for role in ['BIG_SIZE','REGULAR_SIZE']})
    label_sizes=sorted({p['LABEL_SIZE'] for p in references_by_profile.values()})
    expected={f'Value{s}' for s in numeric_sizes}|{f'Label{s}' for s in label_sizes}
    for obsolete in output.iterdir():
        if obsolete.suffix in {'.fnt','.png'} and obsolete.stem not in expected:
            assert obsolete.resolve().parent==output.resolve()
            obsolete.unlink()
    # The shared assets are not a resource root: each product declares three fonts.
    (output/'fonts.xml').unlink(missing_ok=True)
    for size in numeric_sizes:
        manifest.append(atlas(root/'assets/fonts/Roboto_Condensed_Black.ttf',size,numeric_glyphs,output,f'Value{size}'))
    for size in label_sizes:
        manifest.append(atlas(root/'assets/fonts/Roboto_Condensed_SemiBold.ttf',size,label_glyphs,output,f'Label{size}'))
    (root/'config/font-manifest.json').write_text(json.dumps(dict(generator='tools/generate_fonts.py',pillow=pillow_version,python=platform.python_version(),
        inventory_inputs=input_inventory(root),requirement_refs=requirement_refs,
        status='generated; compiler and runtime evidence tracked separately',glyph_contract=contract,
        packing='minimum one-bit scanline bytes across height-sorted shelves; trimmed non-power-of-two bounds',assets=provenance,fonts=manifest),indent=2,ensure_ascii=False)+'\n',encoding='utf-8',newline='\n')
    (root/'assets/fonts/PROVENANCE.txt').write_text('Roboto Condensed source assets. SHA-256 hashes and embedded upstream license metadata follow.\n'+json.dumps(provenance,indent=2,ensure_ascii=False)+'\nLicense text/URL metadata is retained above. The bundled OFL.txt contains the upstream redistribution license for these font assets and their generated resources.\n',encoding='utf-8',newline='\n')
    # Exactly the three APP-24 role fonts are declared and compiled per product.
    profile_metrics={}
    for device in devices:
        directory=root/'profiles'/device['id']
        maximums=references_by_profile[device['id']]
        numbers={maximums['REGULAR_SIZE'],maximums['BIG_SIZE']}
        eligible=[f for f in manifest if (f['role']=='numeric' and f['size'] in numbers) or (f['role']=='label' and f['size']==maximums['LABEL_SIZE'])]
        fonts=directory/'fonts';fonts.mkdir(parents=True,exist_ok=True)
        xml=['<?xml version="1.0" encoding="UTF-8"?>','<resources><fonts>']+[f'<font id="{f["id"]}" filename="../../../resources/fonts/{f["id"]}.fnt" antialias="false"/>' for f in eligible]+['</fonts></resources>']
        declaration=fonts/'fonts.xml';declaration.write_text('\n'.join(xml)+'\n',encoding='utf-8',newline='\n')
        code=['// Generated profile-only metadata and selectors; packed exact glyph metrics.','module FontData {']
        code.append('function info(size,labelRole) {')
        for f in eligible:
            code.append(f'if(size=={f["size"]} && labelRole=={str(f["role"]=="label").lower()}) {{ return [Rez.Fonts.{f["id"]},{f["line_height"]}]; }}')
        code.extend(['return null;','}'])
        code.append('function height(size,labelRole) {')
        for f in eligible:
            code.append(f'if(size=={f["size"]} && labelRole=={str(f["role"]=="label").lower()}) {{ return {f["line_height"]}; }}')
        code.extend(['return null;','}'])
        for role in ['numeric','label']:
            code.append('function '+role+'(height) {')
            for f in [f for f in eligible if f['role']==role]:
                tops=[b[0] for b in f['ink_bounds']];bottoms=[b[1] for b in f['ink_bounds']]
                assert all(0<=x<=255 for x in tops+bottoms+f['advances'])
                code.append('if(height=='+str(f['line_height'])+') { return ['+json.dumps(f['glyphs'],ensure_ascii=False)+','+json.dumps(tops)+'b,'+json.dumps(bottoms)+'b,'+json.dumps(f['advances'])+'b]; }')
            code.extend(['return null;','}'])
        code.append('}')
        (directory/'FontData.mc').write_text('\n'.join(code)+'\n',encoding='utf-8',newline='\n')
        profile_metrics[device['id']]=dict(path=f"profiles/{device['id']}/FontData.mc",sha256=hashlib.sha256((directory/'FontData.mc').read_bytes()).hexdigest(),numeric_sizes=sorted(numbers),label_sizes=[maximums['LABEL_SIZE']],resource_path=declaration.relative_to(root).as_posix(),resource_sha256=hashlib.sha256(declaration.read_bytes()).hexdigest(),encoding='exact glyph tops/bottoms/advances as unsigned byte arrays')
    record=json.loads((root/'config/font-manifest.json').read_text(encoding='utf-8'))
    record['profile_metrics']=profile_metrics
    (root/'config/font-manifest.json').write_text(json.dumps(record,indent=2,ensure_ascii=False)+'\n',encoding='utf-8',newline='\n')
    code=['// Generated thin selectors; profile tables avoid unused resource/metric references.',
          'module FontSelection {',
          'function info(size,labelRole) { return FontData.info(size,labelRole); }',
          'function height(size,labelRole) { return FontData.height(size,labelRole); }','}']
    (root/'source/FontSelection.mc').write_text('\n'.join(code)+'\n',encoding='utf-8',newline='\n')
    metrics=['// Generated from exact masks; data is profile-specific and byte-packed.','module FontMetrics {',
             'function numeric(height) { return FontData.numeric(height); }',
             'function label(height) { return FontData.label(height); }']
    metrics.extend(['function width(text,metrics) {',
        'var width=0; for(var i=0;i<text.length();i+=1) { var index=metrics[0].find(text.substring(i,i+1));',
        'if(index==null) { return 2147483647; } width+=metrics[3][index]; } return width;','}',
        'function bounds(text,metrics) {','var top=null; var bottom=0;',
        'for(var i=0;i<text.length();i+=1) { var index=metrics[0].find(text.substring(i,i+1));',
        'if(index!=null && metrics[2][index]>metrics[1][index]) {',
        'if(top==null || metrics[1][index]<top) { top=metrics[1][index]; }',
        'if(metrics[2][index]>bottom) { bottom=metrics[2][index]; }','}}',
        'return [top==null?0:top,bottom];','}','}'])
    (root/'source/FontMetrics.mc').write_text('\n'.join(metrics)+'\n',encoding='utf-8',newline='\n')
    icon=Image.new('RGBA',(40,40),(0,0,0,255));d=ImageDraw.Draw(icon);d.rectangle((4,4,35,35),outline=(255,255,255,255),width=2);d.line((20,4,20,35),fill='white');d.line((4,20,35,20),fill='white')
    icon.save(root/'resources/drawables/launcher.png')
    (root/'resources/drawables/drawables.xml').write_text('<?xml version="1.0"?><resources><bitmaps><bitmap id="LauncherIcon" filename="launcher.png"/></bitmaps></resources>\n',encoding='utf-8',newline='\n')
    return manifest

def main():
    manifest=generate()
    print(f'Generated {len(manifest)} deterministic one-bit glyph atlases and font-selection source from verified assets.')

if __name__=='__main__':main()
