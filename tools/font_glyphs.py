"""Derive font-role coverage from text that the current English UI can render."""
import hashlib
import json
import re
from pathlib import Path
from header_text import unit_header

ROOT = Path(__file__).resolve().parents[1]
LITERAL = r'"(?:\\.|[^"\\])*"'

def literals(text):
    return [json.loads(value) for value in re.findall(LITERAL, text)]

INPUT_PATHS = ['config/catalogue.json', 'config/decisions.json', 'config/devices.json', 'requirements/workspace-snapshot.json',
               'source/Snapshot.mc', 'source/FieldRenderer.mc', 'source/MaskedText.mc', 'source/Policy.mc',
               'source/Formatting.mc', 'source/FieldPresentation.mc', 'tools/font_glyphs.py',
               'tools/generate_fonts.py', 'tools/requirements.txt', 'tools/header_text.py',
               'tools/generate_catalog.py', 'source/Catalog.mc']

def input_inventory(root=ROOT):
    profiles=json.loads((root/'config/devices.json').read_text(encoding='utf-8-sig'))
    paths=INPUT_PATHS+[f"profiles/{d['id']}/DeviceProfile.mc" for d in profiles]
    return {path: hashlib.sha256((root/path).read_bytes()).hexdigest() for path in paths}

def glyph_contract(root=ROOT):
    catalogue=json.loads((root/'config/catalogue.json').read_text(encoding='utf-8-sig'))
    if catalogue['language'] != 'eng':
        raise ValueError('Language scope changed; define and review the new role inventory.')
    snapshot=(root/'source/Snapshot.mc').read_text(encoding='utf-8')
    renderer=(root/'source/FieldRenderer.mc').read_text(encoding='utf-8')
    policy=(root/'source/Policy.mc').read_text(encoding='utf-8')
    formatting=(root/'source/Formatting.mc').read_text(encoding='utf-8')
    formats=sorted({field['format'] for field in catalogue['fields']})
    if set(formats)!={'float','integer','duration','clock'}:
        raise ValueError('Supported formatting modes changed; review glyph output rules.')
    patterns=sorted({text for text in literals(formatting) if text.startswith('%')})
    if set(patterns)!={'%.2f','%.1f','%.0f','%02d','%d'}:
        raise ValueError('Numeric formatting patterns changed; review glyph output alphabet.')
    markers=[]
    for name in ['UNAVAILABLE','OVERFLOW']:
        match=re.search(r'const\s+'+name+r'\s*=\s*('+LITERAL+r')',policy)
        if not match:raise ValueError('Missing literal presentation marker: '+name)
        markers.append(json.loads(match.group(1)))
    numeric=''.join(sorted(set('0123456789-.:'+''.join(markers))))
    unit_variants={}
    pattern=r'(?:if|else\s+if)\(\s*('+LITERAL+r')\.equals\(unit\)\s*\)\s*\{[^}\n]*?\bunit\s*=\s*([^;]+);'
    for match in re.finditer(pattern,snapshot):
        unit_variants[json.loads(match.group(1))]=literals(match.group(2))
    if set(unit_variants)!={'speed','distance','elevation','temperature','degrees'}:
        raise ValueError('Unit-conversion text changed; review glyph-contract extraction.')
    units=sorted({text for field in catalogue['fields'] for text in unit_variants.get(field['unit'],[field['unit']])})
    unknown=re.search(r'var\s+label\s*=\s*idx\s*==\s*null\s*\?\s*('+LITERAL+r')',snapshot)
    compact=re.search(r'_compactText\s*=\s*('+LITERAL+r')',renderer)
    if not unknown or not compact:raise ValueError('Fallback label text changed; review glyph coverage.')
    fallbacks=[json.loads(unknown.group(1)),json.loads(compact.group(1))]
    for match in re.finditer(r'_compactLines\s*=\s*\[([^;\n]*)\];',renderer):
        fallbacks.extend(literals(match.group(1)))
    periods=re.search(r'hour\s*<\s*12\s*\?\s*('+LITERAL+r')\s*:\s*('+LITERAL+r')',formatting)
    if not periods or 'label+=" | "+Formatting.clockPeriod(clock.hour)' not in snapshot:
        raise ValueError('Clock header text changed; review font roles.')
    clock_units=[json.loads(periods.group(i)) for i in [1,2]]
    labels=[field['label'] for field in catalogue['fields']]+fallbacks
    # Only rendered substitutions/literals contribute glyphs; braces and the
    # placeholder name are specification syntax and never appear on screen.
    headers=[unit_header(field,unit) for field in catalogue['fields']
             for unit in unit_variants.get(field['unit'],[field['unit']]) if unit]
    labels+=headers
    directions=re.search(r'var directions=\[([^\n;]+)\];',formatting)
    if not directions:raise ValueError('Heading cardinal text changed; review label-role coverage.')
    labels+=literals(directions.group(1))
    if 'Formatting.durationParts(value,PresentationPolicy.PAD_LEADING_MINUTES)' not in snapshot:
        raise ValueError('Duration secondary output changed; review font roles.')
    if 'return [text.substring(0,primaryLength),text.substring(primaryLength,text.length())]' not in formatting:
        raise ValueError('Duration secondary extraction changed; review its output alphabet.')
    if '+ "." + remainder.format("%02d")' not in formatting:
        raise ValueError('Duration seconds separator changed; review its output alphabet.')
    # Every .SS value from 00 to 59 can occur. Derive its exact secondary alphabet.
    duration_seconds=[f'.{second:02d}' for second in range(60)]
    duration_glyphs=''.join(sorted(set(''.join(duration_seconds))))
    label_glyphs=''.join(sorted(set(''.join(labels+clock_units+duration_seconds))))
    return dict(language='eng',numeric_glyphs=numeric,label_glyphs=label_glyphs,
                labels=labels,units=units,clock_header=clock_units,duration_secondary_glyphs=duration_glyphs,markers=markers,
                formatting_rules=dict(modes=formats,patterns=patterns,
                    numeric_alphabet='0123456789-.:',
                    trace='Formatting.mc: bounded decimal/integer outputs and colon-separated hours/minutes; Snapshot.mc uses lowercase clock-header indicators and .SS secondary below ten hours in the label role'),
                expected_codepoints=dict(numeric=[ord(c) for c in numeric],label=[ord(c) for c in label_glyphs]),
                marker_decision_status='approved under APP-35 and config/decisions.json',
                scope='Union of supported current UI text per font role; not the full source-font charset.')
