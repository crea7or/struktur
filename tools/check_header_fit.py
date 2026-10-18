"""Audit complete unit headers at native cell widths, without running Placement.

This measures headers only, not value/vertical fit or runtime memory. A passing
Core audit verifies measurements; it does not mean every header fits every cell.
Use --fail-on-overflow to reject any supported header wider than a regular cell.
"""
import argparse
import json
from pathlib import Path

from generate_display_limits import EFFECTS, metrics, read, units, width
from header_text import unit_header


def audit():
    catalogue = read('config/catalogue.json')
    fields = catalogue['fields']
    fonts = {font['id']: font for font in read('config/font-manifest.json')['fonts']}
    defaults = {prop['default']: int(prop['key'].split('_')[1])
                for prop in catalogue['properties'] if prop['key'].endswith('_value')}
    rows = []
    for device in read('config/devices.json'):
        font = metrics(fonts['Label' + str(device['label_font_reference'])])
        for index, field in enumerate(fields):
            for statute in [False, True]:
                unit = units(field, statute)
                header = unit_header(field,unit)
                for enlarged in [False, True]:
                    cell_width = device['design_width'] if enlarged else device['design_width'] // 2
                    for halo in ([False, True] if field['id'] in EFFECTS else [False]):
                        available = cell_width - 2 * (4 + int(halo))
                        plain_width = width(field['label'], font)
                        header_width = width(header, font)
                        slot = defaults.get(index)
                        rows.append(dict(
                            product=device['id'], field=field['id'], requirement=field['requirement'],
                            system='statute' if statute else 'metric', label=field['label'],
                            header=header, unit=unit, cell='enlarged' if enlarged else 'regular',
                            halo=halo, cell_width=cell_width, available_width=available,
                            plain_width=plain_width, header_width=header_width,
                            overflow_px=max(0, header_width - available),
                            newly_overflows=plain_width <= available < header_width,
                            default_slot=slot,
                            visible_default=slot is not None and slot <= 2 * device['design_rows']))
    return dict(scope='Complete headers at native widths, default 24-hour clock; '
                      'both physical-unit systems and available background halo states. '
                      'No value/vertical fit, runtime memory or Placement execution.', rows=rows)


def markdown(report):
    lines = ['# Unit-header width audit', '', report['scope'], '',
             'Default assignments, no enlarged fields. Widths include advance spacing; '
             'the available area reserves 4 px at each side and 1 px extra per side '
             'when a background effect requires a text halo.', '',
             '| Device | Visible default header that overflows | Width | Available | Excess |',
             '| --- | --- | ---: | ---: | ---: |']
    for row in report['rows']:
        if row['visible_default'] and row['cell'] == 'regular' and row['overflow_px']:
            lines.append('| {product} | {header} ({system}{effect}) | {header_width} | '
                         '{available_width} | {overflow_px} |'.format(
                             **row, effect=', halo' if row['halo'] else ''))
    lines.extend(['', 'All fields (metric and statute), for every native device width:', '',
                  '| Device | Field | Header | Cell | Halo | Width | Available | Excess |',
                  '| --- | --- | --- | --- | --- | ---: | ---: | ---: |'])
    for row in report['rows']:
        if row['overflow_px']:
            lines.append('| {product} | {requirement} | {header} | {cell} | {halo} | '
                         '{header_width} | {available_width} | {overflow_px} |'.format(**row))
    return '\n'.join(lines) + '\n'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, help='Write JSON and a sibling Markdown report.')
    parser.add_argument('--fail-on-overflow', action='store_true')
    args = parser.parse_args()
    report = audit()
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
        args.output.with_suffix('.md').write_text(markdown(report), encoding='utf-8')
    for product in dict.fromkeys(row['product'] for row in report['rows']):
        rows = [row for row in report['rows'] if row['product'] == product]
        bad = {row['field'] for row in rows if row['cell'] == 'regular' and row['overflow_px']}
        default = sorted({row['header'] for row in rows if row['cell'] == 'regular'
                          and row['visible_default'] and row['overflow_px']})
        print(f'{product}: {len(bad)}/32 fields have a regular-cell header overflow; '
              f'visible default headers: {", ".join(default) or "none"}')
    return int(args.fail_on_overflow and any(row['overflow_px'] for row in report['rows']))


if __name__ == '__main__':
    raise SystemExit(main())
