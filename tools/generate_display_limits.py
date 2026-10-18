"""Derive conservative display intervals at the pinned APP-24 font sizes.

Checks exact atlas metrics against the smallest native cell of each role.
Every accepted numeric pattern includes every possible digit's ink envelope.
This is host analysis; Core independently checks production fitting in Garmin.
"""
import argparse
from decimal import Decimal, ROUND_HALF_UP
import json
import re
from functools import lru_cache
from pathlib import Path
from header_text import unit_header

ROOT = Path(__file__).resolve().parents[1]
GROUPS = [
    dict(id='small', title='530/540/830/840', products=['edge530','edge540','edge830','edge840']),
    dict(id='550', title='550/850', products=['edge550','edge850']),
    dict(id='wide', title='1030/1040', products=['edge1030','edge1040']),
    dict(id='large', title='1050', products=['edge1050']),
]


def read(name): return json.loads((ROOT/name).read_text(encoding='utf-8-sig'))

# All selectable fields can have a semantic or neutral label-band outline.
EFFECTS = {field['id'] for field in read('config/catalogue.json')['fields']}


def rounded(value, places):
    return Decimal(str(value)).quantize(Decimal(1).scaleb(-places), rounding=ROUND_HALF_UP)


def magnitude_text(value):
    magnitude=abs(Decimal(str(value)))
    precision=2 if magnitude<10 else (1 if magnitude<100 else 0)
    result=rounded(value,precision)
    if precision==2 and abs(result)>=10:
        precision=1; result=rounded(value,precision)
    if precision==1 and abs(result)>=100:
        precision=0; result=rounded(value,precision)
    if not result: result=abs(result)
    return f'{result:.{precision}f}'


def formatted(field, value, clock24=True):
    fmt=field['format']; unit=field['unit']
    if fmt=='duration':
        seconds=int(value); hours=seconds//3600; minute=(seconds%3600)//60
        primary=f'{hours}:{minute:02}' if hours else f'{minute:02}'
        return primary, f'.{seconds%60:02}' if hours<10 else ''
    if fmt=='clock':
        hour=int(value)//60; minute=int(value)%60
        return (f'{hour:02}:{minute:02}' if clock24 else f'{hour%12 or 12}:{minute:02}'), ''
    if field['id']=='grade':
        result=rounded(value,1);return f'{(abs(result) if not result else result):.1f}', ''
    if field['id']=='temperature': return f'{rounded(value,1):.1f}', ''
    if fmt=='float' and field['id']!='elevation': return magnitude_text(value), ''
    if fmt=='integer' or field['id']=='elevation': return str(int(rounded(value,0))), ''
    for precision in [2,1,0]:
        result=rounded(value,precision)
        if not result: result=abs(result)
        text=f'{result:.{precision}f}'
        if len(text)<=5: return text,''
    raise ValueError(('Unexpected domain overflow',field['id'],value))


def segments(field, low, high, clock24):
    fmt=field['format']
    if fmt=='duration': candidates=[(0,3599),(3600,35999),(36000,359999)]; step=1
    elif fmt=='clock':
        candidates=[(0,1439)] if clock24 else [(0,59),(60,599),(600,779),(780,1319),(1320,1439)]
        step=1
    elif fmt=='float' and field['id'] not in ['temperature','grade','elevation']:
        candidates=[(-99999,-10000,1),(-9999,-1000,1),(-999,-100,1),(-99.9,-10,0.1),(-9.99,-0.01,0.01),(0,9.99,0.01),(10,99.9,0.1),(100,999,1),(1000,9999,1),(10000,99999,1)]
        return [(max(a,low),min(b,high),step) for a,b,step in candidates if max(a,low)<=min(b,high)]
    elif field['id'] in ['temperature','grade']:
        candidates=[(-99.9,-10),(-9.9,-0.1),(0,9.9),(10,99.9),(100,199.9)]; step=0.1
    elif fmt=='integer' or field['id']=='elevation':
        candidates=[(-1000,-1000),(-999,-100),(-99,-10),(-9,-1),(0,9),(10,99),(100,999),(1000,9999),(10000,99999)]; step=1
    else:
        candidates=[(-40,-10),(-9.99,-0.01),(0,9.99),(10,99.99),(100,999.9)]; step=0.01
    return [(max(a,low),min(b,high),step) for a,b in candidates if max(a,low)<=min(b,high)]


def examples(low, high, step):
    middle=float((Decimal(str(low))+Decimal(str(high)))/2)
    middle=float(rounded(middle, 2 if step==0.01 else (1 if step==0.1 else 0)))
    return sorted(set([low,max(low,min(high,middle)),high]))


def metrics(font):
    return {ch:dict(top=bound[0],bottom=bound[1],advance=advance)
            for ch,bound,advance in zip(font['glyphs'],font['ink_bounds'],font['advances'])}


def width(text, font): return sum(font[c]['advance'] for c in text)


def bounds(text, font, envelope=False):
    # Tabular digit advances are checked below. Guarantee every digit, rather
    # than predicting only the endpoint's particular visible ink.
    chars=set(text)
    if envelope and any(c.isdigit() for c in text): chars.update('0123456789')
    visible=[font[c] for c in chars if font[c]['bottom']>font[c]['top']]
    return (min(c['top'] for c in visible),max(c['bottom'] for c in visible)) if visible else (0,0)


@lru_cache(maxsize=2)
def shared_band_height(glyph_bounds):
    font={ch:dict(top=top,bottom=bottom) for ch,top,bottom in glyph_bounds}
    headers=set()
    for field in read('config/catalogue.json')['fields']:
        headers.add(field['label'])
        for statute in [False,True]:
            header=unit_header(field,units(field,statute),True)
            headers.add(header)
            if field['format']=='clock':headers.update([header+' | am',header+' | pm'])
    minimum=min(6+sum(bounds(header,font)) for header in headers)
    safe=max(3+bounds(header,font)[1]+1 for header in headers)
    return max(minimum,safe)


def header_band_height(font):
    return shared_band_height(tuple((ch,m['top'],m['bottom']) for ch,m in sorted(font.items())))


def fits(text, secondary, label, numeric, labels, line_height, w, h, radius, label_effect=False):
    margin=4+radius
    if width(label,labels)>w-2*margin: return False
    ink=bounds(text,numeric,True); unit_ink=bounds(secondary,labels,True)
    header_height=max(line_height,header_band_height(labels))
    top=int(rounded(header_height+(h-header_height-(ink[1]-ink[0]))/2,0))
    total=width(text,numeric)+(width(secondary,labels)+2 if secondary else 0)
    band_height=header_band_height(labels) if label_effect else 0
    return (total<=w-2*margin and top>=band_height and top-radius>=header_height and
            top-radius>=4+bounds(label,labels)[1]+radius+2 and
            top+ink[1]-ink[0]+radius<=h and top+unit_ink[1]-unit_ink[0]+radius<=h)


def units(field, statute):
    return {'speed':('km/h','mph'),'distance':('km','mi'),'elevation':('m','ft'),
            'temperature':('°c','°f'),'degrees':('°','°')}.get(field['unit'],(field['unit'],field['unit']))[statute]


def cell_minimum(device, enlarged):
    # All eligible native/fallback rows and all enlargement counts. Widths are
    # even in the nine profiles; floor height is the smallest actual row span.
    rows=device['design_rows']; w=device['design_width']; h=device['design_height']
    return (w if enlarged else w//2), (2*h//rows if enlarged else h//rows)


def range_text(field, intervals):
    def number(value):
        if field['format']=='clock': return f'{int(value)//60:02}:{int(value)%60:02}'
        if field['format']=='duration':
            seconds=int(value); return f'{seconds//3600}:{seconds%3600//60:02}:{seconds%60:02}'
        if field['format']=='float' and field['id'] not in ['temperature','grade','elevation']: return str(int(value)) if int(value)==value else str(value)
        return str(value)
    return '; '.join(number(row['min'])+'–'+number(row['max']) for row in intervals) or 'none'


def field_table(record, field, groups):
    lines=['| Cell / physical-unit header | '+' | '.join(g['title'] for g in groups)+' |',
           '| --- | '+' | '.join('---' for _ in groups)+' |']
    for enlarged in [False,True]:
        for shown in [False,True]:
            cells=[('enlarged' if enlarged else 'regular')+', '+('shown' if shown else 'hidden')]
            for group in groups:
                contexts=[c for c in record['contexts'] if c['group']==group['id'] and c['enlarged']==enlarged and c['headers_shown']==shown]
                if field['format']=='clock':
                    text='; '.join(('24h: ' if mode else '12h: ')+range_text(field,next(c for c in contexts if c['clock24']==mode and not c['statute'])['intervals']) for mode in [True,False])
                else:
                    a=next(c for c in contexts if not c['statute']); b=next(c for c in contexts if c['statute'])
                    text=range_text(field,a['intervals']) if a['intervals']==b['intervals'] else a['unit']+': '+range_text(field,a['intervals'])+'; '+b['unit']+': '+range_text(field,b['intervals'])
                    if field['format']=='duration' and text!='none': text+=' elapsed h:mm:ss'
                cells.append(text)
            lines.append('| '+' | '.join(cells)+' |')
    return '\n'.join(lines)


def requirement_limits_match(description, record, field, groups):
    """Accept a full table, or one exact interval only when every context agrees."""
    description = description.replace('\r', '')
    table = field_table(record, field, groups)
    if table in description:
        return True
    cells = [cell.strip() for row in table.splitlines()[2:]
             for cell in row.strip('|').split('|')[1:]]
    if not cells or len(set(cells)) != 1:
        return False
    statement = ('Normal display ranges: ' + cells[0] +
                 '. All supported devices, regular/enlarged cells, headers hidden/shown.')
    return statement in description


def generate():
    fields=read('config/catalogue.json')['fields']; domains={r['field']:r for r in read('config/display-domains.json')['fields']}
    devices={d['id']:d for d in read('config/devices.json')}; fonts={f['id']:f for f in read('config/font-manifest.json')['fonts']}
    groups=[]
    for group in GROUPS:
        group=dict(group); first=group['products'][0]; device=devices[first]
        source=(ROOT/f'profiles/{first}/DeviceProfile.mc').read_text()
        sizes={k:int(re.search(k+r'=(\d+)',source)[1]) for k in ['BIG_SIZE','REGULAR_SIZE','LABEL_SIZE']}
        group.update(width=device['design_width'],height=device['design_height'],rows=device['design_rows'],sizes=sizes)
        groups.append(group)
    records=[]; fixture_by_group={g['id']:[] for g in groups}; missing_by_group={g['id']:[] for g in groups}
    for index,field in enumerate(fields):
        if field['format']=='text':continue  # Native text bounds have separate executable checks.
        record=dict(field=field['id'],requirement=field['requirement'],precision=domains[field['id']]['precision'],contexts=[])
        for group in groups:
            device=devices[group['products'][0]]; label_record=fonts['Label'+str(group['sizes']['LABEL_SIZE'])]; labels=metrics(label_record)
            for enlarged in [False,True]:
                size=group['sizes']['BIG_SIZE' if enlarged else 'REGULAR_SIZE']; numeric=metrics(fonts['Value'+str(size)])
                assert len({numeric[c]['advance'] for c in '0123456789'})==1, 'Revisit the pattern proof for proportional digits'
                w,h=cell_minimum(device,enlarged)
                for statute in [False,True]:
                    domain=list(domains[field['id']]['normal_range'].values())[int(statute)] if len(domains[field['id']]['normal_range'])==2 else next(iter(domains[field['id']]['normal_range'].values()))
                    if field['format']=='duration': domain=[0,359999]
                    unit=units(field,statute)
                    for shown in [False,True]:
                        for clock24 in ([True,False] if field['format']=='clock' else [True]):
                            header=unit_header(field,unit,shown)
                            # Every known field can now paint a semantic or neutral band.
                            radius=1; bands=[]; samples=[]; previous_step=None
                            for low,high,step in segments(field,*domain,clock24):
                                points=examples(low,high,step); prepared=[]; accepted=True
                                for value in points:
                                    label=header
                                    if field['format']=='clock' and not clock24: label+=' | '+('am' if value<720 else 'pm')
                                    text,secondary=formatted(field,value,clock24)
                                    if not fits(text,secondary,label,numeric,labels,label_record['line_height'],w,h,radius,field['id']!='grade'): accepted=False
                                    prepared.append([value*1000 if field['format']=='duration' else value,text,secondary])
                                if accepted:
                                    if bands and abs(bands[-1]['max']+min(previous_step,step)-low)<0.000001: bands[-1]['max']=high
                                    else: bands.append(dict(min=low,max=high))
                                    samples.extend(prepared); previous_step=step
                            samples=list({json.dumps(s):s for s in samples}.values())
                            context=dict(group=group['id'],enlarged=enlarged,statute=statute,headers_shown=shown,clock24=clock24,unit=unit,intervals=bands)
                            if not bands:
                                clock_header=header+(' | am' if field['format']=='clock' and not clock24 else '')
                                context['reason']='header exceeds cell width' if width(clock_header,labels)>w-2*(4+radius) else 'complete required numeric format exceeds cell bounds'
                                # Store a concrete unsupported fixture for request-only Placement.
                                value=domain[0]; text,secondary=formatted(field,value,clock24)
                                missing_by_group[group['id']].append([index,statute,not shown,clock24,enlarged,value*1000 if field['format']=='duration' else value,text,secondary])
                            else: fixture_by_group[group['id']].append([index,statute,not shown,clock24,enlarged,samples])
                            record['contexts'].append(context)
        records.append(record)
    result=dict(scope='Current APP-24 fonts fit complete clocks and hour-plus-seconds timers. Conservative normal intervals, not maximum representable sets; none is an explicit limitation, never a passing fit assertion. Bounds apply after conversion and presentation rounding. Other values retain APP-34 fallback. Not sensor validity or hardware qualification.',
                groups=groups,conditions='Full-screen dimensions; every native enlargement count, either alignment, Day/Night, worst applicable one-pixel halo. Regular role is absent from four-row/two-enlarged grids. Optional heading cardinal text may be omitted; required primary/secondary text may not.',fields=records)
    return result,fixture_by_group,missing_by_group


def outputs():
    contract,fixtures,missing=generate(); files={'config/display-limits.json':json.dumps(contract,indent=2,ensure_ascii=False)+'\n'}
    for group in contract['groups']:
        name=group['id']; data=json.dumps(fixtures[name],separators=(',',':'),ensure_ascii=False); absent=json.dumps(missing[name],separators=(',',':'),ensure_ascii=False)
        code='// Generated layout-specific contract fixtures; included only in test jungles.\n(:testSupport)\nmodule NormalLimits {\n'
        code+='function cases() { return '+data+'; }\n'
        code+='function unsupported() { return '+absent+'; }\n}\n'
        code=code.replace('function unsupported()', 'function unsupportedCount() { return '+str(len(missing[name]))+'; }\nfunction unsupported()')
        files[f'tests/limits/{name}/NormalLimits.mc']=code
    return files


def main():
    parser=argparse.ArgumentParser();parser.add_argument('--check',action='store_true');args=parser.parse_args()
    for name,text in outputs().items():
        path=ROOT/name
        if args.check:
            assert path.read_text(encoding='utf-8')==text, 'Stale display limit output: '+name
        else:
            path.parent.mkdir(parents=True,exist_ok=True);path.write_text(text,encoding='utf-8')
    if args.check:
        rows={r['stable_id']:r for r in read('requirements/workspace-snapshot.json')}
        contract=read('config/display-limits.json')
        catalogue={f['id']:f for f in read('config/catalogue.json')['fields']}
        for field in contract['fields']:
            description=rows[field['requirement']]['description']
            assert 'Precision:' in description and 'Normal display ranges' in description, field['requirement']
            assert requirement_limits_match(description, field, catalogue[field['field']], contract['groups']), ('Requirement ranges differ from executable limits',field['requirement'])
        fonts={font['id']:font for font in read('config/font-manifest.json')['fonts']}
        devices={device['id']:device for device in read('config/devices.json')}
        for group in contract['groups']:
            label=fonts['Label'+str(group['sizes']['LABEL_SIZE'])]; lm=metrics(label)
            for enlarged in [False,True]:
                size=group['sizes']['BIG_SIZE' if enlarged else 'REGULAR_SIZE']; nm=metrics(fonts['Value'+str(size)])
                w,h=cell_minimum(devices[group['products'][0]],enlarged)
                assert fits('00:00','','time',nm,lm,label['line_height'],w,h,1), (group['id'],size,'clock')
                assert fits('0:00','.00','timer',nm,lm,label['line_height'],w,h,1), (group['id'],size,'timer')
    print('Checked' if args.check else 'Generated','32 layout-specific display contracts at the pinned APP-24 fonts.')


if __name__=='__main__': main()
