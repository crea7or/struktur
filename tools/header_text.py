"""Host interpretation of the requirement-level DVS-50 header override."""


def unit_header(field, unit, shown=True):
    if not shown or not unit:
        return field['label']
    override = field.get('header_with_units')
    if override:
        return override.replace('{unit}', unit)
    return field['label'] + ' | ' + unit
