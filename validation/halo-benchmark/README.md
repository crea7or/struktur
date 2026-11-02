# Halo drawing benchmark

Compares three ways to draw the same Edge 1040 frame (one enlarged and six regular
Whole-cell fields, each with label, value and optional unit):

- **A**: current production halo, eight 1 px shifted `drawText` calls plus the text.
- **B**: build-time outline font (glyphs dilated by one pixel), one call plus the text.
- **C**: text without halo, the baseline. `A-C` and `B-C` are the halo costs.

`make_outline_fonts.py` generates the prototype outline fonts from the production atlases.
The app has its own ID and name ("Struktur Halo Bench"), so it installs beside Struktur.
The bottom strip shows average milliseconds per frame since start; the visible frame
alternates between A and B every five updates. Simulator timings run on the host CPU
and only indicate relative cost; use the sideloaded PRG for device numbers.
