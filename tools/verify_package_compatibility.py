"""Check signed IQ firmware/API gates without modifying the package or SDK."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import xml.etree.ElementTree as ET
from compile_package import effective_metadata


def verify(iq, devices, seven):
    root = Path(__file__).resolve().parents[1]
    policy = json.loads((root/'config/firmware-compatibility.json').read_text())
    overlay = json.loads((root/'artifacts/package-device-overlay.json').read_text())
    manifest = subprocess.run([seven, 'x', '-so', str(iq), 'manifest.xml'],
                              capture_output=True, check=True).stdout
    products = [p.attrib for p in ET.fromstring(manifest).iter() if p.tag.endswith('}product')]
    actual = {p['partNumber']: p for p in products}
    if len(actual) != len(products):
        raise ValueError('Duplicate package part number')
    expected = {}
    for device in json.loads((root/'config/devices.json').read_text()):
        product = device['id']
        raw = (Path(devices)/product/'compiler.json').read_bytes()
        if hashlib.sha256(raw).hexdigest() != overlay['devices'][product]['original_sha256']:
            raise ValueError('Installed metadata changed: ' + product)
        for part in effective_metadata(json.loads(raw), product, policy)['partNumbers']:
            expected[part['number']] = {'firmware': str(part.get('firmwareVersion', 0)),
                                        'api': part['connectIQVersion']}
    if set(actual) != set(expected):
        raise ValueError('Package product/region inventory differs from configured targets')
    for part, gate in expected.items():
        if (actual[part].get('minFirmwareVersion', '0') != gate['firmware'] or
                actual[part]['connectIqVersion'] != gate['api']):
            raise ValueError('Unexpected package firmware/API gate: ' + part)
    return {'status': 'passed', 'package_sha256': hashlib.sha256(Path(iq).read_bytes()).hexdigest(),
            'parts': expected, 'installed_metadata_unchanged': True,
            'physical_qualification': 'not run'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--package', required=True)
    parser.add_argument('--devices', required=True)
    parser.add_argument('--seven', default=shutil.which('7z') or
                        str(Path(os.environ.get('ProgramFiles', 'C:/Program Files'))/'7-Zip/7z.exe'))
    args = parser.parse_args()
    report = verify(args.package, args.devices, args.seven)
    root = Path(__file__).resolve().parents[1]
    (root/'artifacts/package-compatibility.json').write_text(json.dumps(report, indent=2)+'\n')
    print('PASS: signed package firmware/API gates match policy for', len(report['parts']), 'regional variants; installed metadata unchanged.')


if __name__ == '__main__':
    main()
