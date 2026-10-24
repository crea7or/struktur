# Struktur

Your ride, your layout. Struktur is a free, open-source Garmin Edge Data Field that brings your cycling metrics together in two configurable dashboards. Keep everyday ride data on one screen and switch to a second layout for laps, hard efforts or workouts.

![Struktur sample layouts with ride metrics, enlarged fields, day and night themes, and colored backgrounds](samples.png)

*Screenshots use sample data.*

## Make it yours

- **Choose from 33 fields**, including speed, distance, heart rate, cadence, power, slope, elevation, ascent, temperature, timers and battery.
- **Track the current lap** with lap distance, time, average speed, heart rate, power and cadence.
- **Build two independent dashboards.** Each saves ten slot assignments, with its own layout, alignment, theme, grid, unit headers and backgrounds. Assignments stay saved when a layout hides some slots.
- **Enlarge up to two fields** to emphasize your priorities. Center labels and values or align them to the right.
- **Choose your appearance:** Day, Night or automatic theme; no grid, horizontal lines or a full grid; optional inverted themes for enlarged fields.
- **Set each slot's background** to None, Label or Whole cell. Add heart-rate, power or cadence zone colors, or a slope horizon with Whole cell background. Use device training zones or independently enable custom five-zone heart rate and seven-zone power profiles. Cadence zone boundaries are configurable.
- **Show your team name.** Enter the text once and use it in any Team slot on either dashboard. Text fits automatically and wraps at spaces when needed, with optional heart-rate or power coloring.
- **Use your preferred units**, optional `label | unit` headers and a 12- or 24-hour clock. Timers show compact seconds and support long rides.

The default dashboard shows speed, distance, timer, time, heart rate, 3s power, elevation, slope, ascent and temperature. Smaller layouts show the first eight. It starts with right alignment, horizontal separators and backgrounds off.

## Settings guide

Layout and slot options are independent for the first and second dashboards. Team settings and training zones are shared. Units and the 12-/24-hour clock follow your Garmin device preferences; Struktur has no separate selector for them.

### Layout and appearance

| Option | What it does | Default |
| --- | --- | --- |
| **Enlarged slot count** | Choose 0, 1 or 2 enlarged slots. The first slots become larger, reducing the number of visible slots. Hidden assignments stay saved. | First set: 0; second set: 1 |
| **Alignment** | Center labels and values or align them to the right. This does not change the grid. | Right |
| **Theme mode** | Day uses a light background; Night uses a dark background. Auto follows the device's night mode where available, otherwise Day. | Auto |
| **Hide physical units in headers** | On shows the field label alone. Off shows its unit-bearing header, such as `speed | km/h`; some fields use shorter headers. This does not change measurement units or the clock's AM/PM indicator. | On |
| **Inverse theme for enlarged slots** | Swap Day and Night inside enlarged slots to make them stand out. Zone colors retain their meaning. | On |
| **Grid type** | None removes separators; Horizontal lines separates rows; Full grid separates rows and columns. | Horizontal lines |

### Slots and backgrounds

Each dashboard has **Slot 1** through **Slot 10**, each with these two options:

| Option | What it does |
| --- | --- |
| **Slot N: value** | Choose the metric or Team text displayed in that position. Repeated selections are allowed. The first one or two slots are enlarged when enlargement is enabled. |
| **Slot N: background** | None keeps the ordinary theme background. Label colors the padded header band only. Whole cell colors the cell, including the value area. |

Backgrounds are off for all first-set slots by default. The second set starts with Label backgrounds on its first four slots and None on the rest.

Heart-rate, power and cadence fields use the zone of their own reading, including three-second and average values where available. Temperature has temperature-based colors. Slope uses a grade color under Label; Whole cell adds a horizon with the ordinary theme above it and colored ground below it. Team can use the shared color source described below. Other fields, or unavailable color data, use light gray in Day and dark gray in Night when a background is enabled. These effects also work in enlarged slots.

Selecting a zone profile or Team color source does not turn on a slot's background: choose Label or Whole cell for each slot that should show it.

The 33 selectable field types cover:

| Group | Available values |
| --- | --- |
| Speed | Current speed, average speed, lap speed |
| Distance | Ride distance, lap distance, distance to next waypoint |
| Heart rate | Current, average, three-second average, lap average, zone number |
| Power | Current, three-second average, activity average, lap average, zone number |
| Cadence | Current, activity average, lap average |
| Terrain | Elevation, ascent, descent, slope |
| Time | Activity timer, elapsed time, time of day, lap time |
| Other | Calories, temperature, battery, heading, completed laps, Team |

Lap speed, heart rate, power and cadence are averages for the current lap.

### Team text

| Option | What it does | Default |
| --- | --- | --- |
| **Team name** | Enter up to 32 printable ASCII characters, preserving case and spaces. Every Team slot on either dashboard displays this same text. An empty value leaves only the label. Text uses an automatically fitted Garmin built-in font and wraps at spaces only when needed. | `TEAM` |
| **Team color source** | None, Power or Heart rate. Power and Heart rate use the current reading and the corresponding selected zone profile, even when that metric has no visible slot. Set the Team slot's background to Label or Whole cell to show the color. None or unavailable color data gives the neutral gray background. | None |

Choose Team as a slot's value to display the text. There is one shared name and color source, rather than separate options for each Team slot.

## Switch to a second dashboard

Choose a trigger in the **Second field set** settings:

| Trigger | Show the second set | Return to the first set |
| --- | --- | --- |
| **Manual lap** (default) | Press the Lap button | Press Lap again |
| **3s power** | Reach your activation threshold | Drop below your separate return threshold |
| **Heart rate** | Reach your activation threshold | Drop below your separate return threshold |
| **Workout started** | Start a workout | Reset the activity timer |
| **None** | Switching is disabled | The first set stays active |

The **Second field set ? activation event** selector chooses the trigger. Its threshold options are:

| Option | Purpose | Allowed values | Default |
| --- | --- | --- | ---: |
| **Power: activate at (W)** | Show the second set when three-second power reaches this value. | 1?3000 W | 250 |
| **Power: return below (W)** | Return when three-second power falls strictly below this value. | 1?3000 W | 220 |
| **Heart rate: activate at (bpm)** | Show the second set when current heart rate reaches this value. | 30?250 bpm | 160 |
| **Heart rate: return below (bpm)** | Return when heart rate falls strictly below this value. | 30?250 bpm | 150 |

Only the threshold pair for the selected trigger is used. Set its return threshold at or below its activation threshold; the gap prevents repeated switching near one boundary. An invalid selected pair keeps the first set active. These thresholds control dashboard switching, independently of training-zone boundaries.

The app starts on the first dashboard, and timer reset returns to it. Power and heart-rate triggers evaluate while the activity timer runs; pause or stop holds the current dashboard. Missing readings during evaluation return to the first set. In Workout started mode, pausing, stopping or completing a workout keeps the second set visible until timer reset.

**Edge 530, 830 and 1030:** disable Auto Lap for Lap-button switching. Automatic and workout-generated laps can also toggle the dashboard on these devices.

The second dashboard starts with enlarged 3s power, followed by heart rate, cadence, slope, lap average power, speed, lap distance, lap time, elevation and temperature. Label backgrounds are enabled for its first four slots. The number of visible slots depends on the device and enlargement choices.

## Customize training zones

Training zones determine numeric zone fields and background colors. Configure them once for both dashboards.

| Option | What it does | Default |
| --- | --- | --- |
| **Use custom power zones** | On uses your seven-zone profile; Off uses the device's cycling power zones where available. Custom zones also work without a device-provided power-zone profile. | Off |
| **Power zone 1?6: upper W** | Six strictly increasing upper limits for Active Recovery, Endurance, Tempo, Threshold, VO2 Max and Anaerobic. Each must be an integer from 1 to 3000 W. Zone 7, Neuromuscular, covers everything above the sixth limit. | All 0 (unset) |
| **Use custom heart rate zones** | On uses your five-zone profile; Off uses the device's cycling heart-rate zones. Independent of the power switch. | Off |
| **Heart rate zone 1?4: upper bpm** | Four strictly increasing integer upper limits from 30 to 250 bpm. Zone 5 covers everything above the fourth limit. | All 0 (unset) |
| **Cadence zone 1?4: upper rpm** | Four strictly increasing integer upper limits from 0 to 300 rpm. Zone 5 covers everything above the fourth limit. Cadence always uses these app-defined boundaries, with no device/custom switch. | 60, 80, 100, 120 rpm |

Power and heart-rate inputs accept 0 to let you leave a limit unset, but every limit must be valid before enabling that custom profile. Enter actual watts or bpm; Struktur does not calculate these limits from FTP or percentages. The maximum editable limit is not a cap on readings: higher readings still enter the open-ended final zone.

| Zone | Power zone name | Color |
| --- | --- | --- |
| 1 | Active Recovery | Blue (`#00AAFF`) |
| 2 | Endurance | Green (`#00FF00`) |
| 3 | Tempo | Yellow (`#FFAA00`) |
| 4 | Threshold | Orange (`#FF5500`) |
| 5 | VO2 Max | Red (`#FF0000`) |
| 6 | Anaerobic | Magenta (`#FF00FF`) |
| 7 | Neuromuscular | Dark magenta (`#AA00AA`) |

Heart rate and cadence use the first five colors. Device-provided power zones use magenta for zone 6 and dark magenta for zone 7 or higher. Classification uses the rounded whole-number reading; a reading exactly at an upper limit stays in the lower zone. For example, the default cadence boundaries put 60 rpm in zone 1 and 61 rpm in zone 2.

The selected heart-rate and power profiles apply to current readings, three-second averages, activity and lap averages, numeric zone fields and Team coloring. Each average is classified using its own value; Team uses the current reading.

Missing, repeated, descending or out-of-range limits make an enabled custom profile invalid. Its zone fields show `--` and enabled backgrounds use neutral gray; valid metric values and Team text remain visible. There is no automatic fallback to device zones: turn the custom switch off to use those again. Custom limits remain saved while the switch is off. Invalid cadence boundaries likewise produce neutral backgrounds.

## Devices and layouts

Use Struktur in a **full-page, single Data Field** layout in your cycling activity.

| Edge models | Regular slots | With one enlarged slot | With two enlarged slots |
| --- | ---: | ---: | ---: |
| 530, 540, 550, 830, 840, 850 | 8 | 5 | 2 |
| 1030, 1040, 1050, 1060 | 10 | 7 | 4 |

These are the project's target devices. Availability of readings and device-specific features depends on the sensors and firmware; simulator testing does not establish physical-device compatibility.

## Set up

1. Install Struktur, then add it as the single Data Field on a full-page cycling data screen.
2. Open its application settings in Garmin Connect or Garmin Express to select slots and appearance.
3. Configure the second dashboard and its trigger. Team name and color source are shared across both dashboards.

For manual installation, use the PRG built for your exact device model and copy it to `GARMIN/APPS` on the device. Publishing packages and sideloading files are placed in `dist/` when generated.

An unavailable reading displays `--`. Lap metrics need an observed lap boundary if the app is loaded during a ride. Temperature readings can take several minutes to appear or refresh. Device-provided power zones may be unavailable on some devices or firmware; custom power zones do not depend on that source.

## For developers

Struktur uses Monkey C and the Garmin Connect IQ SDK. See [toolchain requirements](config/toolchain.json) and the [field and settings catalogue](config/catalogue.json). Keep the developer signing key outside the repository. With the SDK, Java and signing key configured:

```powershell
# Build and launch Edge 1040 in the simulator
./run-emulator.cmd edge1040 -Build

# Run the default Core suite
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/run-tests.ps1 -Product edge1040
```

Memory and Placement suites run only when explicitly requested. Use `bin/` for internal builds and `dist/` for store packages and sideloading PRGs.

The project was made with the [AI Architect requirement service](https://ai-architect.link). The [public specification](architecture/specification.md) describes requirements and design decisions. See [AGENTS.md](AGENTS.md) for contribution and publication conventions.

## License

Project code uses the [MIT license](LICENSE). Roboto Condensed fonts and generated resources retain the [SIL Open Font License 1.1](assets/fonts/OFL.txt).
