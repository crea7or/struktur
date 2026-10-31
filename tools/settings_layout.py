"""Validate the single-page Garmin settings presentation; no emulator or phone claims."""


def validate_settings_layout(resources, properties):
    settings = resources.find('settings')
    if settings is None:
        raise ValueError('Missing settings page')
    if any(True for _ in settings.iter('group')):
        raise ValueError('Nested settings groups can lose mobile Save edits')
    if any(child.tag != 'setting' for child in settings):
        raise ValueError('Only direct setting controls are allowed on the main page')
    expected = [prop['key'] for prop in properties if not prop.get('hidden')]
    actual = [control.get('propertyKey', '').removeprefix('@Properties.') for control in settings]
    if len(actual) != len(set(actual)):
        raise ValueError('Duplicate settings controls')
    if actual != expected:
        raise ValueError('Settings controls must match catalogue keys and order exactly')
    return actual
