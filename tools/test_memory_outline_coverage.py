"""Host-only log-validation regressions; does not start a memory runner."""
import unittest
from report_memory_validation import validate_outline_coverage


class OutlineCoverageTests(unittest.TestCase):
    def test_complete_api4_coverage(self):
        validate_outline_coverage(dict(max_fonts=6,outline_roles=7),True)

    def test_complete_legacy_coverage(self):
        validate_outline_coverage(dict(max_fonts=3,outline_roles=0),False)

    def test_reject_base_fonts_only(self):
        with self.assertRaises(AssertionError):
            validate_outline_coverage(dict(max_fonts=3,outline_roles=0),True)

    def test_reject_missing_outline_role(self):
        for mask in [0,1,2,3,4,5,6]:
            with self.subTest(mask=mask),self.assertRaises(AssertionError):
                validate_outline_coverage(dict(max_fonts=6,outline_roles=mask),True)

    def test_reject_missing_coverage_metric(self):
        with self.assertRaises(AssertionError):
            validate_outline_coverage(dict(max_fonts=6),True)

    def test_reject_extra_font_resources(self):
        with self.assertRaises(AssertionError):
            validate_outline_coverage(dict(max_fonts=7,outline_roles=7),True)

    def test_reject_outline_resources_on_legacy(self):
        with self.assertRaises(AssertionError):
            validate_outline_coverage(dict(max_fonts=4,outline_roles=1),False)


if __name__=='__main__':
    unittest.main()
