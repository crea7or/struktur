"""Regression for Garmin group-page Save loss; validate all controls stay on the main page."""
import copy
import json
from pathlib import Path
import unittest
import xml.etree.ElementTree as ET
from settings_layout import validate_settings_layout

ROOT = Path(__file__).resolve().parents[1]


class SettingsPageTests(unittest.TestCase):
    def setUp(self):
        self.props = json.loads((ROOT/'config/catalogue.json').read_text('utf-8'))['properties']
        self.resources = ET.parse(ROOT/'resources/settings/settings.xml').getroot()
        self.page = self.resources.find('settings')

    def test_generated_page_keeps_every_property_in_order(self):
        self.assertEqual([p['key'] for p in self.props], validate_settings_layout(self.resources,self.props))
        self.assertEqual(75, len(self.page))

    def test_rejects_nested_second_set(self):
        control = next(s for s in self.page if s.get('propertyKey') == '@Properties.b1')
        self.page.remove(control)
        ET.SubElement(self.page,'group',id='second_field_set').append(control)
        with self.assertRaisesRegex(ValueError,'Nested settings groups'):
            validate_settings_layout(self.resources,self.props)

    def test_rejects_empty_group_too(self):
        ET.SubElement(self.page,'group',id='training_zones')
        with self.assertRaisesRegex(ValueError,'Nested settings groups'):
            validate_settings_layout(self.resources,self.props)

    def test_rejects_lost_control(self):
        self.page.remove(self.page[-1])
        with self.assertRaisesRegex(ValueError,'keys and order'):
            validate_settings_layout(self.resources,self.props)

    def test_rejects_duplicate_control(self):
        self.page.append(copy.deepcopy(self.page[-1]))
        with self.assertRaisesRegex(ValueError,'Duplicate'):
            validate_settings_layout(self.resources,self.props)

    def test_rejects_reordered_controls(self):
        first = self.page[0]
        self.page.remove(first)
        self.page.append(first)
        with self.assertRaisesRegex(ValueError,'keys and order'):
            validate_settings_layout(self.resources,self.props)


if __name__ == '__main__':
    unittest.main()
