"""Single-source settings/field resources. No production files are silently inferred."""
import json
import re
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FIELDS = [
    ('current_speed','Speed','DVS-8','currentSpeed','float','speed'),
    ('average_speed','Avg speed','DVS-9','averageSpeed','float','speed'),
    ('current_cadence','Cadence','DVS-10','currentCadence','integer','rpm'),
    ('average_cadence','Avg cadence','DVS-11','averageCadence','integer','rpm'),
    ('current_heart_rate','Heart rate','DVS-18','currentHeartRate','integer','bpm'),
    ('average_heart_rate','Avg HR','DVS-19','averageHeartRate','integer','bpm'),
    ('heart_rate_zone','HR zone','DVS-20',None,'integer',''),
    ('current_power','Power','DVS-21','currentPower','integer','W'),
    ('power_3s','3s power','DVS-22',None,'integer','W'),
    ('average_power','Avg power','DVS-23','averagePower','integer','W'),
    ('power_zone','Power zone','DVS-24',None,'integer',''),
    ('distance','Distance','DVS-25','elapsedDistance','float','distance'),
    ('elevation','Elevation','DVS-26','altitude','integer','elevation'),
    ('total_ascent','Ascent','DVS-27','totalAscent','integer','elevation'),
    ('total_descent','Descent','DVS-28','totalDescent','integer','elevation'),
    ('grade','Grade','DVS-29',None,'float','%'),
    ('activity_timer','Timer','DVS-30','timerTime','duration',''),
    ('elapsed_time','Elapsed','DVS-31','elapsedTime','duration',''),
    ('time_of_day','Time','DVS-32',None,'clock',''),
    ('calories','Calories','DVS-33','calories','integer','kcal'),
    ('temperature','Temperature','DVS-34',None,'float','temperature'),
    ('battery','Battery','DVS-35',None,'integer','%'),
    ('heading','Heading','DVS-36','currentHeading','integer','degrees'),
    ('distance_next_waypoint','Next point','DVS-37','distanceToNextPoint','float','distance'),
    ('completed_laps','Laps','DVS-39',None,'integer',''),
    ('heart_rate_3s','3s HR','DVS-47',None,'integer','bpm'),
    ('lap_distance','lap distance','FUNC-3',None,'float','distance'),
    ('lap_time','lap time','FUNC-4',None,'duration',''),
    ('lap_speed','lap speed','FUNC-5',None,'float','speed'),
    ('lap_heart_rate','lap heart rate','FUNC-6',None,'integer','bpm'),
    ('lap_power','lap power','FUNC-7',None,'integer','w'),
    ('lap_cadence','lap cadence','FUNC-8',None,'integer','rpm'),
    ('team','team','SPEC-253',None,'text',''),
]
DEFAULTS=['current_speed','distance','activity_timer','time_of_day','current_heart_rate',
          'power_3s','elevation','grade','total_ascent','temperature']
SECOND_DEFAULTS=['power_3s','current_heart_rate','current_cadence','grade','lap_power',
                 'current_speed','lap_distance','lap_time','elevation','temperature']
def write_xml(path, element):
    ET.indent(element, space='  ')
    path.parent.mkdir(parents=True,exist_ok=True)
    ET.ElementTree(element).write(path,encoding='utf-8',xml_declaration=True)

def main():
    for folder in ['config','resources/settings','resources/strings','resources/drawables','source','requirements']:
        (ROOT/folder).mkdir(parents=True,exist_ok=True)
    fields=[dict(id=f[0],label=f[1],requirement=f[2],member=f[3],format=f[4],unit=f[5]) for f in FIELDS]
    reviewed=json.loads((ROOT/'requirements/workspace-snapshot.json').read_text(encoding='utf-8-sig'))
    reviewed={r['stable_id']:r for r in reviewed}
    for field in fields:
        if field['id']=='team':
            field['header_with_units']=None;field['rendered_label']='team';continue
        description=reviewed[field['requirement']]['description']
        field['label']=re.search(r'Label text:\s*`([^`]*)`',description).group(1)
        header=re.search(r'Header text with units:\s*`([^`]*)`',description)
        field['header_with_units']=header.group(1) if header else None
        if field['header_with_units']=='""':field['header_with_units']=''
        if field['header_with_units']:
            text=field['header_with_units'];assert text==text.lower(),field['requirement']
            assert text.count('{unit}')<=1 and not re.search(r'[{}]',text.replace('{unit}','')),field['requirement']
        if field['unit'] not in ['speed','distance','elevation','temperature','degrees']:
            unit=re.search(r'Unit text:\s*`([^`]*)`',description).group(1)
            field['unit']='' if unit=='\"\"' else unit
    props=[dict(key='enlarged_field_count',type='number',default=0,choices=[0,1,2]),
           dict(key='alignment',type='number',default=1,choices=[0,1],identifiers=['center','right']),
           dict(key='theme_mode',type='number',default=0,choices=[0,1,2],identifiers=['auto','day','night']),
           dict(key='hide_value_units',type='boolean',default=True,title='Hide physical units in headers'),
           dict(key='inverse_enlarged_theme',type='boolean',default=True,title='Inverse theme for enlarged fields'),
           dict(key='grid_type',type='number',default=1,choices=[0,1,2],identifiers=['none','horizontal','full'],choice_labels=['None','Horizontal lines','Full grid'],title='Grid type')]
    for i in range(10):
        props.extend([dict(key=f'slot_{i+1}_value',type='number',default=[f['id'] for f in fields].index(DEFAULTS[i]),choices=list(range(len(fields))),identifiers=[f['id'] for f in fields]),
                      dict(key=f'slot_{i+1}_background_effects',type='boolean',default=False,hidden=True),
                      dict(key=f'slot_{i+1}_background_mode',type='number',default=-1,factory_default=0,choices=[0,1,2],choice_labels=['None','Label','Whole cell'],title=f'Field {i+1}: background coverage'),
                      dict(key=f'slot_{i+1}_team_text',type='string',default='TEAM',maxLength=32,title=f'Field {i+1}: Team text',prompt='Team field only. Up to 32 printable ASCII characters; preserve spaces and case.'),
                      dict(key=f'slot_{i+1}_team_font',type='number',default=0,choices=[0],choice_labels=['Automatic'],title=f'Field {i+1}: Team font',prompt='Only qualified general-text AUX fonts are offered. Unsupported saved AUX selections use Automatic.'),
                      dict(key=f'slot_{i+1}_team_color_source',type='number',default=0,choices=[0,1,2],choice_labels=['None','Power','Heart rate'],title=f'Field {i+1}: Team color source')])
    first_props=list(props)
    props += [dict(key=f'cadence_zone_{i}_max_rpm',type='number',default=value,min=0,max=300,title=f'Cadence zone {i}: upper rpm',prompt='Four increasing upper bounds define five coloring zones; both field sets share these values.') for i,value in enumerate([60,80,100,120],1)]
    props += [dict(key='second_set_trigger',type='number',default=3,choices=[0,1,2,3,4],
                   identifiers=['trigger_none','trigger_power_3s','trigger_heart_rate','trigger_manual_lap','trigger_workout'],
                   choice_labels=['None','3s power','Heart rate','Manual lap','Workout started'],title='Second field set - activation event',
                   prompt='Only the selected mode controls the second set. Edge 530/830/1030: disable Auto Lap. This device cannot distinguish manual from automatic lap events. Other automatic/workout lap sources must also be absent on those devices.'),
              dict(key='second_power_activate_w',type='number',default=250,min=1,max=3000,title='Power: activate at (W)',prompt='3s power mode only. Return threshold must be less than or equal to activation.'),
              dict(key='second_power_return_w',type='number',default=220,min=1,max=3000,title='Power: return below (W)',prompt='3s power mode only. Return threshold must be less than or equal to activation.'),
              dict(key='second_hr_activate_bpm',type='number',default=160,min=30,max=250,title='Heart rate: activate at (bpm)',prompt='Heart rate mode only. Return threshold must be less than or equal to activation.'),
              dict(key='second_hr_return_bpm',type='number',default=150,min=30,max=250,title='Heart rate: return below (bpm)',prompt='Heart rate mode only. Return threshold must be less than or equal to activation.')]
    for p in first_props:
        second=dict(p,key='second_'+p['key'],title='Second set: '+p.get('title',p['key'].replace('_',' ').capitalize()))
        slot=re.fullmatch(r'slot_(\d+)_value',p['key'])
        effect=re.fullmatch(r'slot_(\d+)_background_effects',p['key'])
        coverage=re.fullmatch(r'slot_(\d+)_background_mode',p['key'])
        if p['key']=='enlarged_field_count':second['default']=1
        elif slot:second['default']=[f['id'] for f in fields].index(SECOND_DEFAULTS[int(slot[1])-1])
        elif effect:second['default']=int(effect[1])<=4
        elif coverage:second['factory_default']=1 if int(coverage[1])<=4 else 0
        props.append(second)
    props.append(dict(key='settings_schema_version',type='number',default=0,hidden=True))
    (ROOT/'config/catalogue.json').write_text(json.dumps(dict(language='eng',status='full-capacity APP-20 layouts; APP-31 defines all ten defaults; SDK numeric mappings remain recorded implementation choices',fields=fields,properties=props),indent=2)+'\n',encoding='utf-8')
    resources=ET.Element('resources'); strings=ET.SubElement(resources,'strings')
    ET.SubElement(strings,'string',id='AppName').text='Struktur'
    for f in fields: ET.SubElement(strings,'string',id='Field_'+f['id']).text=f['label']
    properties_root=ET.Element('resources'); properties=ET.SubElement(properties_root,'properties')
    settings_root=ET.Element('resources'); settings=ET.SubElement(settings_root,'settings')
    ET.SubElement(strings,'string',id='SecondSetTitle').text='Second field set'
    ET.SubElement(strings,'string',id='SecondSetDescription').text='Used only while the selected activation event is active. None keeps the default set. Power thresholds apply only to 3s power; heart-rate thresholds only to Heart rate. Neither pair applies to Manual lap, Workout started or None.'
    ET.SubElement(strings,'string',id='CadenceZonesTitle').text='Cadence coloring zones'
    second_group=None
    for p in props:
        if p['key']=='cadence_zone_1_max_rpm':
            second_group=ET.SubElement(settings,'group',id='cadence_zones',title='@Strings.CadenceZonesTitle')
        if p['key']=='second_set_trigger':
            second_group=ET.SubElement(settings,'group',id='second_field_set',title='@Strings.SecondSetTitle',description='@Strings.SecondSetDescription')
        ET.SubElement(properties,'property',id=p['key'],type=p['type']).text=str(p['default']).lower() if p['type']=='boolean' else str(p['default'])
        if p.get('hidden'):continue
        sid='Setting_'+p['key']; ET.SubElement(strings,'string',id=sid).text=p.get('title',p['key'].replace('_',' ').capitalize())
        setting=ET.SubElement(second_group if second_group is not None else settings,'setting',propertyKey='@Properties.'+p['key'],title='@Strings.'+sid)
        if p.get('prompt'):
            prompt='Prompt_'+p['key'];ET.SubElement(strings,'string',id=prompt).text=p['prompt'];setting.set('prompt','@Strings.'+prompt)
        ctype='list' if 'choices' in p else ('boolean' if p['type']=='boolean' else ('alphaNumeric' if p['type']=='string' else 'numeric'))
        config=ET.SubElement(setting,'settingConfig',type=ctype)
        if 'maxLength' in p:config.set('maxLength',str(p['maxLength']))
        if 'min' in p:config.set('min',str(p['min']));config.set('max',str(p['max']))
        for index,value in enumerate(p.get('choices',[])):
            identifier=p.get('identifiers',p.get('choices',[]))[index]
            label='Choice_'+(p['key']+'_' if p.get('choice_labels') else '')+str(identifier)
            field=next((f for f in fields if f['id']==identifier),None)
            if not any(s.attrib.get('id')==label for s in strings):ET.SubElement(strings,'string',id=label).text=p.get('choice_labels',[])[index] if p.get('choice_labels') else (field['label'] if field else str(identifier).replace('_',' ').capitalize())
            ET.SubElement(config,'listEntry',value=str(value)).text='@Strings.'+label
    # Settings text is not runtime UI. Legacy VMs cap a module at 254 members.
    for entry in strings:
        if entry.attrib['id']!='AppName':entry.set('scope','settings')
    write_xml(ROOT/'resources/strings/strings.xml',resources)
    write_xml(ROOT/'resources/settings/properties.xml',properties_root)
    write_xml(ROOT/'resources/settings/settings.xml',settings_root)
    mc=['// Generated by tools/generate_catalog.py from the versioned selectable DVS list and user-authorized presentation supplement.','module Catalog {',
        '    const IDS = '+json.dumps([f['id'] for f in fields])+';',
        '    const LABELS = '+json.dumps([f['label'] for f in fields])+';',
        '    const HEADERS_WITH_UNITS = '+json.dumps([f['header_with_units'] for f in fields],ensure_ascii=False)+';',
        '    const FORMATS = '+json.dumps([f['format'] for f in fields])+';',
        '    const UNITS = '+json.dumps([f['unit'] for f in fields])+';',
        '    function index(id) { for (var i=0;i<IDS.size();i+=1) { if(IDS[i].equals(id)) { return i; } } return null; }',
        '    function defaultSlots() { return '+json.dumps(DEFAULTS)+'; }',
        '    function secondaryDefaultSlots() { return '+json.dumps(SECOND_DEFAULTS)+'; }','}',
        'module SettingsCatalogue {','    function keys() { return '+json.dumps([p['key'] for p in props])+'; }',
        '    // Garmin settings lists store numeric codes; retain legacy strings without rewriting them.',
        '    function decode(key,value) {',
        '        if (!(value instanceof Toybox.Lang.Number)) { return value; }',
        '        if(key.find("second_")==0) { key=key.substring(7,key.length()); }',
        '        var ids = "alignment".equals(key) ? ["center","right"] : ("theme_mode".equals(key) ? ["auto","day","night"] : ("grid_type".equals(key) ? ["none","horizontal","full"] : Catalog.IDS));',
        '        if(value>=0 && value<ids.size()) { return ids[value]; }',
        '        return key.find("slot_")==0 && value>=0?"unknown_field_"+value.toString():null;',
        '    }','}']
    (ROOT/'source/Catalog.mc').write_text('\n'.join(mc)+'\n',encoding='utf-8')
    adapter=['using Toybox.System;','using Toybox.Lang;','// SPEC-156: explicit optional Activity.Info members, raw producer units.','module ActivityReader {','    function read(info) as Lang.Dictionary { return readWithBattery(info,true); }','    function readWithBattery(info,includeBattery) as Lang.Dictionary {','        var raw = {} as Lang.Dictionary;']
    for f in fields:
        if f['member']:adapter.append(f'        if (info has :{f["member"]}) {{ raw["{f["id"]}"] = Numeric.finite(info.{f["member"]}) ? info.{f["member"]} : null; }}')
    adapter.extend(['        raw["battery"]=includeBattery?batteryValue():null;',
                    '        // Stateful acquisition is shared independently of active field assignments.',
                    '        raw["grade"] = null; raw["completed_laps"] = null; raw["temperature"] = null;',
                    '        return raw;','    }',
                    '    function batteryValue() {',
                    '        var stats=System.getSystemStats();',
                    '        return stats has :battery && Numeric.finite(stats.battery) && stats.battery>=0 && stats.battery<=100?stats.battery:null;',
                    '    }','}'])
    (ROOT/'source/ActivityReader.mc').write_text('\n'.join(adapter)+'\n',encoding='utf-8')
    print(f'Generated {len(fields)} selectable fields and {len(props)} typed settings with matching XML/Monkey C definitions.')

if __name__=='__main__':main()
