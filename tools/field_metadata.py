"""Read canonical selectable-field metadata from exported typed item attributes."""

def field_attributes(row):
    attrs = row.get('attributes_jsonb', {})
    assert isinstance(attrs.get('CODE'), int) and not isinstance(attrs['CODE'], bool), row['stable_id']
    assert attrs['CODE'] >= 0, row['stable_id']
    for key in ['IDENTIFIER', 'LABEL', 'UNIT', 'LABEL_AND_UNIT']:
        assert isinstance(attrs.get(key), str), (row['stable_id'], key)
    assert attrs['IDENTIFIER'] and attrs['LABEL'], row['stable_id']
    if 'PRECISION' in attrs:
        assert isinstance(attrs['PRECISION'], int) and not isinstance(attrs['PRECISION'], bool) and attrs['PRECISION'] >= 0
        assert 'PRECISION_RULE' not in attrs, row['stable_id']
    else:
        assert isinstance(attrs.get('PRECISION_RULE'), str) and attrs['PRECISION_RULE'], row['stable_id']
    return attrs


def primary_unit(attrs):
    # Variant annotations remain lossless in UNIT; conversion kinds select their live variant.
    return attrs['UNIT'].replace('`', '').split(' ', 1)[0]
