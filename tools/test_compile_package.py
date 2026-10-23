import copy
import unittest
from compile_package import effective_metadata


class FirmwareOverrideTests(unittest.TestCase):
    def setUp(self):
        self.original = {'partNumbers': [
            {'number': '006-B3843-00', 'firmwareVersion': 3135, 'connectIQVersion': '6.0.0'},
            {'number': '006-B4305-00', 'firmwareVersion': 2456, 'connectIQVersion': '6.0.0'},
        ], 'other': [1, 2]}

    def test_only_requested_firmware_changes(self):
        before = copy.deepcopy(self.original)
        expected = copy.deepcopy(before)
        expected['partNumbers'][0]['firmwareVersion'] = 3133
        self.assertEqual(effective_metadata(self.original), expected)
        self.assertEqual(self.original, before)

    def test_upstream_drift_fails_closed(self):
        for key, value in [('firmwareVersion', 3136), ('connectIQVersion', '6.0.1')]:
            changed = copy.deepcopy(self.original)
            changed['partNumbers'][0][key] = value
            with self.assertRaises(ValueError):
                effective_metadata(changed)

    def test_missing_or_duplicate_part_fails_closed(self):
        for parts in [[], self.original['partNumbers'] * 2]:
            with self.assertRaises(ValueError):
                effective_metadata({'partNumbers': parts})


if __name__ == '__main__':
    unittest.main()
