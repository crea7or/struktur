"""Host regressions for typed field metadata; no simulator or device claims."""
import copy
import json
from pathlib import Path
import unittest
from field_metadata import field_attributes, primary_unit


class FieldMetadataTests(unittest.TestCase):
    def setUp(self):
        self.row = {'stable_id': 'example', 'attributes_jsonb': {'CODE': 0, 'IDENTIFIER': 'speed', 'LABEL': 'speed',
                    'UNIT': 'km/h (metric) or mph (imperial)', 'LABEL_AND_UNIT': 'speed | {unit}', 'PRECISION_RULE': 'magnitude-based'}}

    def test_all_exported_fields_match_generated_catalogue(self):
        root = Path(__file__).resolve().parents[1]
        rows = {r['stable_id']: r for r in json.loads((root/'requirements/workspace-snapshot.json').read_text(encoding='utf-8-sig'))}
        fields = json.loads((root/'config/catalogue.json').read_text(encoding='utf-8-sig'))['fields']
        self.assertEqual(33, len(fields))
        for code, field in enumerate(fields):
            with self.subTest(field=field['id']):
                attrs = field_attributes(rows[field['requirement']])
                self.assertEqual((code, field['id'], field['label']), (attrs['CODE'], attrs['IDENTIFIER'], attrs['LABEL']))
                self.assertEqual(field.get('header_with_units'), attrs['LABEL_AND_UNIT'] or None)

    def test_compact_range_requires_equal_layout_guarantees(self):
        from generate_display_limits import requirement_limits_match
        root = Path(__file__).resolve().parents[1]
        limits = json.loads((root/'config/display-limits.json').read_text())
        field = next(f for f in json.loads((root/'config/catalogue.json').read_text())['fields'] if f['id']=='average_speed')
        record = next(r for r in limits['fields'] if r['field']=='average_speed')
        for text in ['Normal display ranges: 0–200', 'Normal display ranges: 0–200.']:
            self.assertTrue(requirement_limits_match(text, record, field, limits['groups']))
        for text in ['Normal display ranges: 0–201', 'Normal display ranges: 1–200', 'Normal display ranges: 0–200 unverified extra claim']:
            self.assertFalse(requirement_limits_match(text, record, field, limits['groups']))
        narrowed = copy.deepcopy(record)
        narrowed['contexts'][0]['intervals'] = []
        self.assertFalse(requirement_limits_match('Normal display ranges: 0–200', narrowed, field, limits['groups']))

    def test_conditional_precision_and_unit_variants(self):
        attrs = field_attributes(self.row)
        self.assertEqual('magnitude-based', attrs['PRECISION_RULE'])
        self.assertEqual('km/h', primary_unit(attrs))
        attrs['UNIT'] = '`km/h` (metric) or `mph` (imperial)'
        self.assertEqual('km/h', primary_unit(attrs))

    def test_fixed_zero_and_empty_unit_header_are_valid(self):
        attrs = self.row['attributes_jsonb']
        attrs.pop('PRECISION_RULE')
        attrs.update(PRECISION=0, UNIT='', LABEL_AND_UNIT='')
        self.assertEqual(0, field_attributes(self.row)['PRECISION'])
        self.assertEqual('', primary_unit(attrs))

    def test_missing_attributes_never_fall_back_to_description(self):
        self.row.update(attributes_jsonb={}, description='Field code: 0; identifier: `speed`. Label text: `speed`.')
        with self.assertRaises(AssertionError):
            field_attributes(self.row)

    def test_required_fields_and_precision_types(self):
        for key, invalid in [('CODE', True), ('CODE', -1), ('IDENTIFIER', ''), ('LABEL', ''), ('UNIT', None), ('LABEL_AND_UNIT', None), ('PRECISION_RULE', '')]:
            row = copy.deepcopy(self.row)
            row['attributes_jsonb'][key] = invalid
            with self.subTest(key=key, invalid=invalid), self.assertRaises(AssertionError):
                field_attributes(row)

    def test_fixed_and_conditional_precision_are_exclusive(self):
        self.row['attributes_jsonb']['PRECISION'] = 1
        with self.assertRaises(AssertionError):
            field_attributes(self.row)
        self.row['attributes_jsonb'].pop('PRECISION_RULE')
        self.row['attributes_jsonb']['PRECISION'] = True
        with self.assertRaises(AssertionError):
            field_attributes(self.row)


if __name__ == '__main__':
    unittest.main()
