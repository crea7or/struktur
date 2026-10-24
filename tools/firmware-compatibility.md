# Firmware compatibility targets

SDK 9.2.0 remains pinned. The package uses a local copy of device definitions;
installed Garmin files and signed output are never edited. The app source and
feature behavior are unchanged.

`config/firmware-compatibility.json` defines the only reviewed overrides:

| Product/region | Effective firmware | Effective API | Evidence |
|---|---:|---:|---|
| Edge 1040 worldwide | 30.18 | 6.0.0 | Device crash report explicitly records firmware, API and VM versions |
| Edge 1050 | 30.18 | 6.0.0 | Developer device reproduction records firmware and CIQ version |
| Edge 540 / 840 | 30.18 | 6.0.0 | Model-specific release notices plus API inference from the 1040 release family |
| Edge 550 / 850 | 30.18 | 6.0.0 | Model-specific release notices plus API inference from the 1050 release family |

Evidence URLs and exact upstream values are stored in the policy. The four additional targets explicitly use release-family inference; they are
not direct device/API captures or physically qualified historical targets. Legacy
530/830/1030, APAC 1040 and the 1060 retain installed definitions. These are
reviewed compatibility targets, not proven absolute earliest compatible releases.

## API audit

| Feature | API needed | Production path |
|---|---:|---|
| Saved properties | 2.4.0 | Application.Properties |
| Temperature sensor inventory | 3.2.0 | Guarded Sensor.getRegisteredSensors |
| Native Team fonts | 1.0.0 | Standard text fonts and Dc text measurement/drawing |
| Cycling power-zone thresholds | 5.2.2 | Guarded UserProfile.getPowerZones |
| Manual-versus-auto lap events | 5.2.2 | Profile-specific onTimerLap2 adapter |

All six selected modern targets retain API 6.0.0, which includes the required 5.2.2 features.
No source call requires API 6.0.1 or newer. SDK 9.2 release notes add features such
as expanded TextPicker input and sleep-score complications that Struktur does not
use. The old 2025 firmware/VM reports alone do not establish availability of the
power-zone and typed-lap APIs. Legacy 530/830/1030 adapters and their existing
fallback behavior are unchanged.

## Verification

Core runs `tools/test_compile_package.py`. Package builds also run
`tools/verify_package_compatibility.py`, comparing every exported regional gate
and installed metadata hash. Unexpected upstream values fail the build.
Simulator Core checks validate behavior on the installed device definitions;
they do not emulate firmware 30.18. Physical verification of these historical
firmware targets remains pending.
