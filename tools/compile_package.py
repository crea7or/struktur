"""Compile signed packages using an isolated, evidence-based compatibility overlay."""
import argparse
import copy
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess


def api_version(value):
    parts = value.split('.')
    if len(parts) != 3 or any(not part.isdigit() for part in parts):
        raise ValueError('Expected a three-component Connect IQ API version')
    return tuple(int(part) for part in parts)


def effective_metadata(original, product='edge1040', policy=None):
    if policy is None:
        policy = json.loads((Path(__file__).resolve().parents[1] /
                             'config/firmware-compatibility.json').read_text())
    result = copy.deepcopy(original)
    rule = policy['overrides'].get(product)
    if rule is None:
        return result
    matches = [p for p in result['partNumbers'] if p['number'] == rule['part']]
    if len(matches) != 1:
        raise ValueError('Expected exactly one declared part: ' + rule['part'])
    part = matches[0]
    if (part.get('firmwareVersion') != rule['upstream_firmware'] or
            part.get('connectIQVersion') != rule['upstream_api']):
        raise ValueError('Upstream metadata changed; review the firmware override: ' + product)
    if (not isinstance(rule['firmware'], int) or isinstance(rule['firmware'], bool) or
            rule['firmware'] <= 0 or rule['firmware'] > rule['upstream_firmware']):
        raise ValueError('Invalid effective firmware floor')
    if (api_version(rule['api']) < api_version(policy['feature_api_floor']) or
            api_version(rule['api']) > api_version(rule['upstream_api'])):
        raise ValueError('Effective API must retain the declared feature floor')
    if not rule.get('evidence') or not rule.get('evidence_scope'):
        raise ValueError('Model-specific firmware/API evidence is required')
    kind = rule.get('evidence_kind')
    if kind not in ('device_report', 'release_family_inference'):
        raise ValueError('Declare the compatibility evidence kind')
    if kind == 'release_family_inference' and not rule.get('api_evidence'):
        raise ValueError('Release-family inference requires its API evidence anchor')
    part['firmwareVersion'] = rule['firmware']
    part['connectIQVersion'] = rule['api']
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
    policy = json.loads((root / 'config/firmware-compatibility.json').read_text())
    evidence = {}
    for device in json.loads((root / 'config/devices.json').read_text()):
        product = device['id']
        source = Path(args.devices) / product
        target = destination / product
        shutil.copytree(source, target, dirs_exist_ok=True)
        original = (source / 'compiler.json').read_bytes()
        if product in policy['overrides']:
            effective = effective_metadata(json.loads(original), product, policy)
            (target / 'compiler.json').write_text(json.dumps(effective, indent=4), encoding='utf-8')
        evidence[product] = {
            'original_sha256': hashlib.sha256(original).hexdigest(),
            'effective_sha256': hashlib.sha256((target / 'compiler.json').read_bytes()).hexdigest(),
        }
    (root / 'artifacts/package-device-overlay.json').write_text(json.dumps({
        'overrides': policy['overrides'],
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
