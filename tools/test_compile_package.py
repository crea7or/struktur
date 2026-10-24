import copy
import json
from pathlib import Path
import unittest
from compile_package import effective_metadata


class FirmwareOverrideTests(unittest.TestCase):
    def setUp(self):
        self.policy = json.loads((Path(__file__).resolve().parents[1] /
                                 'config/firmware-compatibility.json').read_text())
        self.original = {'partNumbers': [
            {'number': '006-B3843-00', 'firmwareVersion': 3135, 'connectIQVersion': '6.0.0'},
            {'number': '006-B4305-00', 'firmwareVersion': 2456, 'connectIQVersion': '6.0.0'},
        ], 'other': [1, 2]}

    def test_audited_targets(self):
        self.assertEqual(set(self.policy['overrides']), {'edge540', 'edge550', 'edge840', 'edge850', 'edge1040', 'edge1050'})
        for product, part in [('edge540', '006-B4061-00'), ('edge550', '006-B4633-00'),
                              ('edge840', '006-B4062-00'), ('edge850', '006-B4634-00'),
                              ('edge1040', '006-B3843-00'), ('edge1050', '006-B4440-00')]:
            rule = self.policy['overrides'][product]
            self.assertEqual((rule['part'], rule['firmware'], rule['api']), (part, 3018, '6.0.0'))

    def test_only_declared_part_changes_and_input_is_immutable(self):
        before = copy.deepcopy(self.original)
        expected = copy.deepcopy(before)
        expected['partNumbers'][0]['firmwareVersion'] = 3018
        self.assertEqual(effective_metadata(self.original), expected)
        self.assertEqual(self.original, before)

    def test_1050_preserves_features_on_api_six(self):
        original = {'partNumbers': [
            {'number': '006-B4440-00', 'firmwareVersion': 3220, 'connectIQVersion': '6.0.3'}]}
        before = copy.deepcopy(original)
        result = effective_metadata(original, 'edge1050')
        self.assertEqual(result['partNumbers'][0]['firmwareVersion'], 3018)
        self.assertEqual(result['partNumbers'][0]['connectIQVersion'], '6.0.0')
        self.assertEqual(original, before)

    def test_all_modern_targets_preserve_metadata_and_feature_api(self):
        for product, rule in self.policy['overrides'].items():
            original = {'partNumbers': [{'number': rule['part'],
                'firmwareVersion': rule['upstream_firmware'], 'connectIQVersion': rule['upstream_api'],
                'languages': [{'code': 'eng'}]}], 'deviceId': product}
            before = copy.deepcopy(original)
            result = effective_metadata(original, product)
            self.assertEqual(result['partNumbers'][0]['firmwareVersion'], 3018)
            self.assertEqual(result['partNumbers'][0]['connectIQVersion'], '6.0.0')
            self.assertEqual(result['partNumbers'][0]['languages'], before['partNumbers'][0]['languages'])
            self.assertEqual(original, before)
            self.assertIn(rule['evidence_kind'], ['device_report', 'release_family_inference'])
            if rule['evidence_kind'] == 'release_family_inference':
                self.assertTrue(rule['api_evidence'])
                incomplete = copy.deepcopy(self.policy)
                incomplete['overrides'][product].pop('api_evidence')
                with self.assertRaises(ValueError):
                    effective_metadata(original, product, incomplete)

    def test_unreviewed_products_are_unchanged(self):
        for product in self.policy['retained_products']:
            self.assertEqual(effective_metadata(self.original, product), self.original)

    def test_upstream_drift_fails_closed(self):
        for product, rule in self.policy['overrides'].items():
            original = {'partNumbers': [{'number': rule['part'],
                'firmwareVersion': rule['upstream_firmware'], 'connectIQVersion': rule['upstream_api']}]}
            for key, value in [('firmwareVersion', 9999), ('connectIQVersion', '6.1.0')]:
                changed = copy.deepcopy(original)
                changed['partNumbers'][0][key] = value
                with self.assertRaises(ValueError):
                    effective_metadata(changed, product)

    def test_missing_or_duplicate_part_fails_closed(self):
        for parts in [[], self.original['partNumbers'] * 2]:
            with self.assertRaises(ValueError):
                effective_metadata({'partNumbers': parts})

    def test_feature_loss_invalid_version_or_missing_evidence_fails(self):
        for key, value in [('api', '5.2.0'), ('api', '6.0.1'), ('api', '6.0'),
                           ('firmware', 0), ('firmware', 3136), ('evidence', '')]:
            policy = copy.deepcopy(self.policy)
            policy['overrides']['edge1040'][key] = value
            with self.assertRaises(ValueError):
                effective_metadata(self.original, policy=policy)


if __name__ == '__main__':
    unittest.main()
