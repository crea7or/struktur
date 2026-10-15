"""Generate an explicit, fail-closed physical source allowlist; no guessed models."""
import hashlib
import json
import sys
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
def main():
    data=json.loads((ROOT/'config/temperature-qualification.json').read_text(encoding='utf-8'))
    assert data['protocol']==1 and data['path']=='onboard-v1'
    entries=[]
    for item in data['qualified_targets']:
        assert item['model'] in {d['id'] for d in json.loads((ROOT/'config/devices.json').read_text(encoding='utf-8'))}
        assert isinstance(item['part_number'],str) and item['part_number']
        assert len(item['firmware'])==2 and all(type(v) is int and v>=0 for v in item['firmware'])
        evidence=(ROOT/item['evidence_path']).resolve()
        assert evidence.is_relative_to(ROOT) and evidence.is_file()
        assert hashlib.sha256(evidence.read_bytes()).hexdigest()==item['evidence_sha256']
        proof=json.loads(evidence.read_text(encoding='utf-8-sig'))
        assert proof['review_status']=='approved' and proof['onboard_only']=='passed' and proof['external_sensor_cases']=='passed'
        assert proof['model']==item['model'] and proof['part_number']==item['part_number'] and proof['firmware']==item['firmware']
        entries.append([item['part_number'],*item['firmware']])
    text='''using Toybox.System;
using Toybox.Lang;
// Generated from reviewed physical evidence. An empty allowlist disables source use.
(:background)
module TemperatureQualification {
    const TARGETS = %s;
    function qualified(part,firmware) {
        if(!(part instanceof Lang.String) || !(firmware instanceof Lang.Array) || firmware.size()!=2) { return false; }
        for(var i=0;i<TARGETS.size();i+=1) {
            var target=TARGETS[i];
            if(target[0].equals(part) && target[1]==firmware[0] && target[2]==firmware[1]) { return true; }
        }
        return false;
    }
    function current() {
        var device=System.getDeviceSettings();
        return device has :partNumber && device has :firmwareVersion && qualified(device.partNumber,device.firmwareVersion);
    }
}
'''%json.dumps(entries)
    if not entries:
        start=text.index('        for(var i=0;')
        end=text.index('        return false;',start)
        text=text[:start]+text[end:]
    path=ROOT/'source/TemperatureQualification.mc'
    if '--check' in sys.argv:
        assert path.read_text(encoding='utf-8')==text,'Temperature qualification source is stale; regenerate from reviewed evidence.'
    else:path.write_text(text,encoding='utf-8')
    print('Generated '+str(len(entries))+' physically qualified temperature target/firmware entries.')
if __name__=='__main__':main()
