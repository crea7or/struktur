# Application properties

All 63 properties use compact keys. `a` is the default set; `b` is the second set. UI captions remain readable. These names replace the previous schema without compatibility migration.

The SDK serialization check includes keys and overhead, with the maximum 32-character Team value. Both default and maximum dictionaries must fit 8,000 bytes.

| Key | Setting | Type / allowed values | Default |
| --- | --- | --- | --- |
| `a_big` | Enlarged slot count | number: 0, 1, 2 | `0` |
| `a_align` | Alignment | number: 0 center, 1 right | `1` |
| `a_theme` | Theme mode | number: 0 auto, 1 day, 2 night | `0` |
| `a_hideu` | Hide physical units in headers | boolean | `true` |
| `a_inv` | Inverse theme for enlarged slots | boolean | `true` |
| `a_grid` | Grid type | number: 0 None, 1 Horizontal lines, 2 Full grid | `1` |
| `team` | Team name | string: 0?32 printable ASCII characters | `TEAM` |
| `tsrc` | Team color source | number: 0 None, 1 Power, 2 Heart rate | `0` |
| `a1` | Slot 1: value | number: field codes 0?32 (below) | `0` |
| `a1_bg` | Slot 1: background coverage | number: 0 None, 1 Label, 2 Whole cell | `0` |
| `a2` | Slot 2: value | number: field codes 0?32 (below) | `11` |
| `a2_bg` | Slot 2: background coverage | number: 0 None, 1 Label, 2 Whole cell | `0` |
| `a3` | Slot 3: value | number: field codes 0?32 (below) | `16` |
| `a3_bg` | Slot 3: background coverage | number: 0 None, 1 Label, 2 Whole cell | `0` |
| `a4` | Slot 4: value | number: field codes 0?32 (below) | `18` |
| `a4_bg` | Slot 4: background coverage | number: 0 None, 1 Label, 2 Whole cell | `0` |
| `a5` | Slot 5: value | number: field codes 0?32 (below) | `4` |
| `a5_bg` | Slot 5: background coverage | number: 0 None, 1 Label, 2 Whole cell | `0` |
| `a6` | Slot 6: value | number: field codes 0?32 (below) | `8` |
| `a6_bg` | Slot 6: background coverage | number: 0 None, 1 Label, 2 Whole cell | `0` |
| `a7` | Slot 7: value | number: field codes 0?32 (below) | `12` |
| `a7_bg` | Slot 7: background coverage | number: 0 None, 1 Label, 2 Whole cell | `0` |
| `a8` | Slot 8: value | number: field codes 0?32 (below) | `15` |
| `a8_bg` | Slot 8: background coverage | number: 0 None, 1 Label, 2 Whole cell | `0` |
| `a9` | Slot 9: value | number: field codes 0?32 (below) | `13` |
| `a9_bg` | Slot 9: background coverage | number: 0 None, 1 Label, 2 Whole cell | `0` |
| `a10` | Slot 10: value | number: field codes 0?32 (below) | `20` |
| `a10_bg` | Slot 10: background coverage | number: 0 None, 1 Label, 2 Whole cell | `0` |
| `cad1` | Cadence zone 1: upper rpm | number: 0?300 | `60` |
| `cad2` | Cadence zone 2: upper rpm | number: 0?300 | `80` |
| `cad3` | Cadence zone 3: upper rpm | number: 0?300 | `100` |
| `cad4` | Cadence zone 4: upper rpm | number: 0?300 | `120` |
| `trig` | Second field set - activation event | number: 0 None, 1 3s power, 2 Heart rate, 3 Manual lap, 4 Workout started | `3` |
| `p_on` | Power: activate at (W) | number: 1?3000 | `250` |
| `p_off` | Power: return below (W) | number: 1?3000 | `220` |
| `hr_on` | Heart rate: activate at (bpm) | number: 30?250 | `160` |
| `hr_off` | Heart rate: return below (bpm) | number: 30?250 | `150` |
| `b_big` | Second set: Enlarged slot count | number: 0, 1, 2 | `1` |
| `b_align` | Second set: Alignment | number: 0 center, 1 right | `1` |
| `b_theme` | Second set: Theme mode | number: 0 auto, 1 day, 2 night | `0` |
| `b_hideu` | Second set: Hide physical units in headers | boolean | `true` |
| `b_inv` | Second set: Inverse theme for enlarged slots | boolean | `true` |
| `b_grid` | Second set: Grid type | number: 0 None, 1 Horizontal lines, 2 Full grid | `1` |
| `b1` | Second set: Slot 1: value | number: field codes 0?32 (below) | `8` |
| `b1_bg` | Second set: Slot 1: background coverage | number: 0 None, 1 Label, 2 Whole cell | `1` |
| `b2` | Second set: Slot 2: value | number: field codes 0?32 (below) | `4` |
| `b2_bg` | Second set: Slot 2: background coverage | number: 0 None, 1 Label, 2 Whole cell | `1` |
| `b3` | Second set: Slot 3: value | number: field codes 0?32 (below) | `2` |
| `b3_bg` | Second set: Slot 3: background coverage | number: 0 None, 1 Label, 2 Whole cell | `1` |
| `b4` | Second set: Slot 4: value | number: field codes 0?32 (below) | `15` |
| `b4_bg` | Second set: Slot 4: background coverage | number: 0 None, 1 Label, 2 Whole cell | `1` |
| `b5` | Second set: Slot 5: value | number: field codes 0?32 (below) | `30` |
| `b5_bg` | Second set: Slot 5: background coverage | number: 0 None, 1 Label, 2 Whole cell | `0` |
| `b6` | Second set: Slot 6: value | number: field codes 0?32 (below) | `0` |
| `b6_bg` | Second set: Slot 6: background coverage | number: 0 None, 1 Label, 2 Whole cell | `0` |
| `b7` | Second set: Slot 7: value | number: field codes 0?32 (below) | `26` |
| `b7_bg` | Second set: Slot 7: background coverage | number: 0 None, 1 Label, 2 Whole cell | `0` |
| `b8` | Second set: Slot 8: value | number: field codes 0?32 (below) | `27` |
| `b8_bg` | Second set: Slot 8: background coverage | number: 0 None, 1 Label, 2 Whole cell | `0` |
| `b9` | Second set: Slot 9: value | number: field codes 0?32 (below) | `12` |
| `b9_bg` | Second set: Slot 9: background coverage | number: 0 None, 1 Label, 2 Whole cell | `0` |
| `b10` | Second set: Slot 10: value | number: field codes 0?32 (below) | `20` |
| `b10_bg` | Second set: Slot 10: background coverage | number: 0 None, 1 Label, 2 Whole cell | `0` |

All Team slots share `team` and `tsrc`. They are configured before the slot controls. Team font fitting is automatic; no font selector is exposed.

Cadence bounds must increase strictly. Invalid present bounds disable cadence coloring. Each activation return threshold must be no greater than its activation threshold; invalid selected pairs keep the default dashboard.

Field codes:

| Code | Field |
| --- | --- |
| 0 | current_speed |
| 1 | average_speed |
| 2 | current_cadence |
| 3 | average_cadence |
| 4 | current_heart_rate |
| 5 | average_heart_rate |
| 6 | heart_rate_zone |
| 7 | current_power |
| 8 | power_3s |
| 9 | average_power |
| 10 | power_zone |
| 11 | distance |
| 12 | elevation |
| 13 | total_ascent |
| 14 | total_descent |
| 15 | grade |
| 16 | activity_timer |
| 17 | elapsed_time |
| 18 | time_of_day |
| 19 | calories |
| 20 | temperature |
| 21 | battery |
| 22 | heading |
| 23 | distance_next_waypoint |
| 24 | completed_laps |
| 25 | heart_rate_3s |
| 26 | lap_distance |
| 27 | lap_time |
| 28 | lap_speed |
| 29 | lap_heart_rate |
| 30 | lap_power |
| 31 | lap_cadence |
| 32 | team |
