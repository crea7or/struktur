"""Validate canonical requirement ownership and exported traceability; no emulator."""
import json
import re
from pathlib import Path

from generate_display_limits import requirement_limits_match

ROOT = Path(__file__).resolve().parents[1]


def validate_ownership(root=ROOT):
    def read(name):
        return json.loads((root / name).read_text(encoding='utf-8-sig'))

    rows = read('requirements/workspace-snapshot.json') + read('requirements/supporting-approved-snapshot.json')
    by_id = {row['stable_id']: row for row in rows}
    obsolete = {key for key, row in by_id.items() if row['status'] == 'obsolete'}
    fields = read('config/catalogue.json')['fields']
    owners = {field['requirement'] for field in fields}
    assert len(owners) == len(fields), 'Two fields share a field-specific requirement'
    package = read('requirements/export/requirements.json')
    placements = {key: [] for key in owners}

    def walk(nodes):
        for node in nodes:
            yield node
            yield from walk(node['children'])

    for document in package['documents']:
        for node in walk(document['outline']):
            key = node.get('work_item_stable_id')
            if key in placements:
                placements[key].append(document['stable_id'])
    assert all(value == ['DVS-1'] for value in placements.values()), ('Field catalog placement drift', placements)

    edges = [(edge['source_client_ref'][5:], edge['target_client_ref'][5:], edge['relation_code'])
             for edge in read('requirements/export/workspace-spec-package.json')['relations']]
    assert len(edges) == len(set(edges)), 'Duplicate exported relations'
    uses = {(source, target) for source, target, code in edges if code == 'uses'}
    verified = {target for source, target, code in edges
                if code == 'verifies' and by_id[source]['work_item_type_code'] == 'test'}
    for row in rows:
        key = row['stable_id']
        if row['status'] == 'obsolete':
            continue
        references = set(re.findall(r'\[\[([A-Z]+-\d+)\]\]', row['description']))
        assert not references & obsolete, ('Active definition references retired owner', key, references & obsolete)
        if row['work_item_type_code'] == 'requirement':
            assert key in verified, ('Unverified requirement', key)
        if row['work_item_type_code'] == 'test':
            for line in re.findall(r'^Requirement references: (.+)$', row['description'], re.M):
                refs = re.findall(r'\[\[([A-Z]+-\d+)\]\]', line)
                assert len(refs) == len(set(refs)), ('Duplicate Test reference', key)
    for source, target, code in edges:
        if code in {'uses', 'depends_on', 'refines', 'clarifies', 'verifies'}:
            assert source not in obsolete and target not in obsolete, ('Retired ordinary endpoint', source, target, code)

    limits = read('config/display-limits.json')
    limit_by_field = {row['field']: row for row in limits['fields']}
    for number, field in enumerate(fields):
        key = field['requirement']; description = by_id[key]['description']
        identity = re.findall(r'^Field code: (\d+); identifier: `([^`]+)`\.', description, re.M)
        assert identity == [(str(number), field['id'])], ('Field identity drift', key)
        for property_name in ['Label text', 'Unit text', 'Precision']:
            assert len(re.findall(r'^' + property_name + r':', description, re.M)) == 1, (key, property_name)
        required = {'DVS-12', 'APP-21', 'APP-34', 'SPEC-235'}
        formatter = {'float': 'DVS-2', 'integer': 'DVS-7', 'duration': 'DVS-13'}.get(field['format'])
        if formatter:
            required.add(formatter)
        if field['unit']:
            required.add('DVS-50')
        assert all((key, shared) in uses for shared in required), ('Missing applicable shared rule', key)
        if field['format'] != 'text':
            assert requirement_limits_match(description, limit_by_field[field['id']], field, limits['groups']), ('Range contract mismatch', key)
    return dict(fields=len(fields),active_requirements=sum(r['work_item_type_code']=='requirement' and r['status']!='obsolete' for r in rows),field_documents=['DVS-1'],status='passed')


if __name__ == '__main__':
    print(json.dumps(validate_ownership(), indent=2))
