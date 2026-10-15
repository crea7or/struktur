"""Fail closed if suite inventories and compiler inputs disagree. No emulator."""
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def validate_suites():
    config = json.loads((ROOT / 'tests/suites.json').read_text(encoding='utf-8'))
    assert config['default'] == 'Core'
    assert set(config['suites']) == {'Core', 'Memory', 'Placement'}
    discovered = {}
    for path in (ROOT / 'tests').glob('*.mc'):
        for name in re.findall(r'\(:test\)\s*function\s+(\w+)\(', path.read_text()):
            assert name not in discovered, ('Duplicate test', name)
            discovered[name] = path.relative_to(ROOT).as_posix()
    assigned = {}
    result = {}
    for suite, definition in config['suites'].items():
        jungle = (ROOT / definition['jungle']).read_text()
        source_paths = re.search(r'^base.sourcePath\s*=\s*(.+)$', jungle, re.M)[1].split(';')
        assert source_paths == ['source', *definition['files'], *definition['support']]
        assert all((ROOT / path).exists() for path in source_paths)
        names = [name for name, path in discovered.items() if path in definition['files']]
        assert names, ('Empty suite', suite)
        assert not any(path in definition['support'] for path in discovered.values())
        assert not (set(names) & set(assigned)), ('Test assigned twice', suite)
        assigned.update(dict.fromkeys(names, suite))
        result[suite] = names
    assert set(assigned) == set(discovered), ('Unassigned tests', set(discovered) - set(assigned))
    assert result['Memory'] == ['profileFontLoad', 'allFontVariantsLoad']
    assert {'proportionalCaptionFit', 'actualValueFitAndCompactCache', 'presentationDrawAndAlignment'} <= set(result['Placement'])
    assert (ROOT / 'logic-tests.jungle').read_bytes() == (ROOT / 'tests.jungle').read_bytes()
    for script in ['run-tests.ps1', 'ci.ps1', 'compile-tests.ps1']:
        text = (ROOT / 'scripts' / script).read_text()
        assert "[string]$Suite='Core'" in text, script
    return result


if __name__ == '__main__':
    print(json.dumps({name: len(tests) for name, tests in validate_suites().items()}))
