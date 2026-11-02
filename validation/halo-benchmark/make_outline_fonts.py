"""Prototype outline fonts for the halo benchmark (not production resources).

Each glyph mask is dilated by one pixel in all eight directions (the DVS-6 halo
region plus the glyph), drawn 1 px up/left with the same advance, so drawing the
outline font in the halo color and the base font on top reproduces the eight
shifted runtime draws exactly.

usage: python make_outline_fonts.py Value116 Value55 Label21
"""
import re
import sys
from pathlib import Path

from PIL import Image, ImageFilter

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / 'resources/fonts'
OUTPUT = Path(__file__).resolve().parent / 'resources/fonts'
ATLAS_WIDTH = 512


def glyphs(fnt):
    return [dict((k, int(v)) for k, v in re.findall(r'(\w+)=(-?\d+)', line))
            for line in fnt.splitlines() if line.startswith('char ')]


def outline(name):
    fnt = (SOURCE / f'{name}.fnt').read_text(encoding='utf-8')
    atlas = Image.open(SOURCE / f'{name}.png')
    ink = atlas.point(lambda index: 255 if index == 1 else 0, 'L')
    rows, placed, x, y, shelf = [], [], 1, 1, 0
    for g in glyphs(fnt):
        if g['width'] == 0 or g['height'] == 0:
            placed.append((g, None, 0, 0))
            continue
        crop = ink.crop((g['x'], g['y'], g['x'] + g['width'], g['y'] + g['height']))
        padded = Image.new('L', (g['width'] + 2, g['height'] + 2), 0)
        padded.paste(crop, (1, 1))
        grown = padded.filter(ImageFilter.MaxFilter(3))
        if x + grown.width + 1 > ATLAS_WIDTH:
            x, y, shelf = 1, y + shelf + 1, 0
        placed.append((g, grown, x, y))
        x, shelf = x + grown.width + 1, max(shelf, grown.height)
    height = y + shelf + 1
    out = Image.new('P', (ATLAS_WIDTH, height), 0)
    out.putpalette(atlas.getpalette())
    out.info['transparency'] = 0
    lines = [line for line in fnt.splitlines() if not line.startswith(('char ', 'chars ', 'page ', 'common '))]
    common = re.sub(r'scaleW=\d+ scaleH=\d+', f'scaleW={ATLAS_WIDTH} scaleH={height}',
                    next(line for line in fnt.splitlines() if line.startswith('common ')))
    lines += [common, f'page id=0 file="{name}Outline.png"', f'chars count={len(placed)}']
    for g, grown, gx, gy in placed:
        if grown is None:
            lines.append(f"char id={g['id']} x=0 y=0 width=0 height=0 xoffset={g['xoffset']} "
                         f"yoffset={g['yoffset']} xadvance={g['xadvance']} page=0 chnl=15")
            continue
        out.paste(grown.point(lambda v: 1 if v else 0), (gx, gy), grown.point(lambda v: 255 if v else 0))
        lines.append(f"char id={g['id']} x={gx} y={gy} width={grown.width} height={grown.height} "
                     f"xoffset={g['xoffset'] - 1} yoffset={g['yoffset'] - 1} xadvance={g['xadvance']} page=0 chnl=15")
    OUTPUT.mkdir(parents=True, exist_ok=True)
    out.save(OUTPUT / f'{name}Outline.png', transparency=0, optimize=True)
    (OUTPUT / f'{name}Outline.fnt').write_text('\n'.join(lines) + '\n', encoding='utf-8', newline='\n')
    return out.size


if __name__ == '__main__':
    for font in sys.argv[1:]:
        print(font, 'outline atlas', outline(font))
