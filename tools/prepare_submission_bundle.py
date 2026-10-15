"""Assemble an allowlisted candidate bundle from matching build and capture evidence.

The SDK-generated IQ is preserved byte for byte. 7-Zip is required to inspect it.
No simulator runs, settings writes or submission are performed by this tool.
"""
import argparse
import hashlib
import json
import os
import re
from pathlib import Path, PurePosixPath
import shutil
import subprocess
import xml.etree.ElementTree as ET
import zipfile

from PIL import Image, ImageDraw, ImageFont
from check_test_suites import validate_suites

ROOT = Path(__file__).resolve().parents[1]
NS = {'iq': 'http://www.garmin.com/xml/connectiq'}


def read(path):
    return json.loads(Path(path).read_text('utf-8-sig'))


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--device-root', type=Path, required=True)
    parser.add_argument('--seven-zip', default=shutil.which('7z') or
                        str(Path(os.environ.get('ProgramFiles', '')) / '7-Zip/7z.exe'))
    args = parser.parse_args()
    build = read(ROOT / 'artifacts/build-results.json')
    package = read(ROOT / 'artifacts/package-build.json')
    captures = read(ROOT / 'artifacts/publishing-screenshots.json')
    inputs = read(ROOT / 'artifacts/publishing-preview-inputs.json')
    configs = read(ROOT / 'validation/publishing/configurations.json')['configurations']
    devices = read(ROOT / 'config/devices.json')
    cores = [read(ROOT / ('artifacts/'+d['id']+'-core-tests.json')) for d in devices]
    expected_core = set(validate_suites()['Core'])
    aliases = read(ROOT / 'artifacts/current-app-aliases.json')
    fonts = read(ROOT / 'artifacts/header-font-resources.json')
    current = json.loads(subprocess.check_output([
        'powershell.exe', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command',
        '& ./scripts/source-provenance.ps1 | ConvertTo-Json -Depth 8 -Compress'
    ], cwd=ROOT, encoding='utf-8-sig'))
    revision = current['source_revision']
    assert all(r['source_revision'] == revision for r in
               [build, package, captures, *cores, aliases, fonts]), 'Stale evidence'
    assert package['mode'] == 'candidate' and package['status'] == 'compiled'
    assert package['release_qualified'] is False
    for core in cores:
        assert core['status'] == 'passed' and core['test_count'] == len(expected_core)
        assert {c['name'] for c in core['cases']} == expected_core
        assert all(c['status'] == 'passed' for c in core['cases'])
    assert captures['memory_tests_run'] == captures['placement_tests_run'] == 0
    assert inputs['definition_sha256'] == sha(ROOT / 'validation/publishing/configurations.json')
    assert inputs['fixture_sha256'] == sha(ROOT / 'validation/publishing/StorePreview.mc')
    for source in inputs['sources']:
        assert source['production_sha256'] == sha(ROOT / source['path'])
    properties = {p['key']:p['default'] for p in read(ROOT / 'config/catalogue.json')['properties']}
    products = {d['id'] for d in devices}
    assert {r['product'] for r in build['products']} == products == set(package['products'])
    assert {r['product'] for r in aliases['products']} == products
    assert len(fonts['products']) == len(products) == 9
    assert all(r['status'] == 'passed' and len(r['font_resources']) == 3 for r in fonts['products'])
    candidate = Path(package['binary'])
    assert sha(candidate) == package['binary_sha256']
    subprocess.run([args.seven_zip, 't', str(candidate)], check=True, capture_output=True)

    def member(name):
        # Read one known SDK manifest member without extracting archive paths.
        assert not PurePosixPath(name).is_absolute() and '..' not in PurePosixPath(name).parts
        data = subprocess.check_output([args.seven_zip, 'x', '-so', str(candidate), name])
        assert data, name
        return data

    manifest = ET.fromstring(member('manifest.xml'))
    app = manifest.find('iq:application', NS)
    source_app = ET.parse(ROOT / 'manifest.xml').find('iq:application', NS)
    assert app is not None and source_app is not None
    assert app.get('id') == source_app.get('id') and app.get('type') == 'datafield'
    assert member('manifest.sig2') and member('dev_key.pub')
    variants = {}
    for product in products:
        compiler = read(args.device_root / product / 'compiler.json')
        for part in compiler['partNumbers']:
            if any(lang['code'] == 'eng' for lang in part['languages']):
                assert part['number'] not in variants
                variants[part['number']] = product
    found = []
    for variant in app.findall('iq:products/iq:product', NS):
        part = variant.get('partNumber')
        assert part in variants and variant.get('sig') and variant.get('sig2')
        binary = member(variant.get('filename'))
        assert b'StorePreviewField' not in binary and b'StoreConfig' not in binary
        settings = json.loads(member(variant.get('settings')))['settings']
        defaults = {s['key']: s['defaultValue'] for s in settings}
        assert set(defaults) == set(properties)
        assert defaults['grid_type']==1 and 'show_grid' not in defaults
        assert all(defaults[f'slot_{i}_background_effects'] is False for i in range(1, 11))
        assert defaults['alignment'] == 1 and defaults['enlarged_field_count'] == 0
        found.append(dict(product=variants[part], part_number=part,
                          binary_sha256=hashlib.sha256(binary).hexdigest()))
    assert {r['part_number'] for r in found} == set(variants) and len(found) == len(variants)

    out = ROOT / 'dist/Struktur-publishing'
    out.mkdir(parents=True, exist_ok=True)
    allowed = []

    def include(source, relative):
        target = out / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        if Path(source).resolve() != target.resolve():
            shutil.copyfile(source, target)
        allowed.append(relative)

    include(candidate, 'Struktur-candidate.iq')
    sideloads = []
    for record in aliases['products']:
        product = record['product']
        prg = ROOT / record['binary']
        assert sha(prg) == record['sha256']
        built = next(r for r in build['products'] if r['product'] == product)
        assert built['status'] == 'passed' and sha(prg) == built['binary_sha256']
        relative = 'prg/' + prg.name
        include(prg, relative)
        sideloads.append(dict(product=product, file=relative, sha256=sha(prg)))

    assert len(captures['images']) == len(configs) == 9
    images = []
    covered = set()
    gallery = Image.new('RGB', (780, 480*((len(configs)+2)//3)), '#dce1e7')
    draw = ImageDraw.Draw(gallery)
    title_font = ImageFont.truetype(str(ROOT / 'assets/fonts/Roboto_Condensed_SemiBold.ttf'), 15)
    for index, (record, config) in enumerate(zip(captures['images'], configs, strict=True)):
        assert record['id'] == config['id'] and record['fields'] == config['fields']
        assert record['settings'] == config['settings'] and record['product'] == 'edge1050'
        assert sha(record['image']) == record['image_sha256']
        assert sha(record['source_capture']) == record['source_sha256']
        assert sha(record['sample_binary']) == record['sample_binary_sha256']
        expected = f"STORE_OK id={record['id']} product=edge1050 width=480 height=800 fields={len(config['fields'])}"
        grid=['none','horizontal','full'][config['settings'].get('grid_type',properties['grid_type'])]
        alignment='center' if config['settings'].get('alignment',properties['alignment'])==0 else 'right'
        expected+=' grid='+grid+' alignment='+alignment+' lines='
        runtime=Path(record['log']).read_text('utf-8-sig')
        observation=re.search(re.escape(expected)+r'(\d+)',runtime)
        assert observation and ((int(observation[1])>0) if grid!='none' else int(observation[1])==0), record['id']
        with Image.open(record['image']) as image:
            assert image.size == (480, 800)
            assert not {'exif', 'XML:com.adobe.xmp', 'Description', 'Comment'} & set(image.info)
            x, y = 10 + (index % 3) * 260, 38 + (index // 3) * 480
            draw.text((x, y-27), config['title'], font=title_font, fill='#18212b')
            gallery.paste(image.convert('RGB').resize((240, 400), Image.Resampling.LANCZOS), (x, y))
        relative = 'screenshots/' + config['id'] + '.png'
        include(record['image'], relative)
        images.append(dict(id=config['id'], title=config['title'], file=relative,
                           width=480, height=800, fields=config['fields'],
                           settings=config['settings'], grid_type=grid, alignment=alignment,
                           observed_grid_lines=int(observation[1]), features=config['features']))
        covered.update(config['fields'])
    assert covered == {f['id'] for f in read(ROOT / 'config/catalogue.json')['fields']}
    assert {(r['alignment'],r['grid_type']) for r in images}=={(a,g) for a in ['center','right'] for g in ['none','horizontal','full']}
    gallery.save(ROOT / 'artifacts/publishing-contact-sheet.png')
    include(ROOT / 'artifacts/publishing-contact-sheet.png', 'screenshots-overview.png')
    include(ROOT / 'publishing/store-listing.md', 'store-listing.md')
    include(ROOT / 'assets/fonts/OFL.txt', 'OFL.txt')
    include(ROOT / 'assets/fonts/PROVENANCE.txt', 'font-provenance.txt')
    summary = dict(status='candidate', release_qualified=False, source_revision=revision,
                   products=sorted(products), sdk_variants=found, sideloads=sideloads,
                   core_tests=dict(products=[dict(product=r['product'],passed=r['test_count']) for r in cores],passed=sum(r['test_count'] for r in cores)), screenshots=images,
                   screenshot_scope='Synthetic ride data, actual production rendering in Edge 1050 simulator; all 32 selectable field types shown.',
                   unavailable_fields=['temperature', 'power_zone'],
                   memory_tests_run=0, placement_tests_run=0,
                   qualification='Physical-device, memory and full release qualification remain pending.')
    (out / 'manifest.json').write_text(json.dumps(summary, indent=2)+'\n', 'utf-8')
    allowed.append('manifest.json')
    guide = '''Struktur publishing candidate

Struktur-candidate.iq: SDK-signed, release-format Connect IQ store upload candidate,
covering nine Edge models and their regional part numbers. Preserve this file
unchanged. It is not an approved/qualified release. No upload has been performed.
The SDK includes companion debug.xml metadata (including source paths) inside IQ;
raw build logs, local configuration, signing private keys and preview PRGs are excluded.

prg/: signed development PRGs for individual device sideloading. Copy the model's
PRG to GARMIN/APPS over USB; select Struktur in a full-page single Data Field.
These debug PRGs and the optimized store binaries are separate build variants.

screenshots/: nine native 480x800 Edge 1050 simulator captures with synthetic ride
data, made with the production renderer. 01-default uses unmodified factory
settings: Right alignment, no enlargement, hidden units, Auto/Day, all effects off.
Other images cover all 32 field assignments, metric/statute units, 12/24-hour
clocks, lap fields, small seconds, long durations, Center/Right alignment,
Day/Night themes, zero/one/two enlarged fields, enlarged inversion and opt-in
HR/grade effects. None, Horizontal lines and Full grid work with Center/Right independently.
Actual drawLine calls and captures cover all six combinations.
Temperature and power zones honestly show unavailable (--).
Power-zone coloring and onboard-temperature readings are not yet qualified.
The overview is a contact sheet; use the nine original PNGs for store screenshots.
Confirm image/artwork requirements in the current Garmin submission form.

Core: matching-source suites passed on all nine profiles; see manifest.json for
exact per-device counts. All nine app profiles compiled and retain
exactly three serialized font resources. Memory/Placement suites were not run.
Physical-device qualification and remaining release gates must be completed
before claiming full support. The store listing remains a publisher-review draft.
See manifest.json for configurations, provenance and precise evidence scope.
SHA256SUMS.txt covers the allowlisted files in this ZIP (no history/archives).

Built with https://ai-architect.link requirement service.
'''
    (out / 'README.txt').write_text(guide, 'utf-8')
    allowed.append('README.txt')
    sums = ''.join(sha(out / name)+'  '+name+'\n' for name in sorted(allowed))
    (out / 'SHA256SUMS.txt').write_text(sums, 'utf-8')
    allowed.append('SHA256SUMS.txt')
    bundle = ROOT / 'dist/Struktur-publishing.zip'
    with zipfile.ZipFile(bundle, 'w', zipfile.ZIP_DEFLATED) as archive:
        for name in sorted(allowed):
            archive.write(out / name, name)
    with zipfile.ZipFile(bundle) as archive:
        assert archive.testzip() is None and set(archive.namelist()) == set(allowed)
    report = dict(source_revision=revision, status='passed', package_variants=len(found),
                  products=len(products), native_screenshots=len(images), selectable_fields=len(covered),
                  bundle_sha256=sha(bundle), bundle_files=sorted(allowed), iq_sha256=sha(candidate))
    (ROOT / 'artifacts/submission-bundle.json').write_text(json.dumps(report, indent=2)+'\n', 'utf-8')
    print('Prepared signed candidate, nine sideload PRGs and nine verified native screenshots; all grid/alignment modes and 32 field types covered.')
    print('Source revision:', revision)


if __name__ == '__main__':
    main()
