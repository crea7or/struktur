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
- **Set each slot's background** to None, Label or Whole cell. Add heart-rate, power or cadence zone colors, or a slope horizon with Whole cell background. Cadence zone boundaries are configurable.
- **Show your team name.** Enter the text once and use it in any Team slot on either dashboard. Text fits automatically and wraps at spaces when needed, with optional heart-rate or power coloring.
- **Use your preferred units**, optional `label | unit` headers and a 12- or 24-hour clock. Timers show compact seconds and support long rides.

The default dashboard shows speed, distance, timer, time, heart rate, 3s power, elevation, slope, ascent and temperature. Smaller layouts show the first eight. It starts with right alignment, horizontal separators and backgrounds off.

## Switch to a second dashboard

Choose a trigger in the **Second field set** settings:

| Trigger | Show the second set | Return to the first set |
| --- | --- | --- |
| **Manual lap** (default) | Press the Lap button | Press Lap again |
| **3s power** | Reach your activation threshold | Drop below your separate return threshold |
| **Heart rate** | Reach your activation threshold | Drop below your separate return threshold |
| **Workout started** | Start a workout | Reset the activity timer |
| **None** | Switching is disabled | The first set stays active |

The app starts on the first dashboard. For power and heart-rate switching, set the return threshold at or below the activation threshold. Missing readings return to the first set. In Workout started mode, pausing, stopping or completing a workout keeps the second set visible until timer reset.

**Edge 530, 830 and 1030:** disable Auto Lap for Lap-button switching. Automatic and workout-generated laps can also toggle the dashboard on these devices.

The second dashboard starts with enlarged 3s power, followed by heart rate, cadence, slope, lap average power, speed, lap distance, lap time, elevation and temperature. Label backgrounds are enabled for its first four slots. The number of visible slots depends on the device and enlargement choices.

## Devices and layouts

Use Struktur in a **full-page, single Data Field** layout in your cycling activity.

| Edge models | Regular slots | With one enlarged slot | With two enlarged slots |
| --- | ---: | ---: | ---: |
| 530, 540, 550, 830, 840, 850 | 8 | 5 | 2 |
| 1030, 1040, 1050 | 10 | 7 | 4 |

These are the project's target devices. Availability of readings and device-specific features depends on the sensors and firmware; simulator testing does not establish physical-device compatibility.

## Set up

1. Install Struktur, then add it as the single Data Field on a full-page cycling data screen.
2. Open its application settings in Garmin Connect or Garmin Express to select slots and appearance.
3. Configure the second dashboard and its trigger. Team name and color source are shared across both dashboards.

For manual installation, use the PRG built for your exact device model and copy it to `GARMIN/APPS` on the device. Publishing packages and sideloading files are placed in `dist/` when generated.

An unavailable reading displays `--`. Lap metrics need an observed lap boundary if the app is loaded during a ride. Temperature readings can take several minutes to appear or refresh. Power-zone coloring remains unavailable where its device data has not been validated.

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
