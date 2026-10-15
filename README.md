# Struktur

Struktur is a Garmin Connect IQ **Data Field** for cycling. It displays configurable ride metrics in a two-column grid, with up to two enlarged fields, clear labels and compact secondary units.

The project was developed using the [AI Architect requirement service](https://ai-architect.link). Its requirements guided implementation, review and validation. The exported specification is included in this repository so the design and its acceptance rules can be reviewed alongside the code.

## Features

- 32 selectable values, including speed, cadence, heart rate, power, distance, elevation, grade, timers, heading, battery, completed laps and six current-lap metrics.
- Full-capacity layouts with zero, one or two enlarged fields. Ten ordered assignments are retained, including temporarily hidden slots; repeated values are supported.
- Default slot order: speed, distance, timer, time, heart rate, 3s power, elevation, grade, ascent and temperature. Valid saved assignments take precedence; four-row layouts initially show the first eight.
- Center or Right alignment, with Right as the first-install default.
- Day/Night themes, optional enlarged-field theme inversion, and per-slot background-effects controls.
- Metric/statute physical units in optional `label | unit` headers; lowercase am/pm in 12-hour clock headers.
- Duration values with smaller `.SS` seconds below ten hours; multi-digit hours such as `100:00` omit seconds.
- Roboto Condensed font sprites with explicit glyph inventories and reproducible generation.

## Current-lap fields

Select `lap distance`, `lap time`, `lap speed`, `lap heart rate`, `lap watts` or `lap cadence` in any slot. Lap speed is distance divided by active lap time. Heart rate, power and cadence use time-weighted valid intervals; measured zero power/cadence are included, while missing intervals are excluded. Native device averaging preferences may differ.

Pause preserves lap totals and averages without bridging stopped intervals. Loading into an existing ride leaves lap metrics unavailable until the next observed lap boundary; completed-lap history can remain unknown. Missing boundary counters are never replaced by zero. These are app-observed estimates, with manual/Auto Lap/workout delivery and boundary accuracy awaiting device qualification.

## Device profiles

These are development and qualification candidates, not a claim of complete release-qualified support.

| Edge models | Full-screen rows | Total fields with 0 / 1 / 2 enlarged fields |
| --- | ---: | --- |
| 530, 540, 550, 830, 840, 850 | 4 | 8 / 5 / 2 |
| 1030, 1040, 1050 | 5 | 10 / 7 / 4 |

The assigned drawing area determines fitting. A compact fallback is used when neither grid fits safely.

## Development status

The application is a development build with nine candidate device profiles. Build and execution reports are generated locally and excluded from Git. Requirement approval and successful compilation do not establish complete product qualification.

The implementation supports per-field `Header text with units`, including exact
literal headers such as `watts` and `kcal`, and optional `{unit}` substitution
such as `temp | {unit}`. Headers use one space on each side of `|`, including
`time | am` in 12-hour mode. Slashes within units such as `km/h` are preserved.
Hidden units retain the field's full Label text. Shared
DVS-50/TFNC-8 rules, the generated catalogue, glyph tracing and Core fixtures
are aligned with those contracts. The Edge 850 profile was corrected to the
SDK's actual 420x600 display, four rows and 175/83/35 px font roles. Current-source
build, Core and sample-image evidence is recorded under `artifacts/`; older
binaries and executions do not qualify these revisions. See [the implementation review](requirements/header-separator-review-20261015.json).

The current source implements the 15 October display contracts: physical-unit headers, lowercase clock indicators, the ten-hour duration-seconds cutoff, exact revised labels and five-sample grade regression. The retired `use_units_as_labels` setting is ignored; 25 active settings remain. Current build and test evidence is stored under `artifacts/` with source fingerprints.

- Grade uses the latest five valid running samples, with zero during valid warm-up before three samples. Three seconds without distance progress makes it unavailable until progress resumes. Its two-decimal estimate supplies effects; the displayed slope uses one decimal; only ground is colored, and sky retains the effective cell background.
- Completed laps require a continuously observed, known-zero activity baseline. Loading into an existing activity leaves the total unavailable until a fresh session is established.
- Background temperature acquisition/cache logic is implemented, but the onboard-source qualification allowlist is empty. Temperature remains unavailable until each enabled model/firmware has reviewed onboard-only evidence.
- Heart-rate zones use validated personal bounds and the displayed whole-number reading, with upper-inclusive boundaries. Power-zone effects remain unavailable until the SDK array interpretation has qualified evidence. Visual acceptance, the simulator scenario matrix, actual-device checks and memory qualification remain open gates. See [the decision register](config/decisions.json) and [verification plan](requirements/verification-plan.txt).

## Build

The documented workflow uses Windows PowerShell. The recorded toolchain is Connect IQ SDK **9.2.0**, JetBrains OpenJDK **25.0.3**, Python **3.14.7** and Pillow **12.2.0**. Compiler identity and device-package records are in [config/toolchain.json](config/toolchain.json).

Install the SDK and all nine device packages through Garmin SDK Manager, then configure paths for your machine. Keep the developer signing key outside the checkout.

```powershell
$env:CONNECTIQ_SDK = 'C:\path\to\connectiq-sdk'
$env:JAVA_HOME = 'C:\path\to\java'
$env:CONNECTIQ_DEVICES = Join-Path $env:APPDATA 'Garmin\ConnectIQ\Devices'
$env:STRUKTUR_DEVELOPER_KEY = 'C:\path\outside\the-repository\developer_key'

py -m venv .venv
& .\.venv\Scripts\python.exe -m pip install -r tools/requirements.txt
$env:STRUKTUR_PYTHON = (Resolve-Path .\.venv\Scripts\python.exe).Path

& .\scripts\check-environment.ps1 -RequireKey
& .\scripts\build.ps1 -Mode debug -Product edge1040 -Python $env:STRUKTUR_PYTHON
```

The PRG and generated settings description are written to `bin/`. `-Mode all` compiles all nine candidates. Release/package modes require reviewed decisions and matching qualification evidence.

## Connect IQ submission preparation

Create a signed store-format candidate containing all nine manifest products:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/build.ps1 -Mode candidate
```

This produces `bin/Struktur-candidate.iq` with debug information stripped from the PRGs. The SDK also retains companion `debug.xml` files inside the package. Candidate export does not approve Draft requirements or qualify runtime behavior. The guarded `release` and `package` modes still require approved requirements, resolved decisions and reviewed evidence matching the current build inputs. No simulator or memory tests run during candidate export.

The [submission instructions](publishing/README.md) and [English store listing draft](publishing/store-listing.md) cover the remaining publication work. Upload only after the recorded release gates and current screenshots are complete. Keep using the same external signing key for subsequent versions of this application.

## Emulator and configuration

```powershell
.\run-emulator.cmd edge1040
```

The launcher opens or connects to the simulator and transfers the settings-editor description. Use **File → Edit Persistent Storage → Edit Application.Properties data** to change field assignments, alignment, enlargement, themes and presentation options. Existing valid saved settings are preserved.

To simulate activity data, open **Simulation → Activity Data**, select **Data Simulation**, start the Data Field timer, and start playback. Timer controls and data playback are separate.

For device development sideloading, copy the matching debug PRG into the device's `GARMIN/APPS` directory. Full release qualification remains separate.

## Validation

Compile regression sources without starting the simulator with `scripts/compile-tests.ps1 -All`. Run project and font checks with the configured Python environment:

```powershell
& $env:STRUKTUR_PYTHON tools/check_project.py
& $env:STRUKTUR_PYTHON tools/validate_fonts.py
& $env:STRUKTUR_PYTHON tools/test_font_validation.py
```

Core is the default suite after app changes. With the SDK simulator running:

```powershell
& .\scripts\run-tests.ps1 -Product edge1040 -Python $env:STRUKTUR_PYTHON
# Core plus all-device builds:
& .\scripts\ci.ps1 -Python $env:STRUKTUR_PYTHON
```

The three groups compile separate test inventories in [tests/suites.json](tests/suites.json):

| Suite | Scope | Execution policy |
| --- | --- | --- |
| Core | Fast production calculations, settings, precision and normal-value UI bounds | Default; run after app changes |
| Memory | Isolated font probes plus normal Data Field runtime memory validation | Explicit user request only |
| Placement | Deliberate overflow, insufficient drawing areas and compact-message behavior | Explicit user request only |

Only when the corresponding suite has been requested:

```powershell
& .\scripts\run-tests.ps1 -Product edge1040 -Suite Memory
& .\scripts\run-tests.ps1 -Product edge1040 -Suite Placement
```

`-LogicOnly` remains a compatibility alias for Core. `tests.jungle` and
`logic-tests.jungle` both compile Core only. `compile-tests.ps1` also defaults
to Core and never executes tests. Memory and Placement are never chained from
Core; all workflows sharing the simulator must run sequentially.

Core checks exact formatted values and actual fixed-font measurements against
native cell bounds for all 32 fields. The [layout-specific normal limits](requirements/display-limits.md)
state minimum/maximum intervals for each screen/font group, cell role, unit/header
setting and clock preference. Unsupported contexts are explicit limitations;
their negative assertions belong to request-only Placement, and are never counted
as passing normal rendering coverage. Core covers every declared guarantee.

APP-24 requires complete `00:00` values and `1:00.00` timers to fit every native
cell, including margins and a one-pixel contour. These use the same three fixed
font roles throughout; no per-value scaling occurs. Speed (current/average/lap)
and slope use one decimal; elevation, ascent and descent use integers. Grade
effects retain the canonical two-decimal estimate. Your `avg cadence` label is
preserved. Label fonts remain 21/35 px; long complete headers still have explicit
limits in the field contracts.

`tools/check_header_fit.py --output artifacts/header-fit.json` audits all 32
headers, both physical-unit systems, native regular/enlarged widths and available
background halos for all nine profiles. It resolves exact literal or templated
overrides, using `label | unit` when no override exists. Core's `composedHeaderWidthAudit`
checks these width measurements against Garmin's loaded font resources. This
diagnostic reports unsupported headers. All physical-unit headers must fit;
the long unitless `heart rate zone` header retains a small-profile limitation.
Use `--fail-on-overflow` for a failing header-fit gate. It runs no Memory or
Placement tests.

The audit uses the current generated runtime catalogue. The corrected `avg watts`
header fits all nine profiles; host measurements do not replace executable evidence.

`scripts/capture-samples.ps1 -Product all` captures one sample image per device.
It selects the simulator's full-screen Data Field layout and uses production
formatting and drawing with an isolated sample-data view. Synthetic temperature,
heart-rate zones and other readings do not qualify physical acquisition. No
memory probes or saved-property writes are performed. Images and provenance
are recorded in `artifacts/sample-images.json`.

Per-suite JSON/log files in `artifacts/<product>-core-tests.*`, `-memory-tests.*`
and `-placement-tests.*` identify the actual source and results. Normal Data Field
memory evidence remains separately named `<product>-memory.*`. No prior memory
or placement result qualifies newer sources. Simulator results do not establish
physical-device qualification.

## Requirements and traceability

The [readable requirements export](requirements/export/requirements.md) and [machine-readable export](requirements/export/requirements.json) contain **178 current specification records**: **110 requirements** and **68 supporting definitions**, including 39 Tests. Requirement states are 81 Draft, 28 Approved and one Obsolete (FUNC-2). Descriptions, states, revisions, ordinary relations, document outlines and referenced attachments match the service after header-rule alignment and refreshed normal-range tables. See the [implementation review](requirements/header-separator-review-20261015.json), the earlier [header clarification sync](requirements/user-header-sync-20261015.json), and the [clock-font and normal-range review](requirements/clock-font-display-review-20261015.json). This working export is separate from immutable baseline 12; historical executions do not qualify its revised contracts.

APP-24 specifies these fixed sizes (pixels):

| Edge models | Enlarged | Regular | Labels/secondary |
| --- | ---: | ---: | ---: |
| 530, 540, 830, 840 | 100 | 45 | 21 |
| 550, 850 | 175 | 83 | 35 |
| 1030, 1040 | 116 | 55 | 21 |
| 1050 | 200 | 95 | 35 |

Each device bundles exactly three fonts. All regular fields share the regular
size, including timer, elapsed and battery. Values outside measured bounds use
`!`; compact fallback uses the same label font. See [the fixed-font policy](requirements/font-policy.txt).

- [Export manifest and checksums](requirements/export/manifest.json).
- [Native MCP workspace-spec package](requirements/export/workspace-spec-package.json): non-document records and relations. The service's V1 format cannot represent APP-1's nested placements; complete document outlines are retained in the full exports and [document files](requirements/export/documents/APP-1.md).
- [Current working requirement pins](requirements/baseline.json) and [code/validation traceability](requirements/traceability.json).
- [Field acquisition contracts](config/acquisition-table.json) and [typed settings catalogue](config/catalogue.json).
- [Focused automated test definitions](tests/service-cases.json): 20 production-logic fixtures and four compilation/font/publication checks, with exact requirement references and current states. Formal executions must use a matching captured baseline; current Core results are recorded locally by source revision; broad hardware, Memory and Placement acceptance remains separate.

Only the current working specification and supporting definitions are included in publication files. Internal authoring scripts and execution artifacts stay ignored. The export's diagrams have editing metadata removed without changing their pixels. Machine-specific build paths stay in ignored local configuration; signing keys belong outside the checkout.

The six current-lap fields in FUNC-3 through FUNC-8 are implemented. Shared contracts FUNC-9 through FUNC-11 define current-lap boundaries, weighted averages and stable settings mappings. FUNC-12 through FUNC-17 separate grade, temperature and completed-lap acquisition. TFNC-21 and the [API assessment](requirements/lap-api-assessment.json) describe callback qualification; physical delivery and boundary accuracy require separate evidence.

Before publication, run `tools/check_publication.py` to check publication candidates, export checksums and links, and baseline consistency. Git author metadata is separate from the working-file audit.

## Repository layout

| Directory | Contents |
| --- | --- |
| `source/` | Monkey C application, acquisition, formatting and rendering code |
| `profiles/` | Device-specific design references |
| `resources/` | Settings, strings, icon and generated font resources |
| `assets/fonts/` | Font source assets, provenance and license |
| `config/` | Field/settings catalogues, approved decisions and capability records |
| `requirements/` | Requirement exports, versioned baselines and verification plans |
| `tests/` | Production-logic fixtures and separate font tests |
| `scripts/`, `tools/` | Build, validation and resource-generation utilities |
| `validation/` | Separate qualification drivers |

## License

Project code is covered by the [MIT license](LICENSE). Bundled Roboto Condensed fonts and their generated font resources retain the [SIL Open Font License 1.1](assets/fonts/OFL.txt); the license text comes from the [upstream Roboto project](https://github.com/googlefonts/roboto-classic/blob/main/OFL.txt).

Colored effects render text through a transparent glyph mask with a one-pixel contrast halo. Physical units decorate headers without replacing labels. Complete headers that exceed fixed-font cell bounds trigger the specified compact-area fallback. Simulator/memory evidence remains separate from physical-device qualification; older bundles do not qualify current sources.
