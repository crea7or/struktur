"""Protect typed property metadata validation; no simulator required."""
import unittest
from check_properties import validate_property_metadata
class PropertyContracts(unittest.TestCase):
    def test_exact_metadata(self):
        p=dict(key='a_align',title='Alignment',type='number',choices=[0,1],default=1)
        validate_property_metadata('Key: `a_align`\nCaption: Alignment\nType and values: Integer 0, 1\nDefault: `1`\n\nThe body may contain behavior.',p)
    def test_boolean_type_form(self):
        p=dict(key='halo',title='Text outline',type='boolean',default=True)
        validate_property_metadata('Key: `halo`\nCaption: Text outline\nType: Boolean\nDefault: `true`',p)
    def test_wrong_values_fail(self):
        p=dict(key='a_align',title='Alignment',type='number',choices=[0,1],default=1)
        template='Key: `a_align`\nCaption: Alignment\nType and values: Integer 0, 1\nDefault: `1`'
        for old,new in [('a_align','b_align'),('Alignment','Other'),('Integer 0, 1','Integer 0, 1, 2'),('`1`','`0`')]:
            with self.assertRaises(AssertionError):validate_property_metadata(template.replace(old,new),p)
    def test_duplicate_metadata_cannot_override(self):
        p=dict(key='halo',title='Text outline',type='boolean',default=True)
        with self.assertRaises(AssertionError):
            validate_property_metadata('Key: `other`\nCaption: Text outline\nType: Boolean\nDefault: `true`\nKey: `halo`',p)
if __name__=='__main__': unittest.main()
