"""Compile signed packages using an isolated, firmware-only device overlay."""
import argparse
import copy
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess


def effective_metadata(original):
    result = copy.deepcopy(original)
    matches = [p for p in result['partNumbers'] if p['number'] == '006-B3843-00']
    if len(matches) != 1:
        raise ValueError('Expected exactly one worldwide Edge 1040 part')
    part = matches[0]
    if part.get('firmwareVersion') != 3135 or part.get('connectIQVersion') != '6.0.0':
        raise ValueError('Upstream Edge 1040 metadata changed; review the firmware override')
    part['firmwareVersion'] = 3133
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--sdk', required=True)
    parser.add_argument('--java-home', required=True)
    parser.add_argument('--devices', required=True)
    args, compiler = parser.parse_known_args()
    if compiler[:1] == ['--']:
        compiler = compiler[1:]
    root = Path(__file__).resolve().parents[1]
    appdata = root / '.local/package-appdata'
    destination = appdata / 'Garmin/ConnectIQ/Devices'
    evidence = {}
    for device in json.loads((root / 'config/devices.json').read_text()):
        product = device['id']
        source = Path(args.devices) / product
        target = destination / product
        shutil.copytree(source, target, dirs_exist_ok=True)
        original = (source / 'compiler.json').read_bytes()
        if product == 'edge1040':
            effective = effective_metadata(json.loads(original))
            (target / 'compiler.json').write_text(json.dumps(effective, indent=4), encoding='utf-8')
        evidence[product] = {
            'original_sha256': hashlib.sha256(original).hexdigest(),
            'effective_sha256': hashlib.sha256((target / 'compiler.json').read_bytes()).hexdigest(),
        }
    (root / 'artifacts/package-device-overlay.json').write_text(json.dumps({
        'override': {'part': '006-B3843-00', 'firmware': 3133, 'api': '6.0.0'},
        'devices': evidence,
    }, indent=2), encoding='utf-8')
    env = os.environ.copy()
    env['APPDATA'] = str(appdata)
    command = [str(Path(args.java_home) / 'bin/java.exe'), '-Xms1g',
               '-Dfile.encoding=UTF-8', '-Dapple.awt.UIElement=true',
               '-cp', str(Path(args.sdk) / 'bin/monkeybrains.jar') + ';',
               'com.garmin.monkeybrains.Monkeybrains', *compiler]
    raise SystemExit(subprocess.run(command, cwd=root, env=env).returncode)


if __name__ == '__main__':
    main()
