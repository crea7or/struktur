"""Exercise fail-closed property serialization with the actual installed SDK."""
import argparse
import json
import subprocess
import tempfile
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
def main():
    parser=argparse.ArgumentParser();parser.add_argument('--sdk',required=True);parser.add_argument('--java',required=True);args=parser.parse_args()
    command=[str(Path(args.java)/'bin/java.exe'),'-cp',str(Path(args.sdk)/'bin/monkeybrains.jar'),str(ROOT/'tools/PropertyBudget.java')]
    xml=ET.parse(ROOT/'resources/settings/properties.xml');properties=xml.getroot().find('properties')
    for i in range(1000):ET.SubElement(properties,'property',id='x'+str(i).zfill(7),type='number').text='0'
    cases={
        'oversize':(ET.tostring(xml.getroot(),encoding='unicode'),'Property budget exceeded'),
        'duplicate':('<resources><properties>'+('<property id="team" type="string">TEAM</property>'*2)+'</properties></resources>','Duplicate key'),
        'invalid_key':('<resources><properties><property id="not_a_short_key" type="number">0</property></properties></resources>','Invalid compact key')}
    with tempfile.TemporaryDirectory(prefix='struktur-properties-') as folder:
        for name,(content,error) in cases.items():
            path=Path(folder)/(name+'.xml');path.write_text(content,encoding='utf-8')
            result=subprocess.run(command+[str(path),'8000'],capture_output=True,text=True)
            if result.returncode==0 or error not in result.stderr:raise RuntimeError('Serialization guard failed: '+name)
    print(json.dumps(dict(host_property_guard='passed',negative_cases=list(cases))))
if __name__=='__main__':main()
