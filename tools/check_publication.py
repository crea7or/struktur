"""Audit publishable files without printing credentials or personal values."""
import hashlib
from collections import Counter
import json
import re
import struct
import subprocess
from pathlib import Path, PurePosixPath
import zipfile

ROOT = Path(__file__).resolve().parents[1]
EXPORT = ROOT / 'requirements/export'

def read(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def audit_public_archive(path, patterns):
    """Inspect compressed publication content as well as repository filenames."""
    with zipfile.ZipFile(path) as archive:
        names = archive.namelist()
        assert len(names) == len(set(names)), 'Duplicate archive entries'
        assert sum(info.file_size for info in archive.infolist()) <= 50 * 1024 * 1024
        assert {'specification.md', 'specification.json', 'release.json', 'SHA256SUMS.txt'} <= set(names)
        for name in names:
            relative = PurePosixPath(name)
            assert not relative.is_absolute() and '..' not in relative.parts and '\\' not in name and ':' not in name
            data = archive.read(name)
            for reason, pattern in patterns.items():
                assert not re.search(pattern, data), (path.name, name, reason)
        checksums = {}
        for line in archive.read('SHA256SUMS.txt').decode('utf-8').splitlines():
            digest, name = line.split('  ', 1)
            assert name not in checksums
            checksums[name] = digest
        assert set(checksums) == set(names) - {'SHA256SUMS.txt'}
        assert all(hashlib.sha256(archive.read(name)).hexdigest() == digest for name, digest in checksums.items())
        spec = json.loads(archive.read('specification.json'))
        keys = {item['stable_id'] for item in spec['items']}
        assert len(keys) == len(spec['items']) and all(item['type'] != 'test_execution' for item in spec['items'])
        for item in spec['items']:
            assert all(target in keys for targets in item['relations'].values() for target in targets)
        text = archive.read('specification.md').decode('utf-8')
        for target in re.findall(r'\]\(([^\s)]+)\)', text):
            if target.startswith('https://'):
                continue
            filename, _, anchor = target.partition('#')
            if filename:
                assert filename in names, target
            else:
                assert anchor and 'id="' + anchor + '"' in text, target
        return {'artifact': path.name, 'entries': len(names), 'records': len(keys), 'checksums': 'passed'}


def main():
    filenames = subprocess.check_output(
        ['git', 'ls-files', '--cached', '--others', '--exclude-standard', '-z'], cwd=ROOT
    ).decode('utf-8').split('\0')
    files = sorted(set(name for name in filenames if name))
    findings = []
    patterns = {
        'private key': rb'-----BEGIN (?:[A-Z ]+ )?PRIVATE KEY-----',
        'personal Windows path': rb'(?i)[a-z]:[\\/]+Users[\\/]+(?!Public\b|Default\b)[^\s"<>]+',
        'local service URL': rb'(?i)https?://(?:localhost|127\.0\.0\.1|192\.168\.\d+\.\d+|10\.\d+\.\d+\.\d+)(?=[:/\s"\x27])',
        'literal credential': rb'(?i)(?:password|passwd|csrf_token|access_token|refresh_token|api_key|client_secret)\s*["\x27]?\s*[:=]\s*["\x27][^"\x27\s]+["\x27]',
    }
    patterns.update({
        'internal service identifier': rb'(?i)["\x27](?:workspace_id|baseline_id|verified_baseline_id|server_id|work_item_id|released_by|created_by|updated_by)["\x27]\s*:\s*(?:\d|["\x27])',
        'numeric workspace reference': rb'(?i)\bworkspace\s*(?:id\s*[:=]?\s*)?[#:]?\s+\d+\b',
    })
    for name in files:
        path = ROOT / name
        if not path.is_file():
            continue
        if name.startswith(('.local/', 'artifacts/', 'bin/')) or path.suffix.lower() in {'.key', '.pem', '.der', '.p12', '.pfx', '.prg', '.iq'}:
            findings.append({'file': name, 'reason': 'internal file in publication candidates'})
        data = path.read_bytes()
        for reason, pattern in patterns.items():
            if re.search(pattern, data):
                findings.append({'file': name, 'reason': reason})
        if path.suffix.lower() in {'.md', '.txt', '.json', '.mc', '.ps1', '.cmd', '.py', '.xml'}:
            text = data.decode('utf-8-sig')
            # Font license/provenance notices retain their upstream attribution.
            if not name.startswith('assets/fonts/') and not name.endswith('OFL.txt'):
                if re.search(r'(?i)\b[A-Z0-9_.+-]+@[A-Z0-9-]+\.[A-Z0-9.-]+\b', text):
                    findings.append({'file': name, 'reason': 'email address'})
        if data.startswith(b'\x89PNG\r\n\x1a\n'):
            offset = 8
            while offset < len(data):
                length = struct.unpack('>I', data[offset:offset+4])[0]
                kind = data[offset+4:offset+8]
                if kind in {b'tEXt', b'zTXt', b'iTXt', b'eXIf', b'tIME'}:
                    findings.append({'file': name, 'reason': 'PNG editing metadata'})
                offset += length + 12
            assert offset == len(data), name
    assert not findings, json.dumps(findings, indent=2)

    archives = [audit_public_archive(path, patterns) for path in sorted((ROOT / 'architecture').glob('*.zip'))]
    package = read(EXPORT / 'requirements.json')
    assert len(package['relations']) >= 370
    document_ids={row['stable_id'] for row in package['items'] if row['type']=='document'}
    assert document_ids and {doc['stable_id'] for doc in package['documents']}==document_ids
    assert len(package['documents'])==len(document_ids) and len(package['attachments'])==18
    snapshots = read(ROOT / 'requirements/workspace-snapshot.json') + read(ROOT / 'requirements/supporting-approved-snapshot.json')
    current = {row['stable_id']: row for row in snapshots}
    assert len(current) == len(snapshots) == len(package['items'])
    counts = dict(Counter(row['type'] for row in package['items']))
    assert package['counts'] == counts
    assert read(ROOT / 'requirements/baseline.json')['requirement_count'] == counts['requirement']
    assert read(ROOT / 'requirements/supporting-approved-baseline.json')['record_count'] == len(current) - counts['requirement']
    for exported in package['items']:
        row = current[exported['stable_id']]
        assert exported['description'] == row['description'] and exported['title'] == row['title']
        assert exported['status'] == row['status']
        assert exported['revision'] == row['head_change_seq']
    native = read(EXPORT / 'workspace-spec-package.json')
    native_items = native['work_items'] + native['verification_items']
    assert len(native_items) == len(current) - len(package['documents'])
    assert {r['client_ref'].removeprefix('item:') for r in native_items} == {r['stable_id'] for r in package['items'] if r['type'] != 'document'}
    for row in native_items:
        assert row['description'] == current[row['client_ref'].removeprefix('item:')]['description']
    manifest = read(EXPORT / 'manifest.json')
    actual_files = {p.relative_to(EXPORT).as_posix() for p in EXPORT.rglob('*') if p.is_file() and p.name != 'manifest.json'}
    assert set(manifest['files']) == actual_files
    for name, expected in manifest['files'].items():
        assert sha(EXPORT / name) == expected, name
    for attachment in package['attachments'].values():
        path = EXPORT / attachment['path']
        assert sha(path) == attachment['sha256'] and path.stat().st_size == attachment['bytes']
    for path in [ROOT / 'README.md', *EXPORT.rglob('*.md')]:
        for target in re.findall(r'\]\(([^\s)]+)\)', path.read_text(encoding='utf-8')):
            if target.startswith(('http://', 'https://', 'mailto:')):
                continue
            filename, _, anchor = target.partition('#')
            linked = (path.parent / filename).resolve() if filename else path
            assert linked.is_file(), (path.relative_to(ROOT).as_posix(), target)
            if anchor and linked.suffix == '.md' and re.fullmatch(r'[a-z]+-\d+', anchor):
                assert 'id="' + anchor + '"' in linked.read_text(encoding='utf-8'), target
    for name in ['.local/environment.json', 'bin/example.prg', 'artifacts/example.json', '.env', 'developer_key', '.vscode/settings.json']:
        assert subprocess.run(['git', 'check-ignore', '--quiet', name], cwd=ROOT).returncode == 0, name
    report = {'status': 'passed', 'publication_files': len(files), 'requirements': counts['requirement'],
              'supporting_records': len(current) - counts['requirement'], 'export_checksums': 'passed', 'private_data_findings': [],
              'scope': 'Current publication files; ignored machine configuration and Git history are separate.',
              'memory_tests_run': 0}
    report['architecture_archives'] = archives
    (ROOT / 'artifacts').mkdir(exist_ok=True)
    (ROOT / 'artifacts/publication-checks.json').write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(report, indent=2))

if __name__ == '__main__':
    main()
