# Struktur — current requirements snapshot

Working specification updated: **31 October 2026**. This specification preserves current review states. Test definitions are separate from execution results.

Field identity, labels, units, header templates and precision are stored as typed attributes. Conditional precision uses PRECISION_RULE rather than numeric PRECISION.

## Index

- [TINT-1 — Compile the production Data Field for each declared profile](#tint-1)
- [SPEC-153 — Provide repeatable CLI build, simulator-test and package commands](#spec-153)
- [SPEC-152 — Version the Data Field project and per-device API capability matrix](#spec-152)
- [TPRF-5 — Changed-cell fitting and prepared-only rendering](#tprf-5)
- [APP-26 — Prepare geometry and sensor values outside the drawing path](#app-26)
- [TPRF-9 — Normal Data Field runtime memory validation](#tprf-9)
- [APP-48 — Measure runtime memory and verify bounded allocation](#app-48)
- [SPEC-229 — Core: verify workout-start latch and timer-reset return](#spec-229)
- [SPEC-232 — Placement: verify compact fallback independently for both field sets](#spec-232)
- [SPEC-170 — Verify: exercise and record the complete nine-device simulator scenario matrix](#spec-170)
- [TFNC-21 — Verify current-lap fields, averages and boundary lifecycle](#tfnc-21)
- [SPEC-228 — Core: verify manual-lap adapters and exactly-once boundaries](#spec-228)
- [SPEC-231 — Memory: verify bounded allocation while switching both field sets](#spec-231)
- [SPEC-291 — Verify Team native text bounds](#spec-291)
- [SPEC-296 — Verify Team and coloring runtime memory](#spec-296)
- [SPEC-163 — Verify: record and verify a reproducible Connect IQ development toolchain](#spec-163)
- [SPEC-164 — Verify: version the Data Field project and per-device API capability matrix](#spec-164)
- [SPEC-219 — Latch the second set from workout start until timer reset](#spec-219)
- [SPEC-217 — Toggle on manual typed lap events exactly once](#spec-217)
- [APP-34 — Reflow the grid to the assigned data-field bounds](#app-34)
- [APP-24 — Target Garmin Edge full-screen design profiles](#app-24)
- [SPEC-284 — Verify native power-zone mapping](#spec-284)
- [TFNC-24 — Validated zone metadata and snapshot classification](#tfnc-24)
- [DVS-42 — Handle unsupported training-zone data honestly](#dvs-42)
- [APP-20 — Configure the two-column Garmin field grid](#app-20)
- [TPRF-6 — Optional battery clock and diagnostic work](#tprf-6)
- [TPRF-4 — Bounded snapshot caches and live-input invalidation](#tprf-4)
- [DVS-34 — Temperature](#dvs-34)
- [SPEC-300 — Application properties](#spec-300)
- [SPEC-233 — Shared Coloring and Settings Migration](#spec-233)
- [SPEC-207 — Triggered Field Sets](#spec-207)
- [SPEC-175 — Bundled Glyph Inventory](#spec-175)
- [SPEC-150 — Development and Verification](#spec-150)
- [DVS-1 — Selectable Fields and Shared Display Rules](#dvs-1)
- [APP-1 — Application Design](#app-1)
- [SPEC-324 — Slot 7: background (a7_bg)](#spec-324)
- [SPEC-323 — Slot 7: value (a7)](#spec-323)
- [SPEC-322 — Slot 6: background (a6_bg)](#spec-322)
- [SPEC-321 — Slot 6: value (a6)](#spec-321)
- [SPEC-320 — Slot 5: background (a5_bg)](#spec-320)
- [SPEC-319 — Slot 5: value (a5)](#spec-319)
- [SPEC-318 — Slot 4: background (a4_bg)](#spec-318)
- [SPEC-317 — Slot 4: value (a4)](#spec-317)
- [SPEC-316 — Slot 3: background (a3_bg)](#spec-316)
- [SPEC-315 — Slot 3: value (a3)](#spec-315)
- [SPEC-314 — Slot 2: background (a2_bg)](#spec-314)
- [SPEC-313 — Slot 2: value (a2)](#spec-313)
- [SPEC-312 — Slot 1: background (a1_bg)](#spec-312)
- [SPEC-311 — Slot 1: value (a1)](#spec-311)
- [SPEC-310 — Team color source (tsrc)](#spec-310)
- [SPEC-308 — Team name (team)](#spec-308)
- [SPEC-253 — Team](#spec-253)
- [SPEC-249 — Fall back without discarding a valid metric](#spec-249)
- [SPEC-243 — Use compact property keys](#spec-243)
- [SPEC-214 — Evaluate the power event from the shared three-second average](#spec-214)
- [SPEC-210 — Keep all dashboard controls on one savable settings page](#spec-210)
- [SPEC-208 — Configure two independent field sets](#spec-208)
- [FUNC-8 — Lap cadence](#func-8)
- [FUNC-7 — Lap power](#func-7)
- [FUNC-6 — Lap heart rate](#func-6)
- [FUNC-5 — Lap speed](#func-5)
- [FUNC-4 — Lap time](#func-4)
- [FUNC-3 — Lap distance](#func-3)
- [DVS-50 — Show or hide physical units in field headers](#dvs-50)
- [SPEC-160 — Gate changes on repeatable compilation and explicit test evidence](#spec-160)
- [SPEC-155 — Publish one typed settings catalogue shared by XML, runtime and tests](#spec-155)
- [APP-49 — Select background coverage independently per field slot](#app-49)
- [DVS-47 — Display three-second average heart rate](#dvs-47)
- [DVS-41 — Compute shared three-second windows](#dvs-41)
- [APP-36 — Keep text readable when effects and themes change](#app-36)
- [APP-33 — Publish complete display snapshots before drawing](#app-33)
- [APP-31 — Validate saved settings and use safe display defaults](#app-31)
- [APP-30 — Configure visible count and value of each grid field](#app-30)
- [DVS-39 — Completed laps](#dvs-39)
- [DVS-37 — Distance to next waypoint](#dvs-37)
- [DVS-36 — Heading](#dvs-36)
- [DVS-35 — Device battery level](#dvs-35)
- [DVS-33 — Calories](#dvs-33)
- [DVS-32 — Time of day](#dvs-32)
- [DVS-31 — Elapsed time](#dvs-31)
- [DVS-30 — Activity timer](#dvs-30)
- [DVS-29 — Grade](#dvs-29)
- [DVS-28 — Total descent](#dvs-28)
- [DVS-27 — Total ascent](#dvs-27)
- [DVS-26 — Elevation](#dvs-26)
- [DVS-25 — Distance](#dvs-25)
- [DVS-24 — Power zone](#dvs-24)
- [DVS-23 — Average power](#dvs-23)
- [DVS-22 — Three-second average power](#dvs-22)
- [DVS-21 — Current power](#dvs-21)
- [DVS-20 — Heart rate zone](#dvs-20)
- [DVS-19 — Average heart rate](#dvs-19)
- [DVS-18 — Current heart rate](#dvs-18)
- [DVS-12 — Define field headers and their common band height](#dvs-12)
- [DVS-11 — Average Cadence](#dvs-11)
- [DVS-10 — Current Cadence](#dvs-10)
- [DVS-9 — Average speed](#dvs-9)
- [DVS-8 — Current speed](#dvs-8)
- [DVS-6 — Render transparent text with contrast halos on effect backgrounds](#dvs-6)
- [DVS-4 — App shall support metric and imperial values](#dvs-4)
- [APP-25 — Use the three specified Roboto Condensed font roles](#app-25)
- [SPEC-365 — Second set: Slot 10: background (b10_bg)](#spec-365)
- [SPEC-364 — Second set: Slot 10: value (b10)](#spec-364)
- [SPEC-363 — Second set: Slot 9: background (b9_bg)](#spec-363)
- [SPEC-362 — Second set: Slot 9: value (b9)](#spec-362)
- [SPEC-361 — Second set: Slot 8: background (b8_bg)](#spec-361)
- [SPEC-360 — Second set: Slot 8: value (b8)](#spec-360)
- [SPEC-359 — Second set: Slot 7: background (b7_bg)](#spec-359)
- [SPEC-358 — Second set: Slot 7: value (b7)](#spec-358)
- [SPEC-357 — Second set: Slot 6: background (b6_bg)](#spec-357)
- [SPEC-356 — Second set: Slot 6: value (b6)](#spec-356)
- [SPEC-355 — Second set: Slot 5: background (b5_bg)](#spec-355)
- [SPEC-354 — Second set: Slot 5: value (b5)](#spec-354)
- [SPEC-353 — Second set: Slot 4: background (b4_bg)](#spec-353)
- [SPEC-352 — Second set: Slot 4: value (b4)](#spec-352)
- [SPEC-351 — Second set: Slot 3: background (b3_bg)](#spec-351)
- [SPEC-350 — Second set: Slot 3: value (b3)](#spec-350)
- [SPEC-349 — Second set: Slot 2: background (b2_bg)](#spec-349)
- [SPEC-348 — Second set: Slot 2: value (b2)](#spec-348)
- [SPEC-347 — Second set: Slot 1: background (b1_bg)](#spec-347)
- [SPEC-346 — Second set: Slot 1: value (b1)](#spec-346)
- [SPEC-345 — Second set: Grid type (b_grid)](#spec-345)
- [SPEC-344 — Second set: Inverse theme for enlarged slots (b_inv)](#spec-344)
- [SPEC-343 — Second set: Hide physical units in headers (b_hideu)](#spec-343)
- [SPEC-342 — Second set: Theme mode (b_theme)](#spec-342)
- [SPEC-341 — Second set: Alignment (b_align)](#spec-341)
- [SPEC-340 — Second set: Enlarged slot count (b_big)](#spec-340)
- [SPEC-339 — Heart rate: return below (bpm) (hr_off)](#spec-339)
- [SPEC-338 — Heart rate: activate at (bpm) (hr_on)](#spec-338)
- [SPEC-337 — Power: return below (W) (p_off)](#spec-337)
- [SPEC-336 — Power: activate at (W) (p_on)](#spec-336)
- [SPEC-335 — Second field set - activation event (trig)](#spec-335)
- [SPEC-334 — Cadence zone 4: upper rpm (cad4)](#spec-334)
- [SPEC-333 — Cadence zone 3: upper rpm (cad3)](#spec-333)
- [SPEC-332 — Cadence zone 2: upper rpm (cad2)](#spec-332)
- [SPEC-331 — Cadence zone 1: upper rpm (cad1)](#spec-331)
- [SPEC-330 — Slot 10: background (a10_bg)](#spec-330)
- [SPEC-329 — Slot 10: value (a10)](#spec-329)
- [SPEC-328 — Slot 9: background (a9_bg)](#spec-328)
- [SPEC-327 — Slot 9: value (a9)](#spec-327)
- [SPEC-326 — Slot 8: background (a8_bg)](#spec-326)
- [SPEC-325 — Slot 8: value (a8)](#spec-325)
- [SPEC-307 — Grid type (a_grid)](#spec-307)
- [SPEC-306 — Inverse theme for enlarged slots (a_inv)](#spec-306)
- [SPEC-305 — Hide physical units in headers (a_hideu)](#spec-305)
- [SPEC-304 — Theme mode (a_theme)](#spec-304)
- [SPEC-303 — Alignment (a_align)](#spec-303)
- [SPEC-302 — Enlarged slot count (a_big)](#spec-302)
- [SPEC-301 — Property field-selection codes](#spec-301)
- [SPEC-252 — Configure four cadence upper boundaries](#spec-252)
- [SPEC-248 — Color each metric from its own value](#spec-248)
- [SPEC-247 — Classify cadence using five disjoint zones](#spec-247)
- [SPEC-246 — Use seven explicit training colors](#spec-246)
- [SPEC-245 — Bound the serialized settings dictionary](#spec-245)
- [SPEC-244 — Read current properties without compatibility migration](#spec-244)
- [SPEC-221 — Apply settings changes without replaying old events](#spec-221)
- [SPEC-220 — Reset switching state at activity and app boundaries](#spec-220)
- [SPEC-218 — Require Auto Lap disabled for legacy lap switching](#spec-218)
- [SPEC-216 — Return threshold modes to default on unavailable input](#spec-216)
- [SPEC-215 — Evaluate the heart-rate event from current heart rate](#spec-215)
- [SPEC-213 — Switch threshold modes with defined hysteresis](#spec-213)
- [SPEC-212 — Configure separate activation and return thresholds](#spec-212)
- [SPEC-211 — Select one activation event with Manual lap as default](#spec-211)
- [FUNC-10 — Calculate bounded time-weighted lap sensor averages](#func-10)
- [FUNC-9 — Establish and retain the current observed lap baseline](#func-9)
- [DVS-51 — Inverse theme for enlarged fields option](#dvs-51)
- [SPEC-177 — Reject missing or surplus font glyphs during generation and verification](#spec-177)
- [SPEC-176 — Bundle exactly the glyphs that each application font role can render](#spec-176)
- [SPEC-162 — Define development milestones and traceable release evidence](#spec-162)
- [SPEC-161 — Record unresolved product decisions before closing dependent development tasks](#spec-161)
- [SPEC-159 — Provide physical-device and memory-performance qualification procedures](#spec-159)
- [SPEC-158 — Exercise and record the complete nine-device simulator scenario matrix](#spec-158)
- [SPEC-157 — Run deterministic Monkey C tests for formatting, settings and sample processing](#spec-157)
- [SPEC-156 — Specify each displayed value acquisition path and deterministic sensor fixtures](#spec-156)
- [SPEC-154 — Reproduce Garmin-compatible Roboto Condensed resources within the memory budget](#spec-154)
- [SPEC-151 — Record and verify a reproducible Connect IQ development toolchain](#spec-151)
- [APP-47 — Apply per-device Connect IQ Data Field memory ceilings](#app-47)
- [DVS-45 — Keep slope and temperature palette extensions separate](#dvs-45)
- [APP-46 — Configure visible fields in Garmin Connect](#app-46)
- [APP-45 — Support day and night themes on Garmin devices](#app-45)
- [DVS-40 — Convert SDK units before displaying values](#dvs-40)
- [APP-38 — Qualify the declared Garmin device matrix](#app-38)
- [APP-37 — Stay within device memory and refresh budgets](#app-37)
- [APP-35 — Show unavailable activity values without stale readings](#app-35)
- [APP-32 — Apply changed settings without restarting an activity](#app-32)
- [HFER-8 — Draw the Horizontal lines pattern](#hfer-8)
- [HFER-7 — Draw the Full grid pattern](#hfer-7)
- [DVS-13 — Duration values display format](#dvs-13)
- [DVS-7 — Display valid integral values within field bounds](#dvs-7)
- [DVS-3 — Position numeric secondary text beside the primary value](#dvs-3)
- [DVS-2 — Format decimals using field precision and value magnitude](#dvs-2)
- [APP-23 — Choose grid row capacity from the assigned drawing area](#app-23)
- [APP-22 — Select grid independently of alignment](#app-22)
- [APP-21 — Align field labels and values at center or right](#app-21)
- [TSTFUNC-5 — SDK runner process ownership and cleanup](#tstfunc-5)
- [TSTFUNC-4 — Core: compact properties, defaults and field applicability](#tstfunc-4)
- [TSTFUNC-3 — Native properties persistence and settings callback](#tstfunc-3)
- [TSTFUNC-2 — Mixed Team and metric layouts through typed lap callbacks](#tstfunc-2)
- [TSTFUNC-1 — Verify battery percentage validity before rounding](#tstfunc-1)
- [SPEC-299 — Verify Team preparation invalidation](#spec-299)
- [SPEC-298 — Verify automatic Team fitting preserves settings](#spec-298)
- [SPEC-297 — Verify automatic Team font eligibility](#spec-297)
- [SPEC-295 — Verify Team insufficient-area handling](#spec-295)
- [SPEC-294 — Verify Team coloring regions](#spec-294)
- [SPEC-293 — Verify Team source binding and fallback](#spec-293)
- [SPEC-292 — Verify native Team font selection](#spec-292)
- [SPEC-290 — Verify Team settings isolation](#spec-290)
- [SPEC-289 — Verify Team literal rendering](#spec-289)
- [SPEC-288 — Verify Team binding options](#spec-288)
- [SPEC-287 — Verify Team text options](#spec-287)
- [SPEC-286 — Verify Team catalogue compatibility](#spec-286)
- [SPEC-285 — Verify cadence option validation](#spec-285)
- [SPEC-283 — Verify classification cache isolation](#spec-283)
- [SPEC-282 — Verify zone fallback and recovery](#spec-282)
- [SPEC-281 — Verify all metric family colors](#spec-281)
- [SPEC-280 — Verify cadence boundary table](#spec-280)
- [SPEC-279 — Verify exact seven-zone colors](#spec-279)
- [SPEC-278 — Verify serialized property budget](#spec-278)
- [SPEC-277 — Verify read-only compact property loading](#spec-277)
- [SPEC-276 — Verify current coverage settings without legacy declarations](#spec-276)
- [SPEC-275 — Verify color-only packet invalidation](#spec-275)
- [SPEC-274 — Verify enlarged color bounds and contrast](#spec-274)
- [SPEC-273 — Verify enlarged neutral fallback](#spec-273)
- [SPEC-272 — Verify enlarged semantic label fill](#spec-272)
- [SPEC-271 — Verify mode-only invalidation](#spec-271)
- [SPEC-270 — Verify isolated mode validation](#spec-270)
- [SPEC-269 — Verify whole-cell text contrast](#spec-269)
- [SPEC-268 — Verify background coverage regions](#spec-268)
- [SPEC-267 — Verify background mode choices](#spec-267)
- [SPEC-230 — Core: verify switching lifecycle, atomic frames and shared acquisition](#spec-230)
- [SPEC-227 — Core: verify threshold hysteresis and source validity](#spec-227)
- [SPEC-226 — Core: verify second-set settings, defaults](#spec-226)
- [TUI-12 — Actual overflow and compact layout cache behavior](#tui-12)
- [TPRF-8 — All three profile font resources can load](#tprf-8)
- [TFNC-26 — Late loading and gaps do not invent lap history](#tfnc-26)
- [TFNC-23 — Rolling samples use activity time and valid values](#tfnc-23)
- [TUI-7 — Effect foreground contrast and exact glyph widths](#tui-7)
- [TUI-6 — Exactly three fixed font roles in every layout](#tui-6)
- [TUI-5 — Reviewed field formatting and stable choices](#tui-5)
- [TFNC-22 — Magnitude-based speed, fixed-decimal slope and integral elevation](#tfnc-22)
- [TFNC-19 — Invalid acquisition input and safe background startup](#tfnc-19)
- [TFNC-18 — Data Field callbacks preserve lap continuity](#tfnc-18)
- [TFNC-17 — Shared acquisition integration and duplicate slots](#tfnc-17)
- [TFNC-16 — Legal temperature scheduling and runtime source guards](#tfnc-16)
- [TFNC-15 — Temperature delivery delay and clock guards](#tfnc-15)
- [TFNC-14 — Temperature packet, cache-age and display precision boundaries](#tfnc-14)
- [TFNC-13 — Lap identity, regression and overflow invalidation](#tfnc-13)
- [TFNC-12 — Known-zero lap baseline and pause/reset lifecycle](#tfnc-12)
- [TFNC-11 — Grade continuity and bounded sample history](#tfnc-11)
- [TFNC-10 — Grade regression, distinct distances and startup averaging](#tfnc-10)
- [TUI-1 — Production drawing alignment and palettes](#tui-1)
- [TFNC-8 — All field unit headers and secondary-unit switches](#tfnc-8)
- [TFNC-7 — Measured caption and duration fitting](#tfnc-7)
- [TFNC-6 — Unit conversion and complete duration formatting](#tfnc-6)
- [TFNC-5 — Typed settings defaults and hidden-slot preservation](#tfnc-5)
- [TFNC-4 — Grade and temperature effect boundaries](#tfnc-4)
- [TFNC-3 — Three-second rolling-window continuity](#tfnc-3)
- [TFNC-2 — All six full-capacity logical grids](#tfnc-2)
- [TFNC-1 — Floating-point display boundaries](#tfnc-1)
- [SPEC-178 — Verify exact glyph inventories across font roles and supported UI states](#spec-178)
- [SPEC-169 — Verify: run deterministic Monkey C tests for formatting, settings and sample processing](#spec-169)
- [SPEC-168 — Verify: specify each displayed value acquisition path and deterministic sensor fixtures](#spec-168)
- [SPEC-167 — Verify: publish one typed settings catalogue shared by XML, runtime and tests](#spec-167)
- [SPEC-166 — Verify: reproduce Garmin-compatible Roboto Condensed resources within the memory budget](#spec-166)
- [APP-4 — Data drawer](#app-4)
- [APP-3 — Drawing params provider](#app-3)
- [APP-2 — Initialization handler](#app-2)
- [APP-44 — Toybox.Graphics.Dc.fillPolygon(...)](#app-44)
- [APP-43 — Toybox.UserProfile.getPowerZones(...)](#app-43)
- [APP-12 — onUpdate(dc)](#app-12)
- [APP-8 — compute(info)](#app-8)
- [APP-7 — onLayout(dc)](#app-7)
- [SWINT-1 — Garmin SDK](#swint-1)
- [TRGR-1 — Core](#trgr-1)
- [APP-42 — Toybox.UserProfile.getHeartRateZones(...)](#app-42)
- [APP-41 — Toybox.WatchUi.requestUpdate()](#app-41)
- [APP-15 — Toybox.Application.Properties.getValue(key)](#app-15)
- [APP-5 — initialize()](#app-5)
- [APP-11 — onStop(state)](#app-11)
- [APP-16 — Toybox.Activity.getActivityInfo()](#app-16)
- [APP-6 — onSettingsChanged()](#app-6)
- [TPER-1 — Memory](#tper-1)
- [TRGR-2 — Placement](#trgr-2)
- [TUI-14 — Documented unsupported fields fail safe fitting](#tui-14)
- [TUI-13 — Unsupported and reduced-area presentation matrix](#tui-13)
- [TPRF-7 — Isolated three-font resource allocation probe](#tprf-7)
- [TUI-11 — Guaranteed normal values stay inside native cell borders](#tui-11)
- [TUI-10 — Exact formatting throughout declared normal intervals](#tui-10)
- [TFNC-25 — Current-lap distance time and weighted averages](#tfnc-25)
- [TUI-9 — Complete clock and duration groups fit native cells](#tui-9)
- [TUI-8 — Default-on grid visibility and unchanged cell drawing](#tui-8)
- [TUI-4 — Normal default ride headers and cell bounds](#tui-4)
- [TUI-3 — Literal and unit-template header selection](#tui-3)
- [TUI-2 — Measure complete label and unit headers](#tui-2)
- [SPEC-171 — Verify: provide physical-device and memory-performance qualification procedures](#spec-171)
- [TSEC-1 — Publication privacy, export integrity and current project consistency](#tsec-1)
- [TFNC-20 — Reject semantic font defects with refreshed cached hashes](#tfnc-20)
- [TCOM-1 — Exact glyph inventories and reproducible font resources](#tcom-1)
- [TFNC-9 — Independent theme inversion and sample preservation](#tfnc-9)
- [SPEC-179 — Verify font subset rejection, regeneration and nine-profile compatibility](#spec-179)
- [SPEC-174 — Verify: define development milestones and traceable release evidence](#spec-174)
- [SPEC-173 — Verify: record unresolved product decisions before closing dependent development tasks](#spec-173)
- [SPEC-172 — Verify: gate changes on repeatable compilation and explicit test evidence](#spec-172)
- [SPEC-165 — Verify: provide repeatable CLI build, simulator-test and package commands](#spec-165)
- [APP-40 — Toybox.Application.AppBase.onNightModeChanged()](#app-40)
- [APP-39 — Toybox.System.getDeviceSettings().isNightModeEnabled](#app-39)
- [APP-19 — Toybox.WatchUi.DataField.createField(...)](#app-19)
- [APP-18 — Toybox.UserProfile.getProfile()](#app-18)
- [APP-17 — Toybox.System.getSystemStats()](#app-17)
- [APP-14 — onHide()](#app-14)
- [APP-13 — onShow()](#app-13)
- [APP-10 — onStart(state)](#app-10)
- [APP-9 — getInitialView()](#app-9)
- [SPEC-660 — Custom training zones](#spec-660)
- [SPEC-661 — Classify custom heart rate into five zones](#spec-661)
- [SPEC-662 — Classify custom power into seven zones](#spec-662)
- [SPEC-663 — Select the global power zone source](#spec-663)
- [SPEC-664 — Select the global heart rate zone source](#spec-664)
- [SPEC-665 — Share the selected zone profile with all consumers](#spec-665)
- [SPEC-666 — Keep invalid custom zone profiles unavailable](#spec-666)
- [SPEC-667 — Prepare zone profiles outside compute and drawing](#spec-667)
- [SPEC-668 — Preserve activity state when editing zone settings](#spec-668)
- [SPEC-669 — Keep shared training zone controls contiguous on the main settings page](#spec-669)
- [FR-16431 — Use custom power zones (cpz)](#fr-16431)
- [FR-16432 — Power zone 1 (Active Recovery): upper W (pw1)](#fr-16432)
- [FR-16433 — Power zone 2 (Endurance): upper W (pw2)](#fr-16433)
- [FR-16434 — Power zone 3 (Tempo): upper W (pw3)](#fr-16434)
- [FR-16435 — Power zone 4 (Threshold): upper W (pw4)](#fr-16435)
- [FR-16436 — Power zone 5 (VO2 Max): upper W (pw5)](#fr-16436)
- [FR-16437 — Power zone 6 (Anaerobic): upper W (pw6)](#fr-16437)
- [FR-16438 — Use custom heart rate zones (chz)](#fr-16438)
- [FR-16439 — Heart rate zone 1: upper bpm (hr1)](#fr-16439)
- [FR-16440 — Heart rate zone 2: upper bpm (hr2)](#fr-16440)
- [FR-16441 — Heart rate zone 3: upper bpm (hr3)](#fr-16441)
- [FR-16442 — Heart rate zone 4: upper bpm (hr4)](#fr-16442)
- [TSTFUNC-6 — Core: custom HR boundaries and validation](#tstfunc-6)
- [TSTFUNC-7 — Core: custom power boundaries and names](#tstfunc-7)
- [TSTFUNC-8 — Core: independent zone selection and recovery](#tstfunc-8)
- [TSTFUNC-9 — Core: selected profiles and seven exact colors](#tstfunc-9)
- [TSTFUNC-10 — Core: custom zone properties and settings persistence](#tstfunc-10)
- [TSTFUNC-11 — Core: zone preparation and activity isolation](#tstfunc-11)

<a id="tint-1"></a>
## TINT-1 — Compile the production Data Field for each declared profile

Type: test | State: approved | Revision: 30

Purpose: Compile the production Data Field for each declared profile.

Requirement references: [SPEC-152](#spec-152), [SPEC-153](#spec-153).

Procedure and expected results: Run build.ps1 -Mode all with the declared toolchain and external signing key. For each of the ten profiles require compiler exit 0, a nonempty PRG, a recorded SHA256 matching the file and matching current source-input hashes. Normal application compilation only; no tests or memory measurements are invoked by this case.

Executable source: `scripts/build.ps1`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.
Run tools/test_compile_package.py in Core: verify all six declared 30.18/API 6.0.0 modern targets, unchanged input, languages and undeclared products/regions; reject upstream drift, missing/duplicate parts, invalid floors, unknown evidence kinds and missing inference anchors. Export a candidate package; tools/verify_package_compatibility.py must verify all regional gates against policy and installed definitions, plus unchanged installed hashes. Core simulator execution does not qualify historical firmware on hardware.

**Relations**

- verifies: [SPEC-152](#spec-152), [SPEC-153](#spec-153)

<a id="spec-153"></a>
## SPEC-153 — Provide repeatable CLI build, simulator-test and package commands

Type: requirement | State: approved | Revision: 61

Provide documented clean/build/test/package commands accepting product/mode/SDK/external key. Targets are deterministic and IDE/checkout-path independent; failures return nonzero. Log product/invocation/source/resource/toolchain hashes without secrets. Distinguish debug/test/release; never package test/diagnostic fixtures in release.
Use verified pinned-SDK options. Emit per-product PRG/debug and supported IQ artifacts. Test orchestration connects/starts the documented simulator and requires named tests plus a successful nonempty summary; timeout/crash/assertion/zero tests fails. Compilation is not runtime qualification. Inject external signing identity/tokens securely; exclude them from commits/artifacts/logs and retain signing identity across upgrades.
Use code-size optimization -O 3z consistently for app, package, preview and test builds. Own automated SDK validation/preview runner descendants before startup; close the entire owned process group on success, failure, timeout or controller exit, including descendants of an exited parent. Preserve exit codes and logs; do not terminate unrelated processes or wait indefinitely for inherited output pipes.
Keep the installed device library unchanged. For store packaging, copy device definitions into a project-local overlay and apply only the model/part-specific firmware/API overrides in config/firmware-compatibility.json. Record device-report or release-family-inference evidence and preserve the feature API floor. An inferred target must cite both its model release notice and API evidence anchor; reject missing evidence or an unknown evidence kind. Reject missing/duplicate declared parts and unexpected upstream firmware/API values; preserve all undeclared metadata. Automatically verify every exported regional firmware/API gate and unchanged installed metadata before reporting package success. Compile and sign with SDK 9.2.0; never edit a signed package. Inspect exported firmware/API gates before distribution.

**Relations**

- part_of: [SPEC-150](#spec-150)
- uses: [SPEC-151](#spec-151), [SPEC-152](#spec-152)

<a id="spec-152"></a>
## SPEC-152 — Version the Data Field project and per-device API capability matrix

Type: requirement | State: approved | Revision: 59

Version Monkey C sources, manifest/jungle, resource/settings XML, tests/fixtures and build scripts. Project inputs use relative paths; tool/key locations are configurable external paths. Exclude generated binaries/caches/secrets. Manifest identifies a stable Data Field application ID/entry point.
For every candidate, record minimum firmware/API, supported optional APIs and fallbacks (properties, zones, night mode, temperature, graphics), and justify permissions including UserProfile/Background/Sensor. Preserve older targets through guarded fallbacks; never require API 5.2.2 globally solely for optional power zones. Do not omit failing candidates or equate compilation with qualified support.
Build all ten profiles with pinned SDK 9.2.0. Use config/firmware-compatibility.json for evidenced package floors: Edge 540/550/840/850, worldwide Edge 1040 and Edge 1050 require firmware 30.18/API 6.0.0. The four added models use model-specific release notices and explicit API release-family inference from 1040/1050 device evidence; do not describe that inference as a direct model/API capture. Retain legacy 530/830/1030, APAC 1040 and 1060 installed gates. Power zones and typed laps require API 5.2.2; do not lower a target by disabling these features. Historical VM versions alone do not prove API availability. These are evidenced compatibility targets, not exhaustive earliest-firmware or physical qualification claims. Inspect exported package gates independently of SDK version. Guard optional power APIs and compile typed-lap adapters only for supported profiles. Record simulator and physical qualification separately.

**Relations**

- part_of: [SPEC-150](#spec-150)
- uses: [APP-24](#app-24), [SPEC-151](#spec-151)

<a id="tprf-5"></a>
## TPRF-5 — Changed-cell fitting and prepared-only rendering

Type: test | State: approved | Revision: 35

Purpose: Verify [APP-26](#app-26) changed-cell preparation and draw-only replay. Suite: Core.

Unchanged immutable visible records, including raw changes with equal displayed text, require zero record-field comparisons, geometry scans, refits and packet rebuilds. One changed value refits one cell. Equal-angle slope polygons survive unrelated changes. Theme, effects, layout and settings changes refresh affected presentation; hidden slots beyond preferred capacity do not scan geometry or refit visible cells.

Lock preparation, fitting, measurement and color-selection methods during ordinary drawing. Verify production callbacks replay prepared commands; packed separator decoding permitted by [APP-26](#app-26) preserves exact endpoints/colors. After clear, ordinary cells perform zero base fills. Inverted or whole-cell backgrounds still fill when different; label bands, horizons and text retain the same rendered result.

Bank replacements release outgoing fits/packets/headers before successors, preserving retained records and acquisition. Repeated spans share bounded separator tables.

Executable: tests/PerformanceTests.mc, rendererCacheAndDrawPurity. Supporting horizon vertices are checked by logicalGridCases. Record executions separately under [SPEC-162](#spec-162); no Memory, Placement or hardware qualification is implied.

Assert active geometry/separator caches contain at most one selected plan. An unchanged-geometry switch reuses that plan; geometry replacement releases the previous plan before constructing a new one. Verify ordinary draw purity, fallback recovery and cache invalidation remain correct.
Exercise full settings reload with three cached font roles: outgoing handles/packets/obsolete geometry are released before property loading, metric tables and acquisition history survive, and the rebuilt view loads at most the same three roles and draws correctly. Verify ordinary bank-switch reuse remains intact.

Custom source/threshold edits must invalidate affected prepared colors before next display; retain draw-only and changed-cell constraints. See [TSTFUNC-11](#tstfunc-11).

**Relations**

- verifies: [APP-12](#app-12), [APP-26](#app-26), [APP-32](#app-32), [DVS-29](#dvs-29), [SPEC-667](#spec-667)

<a id="app-26"></a>
## APP-26 — Prepare geometry and sensor values outside the drawing path

Type: requirement | State: approved | Revision: 105

Prepare bounded caches when inputs become available:
- Init/settings: validate both banks; resolve descriptors/conversions/formats/effects/channels and unavailable-safe values. Cache three metric roles, native candidates and header metrics. Keep at most two configuration banks, one acquisition state and one active prepared presentation; release outgoing fits/packets/headers before replacements. Reuse valid active geometry/fonts across switches. Retain only the selected geometry/separator plan; release failed/unselected plans and release obsolete geometry before replacing it.
- Layout: cache geometry, selected fonts, header width/ink, separators and repeated segment tables. Identical layouts reuse state; grid-only edits refresh separators. Retain only assigned header variants.
- Refit only for changed displayed text/secondary/header, native face, bounds or halo clearance. Reuse wrapped lines/runs/packets/equal-angle polygons. Reconsider preferred capacity after fallback when candidates change; slots beyond preferred capacity never refit visible cells.
- Validate zone bounds on metadata refresh, cache by channel/reading/profile revision, and share current-source classification across duplicates/zone fields/text bindings. Invalidate only affected channels/packets; equal cadence bounds preserve cache.
- Advance readings/rolling/grade/lap/lifecycle once per delivered compute, including hidden sources/triggers. Never duplicate sampling by slot/bank. Clock/battery queries follow active retained needs; newly active banks obtain required current values before their frame. Validate nonempty temperature caches on every delivered compute and presentation refresh, even without an assigned temperature slot; skip age/clock queries only while empty. Read device unit, clock-format and automatic-theme preferences on each delivered compute and presentation refresh; apply changes to that snapshot without sample-count throttling.
Never mutate published records: reuse unchanged records, replace changed ones. Skip record-field comparisons for identical records; skip cell preparation when visible records, palette and layout are unchanged. Prepare coordinates/colors/contours/polygons/wrapped text before drawing. Ordinary onUpdate only dispatches prepared graphics/clip commands. After clearing the frame, fill a cell base only when its prepared background differs from the cleared background; retain label bands, slope polygons and text contrast. Packed separator commands may decode their stored coordinates and grayscale bytes during dispatch; geometry, gradient selection and fitting remain cached. It may dispatch onLayout with its current Dc once for uninitialized/changed bounds or pending Team text/font/header fitting that needs live native measurements. That bounded layout branch performs the required measurement/preparation; unchanged frames do not remeasure. Outside it, onUpdate performs no formatting, measurement, resource loading, sensor/settings queries or presentation calculations. This applies to the complete DataField entry and renderer. Release obsolete caches; retain no unbounded history. Settings/switches preserve shared acquisition.
Keep callback preparation within the target VM stack limit, including mixed native Team and sprite metrics after layout through settings and typed lap callbacks.
Never retain a native Dc after its callback returns. Settings, compute, lap and background callbacks may invalidate native fits but must defer native measurement to the next layout with a current Dc.
Use bounded packed slot/presentation/geometry state. Release replaced raw frames and reset presentation before constructing their successors; externally retained presentation records remain unchanged.
On full properties reload, release outgoing presentation, geometry and font handles before loading the property dictionary and replacement banks. Retain metric tables and acquisition history, then reload only the required fixed font roles. Ordinary bank switches continue to reuse valid geometry/fonts.

**Relations**

- allocated_to: [APP-3](#app-3)
- part_of: [APP-1](#app-1)
- uses: [APP-12](#app-12), [APP-7](#app-7), [APP-8](#app-8)

<a id="tprf-9"></a>
## TPRF-9 — Normal Data Field runtime memory validation

Type: test | State: approved | Revision: 33

Purpose: Normal Data Field runtime memory validation. Suite: Memory; explicit request only.

References: [APP-47](#app-47), [APP-48](#app-48), [APP-37](#app-37), [APP-38](#app-38), [SPEC-162](#spec-162), [SPEC-231](#spec-231), [SPEC-296](#spec-296).

After isolated font probes, run scripts/validate-memory.ps1 for each requested profile with identical production sources/resources and current hashes. Run separately:
1. Native/default observer: real production callbacks, no synthetic fixtures, RuntimeMetrics disabled; at least 10 computes, three draws and 30 seconds.
2. Matrix: three cycles of 216 cases; at least 54 complete native grids, three font roles and all 33 fields in fitting roles, including maximum Team text, effects/themes/inversion, missing values, settings/lifecycle and bounded acquisition history. Cache header eligibility; substitute a compatible field only for unsupported regular headers and report substitutions. Unsupported placements remain in Placement.
3. Switching: all [SPEC-231](#spec-231) transitions, settings changes and repeated-state checkpoints.

Use native full-bounds Dc directly. Retain at most the app's two configuration banks, one acquisition and one active presentation; recreate reference settings between cycles rather than retaining a third bank. Release outgoing raw/presentation state before replacements and synthetic presentation before native producer callbacks. Supply known validated synthetic zone bounds without cloning presentation records; this does not qualify sensor provenance.

Sampling retains fixed counters without I/O or formatting. Defer diagnostics until fixture locals are released. Record initialization/first-draw values and peak/free/total for each run; identify native observer and driver overhead without subtracting estimates to obtain a pass. Run host regressions for sampler I/O, incomplete/duplicate/crashed records and absolute limit violations.

Require all three current-source normal Data Field reports, no allocation/stack failure, unchanged runtime/published limits and no sustained growth over repeated returns to the same configuration. Partial diagnosis runs cannot qualify a profile. Preserve failed attempts, environment, source/binary hashes and exact coverage. Observer overhead is included; default observation and sparse sampling do not establish uninstrumented/maximal/transient peaks. Missing physical evidence stays unrun/blocked.

**Relations**

- verifies: [APP-37](#app-37), [APP-38](#app-38), [APP-47](#app-47), [APP-48](#app-48)

<a id="app-48"></a>
## APP-48 — Measure runtime memory and verify bounded allocation

Type: requirement | State: approved | Revision: 38

Only explicit Memory validation enables diagnostic sampling. Record total/used/free memory after initialization/resources and through maximal grid/resources, themes/effects, rolling buffers, sensor interruptions, settings and repeated bank switches. State sampling method and maximum used/minimum free bytes; sampling does not prove absence of between-sample peaks.
Pass only within runtime allocation and Data Field ceiling, without allocation failure/OOM or sustained unreclaimed growth after returning to the same configuration. Bound/reuse resources, buffers and caches. Qualify each profile independently even when screen/fonts/ceiling match: before API 4.0 loaded fonts share heap, while newer APIs have a separate graphics pool. Record resource hashes; retain fixed fonts and maximal-grid coverage during optimization checks. Hardware evidence is separate.

Memory sampling shall retain fixed counters and stage identifiers without console output or diagnostic formatting in the sampling path. Emit records after fixture temporaries are released. Measure a separate native-callback/default-configuration observer without synthetic driver state; identify its observer overhead and scope. Apply limits to unadjusted instrumented usage; never subtract estimated overhead to obtain a pass.

**Relations**

- part_of: [APP-1](#app-1)
- uses: [APP-37](#app-37), [APP-47](#app-47)

<a id="spec-229"></a>
## SPEC-229 — Core: verify workout-start latch and timer-reset return

Type: test | State: approved | Revision: 8

Verification definition; implementation and execution evidence are recorded separately. For Workout started mode, initialize default; onWorkoutStarted -> second; repeated workout-start -> second. While second, pause/stop/resume, timer start in the same activity, manual/automatic laps, workout-step completion, workout completion and sensor loss shall all retain second. onTimerReset -> default and repeated reset stays default; next activity remains default until a new workout-start event. Loading late or selecting this mode after an earlier start shall not replay it. Events in other modes do not activate Workout started. Verify onWorkoutStarted and onTimerReset symbols on all ten profiles; production callback entry points must share fixture-tested behavior. Physical workout/callback delivery is blocked until model/firmware evidence exists. This is Core, without Memory/Placement execution.

**Relations**

- part_of: [SPEC-207](#spec-207)
- verifies: [SPEC-211](#spec-211), [SPEC-219](#spec-219), [SPEC-220](#spec-220)

<a id="spec-232"></a>
## SPEC-232 — Placement: verify compact fallback independently for both field sets

Type: test | State: approved | Revision: 16

Verification definition; implementation and execution evidence are recorded separately. Run only when Placement is explicitly requested. On all ten profiles, give one bank a fitting supported layout and the other an intentionally insufficient assigned area/header combination, then switch both ways. Verify the existing exact compact fallback in the failing bank and recovery to the preferred fitting capacity in the other, with no pinned fallback, mixed set or silent partial grid. Repeat for enlarged layout, both alignments, unit-header visibility and each grid type; evaluate resource/glyph bounds and expected overflow markers only in deliberately unsupported contexts. Preserve active trigger state during repeated layout notifications. Record assigned bounds, both configurations and observed messages. These deliberate compact-message cases shall not enter the default Core inventory.

**Relations**

- part_of: [SPEC-207](#spec-207)
- verifies: [APP-33](#app-33), [SPEC-208](#spec-208)

<a id="spec-170"></a>
## SPEC-170 — Verify: exercise and record the complete nine-device simulator scenario matrix

Type: test | State: approved | Revision: 31

Execute the recorded matrix for all ten products and check coverage against scenario IDs. Verify compact fallback has no overlap, all cells stay within assigned bounds, settings leave no obsolete effect pixels and every supported effect has explicit assertions. Inspect product-specific images/logs and record simulator provenance; report unrun scenarios separately. This is a planned verification case; no passing execution is asserted.

Explicitly verify [APP-23](#app-23) capacity selection, [APP-26](#app-26) cached drawing, [DVS-12](#dvs-12) headers, [APP-21](#app-21) alignment and [HFER-7](#hfer-7)/[HFER-8](#hfer-8) exact separator geometry/grayscale; cover [SPEC-248](#spec-248) independently averaged zone effects and [APP-37](#app-37) callback ordering/deadlines.


**Relations**

- part_of: [SPEC-150](#spec-150)
- verifies: [APP-21](#app-21), [APP-23](#app-23), [APP-26](#app-26), [APP-37](#app-37), [DVS-12](#dvs-12), [HFER-7](#hfer-7), [HFER-8](#hfer-8), [SPEC-158](#spec-158), [SPEC-248](#spec-248)

<a id="tfnc-21"></a>
## TFNC-21 — Verify current-lap fields, averages and boundary lifecycle

Type: test | State: approved | Revision: 24

Planned acceptance definition; no execution or implementation is asserted. Verify all six lap fields and the exact labels from their field definitions, codes 26..31, units and full/regular/enlarged/duplicate/hidden layouts. Prove existing 0..25 mappings, saved assignments, ten-slot defaults in both banks and the active catalogue in [SPEC-155](#spec-155) are exposed and the retired use_units_as_labels key is ignored. A full lap of 1000 m over 120000 active ms gives 1.00 km / 02.00 / 30.0 km/h; verify statute conversion, .SS preservation, zero distance and zero-duration unavailability. Use irregular-spacing/zero/missing-channel fixtures against [FUNC-10](#func-10). Verify all channel and time values at confirmed boundaries, including unavailable means until positive covered time.

Exercise fresh activity, late loading while running/paused, recovery at the next confirmed boundary independently of an unknown completed-lap total, manual/Auto Lap, optional lap2 once-only fallback, workout-step-only notifications, pause/stop/resume, save/discard/reset, old events, identity/counter regressions and lost callback continuity under [FUNC-9](#func-9). Verify per-channel availability/coverage, first-sample seeding, gaps, duplicate/out-of-order samples, overflow and long-duration bounded memory. A missing boundary baseline remains unavailable rather than using a cached counter or activity-wide average. Changing settings/layout/visibility does not reset acquisition; drawing adds no samples.

On all ten profiles, separately record compiler capability, callback order/capture freshness, sensor/zero behavior, FIT comparison and observed boundary error with product, SDK, firmware, source revision and captured requirement baseline. Simulator fixtures are not physical evidence. Hardware portions remain blocked until devices/evidence exist. Record unexecuted portions as unrun and missing hardware evidence as blocked. Link this test to its current-lap acquisition and field definitions; approval of the test definition is not a passing result.


**Relations**

- part_of: [DVS-1](#dvs-1)
- verifies: [FUNC-10](#func-10), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [FUNC-9](#func-9), [SPEC-155](#spec-155)

<a id="spec-228"></a>
## SPEC-228 — Core: verify manual-lap adapters and exactly-once boundaries

Type: test | State: approved | Revision: 14

Verification definition; implementation and execution evidence are recorded separately. Compile/inspect adapters for all ten SDK profiles. For modern profiles, inject manual,manual,manual -> second,default,second. Inject every non-manual enum plus absent/unknown metadata: bank unchanged, shared lap-boundary processing still once, handler returns true and legacy fallback is not invoked. In None/power/HR/workout modes, a lap still updates lap metrics once without acting as a manual toggle. Legacy fixtures deliver three callbacks -> second,default,second; verify the exact Auto Lap-off prompt and guide restriction on other automatic lap sources. Legacy cannot prove manual origin: do not report filtering support. Confirm no reset twice through modern/legacy dispatch and no changes from workout-step-only events. Actual physical callback origin/order and Auto Lap setup are a separate per-model/firmware integration check; mark those portions blocked if hardware evidence is unavailable. Core fixtures alone do not qualify physical delivery.
After native layout, exercise onTimerLap2 itself with mixed Team/metric banks, 0/1/2 enlarged fields, both alignments and all coverage modes. Repeated manual toggles must prepare drawable headers/values without stack overflow; do not substitute onLapNotification for the typed entry point.

**Relations**

- part_of: [SPEC-207](#spec-207)
- verifies: [APP-26](#app-26), [SPEC-217](#spec-217), [SPEC-218](#spec-218)

<a id="spec-231"></a>
## SPEC-231 — Memory: verify bounded allocation while switching both field sets

Type: test | State: approved | Revision: 19

Verification definition; implementation and execution evidence are recorded separately. Run only when Memory is explicitly requested. For all ten actual Data Field simulator runtimes, measure initialize/peak/retained heap under [APP-48](#app-48) limits with distinct maximum-complexity sets, both trigger sources, lap/workout events and repeated mode/configuration changes. Include 1000 compute-driven bank transitions and 200 alternating settings changes; sample after warm-up, at 500 and 1000 transitions, and after settings cycles. Assert every measured heap remains within its profile ceiling, font resources stay shared, and retained object/cache counts remain within the declared two banks/one acquisition/one active presentation rather than growing with switch count. Report source fingerprint, SDK/profile, exact sequence, measurements, limits and any failure. Compare repeated steady-state cycles to distinguish retained growth from transient peak. Simulator evidence is not physical qualification; mark unavailable hardware portions blocked.

Execute the switching driver (`validation/memory/MemorySwitching.mc`) separately from the 648-case layout/resource driver (`validation/memory/MemoryValidation.mc`), each in the normal bounded Data Field runtime with the same production sources and resources. Both runs must pass; retain separate source/binary hashes, logs and measurements and aggregate the worst measured usage. This prevents unrelated qualification drivers from occupying the measured heap together; it does not change the app limit, font sizes or required scenarios.

Dispatch bounded batches of transitions/settings changes across native drawing callbacks so harness batching does not trigger the watchdog. Preserve all 1000 transitions, 200 changes and repeated-state checkpoints; require completion within the declared runner timeout.

**Relations**

- part_of: [SPEC-207](#spec-207)
- verifies: [APP-26](#app-26)

<a id="spec-291"></a>
## SPEC-291 — Verify Team native text bounds

Type: test | State: approved | Revision: 15

Suite: Core. On all ten profiles verify fitting native Team lines below the shared header in regular/enlarged slots, both sets and alignments. Check five-percent value-area padding, one-pixel clearance, per-line alignment and vertically centered block. Markers do not count as normal-fit evidence.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [APP-21](#app-21), [APP-34](#app-34), [SPEC-253](#spec-253)

<a id="spec-296"></a>
## SPEC-296 — Verify Team and coloring runtime memory

Type: test | State: approved | Revision: 10

Suite: Memory. Definition; execution evidence is separate.

Explicit-request Memory: run the normal Data Field runtime on all ten profiles with maximum valid Team strings, all three bundled fonts, native text, all colored families/modes and repeated edits/switches. Record peak/steady memory, device limit, source/binary hashes and failures; synthetic test-application memory is insufficient.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [APP-48](#app-48)

<a id="spec-163"></a>
## SPEC-163 — Verify: record and verify a reproducible Connect IQ development toolchain

Type: test | State: approved | Revision: 7

On a clean checkout on the documented host, follow only the guide, verify tool versions and resolve all ten product packages. Exercise missing Java, mismatched SDK and missing device-package cases; each must fail with a useful diagnostic. Compare optional IDE and CLI resolved SDK paths. Record versions and command output; this case is planned, not executed. This is a planned verification case; no passing execution is asserted.

**Relations**

- part_of: [SPEC-150](#spec-150)
- verifies: [SPEC-151](#spec-151)

<a id="spec-164"></a>
## SPEC-164 — Verify: version the Data Field project and per-device API capability matrix

Type: test | State: approved | Revision: 11

Inspect the manifest and build inputs; compile all ten candidates as Data Fields and compare product coverage with the matrix. Exercise unavailable newer APIs on an older candidate and verify the approved neutral/theme fallback. Fail on unsupported product/API references, unexplained permissions or an unreported missing candidate. This is a planned verification case; no passing execution is asserted.

**Relations**

- part_of: [SPEC-150](#spec-150)
- verifies: [SPEC-152](#spec-152)

<a id="spec-219"></a>
## SPEC-219 — Latch the second set from workout start until timer reset

Type: requirement | State: approved | Revision: 15

In Workout started mode, a delivered onWorkoutStarted() selects the second set. Further workout-start notifications keep it selected; this is a latch, not a toggle. Keep the second set until onTimerReset() selects the default and clears the latch. Pause, stop, resume/start of the same activity, manual/automatic laps, workout-step completion, completion of the workout itself, and missing power/heart-rate data shall not clear it.

If the app is loaded after workout start, or this mode is selected after that event, start on the default set and wait for a subsequently delivered onWorkoutStarted(); do not infer an earlier event from samples or a workout-step callback. None/mode changes and process restart still follow [SPEC-211](#spec-211), [SPEC-221](#spec-221) and [SPEC-220](#spec-220). Use the documented callback on all ten profiles.

API: https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/DataField.html#onWorkoutStarted-instance_function

**Relations**

- part_of: [SPEC-207](#spec-207)
- uses: [SPEC-211](#spec-211), [SPEC-220](#spec-220)

<a id="spec-217"></a>
## SPEC-217 — Toggle on manual typed lap events exactly once

Type: requirement | State: approved | Revision: 14

On Edge 540/550/840/850/1040/1050/1060 with onTimerLap2 support, Manual lap mode toggles default -> second -> default only when trigger[:lapTrigger] equals WatchUi.DataField.LAP_TRIGGER_MANUAL. All other or missing/unknown trigger values leave the selected set unchanged. Do not infer manual type from lap count, timing or a workout-step callback.

Route each lap notification through the shared lap-boundary processing once, independently of the selected switching mode. The typed handler shall return true after handling it, including non-manual notifications, so Garmin does not invoke onTimerLap() as fallback and reset or toggle twice. Preserve current-lap and completed-lap contracts; an ignored switching cause is still a delivered lap for acquisition. Compile/guard the typed adapter only for profiles that expose the API.

API: https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/DataField.html#onTimerLap2-instance_function

**Relations**

- part_of: [SPEC-207](#spec-207)
- uses: [FUNC-9](#func-9), [SPEC-211](#spec-211)

<a id="app-34"></a>
## APP-34 — Reflow the grid to the assigned data-field bounds

Type: requirement | State: approved | Revision: 104

Fit complete header/required value-secondary glyphs using cached visible bounds. Numeric margins: 4 px horizontally per edge, 2 px from header bottom to value, including halos. Never truncate/clip, impose a character cap, alter precision or scale fixed fonts to fit. Native fields declare their own value-fitting policy.
If no complete eligible grid fits, centre full grid needs larger area in base palette, with no partial grid. Wrap at spaces in label font; if the complete message cannot fit, background only.
Normal ranges are inclusive after conversion/presentation rounding in displayed units, at full-screen bounds, either alignment/theme and maximum halo. All-device statements cover 530/540/830/840, 550/850, 1030/1040 and 1050/1060 groups. Tables are needed only for differing contexts. none means no guarantee, not sensor invalidity. Duration intervals use elapsed h:mm:ss; clock intervals use 24-hour notation independently of display format. Optional cardinal text may be omitted. Four-row/two-enlarged layouts have no regular cells. Outside guarantees retain measured overflow/fallback.

**Relations**

- allocated_to: [APP-3](#app-3), [APP-4](#app-4)
- part_of: [APP-1](#app-1)
- uses: [APP-20](#app-20), [APP-21](#app-21), [APP-24](#app-24), [APP-35](#app-35), [DVS-3](#dvs-3), [DVS-6](#dvs-6)

<a id="app-24"></a>
## APP-24 — Target Garmin Edge full-screen design profiles

Type: requirement | State: approved | Revision: 83

Use these full-screen design bounds, row capacities and three fixed font sizes:

| Model | Resolution | Screen Ratio | Rows | Enlarged Font Size | Regular Font Size | Label Font Size |
| --- | --- | --- | --- | --- | --- | --- |
| Edge 1060 | 480 x 800 | 1.66 | 5 | 200px | 95px | 35px |
| Edge 1050 | 480 x 800 | 1.66 | 5 | 200px | 95px | 35px |
| Edge 850 | 420 x 600 | 1.42 | 4 | 175px | 83px | 35px |
| Edge 550 | 420 x 600 | 1.42 | 4 | 175px | 83px | 35px |
| Edge 1040 | 282 x 470 | 1.66 | 5 | 116px | 55px | 21px |
| Edge 1030 | 282 x 470 | 1.66 | 5 | 116px | 55px | 21px |
| Edge 840 | 246 x 322 | 1.30 | 4 | 100px | 45px | 21px |
| Edge 830 | 246 x 322 | 1.30 | 4 | 100px | 45px | 21px |
| Edge 540 | 246 x 322 | 1.30 | 4 | 100px | 45px | 21px |
| Edge 530 | 246 x 322 | 1.30 | 4 | 100px | 45px | 21px |


The table defines font sizes without percentage scaling. Assigned drawing bounds determine whether a complete grid fits under [APP-34](#app-34).

At full-screen bounds, both numeric roles shall fit the complete primary text `00:00` and the timer group with primary `0:00` plus label-role `.00` secondary text and its two-pixel gap. Reserve the [APP-34](#app-34) four-pixel horizontal margins plus the largest applicable one-pixel halo; retain the header-height inset and vertical gap. Use these fixed sizes for all values in each role; this is a generation/verification constraint, not runtime font scaling. Other numeric values and complete headers retain their field-specific normal ranges under [APP-34](#app-34).

**Relations**

- part_of: [APP-1](#app-1)

<a id="spec-284"></a>
## SPEC-284 — Verify native power-zone mapping

Type: test | State: approved | Revision: 18

Suite: Core. Requirements: [DVS-42](#dvs-42), [SPEC-246](#spec-246).

For zones 1..5 assert the specified colors; zone 6 uses magenta #FF00FF and zones 7 and 10 use dark magenta #AA00AA while numeric zones remain unchanged. Cover every power metric, power-zone and Power-bound Team, both themes/inversion and Label/Whole cell; None suppresses fill. Unknown metadata and invalid/out-of-range readings use neutral fallback. Include production metadata loading, invalid-profile clearing and valid-profile recovery through approvedZoneSnapshot in tests/AcquisitionTests.mc.

Synthetic fixtures do not confirm the native device layout. Execution evidence is separate.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [DVS-42](#dvs-42), [SPEC-246](#spec-246), [SPEC-663](#spec-663)

<a id="tfnc-24"></a>
## TFNC-24 — Validated zone metadata and snapshot classification

Type: test | State: approved | Revision: 27

Suite: Core. Requirements: [DVS-42](#dvs-42), [DVS-45](#dvs-45), [SPEC-248](#spec-248).

Run approvedZoneSnapshot in tests/AcquisitionTests.mc, including verifyNativePowerZoneMetadata through production metadata() with only the native read substituted. Accept strictly increasing bounds starting at 0 W; reject null, nonzero first bounds and duplicate bounds. Check displayed-value rounding, upper-inclusive equality, zone 6/magenta and out-of-range unavailability. Reload invalid metadata after a valid profile: clear stale zones and colors while retaining valid watts; recover on the next valid reload. Compute must not reread native metadata; retained snapshots remain unchanged.

Synthetic inputs verify the adapter contract, not the device array layout. Record actual product, source, toolchain and named results under [SPEC-162](#spec-162); this definition records no execution.

Custom modes additionally verify [TSTFUNC-6](#tstfunc-6), [TSTFUNC-7](#tstfunc-7) and [TSTFUNC-8](#tstfunc-8); device-mode metadata qualification remains unchanged.

**Relations**

- verifies: [DVS-42](#dvs-42), [DVS-45](#dvs-45), [SPEC-248](#spec-248), [SPEC-661](#spec-661), [SPEC-662](#spec-662), [SPEC-663](#spec-663), [SPEC-664](#spec-664)

<a id="dvs-42"></a>
## DVS-42 — Handle unsupported training-zone data honestly

Type: requirement | State: approved | Revision: 60

Device-selected profiles only; custom HR/power profiles are owned by [SPEC-661](#spec-661) and [SPEC-662](#spec-662).

Retrieve cycling personal thresholds with UserProfile permission/capability checks, never inferred FTP/defaults. Normalize qualified metadata to finite nonnegative strictly increasing b[0..n]: b0 zone-1 minimum; b1..bn successive maxima. HR requires five zones/six min-max values. Power (getPowerZones, API 5.2.2+) uses the same layout and qualifies only when b0=0 W; any other first bound is an unrecognized layout. Null, older-API, ambiguous or unsupported metadata is unavailable. Physical-device confirmation of the power layout remains separate.
Classify displayed whole-unit v: zone 1 b0<=v<=b1; zone i>1 b[i-1]<v<=b[i]. Outside b0..bn has no zone; upper equality belongs to the lower zone. Numeric zones/backgrounds share this classifier; invalid metadata does not invalidate an otherwise valid metric.

**Relations**

- allocated_to: [APP-3](#app-3)
- part_of: [DVS-1](#dvs-1)
- uses: [APP-42](#app-42), [APP-43](#app-43), [DVS-7](#dvs-7)

<a id="app-20"></a>
## APP-20 — Configure the two-column Garmin field grid

Type: requirement | State: approved | Revision: 95

Options: [SPEC-302](#spec-302), [SPEC-340](#spec-340). Two columns; regular is one column/row, enlarged spans both columns/two rows. Stack enlarged cells first in slot order; fill remaining left-to-right/top-to-bottom. Only complete combinations:

| Row capacity | Enlarged | Regular | Total |
| --- | --- | --- | --- |
| 4 | 0 | 8 | 8 |
| 4 | 1 | 4 | 5 |
| 4 | 2 | 0 | 2 |
| 5 | 0 | 10 | 10 |
| 5 | 1 | 6 | 7 |
| 5 | 2 | 2 | 4 |
No independent count selector or partial grid.

**Relations**

- allocated_to: [APP-3](#app-3), [APP-4](#app-4)
- part_of: [APP-1](#app-1)

**Attachments**

- [center-ui-2.png](attachments/center-ui-2.png) — illustrates
- [center-ui-4.png](attachments/center-ui-4.png) — illustrates
- [center-ui-10.png](attachments/center-ui-10.png) — illustrates
- [center-ui-5.png](attachments/center-ui-5.png) — illustrates
- [center-ui-7.png](attachments/center-ui-7.png) — illustrates
- [center-ui-8.png](attachments/center-ui-8.png) — illustrates
- [right-ui-2.png](attachments/right-ui-2.png) — illustrates
- [right-ui-4.png](attachments/right-ui-4.png) — illustrates
- [right-ui-10.png](attachments/right-ui-10.png) — illustrates
- [right-ui-5.png](attachments/right-ui-5.png) — illustrates
- [right-ui-7.png](attachments/right-ui-7.png) — illustrates
- [right-ui-8.png](attachments/right-ui-8.png) — illustrates

<a id="tprf-6"></a>
## TPRF-6 — Optional battery clock and diagnostic work

Type: test | State: approved | Revision: 11

Purpose: Optional queries and temperature-cache freshness.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [APP-26](#app-26), [APP-37](#app-37), [DVS-35](#dvs-35), [DVS-34](#dvs-34).

Procedure and expected results: Require battery/clock selection flags to include hidden assignments, no battery reading on the disabled adapter path, and disabled production RuntimeMetrics counters through real activity callbacks. Core does not collect runtime memory samples.

Executable source: `tests/PerformanceTests.mc`; named test `optionalRuntimeQueries`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

Regression: Through real StrukturField activity processing and app temperature-cache dispatch, keep temperature absent from the active bank. Require a nonempty cache age check each sample, expiry after 360 seconds and clock-rollback rejection while unassigned; switching to a temperature bank must not revive the invalid reading. A valid zero remains valid. Empty caches perform no age/clock queries. Restore the test app cache after the fixture; do not modify production settings.

**Relations**

- verifies: [APP-26](#app-26), [APP-37](#app-37), [DVS-34](#dvs-34), [DVS-35](#dvs-35)

<a id="tprf-4"></a>
## TPRF-4 — Bounded snapshot caches and live-input invalidation

Type: test | State: approved | Revision: 17

Purpose: Bounded snapshot caches and live-input invalidation.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [APP-26](#app-26), [DVS-4](#dvs-4), [DVS-50](#dvs-50), [DVS-32](#dvs-32).

Procedure and expected results: Require ten bounded assignment caches, no descriptor/header/format rebuild for unchanged input, selective changed-reading/unit/header/clock invalidation and unchanged previously published value text. Unknown assignments and unavailable clock state remain safe.

Executable source: `tests/PerformanceTests.mc`; named test `snapshotCacheInvalidation`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

Regression: In snapshotCacheInvalidation, retain a published metric snapshot containing duplicate speed slots. Reassign only one slot, change the reading and distance units, and verify independent new distance/speed values while both old published speed values remain unchanged. Cycle the first assignment through all catalogue fields twice and require the retained descriptor count to remain ten. Keep the existing selective formatting/header/clock invalidation checks. This Core regression performs no runtime-memory sampling; native allocation acceptance remains [TPRF-9](#tprf-9).

Regression: Through SnapshotEngine.prepare, change distance, elevation and temperature units, 12/24-hour format and automatic night preference across consecutive samples without lifecycle callbacks. Require a preference read each time, independent unit conversion and matching headers on that snapshot, current clock/theme mode and unchanged retained snapshots.

Custom profile identity/invalidation and unchanged activity state are additionally verified by [TSTFUNC-11](#tstfunc-11).

**Relations**

- verifies: [APP-26](#app-26), [DVS-32](#dvs-32), [DVS-4](#dvs-4), [DVS-50](#dvs-50), [SPEC-667](#spec-667)

<a id="dvs-34"></a>
## DVS-34 — Temperature

Type: requirement | State: approved | Revision: 172

| Attribute | Value |
| --- | --- |
| CODE | 20 |
| UNIT | °c (Celsius) or °f (Fahrenheit) |
| LABEL | temperature |
| PRECISION | 1 |
| IDENTIFIER | temperature |
| LABEL_AND_UNIT | `temp \| {unit}` |

Source: native Sensor.getInfo().temperature (Celsius), only in background ServiceDelegate.onTemporalEvent with Background/Sensor permissions. No foreground sensor reads/enabling or weather/phone/history substitutes. Device temperature is not guaranteed ambient air temperature.
Source guard: enumerate registered SENSOR_TEMPERATURE sensors before/after reading. Accept empty iterator or numeric matching type and SENSOR_TECHNOLOGY_ONBOARD. Reject null/unavailable/malformed metadata, exceptions, wrong/unknown type/technology, ANT/BLE registrations or >32 entries. Remote registration blocks even if disconnected/disabled. Finite zero is valid.
Delivery: earliest legal event, >=300 s between events including restarts; read once, Background.exit [2, nullable Celsius, UTC read time, "edge-native-v2"]. Accept only the owned worker; update a valid cache and request redraw on accepted data. Reject old protocol/path, future, duplicate, older/out-of-order or incompatible packets without replacing newer data or refreshing age. A newer owned invalid/source-rejected read clears cache.
Freshness: usable through read age 360 s inclusive, including delivery delay; expire thereafter. Missing delivery retains only original expiry. Invalidate on wall-clock rollback; a monotonic receipt-age guard prevents extension. Validate startup/queued packets; never restore unvalidated readings. Pause/settings/units/visibility do not refresh age. Physical qualification is separate; an empty evidence registry must not globally disable runtime-guarded acquisition.
Color source: unrounded Celsius before conversion/rounding, without hysteresis. Bands: <=-10 blue; (-10,0] cyan; (0,10] white; (10,20] green; (20,30] yellow; >30 red. Rejected/expired input uses selected neutral coverage.

Normal display ranges: °c: -40–60; °f: -40–140. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-2](#dvs-2), [DVS-4](#dvs-4), [DVS-40](#dvs-40), [DVS-45](#dvs-45), [DVS-50](#dvs-50)

<a id="spec-300"></a>
## SPEC-300 — Application properties

Type: document | State: approved | Revision: 102

Current compact settings schema: 75 properties, no compatibility aliases or migration. Property requirements own keys, types, ranges and defaults; shared behavior is linked. a = default set; b = second set. Field definitions remain only in [DVS-1](#dvs-1). Key/storage policy: [SPEC-243](#spec-243), [SPEC-244](#spec-244), [SPEC-245](#spec-245).

<a id="spec-233"></a>
## SPEC-233 — Shared Coloring and Settings Migration

Type: document | State: approved | Revision: 110

Coverage, training-zone colors, cadence thresholds and settings compatibility. Field-specific options belong to catalogue entries.

<a id="spec-207"></a>
## SPEC-207 — Triggered Field Sets

Type: document | State: approved | Revision: 60

Two saved configurations and the activation/return state machine, reusing field definitions and shared presentation options.

<a id="spec-175"></a>
## SPEC-175 — Bundled Glyph Inventory

Type: document | State: approved | Revision: 21

Exact reachable bundled glyph inventories and deterministic validation; native text qualification is separate.

<a id="spec-150"></a>
## SPEC-150 — Development and Verification

Type: document | State: approved | Revision: 53

Reproducible toolchain, generated inputs, build/test commands and qualification/evidence gates; no duplicate field definitions.

<a id="dvs-1"></a>
## DVS-1 — Selectable Fields and Shared Display Rules

Type: document | State: approved | Revision: 150

Single authoritative catalogue of selectable fields. Each field owns source/validity, labels/units, precision, normal ranges and specific options. Shared rules apply through explicit relations.
Field identity/presentation metadata is stored in CODE, IDENTIFIER, LABEL, UNIT, LABEL_AND_UNIT and numeric PRECISION attributes. Conditional/non-decimal precision uses PRECISION_RULE instead of PRECISION. Empty UNIT means no physical unit; empty LABEL_AND_UNIT uses the shared header fallback. Descriptions retain acquisition, validity, normal ranges and field-specific rendering behavior.

**Relations**

- allocated_to: [APP-3](#app-3), [APP-4](#app-4)

<a id="app-1"></a>
## APP-1 — Application Design

Type: document | State: approved | Revision: 87

Shared layout/options, lifecycle and resource budgets. Field behavior belongs to the single field catalogue.

**Relations**

- allocated_to: [APP-2](#app-2), [APP-3](#app-3), [APP-4](#app-4)

<a id="spec-324"></a>
## SPEC-324 — Slot 7: background (a7_bg)

Type: requirement | State: approved | Revision: 39

Key: `a7_bg`. Caption: Slot 7: background. Type/values: Integer 0, 1, 2. Default: `0`.

Default set, slot 7.

Behavior: [APP-49](#app-49). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-323"></a>
## SPEC-323 — Slot 7: value (a7)

Type: requirement | State: approved | Revision: 38

Key: `a7`. Caption: Slot 7: value. Type/values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32. Default: `12`.

Default set, slot 7.

Behavior: [APP-30](#app-30). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-322"></a>
## SPEC-322 — Slot 6: background (a6_bg)

Type: requirement | State: approved | Revision: 39

Key: `a6_bg`. Caption: Slot 6: background. Type/values: Integer 0, 1, 2. Default: `0`.

Default set, slot 6.

Behavior: [APP-49](#app-49). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-321"></a>
## SPEC-321 — Slot 6: value (a6)

Type: requirement | State: approved | Revision: 38

Key: `a6`. Caption: Slot 6: value. Type/values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32. Default: `8`.

Default set, slot 6.

Behavior: [APP-30](#app-30). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-320"></a>
## SPEC-320 — Slot 5: background (a5_bg)

Type: requirement | State: approved | Revision: 39

Key: `a5_bg`. Caption: Slot 5: background. Type/values: Integer 0, 1, 2. Default: `0`.

Default set, slot 5.

Behavior: [APP-49](#app-49). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-319"></a>
## SPEC-319 — Slot 5: value (a5)

Type: requirement | State: approved | Revision: 38

Key: `a5`. Caption: Slot 5: value. Type/values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32. Default: `4`.

Default set, slot 5.

Behavior: [APP-30](#app-30). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-318"></a>
## SPEC-318 — Slot 4: background (a4_bg)

Type: requirement | State: approved | Revision: 39

Key: `a4_bg`. Caption: Slot 4: background. Type/values: Integer 0, 1, 2. Default: `0`.

Default set, slot 4.

Behavior: [APP-49](#app-49). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-317"></a>
## SPEC-317 — Slot 4: value (a4)

Type: requirement | State: approved | Revision: 38

Key: `a4`. Caption: Slot 4: value. Type/values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32. Default: `18`.

Default set, slot 4.

Behavior: [APP-30](#app-30). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-316"></a>
## SPEC-316 — Slot 3: background (a3_bg)

Type: requirement | State: approved | Revision: 39

Key: `a3_bg`. Caption: Slot 3: background. Type/values: Integer 0, 1, 2. Default: `0`.

Default set, slot 3.

Behavior: [APP-49](#app-49). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-315"></a>
## SPEC-315 — Slot 3: value (a3)

Type: requirement | State: approved | Revision: 38

Key: `a3`. Caption: Slot 3: value. Type/values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32. Default: `16`.

Default set, slot 3.

Behavior: [APP-30](#app-30). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-314"></a>
## SPEC-314 — Slot 2: background (a2_bg)

Type: requirement | State: approved | Revision: 39

Key: `a2_bg`. Caption: Slot 2: background. Type/values: Integer 0, 1, 2. Default: `0`.

Default set, slot 2.

Behavior: [APP-49](#app-49). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-313"></a>
## SPEC-313 — Slot 2: value (a2)

Type: requirement | State: approved | Revision: 38

Key: `a2`. Caption: Slot 2: value. Type/values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32. Default: `11`.

Default set, slot 2.

Behavior: [APP-30](#app-30). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-312"></a>
## SPEC-312 — Slot 1: background (a1_bg)

Type: requirement | State: approved | Revision: 39

Key: `a1_bg`. Caption: Slot 1: background. Type/values: Integer 0, 1, 2. Default: `0`.

Default set, slot 1.

Behavior: [APP-49](#app-49). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-311"></a>
## SPEC-311 — Slot 1: value (a1)

Type: requirement | State: approved | Revision: 38

Key: `a1`. Caption: Slot 1: value. Type/values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32. Default: `0`.

Default set, slot 1.

Behavior: [APP-30](#app-30). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-310"></a>
## SPEC-310 — Team color source (tsrc)

Type: requirement | State: approved | Revision: 11

Key: `tsrc`. Caption: Team color source. Type/values: Integer 0, 1, 2. Default: `0`.

One shared Team color source: 0 None, 1 current Power, 2 current Heart rate. HR/Power use their selected global zone profiles under [SPEC-664](#spec-664) and [SPEC-663](#spec-663). Source selection does not enable slot coverage. Invalid or missing input uses 0 without rewriting storage.

Fields: [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [SPEC-253](#spec-253), [SPEC-663](#spec-663), [SPEC-664](#spec-664)

<a id="spec-308"></a>
## SPEC-308 — Team name (team)

Type: requirement | State: approved | Revision: 5

Key: `team`. Caption: Team name. Type/values: String. Default: `"TEAM"`.

One shared Team name for every Team slot in both sets. Accept 0..32 printable ASCII characters; preserve spaces and case, including empty text. Invalid or missing input uses "TEAM" without rewriting storage.

Fields: [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [SPEC-253](#spec-253)

<a id="spec-253"></a>
## SPEC-253 — Team

Type: requirement | State: approved | Revision: 59

| Attribute | Value |
| --- | --- |
| CODE | 32 |
| UNIT | "" |
| LABEL | team |
| IDENTIFIER | team |
| LABEL_AND_UNIT | "" |
| PRECISION_RULE | not applicable |

Value: user text below the normal header; preserve case/within-line spaces. Empty leaves the header visible; unit visibility has no effect.

Shared options: [SPEC-308](#spec-308), [SPEC-310](#spec-310). Exactly one set precedes every slot control and applies to all Team slots in both banks. Edits refresh every visible Team value without changing assignments.

Fit below the shared header, reserving px=ceil(0.05*cell_width), py=ceil(0.05*cell_height) on each value-area edge plus one-pixel halo clearance in every mode. Greedily wrap at ASCII spaces without splitting words; consume break separators. Native font-height line spacing; vertically centre the block and apply selected alignment per line.

Font fitting is automatic; no font selector or saved font code is exposed. Candidates: FONT_XTINY/TINY/SMALL/MEDIUM/LARGE; largest complete-block fit by measured height, tie lowest constant. No extra atlas or scaling. Unfit nonempty text shows !, then blank if ! cannot fit, without truncation/replacement glyphs.

Color binding reuses the globally selected power/HR profile under [SPEC-663](#spec-663) / [SPEC-664](#spec-664) and classifies current watts/HR even with its numeric field hidden. Missing/unqualified/None source uses selected neutral coverage without hiding text; ordinary shared coverage regions apply. Shared text/binding survive hidden, duplicate and reassigned slots. Retired slot_N_team_font and slot_N_team_color_source values, including second_ copies, never override the shared selections.

Native text widths are measured only during layout using the current callback Dc, which is released before return. After a setting or bank change, defer any needed Team fitting to the next layout before drawing; no measurement through a saved Dc in settings/compute/lap callbacks.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-42](#dvs-42), [SPEC-246](#spec-246), [SPEC-663](#spec-663), [SPEC-664](#spec-664), [SPEC-665](#spec-665)

<a id="spec-249"></a>
## SPEC-249 — Fall back without discarding a valid metric

Type: requirement | State: approved | Revision: 21

Known fields with enabled coverage use valid declared semantic colors, otherwise #CCCCCC in effective Day or #333333 in Night, including inversion. Invalid/expired/unsupported/unqualified sources preserve independently valid values. Recover semantic coloring on the next valid snapshot. None and unknown fields keep ordinary backgrounds.

**Relations**

- part_of: [SPEC-233](#spec-233)
- uses: [APP-45](#app-45), [DVS-51](#dvs-51)

<a id="spec-243"></a>
## SPEC-243 — Use compact property keys

Type: requirement | State: approved | Revision: 30

Persist only the keys defined in [SPEC-300](#spec-300). Keys are unique lowercase ASCII letters/digits/underscores, begin with a letter and contain at most eight characters. a denotes the default set; b denotes the second set. Captions remain readable and use Slot N. No legacy key aliases are required.

**Relations**

- part_of: [SPEC-233](#spec-233)
- uses: [APP-49](#app-49), [SPEC-155](#spec-155), [SPEC-244](#spec-244)

<a id="spec-214"></a>
## SPEC-214 — Evaluate the power event from the shared three-second average

Type: requirement | State: approved | Revision: 14

For 3s power mode, compare the unrounded watts from the same shared three-second power producer used by [DVS-22](#dvs-22) against the power pair in [SPEC-212](#spec-212). Preserve its existing window, zero, gap, active-timer and reset rules. Do not compare instantaneous power, a displayed rounded string, a colored zone or a separate trigger-specific moving average. Evaluate the producer even when neither visible set contains a power field; displaying duplicate power fields shall not add samples. Finite nonnegative producer values, including measured zero, are eligible. The partial-window means defined by [DVS-22](#dvs-22) are eligible from the first valid sample and can activate immediately. Before the first valid sample, or for an invalid producer result, follow [SPEC-216](#spec-216).

**Relations**

- part_of: [SPEC-207](#spec-207)
- uses: [DVS-22](#dvs-22), [SPEC-213](#spec-213)

<a id="spec-210"></a>
## SPEC-210 — Keep all dashboard controls on one savable settings page

Type: requirement | State: draft | Revision: 29

Render every application setting directly on the main Garmin settings page as a child of the SDK settings element. Do not emit SDK group elements or secondary settings pages, including for Second field set or Training zones; grouped clients can lose edits or the Save action. Garmin's main settings page owns Save; do not add a dummy editable divider or save property.

Retain the existing property keys, types, choice codes, defaults and catalogue order: first-set general controls, the two shared Team controls, first-set slot controls, shared training zones under [SPEC-669](#spec-669), then second-set activation, thresholds, presentation and slots. Activation order is Second field set - activation event; Power: activate at (W); Power: return below (W); Heart rate: activate at (bpm); Heart rate: return below (bpm). Put the section explanation in the activation prompt: the selected event alone controls the second set and None keeps the first set.

Prefix second-set presentation/slot captions Second set:. Per-slot order remains Slot N: value then Slot N: background; never Field N. Do not duplicate shared Team or zone properties. Keep inactive controls editable and saved; only the selected trigger's thresholds act. Saved selections must survive main-page Save, reopening settings and app restart under [APP-32](#app-32). Conditional hiding is not required.

**Relations**

- part_of: [SPEC-207](#spec-207)
- uses: [SPEC-208](#spec-208), [SPEC-211](#spec-211), [SPEC-212](#spec-212), [SPEC-252](#spec-252), [SPEC-253](#spec-253)

<a id="spec-208"></a>
## SPEC-208 — Configure two independent field sets

Type: requirement | State: approved | Revision: 26

Retain independent default/second saved banks with ten ordered slots each, the same field/layout options, and independent slot background coverage. Team text/color source are shared across both banks under [SPEC-253](#spec-253). Keep hidden/duplicate assignments. Display exactly one complete bank; the second replaces the first. Device units/clock/acquisition are shared.

**Relations**

- part_of: [SPEC-207](#spec-207)
- uses: [APP-20](#app-20), [APP-30](#app-30)

<a id="func-8"></a>
## FUNC-8 — Lap cadence

Type: requirement | State: approved | Revision: 48

| Attribute | Value |
| --- | --- |
| CODE | 31 |
| UNIT | rpm |
| LABEL | lap cadence |
| PRECISION | 0 |
| IDENTIFIER | lap_cadence |
| LABEL_AND_UNIT | `lap cad \| rpm` |

Source: Observed-lap time-weighted mean of currentCadence; finite values >=0 including coasting zero contribute independently of native zero-averaging preference. No covered active time is unavailable; never substitute activity averages.

Color source: cadence.

Normal display ranges: 0–250. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [FUNC-10](#func-10), [FUNC-9](#func-9), [SPEC-247](#spec-247), [SPEC-248](#spec-248)

<a id="func-7"></a>
## FUNC-7 — Lap power

Type: requirement | State: approved | Revision: 57

| Attribute | Value |
| --- | --- |
| CODE | 30 |
| UNIT | w |
| LABEL | lap watts |
| PRECISION | 0 |
| IDENTIFIER | lap_power |
| LABEL_AND_UNIT | `lap watts` |

Source: Observed-lap time-weighted mean of currentPower; finite values >=0 including measured zeros contribute. Missing intervals add neither time nor fabricated zero; no covered active time is unavailable.

Color source: power.

Normal display ranges: 0–3000. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-42](#dvs-42), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [FUNC-10](#func-10), [FUNC-9](#func-9), [SPEC-248](#spec-248), [SPEC-663](#spec-663), [SPEC-665](#spec-665)

<a id="func-6"></a>
## FUNC-6 — Lap heart rate

Type: requirement | State: approved | Revision: 58

| Attribute | Value |
| --- | --- |
| CODE | 29 |
| UNIT | bpm |
| LABEL | lap heart rate |
| PRECISION | 0 |
| IDENTIFIER | lap_heart_rate |
| LABEL_AND_UNIT | `lap hr \| bpm` |

Source: Observed-lap time-weighted mean of currentHeartRate; finite values >0 contribute. No covered active time is unavailable. Retain raw accumulation; never substitute activity averages.

Color source: heart rate.

Normal display ranges: 30–250. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-42](#dvs-42), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [FUNC-10](#func-10), [FUNC-9](#func-9), [SPEC-248](#spec-248), [SPEC-664](#spec-664), [SPEC-665](#spec-665)

<a id="func-5"></a>
## FUNC-5 — Lap speed

Type: requirement | State: approved | Revision: 54

| Attribute | Value |
| --- | --- |
| CODE | 28 |
| UNIT | km/h (metric), mph (statute) |
| LABEL | lap speed |
| IDENTIFIER | lap_speed |
| LABEL_AND_UNIT | `lap \| {unit}` |
| PRECISION_RULE | magnitude-based |

Source: D_lap_metres / (T_lap_ms/1000). Require valid known lap distance/active-time baselines and T_lap>0; zero distance yields zero speed. Never substitute current, activity-average, moving-time or sample-mean speed.

Color source: none.

Normal display ranges: 0–200. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-2](#dvs-2), [DVS-4](#dvs-4), [DVS-40](#dvs-40), [DVS-50](#dvs-50), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-9](#func-9)

<a id="func-4"></a>
## FUNC-4 — Lap time

Type: requirement | State: approved | Revision: 42

| Attribute | Value |
| --- | --- |
| CODE | 27 |
| UNIT | "" |
| LABEL | lap time |
| IDENTIFIER | lap_time |
| LABEL_AND_UNIT | "" |
| PRECISION_RULE | 1 second below 10 h; 1 minute from 10 h |

Source: T_lap = timerTime - known lap-start active timer baseline, in milliseconds. Require valid nonnegative counters and a known baseline; pause adds no active time. Missing/regressing counters are unavailable.

Color source: none.

Normal display ranges: 0:00:00–99:59:59 elapsed h:mm:ss. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-13](#dvs-13), [DVS-40](#dvs-40), [FUNC-9](#func-9)

<a id="func-3"></a>
## FUNC-3 — Lap distance

Type: requirement | State: approved | Revision: 53

| Attribute | Value |
| --- | --- |
| CODE | 26 |
| UNIT | km (metric), mi (statute) |
| LABEL | lap distance |
| IDENTIFIER | lap_distance |
| LABEL_AND_UNIT | `lap dist \| {unit}` |
| PRECISION_RULE | magnitude-based |

Source: D_lap = elapsedDistance - known lap-start distance, in metres. Require finite nonnegative totals and a known baseline; zero is valid at a known new lap. Counter regression invalidates distance/speed until a proven boundary. Use host-recorded distance, including any host-recorded stopped movement; never whole-activity distance.

Color source: none.

Normal display ranges: 0–1000. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-2](#dvs-2), [DVS-4](#dvs-4), [DVS-40](#dvs-40), [DVS-50](#dvs-50), [FUNC-9](#func-9)

<a id="dvs-50"></a>
## DVS-50 — Show or hide physical units in field headers

Type: requirement | State: approved | Revision: 66

Options: [SPEC-305](#spec-305), [SPEC-343](#spec-343). True or empty UNIT -> LABEL alone. Otherwise use nonempty LABEL_AND_UNIT, or `LABEL + " | " + UNIT` when absent. Overrides are literal lowercase text with at most one optional `{unit}` substitution; never append redundant units. Preserve spaces around ` | ` and slashes inside units. Unavailable known readings keep the same header; unknown fields have no guessed unit. Physical units never appear beside values. Nonphysical indicators retain their field rules.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [DVS-4](#dvs-4)

<a id="spec-160"></a>
## SPEC-160 — Gate changes on repeatable compilation and explicit test evidence

Type: requirement | State: approved | Revision: 13

CI provisions pinned prerequisites, checks generated/project/settings consistency and compiles every candidate. Run Core on a validated GUI-capable simulator runner; Memory/Placement require explicit request. No display-free assumption, host-language substitution or silently omitted stage.
Missing prerequisites, timeout, zero tests, required skips and compiler/test failures cannot pass required gates. Bind logs/results/artifacts to source/toolchain/device/fixture hashes; invalidate stale caches. Define required checks/warning dispositions before baseline acceptance. Named physical/visual gates are independent; CI never publishes or alters support automatically.

**Relations**

- part_of: [SPEC-150](#spec-150)
- uses: [SPEC-151](#spec-151), [SPEC-153](#spec-153), [SPEC-157](#spec-157), [SPEC-162](#spec-162)

<a id="spec-155"></a>
## SPEC-155 — Publish one typed settings catalogue shared by XML, runtime and tests

Type: requirement | State: approved | Revision: 127

Generate one current catalogue shared by settings XML, runtime and tests from [SPEC-300](#spec-300). Field owners retain codes 0..32, identifiers, labels, units and precision as typed item attributes in [DVS-1](#dvs-1). Each property owner defines its key, type, allowed values, default and applicable field links; those option contracts override generic shared behavior. XML defaults and runtime fallbacks must agree. Counts are generated; settings captions/dividers are not extra properties.
Corresponding a/b properties have identical types/ranges and their own defaults. Team, HR/power/cadence training zones and activation properties are global. Missing second-set values never copy current first-set choices. Validate without rewriting saved values under [APP-31](#app-31).

**Relations**

- part_of: [SPEC-150](#spec-150)
- uses: [APP-20](#app-20), [APP-21](#app-21), [APP-22](#app-22), [APP-30](#app-30), [APP-31](#app-31), [APP-45](#app-45), [APP-49](#app-49), [DVS-50](#dvs-50), [DVS-51](#dvs-51), [SPEC-208](#spec-208), [SPEC-211](#spec-211), [SPEC-212](#spec-212), [SPEC-244](#spec-244), [SPEC-252](#spec-252), [SPEC-253](#spec-253)

<a id="app-49"></a>
## APP-49 — Select background coverage independently per field slot

Type: requirement | State: approved | Revision: 138

Coverage is selected independently for each saved slot; property contracts are in [SPEC-300](#spec-300), with validation under [APP-31](#app-31). Retain valid choices through hiding/reassignment; binding a color source does not enable coverage.
0 None adds no effect fill. 1 Label fills the full-width common padded header band under [DVS-12](#dvs-12). 2 Whole cell fills the clipped cell. Apply equally to regular/enlarged cells; declared field-specific geometry, including slope, overrides the generic fill.
Coverage preserves geometry/alignment/acquisition; only changed halo clearance may refit affected text. Use effective ordinary backgrounds and [DVS-6](#dvs-6) contrast. Unknown/missing semantic readings follow [SPEC-249](#spec-249).

**Relations**

- part_of: [APP-1](#app-1)
- uses: [APP-31](#app-31), [APP-36](#app-36), [DVS-12](#dvs-12), [DVS-6](#dvs-6), [SPEC-155](#spec-155), [SPEC-244](#spec-244), [SPEC-249](#spec-249)

<a id="dvs-47"></a>
## DVS-47 — Display three-second average heart rate

Type: requirement | State: approved | Revision: 95

| Attribute | Value |
| --- | --- |
| CODE | 25 |
| UNIT | bpm |
| LABEL | 3s heart rate |
| PRECISION | 0 |
| IDENTIFIER | heart_rate_3s |
| LABEL_AND_UNIT | `3s hr \| {unit}` |

Source: Shared three-second arithmetic mean of currentHeartRate (bpm), finite samples >0; incomplete window is unavailable.

Color source: heart rate.

Normal display ranges: 30–250. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- allocated_to: [APP-3](#app-3)
- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-41](#dvs-41), [DVS-42](#dvs-42), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [SPEC-248](#spec-248), [SPEC-664](#spec-664), [SPEC-665](#spec-665)

<a id="dvs-41"></a>
## DVS-41 — Compute shared three-second windows

Type: requirement | State: approved | Revision: 52

Keep a three-sample rolling window per declared source, keyed by floor(elapsedTime/1000), independent of slots/drawing. Field defines valid samples and minimum startup sample count (default three). Once that count is reached, publish the unrounded mean of the valid samples currently retained. Duplicate second adds no sample. Invalid input, skipped/decreasing second, pause/stop/resume/reset or changed identity clears it; a valid gap sample seeds anew. Process each delivered compute once.

**Relations**

- allocated_to: [APP-3](#app-3)
- part_of: [DVS-1](#dvs-1)

<a id="app-36"></a>
## APP-36 — Keep text readable when effects and themes change

Type: requirement | State: approved | Revision: 83

Ordinary Day: black on white; Night: white on black. Over fills: black on white/yellow/cyan/green/magenta/light gray; white on blue/orange/red/dark red/black/dark gray. Apply fill contrast only to overlaid text: header in Label, all text in Whole cell. Slope horizon retains the ordinary effective foreground across sky/ground.

**Relations**

- allocated_to: [APP-4](#app-4)
- part_of: [APP-1](#app-1)
- uses: [APP-45](#app-45), [DVS-45](#dvs-45), [DVS-51](#dvs-51)

<a id="app-33"></a>
## APP-33 — Publish complete display snapshots before drawing

Type: requirement | State: approved | Revision: 47

Initialize a complete unavailable-safe snapshot before asynchronous drawing; retain headers and valid settings-sourced values before the first sample. Compute publishes complete replacements; drawing consumes the latest without assuming callback order.
On field-set switches, prepare assignments/layout/labels/values/alignment/units/theme/effects/grid atomically before redraw. Never mix banks or expose a partial layout. Switching requires no page change, timer action or activity restart.

**Relations**

- allocated_to: [APP-3](#app-3), [APP-4](#app-4)
- part_of: [APP-1](#app-1)
- uses: [APP-26](#app-26), [APP-34](#app-34), [APP-35](#app-35), [SPEC-208](#spec-208)

<a id="app-31"></a>
## APP-31 — Validate saved settings and use safe display defaults

Type: requirement | State: approved | Revision: 115

Validate each property independently using its owning type/range/bank default; specific option contracts override generic fallbacks. Missing/malformed input uses only its read fallback without rewriting data. Retain valid zero/false/None and hidden/duplicate/reassigned/inactive options. A valid unknown field code/identifier shows unavailable with header field; malformed selection uses its slot default. Invalid configuration must not block startup.

**Relations**

- allocated_to: [APP-2](#app-2)
- part_of: [APP-1](#app-1)

<a id="app-30"></a>
## APP-30 — Configure visible count and value of each grid field

Type: requirement | State: approved | Revision: 49

Slot selection options are owned in [SPEC-300](#spec-300). Draw the first capacity slots; retain all ten assignments/order through restart, hiding and smaller layouts. Duplicate selections are allowed; restored capacity reveals the saved slots. Selection validation follows [APP-31](#app-31).

**Relations**

- allocated_to: [APP-3](#app-3)
- part_of: [APP-1](#app-1)
- uses: [APP-20](#app-20), [APP-31](#app-31)

<a id="dvs-39"></a>
## DVS-39 — Completed laps

Type: requirement | State: approved | Revision: 130

| Attribute | Value |
| --- | --- |
| CODE | 24 |
| UNIT | "" |
| LABEL | laps |
| PRECISION | 0 |
| IDENTIFIER | completed_laps |
| LABEL_AND_UNIT | "" |

Source: exact app-observed completed-lap count, excluding the unfinished lap; no invented native total or inferred missing history.
States: UNKNOWN, FRESH_READY, TRACKING. A reset or complete pre-activity snapshot arms FRESH_READY; start TRACKING at zero only after the shared fresh-session proof in [FUNC-9](#func-9). Bind available startTime.value().
TRACKING increments once per confirmed callback after lap-record writing, never for updates/pause/stop/button events. Pause/stop/resume retain count; reset ends old activity and arms FRESH_READY, ignoring old finalization events. Changed identity, counter regression without reset, lost continuity or overflow invalidates the total. Late-load UNKNOWN remains unknown for that activity, including later laps; recover only on a proven fresh session. Never restore unproven totals. Settings/page visibility do not reset a continuously observed counter.
Shared lap-boundary delivery follows [FUNC-9](#func-9); trigger metadata is not a unique history ID.

Color source: none.

Normal display ranges: 0–999. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-7](#dvs-7), [FUNC-9](#func-9)

<a id="dvs-37"></a>
## DVS-37 — Distance to next waypoint

Type: requirement | State: approved | Revision: 53

| Attribute | Value |
| --- | --- |
| CODE | 23 |
| UNIT | km (metric) or mi (imperial) |
| LABEL | next waypoint |
| IDENTIFIER | distance_next_waypoint |
| LABEL_AND_UNIT | `next \| {unit}` |
| PRECISION_RULE | magnitude-based |

Source: Activity.Info.distanceToNextPoint (m); Finite numeric, zero valid.

Color source: none.

Normal display ranges: 0–1000. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-2](#dvs-2), [DVS-4](#dvs-4), [DVS-40](#dvs-40), [DVS-50](#dvs-50)

<a id="dvs-36"></a>
## DVS-36 — Heading

Type: requirement | State: approved | Revision: 93

| Attribute | Value |
| --- | --- |
| CODE | 22 |
| UNIT | ° |
| LABEL | heading |
| PRECISION | 0 |
| IDENTIFIER | heading |
| LABEL_AND_UNIT | `heading \| {unit}` |

Source: true-north device heading Activity.Info.currentHeading (radians), not GPS course. Convert to degrees, normalize [0,360), round to whole degrees and map rounded 360 to 0.
Optional secondary: N/NE/E/SE/S/SW/W/NW from floor((degrees+22.5)/45) modulo 8. Omit only if the complete group cannot fit; retain degrees. Cardinal direction is value information, not a removable physical unit.

Color source: none.

Normal display ranges: 0–359. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-3](#dvs-3), [DVS-40](#dvs-40), [DVS-50](#dvs-50), [DVS-7](#dvs-7)

<a id="dvs-35"></a>
## DVS-35 — Device battery level

Type: requirement | State: approved | Revision: 57

| Attribute | Value |
| --- | --- |
| CODE | 21 |
| UNIT | % |
| LABEL | battery |
| PRECISION | 0 |
| IDENTIFIER | battery |
| LABEL_AND_UNIT | `battery \| {unit}` |

Source: System.getSystemStats().battery; finite 0..100 inclusive only, without clamping invalid values. Read once per delivered compute only if any active-bank retained slot needs battery, including hidden slots. Otherwise make no battery-only stats query. Reassignment/bank activation gets a fresh reading before its next frame.

Color source: none.

Normal display ranges: 0–100. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- allocated_to: [APP-4](#app-4)
- part_of: [DVS-1](#dvs-1)
- uses: [APP-17](#app-17), [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-50](#dvs-50), [DVS-7](#dvs-7)

<a id="dvs-33"></a>
## DVS-33 — Calories

Type: requirement | State: approved | Revision: 52

| Attribute | Value |
| --- | --- |
| CODE | 19 |
| UNIT | kcal |
| LABEL | calories |
| PRECISION | 0 |
| IDENTIFIER | calories |
| LABEL_AND_UNIT | `kcal` |

Source: Activity.Info.calories (kcal); Finite numeric, zero valid.

Color source: none.

Normal display ranges: 0–9999. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-50](#dvs-50), [DVS-7](#dvs-7)

<a id="dvs-32"></a>
## DVS-32 — Time of day

Type: requirement | State: approved | Revision: 67

| Attribute | Value |
| --- | --- |
| CODE | 18 |
| UNIT | "" |
| LABEL | time |
| IDENTIFIER | time_of_day |
| LABEL_AND_UNIT | "" |
| PRECISION_RULE | 1 minute |

Source: valid local System.getClockTime(), using device is24Hour (missing -> 24-hour). Show HH:MM, hours 00..23, or h:MM, hours 1..12 without hour padding; minutes always two digits.
In 12-hour mode append ` | am` to the header before noon, ` | pm` thereafter; midnight/noon show 12:00. In 24-hour mode no indicator. This nonphysical indicator ignores unit visibility; invalid local time has no guessed indicator.

Color source: none.

Normal display ranges: 24h: 00:00–23:59; 12h: 00:00–23:59. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- allocated_to: [APP-4](#app-4)
- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12)

<a id="dvs-31"></a>
## DVS-31 — Elapsed time

Type: requirement | State: approved | Revision: 61

| Attribute | Value |
| --- | --- |
| CODE | 17 |
| UNIT | "" |
| LABEL | elapsed |
| IDENTIFIER | elapsed_time |
| LABEL_AND_UNIT | "" |
| PRECISION_RULE | 1 second below 10 h; 1 minute from 10 h |

Source: Activity.Info.elapsedTime (ms), nonnegative elapsed duration including pauses.

Color source: none.

Normal display ranges: 0:00:00–99:59:59 elapsed h:mm:ss. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-13](#dvs-13), [DVS-40](#dvs-40)

<a id="dvs-30"></a>
## DVS-30 — Activity timer

Type: requirement | State: approved | Revision: 61

| Attribute | Value |
| --- | --- |
| CODE | 16 |
| UNIT | "" |
| LABEL | timer |
| IDENTIFIER | activity_timer |
| LABEL_AND_UNIT | "" |
| PRECISION_RULE | 1 second below 10 h; 1 minute from 10 h |

Source: Activity.Info.timerTime (ms), nonnegative active duration excluding stopped time.

Color source: none.

Normal display ranges: 0:00:00–99:59:59 elapsed h:mm:ss. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-13](#dvs-13), [DVS-40](#dvs-40)

<a id="dvs-29"></a>
## DVS-29 — Grade

Type: requirement | State: approved | Revision: 174

| Attribute | Value |
| --- | --- |
| CODE | 15 |
| UNIT | % |
| LABEL | slope |
| PRECISION | 1 |
| IDENTIFIER | grade |
| LABEL_AND_UNIT | `slope \| %` |

Source: app slope estimate from running Activity.Info altitude/distance (m), elapsedTime (ms), timerState and available startTime.value(); no sensor polling or invented native grade member.
Sampling: Admit at most one new point per elapsedTime second; duplicate timestamps are ignored. Retain up to five distinct distances FIFO. At unchanged distance, replace only the newest point's altitude; do not change its admission time, point count, published grade or average slots. This replacement does not consume a new sampling step. At the next admitted distance increase, add one point and calculate once. The window contains distinct positions, not necessarily five seconds.

Regression: for n>=3, D=n*sum(x*x)-sum(x)^2, N=n*sum(x*y)-sum(x)*sum(y), g=100*N/D. abs(D)<1e-9 gives zero. Otherwise require finite arithmetic and D>0. Round each estimate to two decimals, exact halves away from zero. For fewer than three distinct-distance points use zero as the next estimate.
Average: Keep five estimate slots initialized to zero. Once per newly admitted distinct-distance point, replace the oldest slot with the new regression estimate and publish sum(slots)/5 immediately; unfilled startup slots contribute zero. Round the mean to two decimals, exact halves away from zero, suppressing negative zero: canonical grade. Do not wait for five seconds or a full history. Average slope estimates only; never fabricate altitude/distance pairs. Positive is ascent.
Clear regression history/value and refill all average slots with zeros on invalid/missing input, negative/decreasing distance, decreasing time, gaps >2000 ms, stop/pause/resume/reset, changed identity or reported calibration/source change. A valid running reset sample may seed warm-up. After 3 s without distance progress stay unavailable until progress resumes; duplicates do not defer it. Settings/units/visibility preserve both histories; unreported calibration cannot be inferred.

Color source: canonical grade before display rounding. Bands (%): <=0 green; (0,2] blue; (2,5] yellow; (5,8] orange; (8,15] red; (15,20] dark red; >20 black.
Whole-cell effect: horizon through cell centre at clamp(2*g,-45,45) degrees, positive rising left-to-right; fill clipped ground below, ordinary sky/foreground. Label uses the band color only in the common header. None/unavailable has no horizon; unavailable uses selected neutral coverage. Never double/clamp numeric grade or add further smoothing/travel-span rules.

This field background coloring has higher priority when full cell background coloring option is selected.

Normal display ranges: -99.9–99.9. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- allocated_to: [APP-4](#app-4)
- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-44](#app-44), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-2](#dvs-2), [DVS-45](#dvs-45), [DVS-50](#dvs-50)

<a id="dvs-28"></a>
## DVS-28 — Total descent

Type: requirement | State: approved | Revision: 48

| Attribute | Value |
| --- | --- |
| CODE | 14 |
| UNIT | m (metric) or ft (imperial) |
| LABEL | descent |
| PRECISION | 0 |
| IDENTIFIER | total_descent |
| LABEL_AND_UNIT | `descent \| {unit}` |

Source: Activity.Info.totalDescent (m); Finite numeric, zero valid.

Color source: none.

Normal display ranges: 0–9999. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-4](#dvs-4), [DVS-40](#dvs-40), [DVS-50](#dvs-50), [DVS-7](#dvs-7)

<a id="dvs-27"></a>
## DVS-27 — Total ascent

Type: requirement | State: approved | Revision: 48

| Attribute | Value |
| --- | --- |
| CODE | 13 |
| UNIT | m (metric) or ft (imperial) |
| LABEL | ascent |
| PRECISION | 0 |
| IDENTIFIER | total_ascent |
| LABEL_AND_UNIT | `ascent \| {unit}` |

Source: Activity.Info.totalAscent (m); Finite numeric, zero valid.

Color source: none.

Normal display ranges: 0–9999. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-4](#dvs-4), [DVS-40](#dvs-40), [DVS-50](#dvs-50), [DVS-7](#dvs-7)

<a id="dvs-26"></a>
## DVS-26 — Elevation

Type: requirement | State: approved | Revision: 58

| Attribute | Value |
| --- | --- |
| CODE | 12 |
| UNIT | m (metric) or ft (imperial) |
| LABEL | elevation |
| PRECISION | 0 |
| IDENTIFIER | elevation |
| LABEL_AND_UNIT | `elevation \| {unit}` |

Source: Activity.Info.altitude (m); Finite numeric, zero valid.

Color source: none.

Normal display ranges:  -999–9999.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-4](#dvs-4), [DVS-40](#dvs-40), [DVS-50](#dvs-50), [DVS-7](#dvs-7)

<a id="dvs-25"></a>
## DVS-25 — Distance

Type: requirement | State: approved | Revision: 54

| Attribute | Value |
| --- | --- |
| CODE | 11 |
| UNIT | km (metric) or mi (imperial) |
| LABEL | distance |
| IDENTIFIER | distance |
| LABEL_AND_UNIT | `distance \| {unit}` |
| PRECISION_RULE | magnitude-based |

Source: Activity.Info.elapsedDistance (m); Finite numeric, zero valid.

Color source: none.

Normal display ranges: 0–1000. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-2](#dvs-2), [DVS-4](#dvs-4), [DVS-40](#dvs-40), [DVS-50](#dvs-50)

<a id="dvs-24"></a>
## DVS-24 — Power zone

Type: requirement | State: approved | Revision: 64

| Attribute | Value |
| --- | --- |
| CODE | 10 |
| UNIT | "" |
| LABEL | power zone |
| PRECISION | 0 |
| IDENTIFIER | power_zone |
| LABEL_AND_UNIT | "" |

Source: Classify currentPower using the global power source [SPEC-663](#spec-663); show its integral 1-based zone. Custom profiles yield 1..7; qualified device profiles retain their actual indices, including above seven. Invalid selected profile or invalid/out-of-domain reading is unavailable.

Color source: power.

Normal display ranges: 1–7. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- allocated_to: [APP-4](#app-4)
- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-42](#dvs-42), [DVS-7](#dvs-7), [SPEC-248](#spec-248), [SPEC-663](#spec-663), [SPEC-665](#spec-665)

<a id="dvs-23"></a>
## DVS-23 — Average power

Type: requirement | State: approved | Revision: 70

| Attribute | Value |
| --- | --- |
| CODE | 9 |
| UNIT | w |
| LABEL | avg watts |
| PRECISION | 0 |
| IDENTIFIER | average_power |
| LABEL_AND_UNIT | `avg watts` |

Source: Activity.Info.averagePower (watts); Finite numeric, zero valid.

Color source: power.

Normal display ranges: 0–3000. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-42](#dvs-42), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [SPEC-248](#spec-248), [SPEC-663](#spec-663), [SPEC-665](#spec-665)

<a id="dvs-22"></a>
## DVS-22 — Three-second average power

Type: requirement | State: approved | Revision: 82

| Attribute | Value |
| --- | --- |
| CODE | 8 |
| UNIT | w |
| LABEL | 3s watts |
| PRECISION | 0 |
| IDENTIFIER | power_3s |
| LABEL_AND_UNIT | `3s watts` |

Source: Shared three-second arithmetic mean of currentPower (W), finite samples >=0 including measured zero.

Warm-up: Publish the first valid sample unchanged, then the mean of the first two samples, then the rolling mean of the latest three. Use the same warm-up after every window reset; before a valid sample, the value is unavailable.

Color source: power.

Normal display ranges: 0–3000. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-41](#dvs-41), [DVS-42](#dvs-42), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [SPEC-248](#spec-248), [SPEC-663](#spec-663), [SPEC-665](#spec-665)

<a id="dvs-21"></a>
## DVS-21 — Current power

Type: requirement | State: approved | Revision: 71

| Attribute | Value |
| --- | --- |
| CODE | 7 |
| UNIT | w |
| LABEL | watts |
| PRECISION | 0 |
| IDENTIFIER | current_power |
| LABEL_AND_UNIT | `watts` |

Source: Activity.Info.currentPower (watts); Finite numeric, zero valid.

Color source: power.

Normal display ranges: 0–3000. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-42](#dvs-42), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [SPEC-248](#spec-248), [SPEC-663](#spec-663), [SPEC-665](#spec-665)

<a id="dvs-20"></a>
## DVS-20 — Heart rate zone

Type: requirement | State: approved | Revision: 64

| Attribute | Value |
| --- | --- |
| CODE | 6 |
| UNIT | "" |
| LABEL | hr zone |
| PRECISION | 0 |
| IDENTIFIER | heart_rate_zone |
| LABEL_AND_UNIT | "" |

Source: Classify currentHeartRate using the global HR source [SPEC-664](#spec-664); show its integral zone 1..5. Invalid selected profile or invalid/out-of-domain reading is unavailable.

Color source: heart rate.

Normal display ranges: 1–5. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- allocated_to: [APP-4](#app-4)
- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-42](#dvs-42), [DVS-7](#dvs-7), [SPEC-248](#spec-248), [SPEC-664](#spec-664), [SPEC-665](#spec-665)

<a id="dvs-19"></a>
## DVS-19 — Average heart rate

Type: requirement | State: approved | Revision: 72

| Attribute | Value |
| --- | --- |
| CODE | 5 |
| UNIT | bpm |
| LABEL | average hr |
| PRECISION | 0 |
| IDENTIFIER | average_heart_rate |
| LABEL_AND_UNIT | `avg hr \| bpm` |

Source: Activity.Info.averageHeartRate (bpm); Finite numeric, zero valid.

Color source: heart rate.

Normal display ranges: 30–250. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-42](#dvs-42), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [SPEC-248](#spec-248), [SPEC-664](#spec-664), [SPEC-665](#spec-665)

<a id="dvs-18"></a>
## DVS-18 — Current heart rate

Type: requirement | State: approved | Revision: 75

| Attribute | Value |
| --- | --- |
| CODE | 4 |
| UNIT | bpm |
| LABEL | heart rate |
| PRECISION | 0 |
| IDENTIFIER | current_heart_rate |
| LABEL_AND_UNIT | `hr \| {unit}` |

Source: Activity.Info.currentHeartRate (bpm); Finite numeric, zero valid.

Color source: heart rate.

Normal display ranges: 30–250. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-42](#dvs-42), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [SPEC-248](#spec-248), [SPEC-664](#spec-664), [SPEC-665](#spec-665)

<a id="dvs-12"></a>
## DVS-12 — Define field headers and their common band height

Type: requirement | State: approved | Revision: 114

Resolve each complete header from the field's label/unit rules and nonphysical indicators. Use the label font with origin p=3 px below cell top in regular and enlarged cells.
At catalogue/label-font initialization, measure visible bounds [a,b) relative to that origin for every supported complete header. Compute M=min(2*p+a+b), S=max(p+b+1), H=max(M,S), including the one-pixel halo. Include fixed labels, unit variants, hidden assignments and clock indicators; exclude user-entered values.
Cache H for the catalogue/font revision. All regular/enlarged Label bands are full-width and end at cell_y+H. Assignment, unit/clock preferences, header visibility, theme, alignment, values and enlargement do not resize H.

**Relations**

- allocated_to: [APP-4](#app-4)
- part_of: [DVS-1](#dvs-1)
- uses: [APP-25](#app-25), [DVS-50](#dvs-50), [DVS-6](#dvs-6)

<a id="dvs-11"></a>
## DVS-11 — Average Cadence

Type: requirement | State: approved | Revision: 55

| Attribute | Value |
| --- | --- |
| CODE | 3 |
| UNIT | rpm |
| LABEL | avg cadence |
| PRECISION | 0 |
| IDENTIFIER | average_cadence |
| LABEL_AND_UNIT | `avg cad \| rpm` |

Source: Activity.Info.averageCadence (rpm); Finite numeric, zero valid.

Color source: cadence.

Normal display ranges: 0–250. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [SPEC-247](#spec-247), [SPEC-248](#spec-248)

<a id="dvs-10"></a>
## DVS-10 — Current Cadence

Type: requirement | State: approved | Revision: 55

| Attribute | Value |
| --- | --- |
| CODE | 2 |
| UNIT | rpm |
| LABEL | cadence |
| PRECISION | 0 |
| IDENTIFIER | current_cadence |
| LABEL_AND_UNIT | `cad \| rpm` |

Source: Activity.Info.currentCadence (rpm); Finite numeric, zero valid.

Color source: cadence.

Normal display ranges: 0–250. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [SPEC-247](#spec-247), [SPEC-248](#spec-248)

<a id="dvs-9"></a>
## DVS-9 — Average speed

Type: requirement | State: approved | Revision: 62

| Attribute | Value |
| --- | --- |
| CODE | 1 |
| UNIT | `km/h` (metric) or `mph` (imperial) |
| LABEL | avg speed |
| IDENTIFIER | average_speed |
| LABEL_AND_UNIT | `avg \| {unit}` |
| PRECISION_RULE | magnitude-based |

Source: Activity.Info.averageSpeed (m/s); Finite numeric, zero valid.

Color source: none.

Normal display ranges: 0–200

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-2](#dvs-2), [DVS-4](#dvs-4), [DVS-40](#dvs-40), [DVS-50](#dvs-50)

<a id="dvs-8"></a>
## DVS-8 — Current speed

Type: requirement | State: approved | Revision: 65

| Attribute | Value |
| --- | --- |
| CODE | 0 |
| UNIT | km/h (metric) or mph (imperial) |
| LABEL | speed |
| IDENTIFIER | current_speed |
| LABEL_AND_UNIT | `speed \| {unit}` |
| PRECISION_RULE | magnitude-based |

Source: Activity.Info.currentSpeed (m/s); Finite numeric, zero valid.

Color source: none.

Normal display ranges: 0–200. All supported devices, regular/enlarged cells, headers hidden/shown.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-2](#dvs-2), [DVS-4](#dvs-4), [DVS-40](#dvs-40), [DVS-50](#dvs-50)

<a id="dvs-6"></a>
## DVS-6 — Render transparent text with contrast halos on effect backgrounds

Type: requirement | State: approved | Revision: 104

Composite text with transparent glyph masks, without rectangular text panels. Over colored regions, draw a one-pixel opposite black/white halo: the union of eight one-pixel-shifted glyph masks minus the original mask.
Clip glyphs/halos to their painted region and cell. Label-mode halos remain in the colored header; Whole cell applies them to all overlaid text. Use the shared foreground-contrast rule and erase obsolete fills/halos before repaint.

**Relations**

- allocated_to: [APP-4](#app-4)
- part_of: [DVS-1](#dvs-1)
- uses: [APP-36](#app-36)

<a id="dvs-4"></a>
## DVS-4 — App shall support metric and imperial values

Type: requirement | State: approved | Revision: 53

Select distance/elevation/temperature units independently from System.getDeviceSettings().distanceUnits/elevationUnits/temperatureUnits. Each missing preference falls back to metric. Use the field's declared UNIT attribute; preference changes update value/unit together.

**Relations**

- allocated_to: [APP-3](#app-3)
- part_of: [DVS-1](#dvs-1)

<a id="app-25"></a>
## APP-25 — Use the three specified Roboto Condensed font roles

Type: requirement | State: approved | Revision: 52

Bundle exactly three metric roles at fixed profile sizes, without per-value sizes/fitting ladders:

| Role | Source face |
| --- | --- |
| Enlarged primary | [Roboto Condensed Black](attachments/Roboto_Condensed_Black.ttf) |
| Regular primary | [Roboto Condensed Black](attachments/Roboto_Condensed_Black.ttf)  |
| Header/numeric secondary | [Roboto Condensed SemiBold](attachments/Roboto_Condensed_SemiBold.ttf) |
Native-text fields use their own system-font policy without adding atlases.

**Relations**

- allocated_to: [APP-4](#app-4)
- part_of: [APP-1](#app-1)
- uses: [APP-24](#app-24)

**Attachments**

- [Roboto_Condensed_Black.ttf](attachments/Roboto_Condensed_Black.ttf) — design_asset: Source font for enlarged and regular metric values: Roboto Condensed Black.
- [Roboto_Condensed_SemiBold.ttf](attachments/Roboto_Condensed_SemiBold.ttf) — design_asset: Source font for headers and numeric secondary text: Roboto Condensed SemiBold.

<a id="spec-365"></a>
## SPEC-365 — Second set: Slot 10: background (b10_bg)

Type: requirement | State: approved | Revision: 39

Key: `b10_bg`. Caption: Second set: Slot 10: background. Type/values: Integer 0, 1, 2. Default: `0`.

Second set, slot 10.

Behavior: [APP-49](#app-49). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-364"></a>
## SPEC-364 — Second set: Slot 10: value (b10)

Type: requirement | State: approved | Revision: 38

Key: `b10`. Caption: Second set: Slot 10: value. Type/values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32. Default: `20`.

Second set, slot 10.

Behavior: [APP-30](#app-30). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-363"></a>
## SPEC-363 — Second set: Slot 9: background (b9_bg)

Type: requirement | State: approved | Revision: 39

Key: `b9_bg`. Caption: Second set: Slot 9: background. Type/values: Integer 0, 1, 2. Default: `0`.

Second set, slot 9.

Behavior: [APP-49](#app-49). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-362"></a>
## SPEC-362 — Second set: Slot 9: value (b9)

Type: requirement | State: approved | Revision: 38

Key: `b9`. Caption: Second set: Slot 9: value. Type/values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32. Default: `12`.

Second set, slot 9.

Behavior: [APP-30](#app-30). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-361"></a>
## SPEC-361 — Second set: Slot 8: background (b8_bg)

Type: requirement | State: approved | Revision: 39

Key: `b8_bg`. Caption: Second set: Slot 8: background. Type/values: Integer 0, 1, 2. Default: `0`.

Second set, slot 8.

Behavior: [APP-49](#app-49). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-360"></a>
## SPEC-360 — Second set: Slot 8: value (b8)

Type: requirement | State: approved | Revision: 38

Key: `b8`. Caption: Second set: Slot 8: value. Type/values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32. Default: `27`.

Second set, slot 8.

Behavior: [APP-30](#app-30). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-359"></a>
## SPEC-359 — Second set: Slot 7: background (b7_bg)

Type: requirement | State: approved | Revision: 39

Key: `b7_bg`. Caption: Second set: Slot 7: background. Type/values: Integer 0, 1, 2. Default: `0`.

Second set, slot 7.

Behavior: [APP-49](#app-49). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-358"></a>
## SPEC-358 — Second set: Slot 7: value (b7)

Type: requirement | State: approved | Revision: 38

Key: `b7`. Caption: Second set: Slot 7: value. Type/values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32. Default: `26`.

Second set, slot 7.

Behavior: [APP-30](#app-30). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-357"></a>
## SPEC-357 — Second set: Slot 6: background (b6_bg)

Type: requirement | State: approved | Revision: 39

Key: `b6_bg`. Caption: Second set: Slot 6: background. Type/values: Integer 0, 1, 2. Default: `0`.

Second set, slot 6.

Behavior: [APP-49](#app-49). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-356"></a>
## SPEC-356 — Second set: Slot 6: value (b6)

Type: requirement | State: approved | Revision: 38

Key: `b6`. Caption: Second set: Slot 6: value. Type/values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32. Default: `0`.

Second set, slot 6.

Behavior: [APP-30](#app-30). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-355"></a>
## SPEC-355 — Second set: Slot 5: background (b5_bg)

Type: requirement | State: approved | Revision: 39

Key: `b5_bg`. Caption: Second set: Slot 5: background. Type/values: Integer 0, 1, 2. Default: `0`.

Second set, slot 5.

Behavior: [APP-49](#app-49). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-354"></a>
## SPEC-354 — Second set: Slot 5: value (b5)

Type: requirement | State: approved | Revision: 38

Key: `b5`. Caption: Second set: Slot 5: value. Type/values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32. Default: `30`.

Second set, slot 5.

Behavior: [APP-30](#app-30). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-353"></a>
## SPEC-353 — Second set: Slot 4: background (b4_bg)

Type: requirement | State: approved | Revision: 39

Key: `b4_bg`. Caption: Second set: Slot 4: background. Type/values: Integer 0, 1, 2. Default: `1`.

Second set, slot 4.

Behavior: [APP-49](#app-49). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-352"></a>
## SPEC-352 — Second set: Slot 4: value (b4)

Type: requirement | State: approved | Revision: 38

Key: `b4`. Caption: Second set: Slot 4: value. Type/values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32. Default: `15`.

Second set, slot 4.

Behavior: [APP-30](#app-30). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-351"></a>
## SPEC-351 — Second set: Slot 3: background (b3_bg)

Type: requirement | State: approved | Revision: 39

Key: `b3_bg`. Caption: Second set: Slot 3: background. Type/values: Integer 0, 1, 2. Default: `1`.

Second set, slot 3.

Behavior: [APP-49](#app-49). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-350"></a>
## SPEC-350 — Second set: Slot 3: value (b3)

Type: requirement | State: approved | Revision: 38

Key: `b3`. Caption: Second set: Slot 3: value. Type/values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32. Default: `2`.

Second set, slot 3.

Behavior: [APP-30](#app-30). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-349"></a>
## SPEC-349 — Second set: Slot 2: background (b2_bg)

Type: requirement | State: approved | Revision: 39

Key: `b2_bg`. Caption: Second set: Slot 2: background. Type/values: Integer 0, 1, 2. Default: `1`.

Second set, slot 2.

Behavior: [APP-49](#app-49). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-348"></a>
## SPEC-348 — Second set: Slot 2: value (b2)

Type: requirement | State: approved | Revision: 38

Key: `b2`. Caption: Second set: Slot 2: value. Type/values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32. Default: `4`.

Second set, slot 2.

Behavior: [APP-30](#app-30). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-347"></a>
## SPEC-347 — Second set: Slot 1: background (b1_bg)

Type: requirement | State: approved | Revision: 39

Key: `b1_bg`. Caption: Second set: Slot 1: background. Type/values: Integer 0, 1, 2. Default: `1`.

Second set, slot 1.

Behavior: [APP-49](#app-49). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-346"></a>
## SPEC-346 — Second set: Slot 1: value (b1)

Type: requirement | State: approved | Revision: 38

Key: `b1`. Caption: Second set: Slot 1: value. Type/values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32. Default: `8`.

Second set, slot 1.

Behavior: [APP-30](#app-30). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-345"></a>
## SPEC-345 — Second set: Grid type (b_grid)

Type: requirement | State: approved | Revision: 37

Key: `b_grid`. Caption: Second set: Grid type. Type/values: Integer 0, 1, 2. Default: `1`.

Second set. Select 0 None, 1 Horizontal lines, 2 Full grid. Invalid or missing input uses 1 without rewriting storage.

Behavior: [APP-22](#app-22). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-22](#app-22), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-344"></a>
## SPEC-344 — Second set: Inverse theme for enlarged slots (b_inv)

Type: requirement | State: approved | Revision: 37

Key: `b_inv`. Caption: Second set: Inverse theme for enlarged slots. Type/values: Boolean. Default: `true`.

Second set. True inverts the theme in enlarged slots; false retains the base theme. Invalid or missing input uses true without rewriting storage.

Behavior: [DVS-51](#dvs-51). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-51](#dvs-51), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-343"></a>
## SPEC-343 — Second set: Hide physical units in headers (b_hideu)

Type: requirement | State: approved | Revision: 29

Key: `b_hideu`. Caption: Second set: Hide physical units in headers. Type/values: Boolean. Default: `true`.

Second set. True hides physical units in headers; false uses the field-specific header with units. Invalid or missing input uses true without rewriting storage.

Behavior: [DVS-50](#dvs-50). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-47](#dvs-47), [DVS-50](#dvs-50), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8)

<a id="spec-342"></a>
## SPEC-342 — Second set: Theme mode (b_theme)

Type: requirement | State: approved | Revision: 37

Key: `b_theme`. Caption: Second set: Theme mode. Type/values: Integer 0, 1, 2. Default: `0`.

Second set. Select 0 Auto, 1 Day, 2 Night. Invalid or missing input uses 0 without rewriting storage.

Behavior: [APP-45](#app-45). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-45](#app-45), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-341"></a>
## SPEC-341 — Second set: Alignment (b_align)

Type: requirement | State: approved | Revision: 37

Key: `b_align`. Caption: Second set: Alignment. Type/values: Integer 0, 1. Default: `1`.

Second set. Select label and value alignment: 0 Center, 1 Right. Invalid or missing input uses 1 without rewriting storage.

Behavior: [APP-21](#app-21). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-21](#app-21), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-340"></a>
## SPEC-340 — Second set: Enlarged slot count (b_big)

Type: requirement | State: approved | Revision: 37

Key: `b_big`. Caption: Second set: Enlarged slot count. Type/values: Integer 0, 1, 2. Default: `1`.

Second set. Select the number of enlarged top slots. Invalid or missing input uses 1 without rewriting storage.

Behavior: [APP-20](#app-20). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-20](#app-20), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-339"></a>
## SPEC-339 — Heart rate: return below (bpm) (hr_off)

Type: requirement | State: approved | Revision: 5

Key: `hr_off`. Caption: Heart rate: return below (bpm). Type/values: Integer 30..250. Default: `150`.

Return to the default set when the selected valid reading is below this value. Only its matching trigger uses it; return must not exceed activation. Invalid selected pairs keep the default set. Invalid or missing input uses 150 without rewriting storage.

Behavior: [SPEC-212](#spec-212). Fields: [DVS-18](#dvs-18).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-18](#dvs-18), [SPEC-212](#spec-212)

<a id="spec-338"></a>
## SPEC-338 — Heart rate: activate at (bpm) (hr_on)

Type: requirement | State: approved | Revision: 5

Key: `hr_on`. Caption: Heart rate: activate at (bpm). Type/values: Integer 30..250. Default: `160`.

Activate the second set when the selected valid reading is at least this value. Only its matching trigger uses it; return must not exceed activation. Invalid selected pairs keep the default set. Invalid or missing input uses 160 without rewriting storage.

Behavior: [SPEC-212](#spec-212). Fields: [DVS-18](#dvs-18).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-18](#dvs-18), [SPEC-212](#spec-212)

<a id="spec-337"></a>
## SPEC-337 — Power: return below (W) (p_off)

Type: requirement | State: approved | Revision: 5

Key: `p_off`. Caption: Power: return below (W). Type/values: Integer 1..3000. Default: `220`.

Return to the default set when the selected valid reading is below this value. Only its matching trigger uses it; return must not exceed activation. Invalid selected pairs keep the default set. Invalid or missing input uses 220 without rewriting storage.

Behavior: [SPEC-212](#spec-212). Fields: [DVS-22](#dvs-22).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-22](#dvs-22), [SPEC-212](#spec-212)

<a id="spec-336"></a>
## SPEC-336 — Power: activate at (W) (p_on)

Type: requirement | State: approved | Revision: 5

Key: `p_on`. Caption: Power: activate at (W). Type/values: Integer 1..3000. Default: `250`.

Activate the second set when the selected valid reading is at least this value. Only its matching trigger uses it; return must not exceed activation. Invalid selected pairs keep the default set. Invalid or missing input uses 250 without rewriting storage.

Behavior: [SPEC-212](#spec-212). Fields: [DVS-22](#dvs-22).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-22](#dvs-22), [SPEC-212](#spec-212)

<a id="spec-335"></a>
## SPEC-335 — Second field set - activation event (trig)

Type: requirement | State: approved | Revision: 6

Key: `trig`. Caption: Second field set - activation event. Type/values: Integer 0, 1, 2, 3, 4. Default: `3`.

Select 0 None, 1 3s power, 2 Heart rate, 3 Manual lap, 4 Workout started. Only the selected mode acts. Invalid or missing input uses 3 without rewriting storage.

Behavior: [SPEC-211](#spec-211). Fields: [DVS-22](#dvs-22), [DVS-18](#dvs-18).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-18](#dvs-18), [DVS-22](#dvs-22), [SPEC-211](#spec-211)

<a id="spec-334"></a>
## SPEC-334 — Cadence zone 4: upper rpm (cad4)

Type: requirement | State: approved | Revision: 8

Key: `cad4`. Caption: Cadence zone 4: upper rpm. Type/values: Integer 0..300. Default: `120`.

Shared upper rpm bound for zone 4; cross-boundary validity and missing/invalid handling follow [SPEC-252](#spec-252).

Behavior: [SPEC-252](#spec-252). Fields: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [FUNC-8](#func-8).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [FUNC-8](#func-8), [SPEC-252](#spec-252)

<a id="spec-333"></a>
## SPEC-333 — Cadence zone 3: upper rpm (cad3)

Type: requirement | State: approved | Revision: 8

Key: `cad3`. Caption: Cadence zone 3: upper rpm. Type/values: Integer 0..300. Default: `100`.

Shared upper rpm bound for zone 3; cross-boundary validity and missing/invalid handling follow [SPEC-252](#spec-252).

Behavior: [SPEC-252](#spec-252). Fields: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [FUNC-8](#func-8).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [FUNC-8](#func-8), [SPEC-252](#spec-252)

<a id="spec-332"></a>
## SPEC-332 — Cadence zone 2: upper rpm (cad2)

Type: requirement | State: approved | Revision: 8

Key: `cad2`. Caption: Cadence zone 2: upper rpm. Type/values: Integer 0..300. Default: `80`.

Shared upper rpm bound for zone 2; cross-boundary validity and missing/invalid handling follow [SPEC-252](#spec-252).

Behavior: [SPEC-252](#spec-252). Fields: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [FUNC-8](#func-8).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [FUNC-8](#func-8), [SPEC-252](#spec-252)

<a id="spec-331"></a>
## SPEC-331 — Cadence zone 1: upper rpm (cad1)

Type: requirement | State: approved | Revision: 8

Key: `cad1`. Caption: Cadence zone 1: upper rpm. Type/values: Integer 0..300. Default: `60`.

Shared upper rpm bound for zone 1; cross-boundary validity and missing/invalid handling follow [SPEC-252](#spec-252).

Behavior: [SPEC-252](#spec-252). Fields: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [FUNC-8](#func-8).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [FUNC-8](#func-8), [SPEC-252](#spec-252)

<a id="spec-330"></a>
## SPEC-330 — Slot 10: background (a10_bg)

Type: requirement | State: approved | Revision: 39

Key: `a10_bg`. Caption: Slot 10: background. Type/values: Integer 0, 1, 2. Default: `0`.

Default set, slot 10.

Behavior: [APP-49](#app-49). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-329"></a>
## SPEC-329 — Slot 10: value (a10)

Type: requirement | State: approved | Revision: 38

Key: `a10`. Caption: Slot 10: value. Type/values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32. Default: `20`.

Default set, slot 10.

Behavior: [APP-30](#app-30). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-328"></a>
## SPEC-328 — Slot 9: background (a9_bg)

Type: requirement | State: approved | Revision: 39

Key: `a9_bg`. Caption: Slot 9: background. Type/values: Integer 0, 1, 2. Default: `0`.

Default set, slot 9.

Behavior: [APP-49](#app-49). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-327"></a>
## SPEC-327 — Slot 9: value (a9)

Type: requirement | State: approved | Revision: 38

Key: `a9`. Caption: Slot 9: value. Type/values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32. Default: `13`.

Default set, slot 9.

Behavior: [APP-30](#app-30). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-326"></a>
## SPEC-326 — Slot 8: background (a8_bg)

Type: requirement | State: approved | Revision: 39

Key: `a8_bg`. Caption: Slot 8: background. Type/values: Integer 0, 1, 2. Default: `0`.

Default set, slot 8.

Behavior: [APP-49](#app-49). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-325"></a>
## SPEC-325 — Slot 8: value (a8)

Type: requirement | State: approved | Revision: 38

Key: `a8`. Caption: Slot 8: value. Type/values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32. Default: `15`.

Default set, slot 8.

Behavior: [APP-30](#app-30). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-307"></a>
## SPEC-307 — Grid type (a_grid)

Type: requirement | State: approved | Revision: 37

Key: `a_grid`. Caption: Grid type. Type/values: Integer 0, 1, 2. Default: `1`.

Default set. Select 0 None, 1 Horizontal lines, 2 Full grid. Invalid or missing input uses 1 without rewriting storage.

Behavior: [APP-22](#app-22). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-22](#app-22), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-306"></a>
## SPEC-306 — Inverse theme for enlarged slots (a_inv)

Type: requirement | State: approved | Revision: 37

Key: `a_inv`. Caption: Inverse theme for enlarged slots. Type/values: Boolean. Default: `true`.

Default set. True inverts the theme in enlarged slots; false retains the base theme. Invalid or missing input uses true without rewriting storage.

Behavior: [DVS-51](#dvs-51). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-51](#dvs-51), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-305"></a>
## SPEC-305 — Hide physical units in headers (a_hideu)

Type: requirement | State: approved | Revision: 29

Key: `a_hideu`. Caption: Hide physical units in headers. Type/values: Boolean. Default: `true`.

Default set. True hides physical units in headers; false uses the field-specific header with units. Invalid or missing input uses true without rewriting storage.

Behavior: [DVS-50](#dvs-50). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-47](#dvs-47), [DVS-50](#dvs-50), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8)

<a id="spec-304"></a>
## SPEC-304 — Theme mode (a_theme)

Type: requirement | State: approved | Revision: 37

Key: `a_theme`. Caption: Theme mode. Type/values: Integer 0, 1, 2. Default: `0`.

Default set. Select 0 Auto, 1 Day, 2 Night. Invalid or missing input uses 0 without rewriting storage.

Behavior: [APP-45](#app-45). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-45](#app-45), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-303"></a>
## SPEC-303 — Alignment (a_align)

Type: requirement | State: approved | Revision: 37

Key: `a_align`. Caption: Alignment. Type/values: Integer 0, 1. Default: `1`.

Default set. Select label and value alignment: 0 Center, 1 Right. Invalid or missing input uses 1 without rewriting storage.

Behavior: [APP-21](#app-21). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-21](#app-21), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-302"></a>
## SPEC-302 — Enlarged slot count (a_big)

Type: requirement | State: approved | Revision: 37

Key: `a_big`. Caption: Enlarged slot count. Type/values: Integer 0, 1, 2. Default: `0`.

Default set. Select the number of enlarged top slots. Invalid or missing input uses 0 without rewriting storage.

Behavior: [APP-20](#app-20). Fields: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [APP-20](#app-20), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-301"></a>
## SPEC-301 — Property field-selection codes

Type: requirement | State: approved | Revision: 36

Field selectors store integer codes 0..32. The mapping below is independent of display captions; field behavior belongs to its linked owner.

| Code | Identifier | Field requirement |
| --- | --- | --- |
| 0 | current_speed | [DVS-8](#dvs-8) |
| 1 | average_speed | [DVS-9](#dvs-9) |
| 2 | current_cadence | [DVS-10](#dvs-10) |
| 3 | average_cadence | [DVS-11](#dvs-11) |
| 4 | current_heart_rate | [DVS-18](#dvs-18) |
| 5 | average_heart_rate | [DVS-19](#dvs-19) |
| 6 | heart_rate_zone | [DVS-20](#dvs-20) |
| 7 | current_power | [DVS-21](#dvs-21) |
| 8 | power_3s | [DVS-22](#dvs-22) |
| 9 | average_power | [DVS-23](#dvs-23) |
| 10 | power_zone | [DVS-24](#dvs-24) |
| 11 | distance | [DVS-25](#dvs-25) |
| 12 | elevation | [DVS-26](#dvs-26) |
| 13 | total_ascent | [DVS-27](#dvs-27) |
| 14 | total_descent | [DVS-28](#dvs-28) |
| 15 | grade | [DVS-29](#dvs-29) |
| 16 | activity_timer | [DVS-30](#dvs-30) |
| 17 | elapsed_time | [DVS-31](#dvs-31) |
| 18 | time_of_day | [DVS-32](#dvs-32) |
| 19 | calories | [DVS-33](#dvs-33) |
| 20 | temperature | [DVS-34](#dvs-34) |
| 21 | battery | [DVS-35](#dvs-35) |
| 22 | heading | [DVS-36](#dvs-36) |
| 23 | distance_next_waypoint | [DVS-37](#dvs-37) |
| 24 | completed_laps | [DVS-39](#dvs-39) |
| 25 | heart_rate_3s | [DVS-47](#dvs-47) |
| 26 | lap_distance | [FUNC-3](#func-3) |
| 27 | lap_time | [FUNC-4](#func-4) |
| 28 | lap_speed | [FUNC-5](#func-5) |
| 29 | lap_heart_rate | [FUNC-6](#func-6) |
| 30 | lap_power | [FUNC-7](#func-7) |
| 31 | lap_cadence | [FUNC-8](#func-8) |
| 32 | team | [SPEC-253](#spec-253) |

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-252"></a>
## SPEC-252 — Configure four cadence upper boundaries

Type: requirement | State: approved | Revision: 13

Global cadence upper bounds: [SPEC-331](#spec-331), [SPEC-332](#spec-332), [SPEC-333](#spec-333), [SPEC-334](#spec-334). Require t1<t2<t3<t4. Missing bounds use their individual defaults; present invalid bounds make cadence coloring neutral without sorting, clamping or rewriting them.

**Relations**

- part_of: [SPEC-233](#spec-233)
- uses: [APP-31](#app-31), [SPEC-249](#spec-249)

<a id="spec-248"></a>
## SPEC-248 — Color each metric from its own value

Type: requirement | State: approved | Revision: 58

Color numeric metrics from their own displayed whole-unit value using the declared HR/power/cadence source, including rolling/activity/lap averages. Numeric HR/power-zone fields reuse the derived index; never classify an index as bpm/watts. HR and power use their independently selected global sources [SPEC-664](#spec-664) and [SPEC-663](#spec-663). Cadence retains [SPEC-252](#spec-252).

**Relations**

- allocated_to: [APP-3](#app-3), [APP-4](#app-4)
- part_of: [SPEC-233](#spec-233)
- uses: [DVS-7](#dvs-7), [SPEC-246](#spec-246), [SPEC-663](#spec-663), [SPEC-664](#spec-664)

<a id="spec-247"></a>
## SPEC-247 — Classify cadence using five disjoint zones

Type: requirement | State: approved | Revision: 11

For finite nonnegative displayed whole rpm, zone 1 is 0..t1; zones 2..4 are >preceding bound and <=own bound; zone 5 is >t4. Zero is valid; missing/negative/non-finite readings have no zone.

**Relations**

- part_of: [SPEC-233](#spec-233)
- uses: [DVS-7](#dvs-7), [SPEC-252](#spec-252)

<a id="spec-246"></a>
## SPEC-246 — Use seven explicit training colors

Type: requirement | State: approved | Revision: 24

Training zone colors: 1 blue #00AAFF; 2 green #00FF00; 3 yellow #FFAA00; 4 orange #FF5500; 5 red #FF0000; 6 magenta #FF00FF; 7 and above dark magenta #AA00AA. Preserve the actual numeric zone index. Unsupported/out-of-domain metadata uses neutral fallback. Theme and enlargement never alter semantic RGB. Dark magenta uses white label text; Whole cell also uses white value text, while Label coverage retains the ordinary value area and value text. HR and cadence retain their five-zone domains.

**Relations**

- part_of: [SPEC-233](#spec-233)

<a id="spec-245"></a>
## SPEC-245 — Bound the serialized settings dictionary

Type: requirement | State: approved | Revision: 12

Before app/test compilation, serialize the complete current property dictionary with the installed Garmin SDK. Require both defaults and the largest allowed values to be at most 8000 bytes. Include every key and serialization overhead; use 32 printable ASCII characters for maximum Team text. Fail compilation on excess or serializer failure and record both measured sizes. No runtime memory qualification is implied.

**Relations**

- part_of: [SPEC-233](#spec-233)
- uses: [SPEC-244](#spec-244)

<a id="spec-244"></a>
## SPEC-244 — Read current properties without compatibility migration

Type: requirement | State: approved | Revision: 15

Load only the current property catalogue. Do not declare legacy switches, schema markers or install-origin properties; do not read, convert or migrate old settings. Validate fallbacks without writing settings or clearing storage. Fresh schema defaults come directly from each property owner.

**Relations**

- part_of: [SPEC-233](#spec-233)
- uses: [SPEC-155](#spec-155)

<a id="spec-221"></a>
## SPEC-221 — Apply settings changes without replaying old events

Type: requirement | State: approved | Revision: 15

On changing the selected trigger or the effective selected activation/return pair, clear switching state and first select the default set. Threshold modes are next evaluated on a newly delivered eligible sample; lap/workout modes wait for the next qualifying callback. Selecting None or finding an invalid selected pair immediately selects default.

Changes limited to either set's presentation/assignments, or an unused threshold pair, retain the current switching state and apply the affected active set through [APP-32](#app-32). Do not replay cached lap/workout events. Changes shall preserve activity totals, lap baselines, grade and rolling sample history. Saved values are retained while their set/mode is inactive.

**Relations**

- part_of: [SPEC-207](#spec-207)
- uses: [APP-32](#app-32), [SPEC-211](#spec-211), [SPEC-212](#spec-212)

<a id="spec-220"></a>
## SPEC-220 — Reset switching state at activity and app boundaries

Type: requirement | State: approved | Revision: 14

Initialize every new foreground app instance on the default set; do not persist or reconstruct a previous threshold, lap-toggle or workout latch. onTimerReset(), including normal activity-end reset after save/discard, immediately selects default and clears all switching state. The next activity starts from default. Display page hide/show or an ordinary redraw shall not reset switching.

Pause, Auto Pause and manual timer stop preserve the active set and freeze threshold evaluation. On resume/start of the same activity, wait for a new producer-eligible sample before evaluating a threshold; do not reactivate from cached pre-pause input. The first delivered running sample after resume is evaluated even if the power window is still warming up: its unavailable result returns default under [SPEC-216](#spec-216). Do not retain the second set while waiting for three valid power samples. Lap and workout modes retain their latch across pause/stop/resume; qualifying delivered callbacks still apply. A restart or late attachment starts with unknown event history, so only subsequently delivered events may activate an event mode.

After onTimerReset(), ignore lap/workout-step notifications for switching until the next onTimerStart(), onTimerResume() or onWorkoutStarted(); this prevents a finalizing lap from relatching the ended activity. A subsequently delivered workout-start event both arms the new activity and activates Workout started mode. A known change in activity start-time identity also clears switching state; threshold modes may evaluate the new activity's fresh delivered sample, while event modes wait for a new qualifying event. Missing identity alone does not imply a change.

**Relations**

- part_of: [SPEC-207](#spec-207)
- uses: [SPEC-211](#spec-211), [SPEC-216](#spec-216)

<a id="spec-218"></a>
## SPEC-218 — Require Auto Lap disabled for legacy lap switching

Type: requirement | State: approved | Revision: 11

On Edge 530/830/1030, use onTimerLap() for Manual lap mode. Each delivered legacy lap callback toggles the active set once and processes its shared lap boundary once. The supported setup requires the rider to disable Auto Lap in the activity profile before using this mode. State in the mode's settings prompt and user guide: "Edge 530/830/1030: disable Auto Lap. This device cannot distinguish manual from automatic lap events."

The API exposes neither the cause through this callback nor a reliable Auto Lap setting check; do not claim the app detects or enforces the device setting. Other automatic lap sources, including workout-generated laps, are also indistinguishable: manual-only switching is supported only in activities without those sources. If this prerequisite is violated, automatic callbacks can toggle the set. Modern devices shall retain typed filtering even when Auto Lap is enabled. This restriction concerns switching, not ordinary lap-metric acquisition.

**Relations**

- part_of: [SPEC-207](#spec-207)
- uses: [FUNC-9](#func-9), [SPEC-211](#spec-211)

<a id="spec-216"></a>
## SPEC-216 — Return threshold modes to default on unavailable input

Type: requirement | State: approved | Revision: 11

During threshold evaluation, a missing or invalid selected source immediately selects the default set and clears hysteresis state. Do not replace missing input with zero or keep a stale last-good reading for trigger decisions. On recovery, evaluate from the default state: the first eligible value must reach activation again, even if the previous state before loss was second. A dropout in an unrelated channel shall not affect the selected trigger. Pause/stop retention and resume evaluation follow [SPEC-220](#spec-220).

**Relations**

- part_of: [SPEC-207](#spec-207)
- uses: [SPEC-220](#spec-220)

<a id="spec-215"></a>
## SPEC-215 — Evaluate the heart-rate event from current heart rate

Type: requirement | State: approved | Revision: 13

For Heart rate mode, compare the current Activity.Info.currentHeartRate reading used by [DVS-18](#dvs-18), before display rounding, against the heart-rate pair in [SPEC-212](#spec-212). Eligible readings are finite and greater than zero; zero, missing, negative and non-finite readings are invalid. Use current heart rate rather than the three-second average, activity/lap mean or zone. Evaluate this source independently of visible field assignments. Apply [SPEC-213](#spec-213) to each eligible delivered sample.

**Relations**

- part_of: [SPEC-207](#spec-207)
- uses: [DVS-18](#dvs-18), [SPEC-213](#spec-213)

<a id="spec-213"></a>
## SPEC-213 — Switch threshold modes with defined hysteresis

Type: requirement | State: approved | Revision: 16

For the selected power or heart-rate mode, let x be the valid unrounded source value, A its activation threshold and R its return threshold. Starting on the default set: switch to the second set when x >= A, otherwise retain the default. Starting on the second set: return to default when x < R, otherwise retain the second set. Thus R <= x < A retains the previous state, equality with A activates, and equality with R does not return. Apply the transition once after processing each delivered eligible sample. Add no dwell delay, debounce timer or extra smoothing beyond the selected source's acquisition contract. Missing input follows [SPEC-216](#spec-216).

**Relations**

- part_of: [SPEC-207](#spec-207)
- uses: [SPEC-212](#spec-212), [SPEC-216](#spec-216), [SPEC-220](#spec-220)

<a id="spec-212"></a>
## SPEC-212 — Configure separate activation and return thresholds

Type: requirement | State: approved | Revision: 14

Threshold options: [SPEC-336](#spec-336), [SPEC-337](#spec-337), [SPEC-338](#spec-338), [SPEC-339](#spec-339).

For each pair, return shall be less than or equal to activation. Settings prompts shall state this constraint. Validate each property's type/range under [APP-31](#app-31), using its own factory default for missing/malformed input. After that validation, if the selected mode's return exceeds activation, keep the default set until the pair is corrected; do not reorder, clamp, swap or rewrite the saved pair. An invalid unused pair shall not disable another selected mode. Equal thresholds are valid and use the exact comparisons in [SPEC-213](#spec-213).

**Relations**

- part_of: [SPEC-207](#spec-207)
- uses: [SPEC-213](#spec-213)

<a id="spec-211"></a>
## SPEC-211 — Select one activation event with Manual lap as default

Type: requirement | State: approved | Revision: 21

Activation option: [SPEC-335](#spec-335). Exactly one mode applies; events belonging to other modes shall not change the active set. None always displays the default set and preserves all saved second-set options. There is no independent enable switch. Manual-lap event handling and startup behavior follow [SPEC-218](#spec-218) and [SPEC-221](#spec-221); choosing this default does not bypass the legacy-device Auto Lap restriction.

**Relations**

- part_of: [SPEC-207](#spec-207)
- uses: [SPEC-218](#spec-218), [SPEC-221](#spec-221)

<a id="func-10"></a>
## FUNC-10 — Calculate bounded time-weighted lap sensor averages

Type: requirement | State: approved | Revision: 24

Keep constant-size sum, covered active ms and previous endpoint per lap channel. Pair a,b only within one activity/lap epoch, recording ON at both, finite stamps, 0<elapsed_b-elapsed_a<=2000 ms and 0<dt=timer_b-timer_a<=elapsed_b-elapsed_a; both values must satisfy their field validity.
sum += ((a+b)/2)*dt; covered_ms += dt; mean=sum/covered_ms, retaining raw precision. Invalid channel input breaks only its endpoint, adding no time/fabricated zero; retain earlier sums. No covered time is unavailable. Boundary capture may seed; otherwise first active compute only seeds.
Never bridge lap boundaries, pause/resume or >2000 ms gaps. Duplicates add no weight; out-of-order samples never pair with newer endpoints. Counter regression invalidates epoch; valid gap samples seed next pairs. Non-finite/overflow sums/denominators invalidate channel until next lap. Settings/visibility retain sums; post-load samples cannot repair missing baseline. Never derive from activity/three-second averages.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [FUNC-9](#func-9)

<a id="func-9"></a>
## FUNC-9 — Establish and retain the current observed lap baseline

Type: requirement | State: approved | Revision: 38

Maintain one activity/lap epoch for all slots. A fresh session is proven only by an observed completed reset followed by a new start, or a complete pre-activity snapshot (startTime=null, timerState=OFF, timerTime=elapsedTime=elapsedDistance=0) followed by start. Missing values are not zero; startup onTimerStart alone proves nothing.
Use zero first-lap baselines only after this proof. Late load/reload waits for a confirmed later lap boundary; that recovery does not establish a historical completed-lap total.
At each lap callback advance epoch, clear accumulators and capture current Activity.getActivityInfo() timerTime/elapsedDistance/elapsedTime, available startTime.value() and optional seeds. Missing counters are never zero, stale snapshots or later reconstruction: distance gates distance/speed; active timer gates time/speed/means. Integrate only in compute.
Legacy adapter is common; a qualified typed adapter handles once and returns true to prevent fallback duplication. Workout-step-only events never reset laps. The callback follows FIT writing but exposes no exact native boundary timestamp; qualify freshness/error and manual/automatic/workout/hidden-page delivery before native-equivalence claims.
Pause/stop preserve baselines/sums but clear endpoints; resume seeds a new active pair. Settings/visibility/draw preserve state. Reset/save/discard ends epoch, ignoring old finalization events. Identity change, regressing counters, lost continuity or overflow invalidates affected current-lap values until a proven boundary. Bind identity when available; missing identity alone is no change. Never reconstruct history or invent stopped-distance corrections.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-16](#app-16)

<a id="dvs-51"></a>
## DVS-51 — Inverse theme for enlarged fields option

Type: requirement | State: approved | Revision: 78

Options: [SPEC-306](#spec-306), [SPEC-344](#spec-344). True gives enlarged cells the opposite base Day/Night palette; false retains base. Regular cells/separators/compact fallback never invert. Apply effective palette to ordinary/neutral regions, not semantic RGB; preserve acquisition/layout.

**Relations**

- part_of: [DVS-1](#dvs-1)
- uses: [APP-45](#app-45)

<a id="spec-177"></a>
## SPEC-177 — Reject missing or surplus font glyphs during generation and verification

Type: requirement | State: approved | Revision: 36

Record traced inputs/revisions/hashes, role/size/language, expected/generated code points, encoding, source ink/advance metrics and output hashes in a reproducible manifest. Fail generation/build for missing/surplus/duplicate glyphs, opaque undeclared pixels, bad/overlapping rectangles, source mask/metric mismatch or nonreproducibility; identify role/size/code points. Negative fixtures reject missing f in ft, an unused numeric letter and opaque padding. Reachable-text changes require regeneration; compile/load all profiles. Native-font qualification and runtime memory remain separate.

**Relations**

- part_of: [SPEC-175](#spec-175)
- uses: [SPEC-154](#spec-154), [SPEC-176](#spec-176)

<a id="spec-176"></a>
## SPEC-176 — Bundle exactly the glyphs that each application font role can render

Type: requirement | State: approved | Revision: 28

For each bundled role/language, RequiredGlyphs is the union of reachable code points across all fields/settings/units/formats/statuses. English initially; include spaces/casing only where rendered. Generated identifiers must equal this set exactly, without missing/surplus glyphs; undeclared atlas/padding pixels are transparent. Source-TTF inventories and nonrendered metadata are not runtime inventories. Never filter to the current screen. Native user text is excluded, but its fixed bundled header is included.

**Relations**

- part_of: [SPEC-175](#spec-175)
- uses: [APP-25](#app-25)

<a id="spec-162"></a>
## SPEC-162 — Define development milestones and traceable release evidence

Type: requirement | State: approved | Revision: 24

Assess environment/skeleton, core behavior, then effects/acquisition/qualification as separate milestones. Every release requirement needs implemented code and a verification method/evidence; environment tests are not complete product coverage. Maintain exact requirement-to-code/Test/scenario/product/revision/outcome traceability. Reviewed decisions, compatible resources/settings and required simulator/hardware evidence gate release; missing evidence is not full completion.
Executions record time, captured baseline Test/target versions, environment/product, source/binary/raw-log hashes, expected/observed result and actual outcome. A named Monkey C PASS block plus successful suite summary is required; suite duration is not per-case duration. Approval never creates a pass. Preserve historical executions at captured revisions; changed unexecuted scope remains unrun/blocked.

**Relations**

- part_of: [SPEC-150](#spec-150)
- uses: [SPEC-159](#spec-159), [SPEC-160](#spec-160), [SPEC-161](#spec-161)

<a id="spec-161"></a>
## SPEC-161 — Record unresolved product decisions before closing dependent development tasks

Type: requirement | State: approved | Revision: 22

Maintain a versioned decision register identifying each unresolved decision, owner, affected requirements, selected rule/rationale and review state. An unresolved decision blocks only its dependent acceptance. Record specification approval, implementation and qualification separately; do not claim source provenance or measured results from guesses.

**Relations**

- part_of: [SPEC-150](#spec-150)

<a id="spec-159"></a>
## SPEC-159 — Provide physical-device and memory-performance qualification procedures

Type: requirement | State: approved | Revision: 12

Before hardware qualification, review representative old/new model coverage, duration/repetitions and instrumentation method/overhead. On actual devices exercise compute/draw, Garmin Connect delivery/persistence, themes, sensor loss/recovery and maximum resources; measure deadlines and total/used/free memory.
Temperature requires per-model/firmware onboard-source and external-pairing evidence; representative sampling cannot waive it. Record environment/build/settings/source, timings, peak used/minimum free, errors/outcome and foreground/background scopes. Missing hardware, unresolved source or unreviewed plan remains unverified, never passed.

**Relations**

- part_of: [SPEC-150](#spec-150)
- uses: [APP-37](#app-37), [APP-38](#app-38), [APP-48](#app-48), [DVS-34](#dvs-34)

<a id="spec-158"></a>
## SPEC-158 — Exercise and record the complete nine-device simulator scenario matrix

Type: requirement | State: approved | Revision: 11

Run the versioned simulator scenario matrix on every declared product, with exact settings/fixtures and assigned bounds. Cover full/compact layouts, enlargement, alignments/themes, maximum count, missing data, initial draw-before-compute, gaps/pause/resume, settings/rebuilds, duplicate slots and every semantic/neutral effect boundary. Capture images with explicit expected cell/text/unused-area rules; image existence alone is no visual pass.
Report each missing product/compiler/runtime failure independently and bind evidence to inputs. Honor suite separation: compact cases require Placement and diagnostics require Memory requests. Simulator results never substitute for hardware qualification.

**Relations**

- part_of: [SPEC-150](#spec-150)
- uses: [APP-24](#app-24), [APP-38](#app-38), [SPEC-157](#spec-157), [SPEC-162](#spec-162)

<a id="spec-157"></a>
## SPEC-157 — Run deterministic Monkey C tests for formatting, settings and sample processing

Type: requirement | State: approved | Revision: 73

Execute Toybox.Test/Run No Evil against production routines; host approximations never replace Monkey C execution. Use separate inventories:
- Core (default after changes/CI): values/settings/formatting/normal UI, source/lifecycle boundaries, cache invalidation and draw purity. For every guaranteed range, check min/interior/max/width transitions with exact text and real glyph/halo bounds, applicable units/clocks/roles/alignments. Required cases fail on overflow/compact fallback; report no-guarantee contexts explicitly.
- Memory (explicit request only): font probes and normal Data Field allocation qualification.
- Placement (explicit request only): deliberate insufficient areas, overflow, unsupported contexts and compact fallback.
Core must never invoke the other suites or memory instrumentation. Cover unchanged records/refits/header metrics/geometry, rounded-equivalent readings, channel/profile invalidation, duplicate/zone reuse, old snapshot retention, polygons, live preferences/effects/settings, optional queries and first/repeated onUpdate paths. Record selected suite, actual named results/failures and matching inputs. These operation assertions do not establish battery/memory/hardware qualification.

**Relations**

- part_of: [SPEC-150](#spec-150)
- uses: [APP-24](#app-24), [APP-26](#app-26), [APP-34](#app-34), [SPEC-162](#spec-162)

<a id="spec-156"></a>
## SPEC-156 — Specify each displayed value acquisition path and deterministic sensor fixtures

Type: requirement | State: approved | Revision: 23

Generate the acquisition/code/fixture traceability table from canonical field and shared acquisition owners. Record source member/algorithm, context, raw type/unit, validity, clock/update/reset authority and qualification state; do not maintain a second normative field catalogue. Use anonymized timestamped fixtures for missing/non-finite/zero, gaps, units, pause/resume and boundaries; fixture success is not source qualification.

**Relations**

- part_of: [SPEC-150](#spec-150)

<a id="spec-154"></a>
## SPEC-154 — Reproduce Garmin-compatible Roboto Condensed resources within the memory budget

Type: requirement | State: approved | Revision: 43

Generate the three exact profile roles/sizes from versioned licensed source fonts. Record source/license and generator/dependency versions/hashes; provide a deterministic regeneration command with matching outputs. Use the exact-glyph validation contract and compile/load resources for every profile; compilation is not runtime memory qualification.

**Relations**

- part_of: [SPEC-150](#spec-150)
- uses: [APP-24](#app-24), [APP-25](#app-25), [SPEC-176](#spec-176), [SPEC-177](#spec-177)

<a id="spec-151"></a>
## SPEC-151 — Record and verify a reproducible Connect IQ development toolchain

Type: requirement | State: approved | Revision: 9

Record exact developer/CI OS, Connect IQ SDK/compiler/simulator, device-package revisions/hashes, Java distribution/version and font tools in a versioned toolchain manifest. SDK version and minimum app API are separate. Select compatible versions by compiling every declared product; no unrecorded floating latest inputs.
Document Garmin-supported dependency/account provisioning for fresh developers and CI, copyable setup/check/build/test commands and expected results. Environment checks report resolved paths/versions/device packages and actionable missing prerequisites. CLI is authoritative; optional VS Code/Monkey C settings use the same toolchain.

**Relations**

- part_of: [SPEC-150](#spec-150)
- uses: [APP-24](#app-24)

<a id="app-47"></a>
## APP-47 — Apply per-device Connect IQ Data Field memory ceilings

Type: requirement | State: approved | Revision: 21

Every declared candidate Data Field has a ceiling of 131072 bytes (128 KiB). This is not measured free heap: qualification must satisfy both the ceiling and actual runtime allocation. Review vendor/device-package limit changes before changing supported profiles.

**Relations**

- part_of: [APP-1](#app-1)
- uses: [APP-24](#app-24)

<a id="dvs-45"></a>
## DVS-45 — Keep slope and temperature palette extensions separate

Type: requirement | State: approved | Revision: 43

Additional semantic colors: dark red #AA0000, black #000000, cyan #00FFFF, white #FFFFFF. These are palette names, not extra training zones. Field band tables select these or the common blue/green/yellow/orange/red colors; theme never changes semantic RGB.

**Relations**

- allocated_to: [APP-4](#app-4)
- part_of: [DVS-1](#dvs-1)
- uses: [SPEC-246](#spec-246)

<a id="app-46"></a>
## APP-46 — Configure visible fields in Garmin Connect

Type: requirement | State: approved | Revision: 73

Expose the owned typed settings through Garmin Connect for both banks and every field. No on-device editor required. Use specified captions/order, retain valid saved choices and apply changes without restarting activity.

**Relations**

- allocated_to: [APP-3](#app-3)
- part_of: [APP-1](#app-1)
- uses: [SPEC-155](#spec-155), [SPEC-210](#spec-210)

<a id="app-45"></a>
## APP-45 — Support day and night themes on Garmin devices

Type: requirement | State: approved | Revision: 60

Options: [SPEC-304](#spec-304), [SPEC-342](#spec-342). Auto uses supported device night state/notifications, otherwise Day. Regular cells/separators/compact fallback use base palette; enlargement derives effective palette. Theme updates preserve data/layout/semantic colors.

**Relations**

- allocated_to: [APP-4](#app-4)
- part_of: [APP-1](#app-1)
- uses: [APP-39](#app-39), [APP-40](#app-40)

<a id="dvs-40"></a>
## DVS-40 — Convert SDK units before displaying values

Type: requirement | State: approved | Revision: 30

Normalize raw SDK units exactly once before formatting: m/s to selected speed unit, metres to selected distance/elevation unit, Celsius to selected temperature unit, milliseconds to duration seconds and radians to degrees where declared. Never reconvert normalized values.

**Relations**

- allocated_to: [APP-3](#app-3)
- part_of: [DVS-1](#dvs-1)
- uses: [DVS-4](#dvs-4)

<a id="app-38"></a>
## APP-38 — Qualify the declared Garmin device matrix

Type: requirement | State: approved | Revision: 57

Qualify each declared target independently: APIs/resources, full-screen/compact layouts, enlargement/alignments/themes, missing data, settings delivery, all field types, semantic/neutral colors and native glyph/drawing capabilities. Constant/TTF presence alone never qualifies a font. Report failing candidates; do not advertise them as supported. Simulator and model/firmware-specific physical source/callback qualification are distinct.

**Relations**

- allocated_to: [APP-2](#app-2)
- part_of: [APP-1](#app-1)
- uses: [APP-24](#app-24), [APP-47](#app-47), [APP-48](#app-48), [SPEC-159](#spec-159)

<a id="app-37"></a>
## APP-37 — Stay within device memory and refresh budgets

Type: requirement | State: approved | Revision: 37

Process each delivered compute once and prepare its snapshot in <1000 ms without backlog, subject to stricter device limits. Redraw consumes latest snapshot independently of ordering. Production continuous memory/deadline diagnostics stay disabled; explicit validation builds may enable them. No stats queries solely for diagnostics or unevidenced battery-saving claims.

**Relations**

- allocated_to: [APP-3](#app-3), [APP-4](#app-4)
- part_of: [APP-1](#app-1)
- uses: [APP-26](#app-26)

<a id="app-35"></a>
## APP-35 — Show unavailable activity values without stale readings

Type: requirement | State: approved | Revision: 47

Missing/unsupported/invalid-type/out-of-domain/non-finite numeric readings show -- with header retained. Unfit finite complete values show !. Never fabricate zero or retain invalid current readings. Evaluate fields independently; accumulated/cache retention follows acquisition contracts. Text fields declare setting/fit fallback.

**Relations**

- allocated_to: [APP-3](#app-3)
- part_of: [APP-1](#app-1)

<a id="app-32"></a>
## APP-32 — Apply changed settings without restarting an activity

Type: requirement | State: approved | Revision: 81

On changed settings, validate and prepare one coherent presentation before next redraw without restarting/resetting activity. Reuse unaffected descriptors/fits/geometry/resources; grid-only changes refresh separators alone. Refresh unit/clock/theme inputs even without an app-settings callback. Refit only for changed text/header/font/bounds/clearance; mode/color-only changes otherwise replace affected packets.
Saved selections and shared Team text must survive restart. Settings serialization, callback validation and presentation replacement must succeed within the unmodified target limits; never silently treat a failed save as applied.

**Relations**

- allocated_to: [APP-2](#app-2)
- part_of: [APP-1](#app-1)
- uses: [APP-26](#app-26), [APP-41](#app-41)

<a id="hfer-8"></a>
## HFER-8 — Draw the Horizontal lines pattern

Type: requirement | State: approved | Revision: 29

Apply this pattern only when Grid type is Horizontal lines under [APP-22](#app-22), independently of text alignment.

Draw no vertical separator. Draw a one-pixel horizontal line at the bottom pixel of each regular cell, including the last row, with no line across enlarged cells. Split each cell width into 16 equal integer-bounded segments from left to right; omit empty segments.

For segment index i=0..15, q = floor(96*(i+1)/16). Night uses RGB(q,q,q); Day uses RGB(255-q,255-q,255-q), giving increasing contrast toward the right. Use the base palette, preserve cell boundaries and clip under [APP-34](#app-34). Reference: [horizontal line pattern](attachments/right-delimiters.png).

**Relations**

- part_of: [APP-1](#app-1)
- uses: [APP-34](#app-34), [APP-45](#app-45)

<a id="hfer-7"></a>
## HFER-7 — Draw the Full grid pattern

Type: requirement | State: approved | Revision: 29

Apply this pattern only when Grid type is Full grid under [APP-22](#app-22), independently of text alignment.

Draw one-pixel horizontal separators between regular rows and a vertical separator between regular columns. Do not cross enlarged cells or add an outer border. Split each cell-length line into 16 equal integer-bounded segments; omit empty segments.

For horizontal segments, use their global horizontal midpoint p and display width W: intensity q = floor(96 * clamp(1 - abs(p-W/2)/(W/2), 0, 1)). For vertical segments, use the global vertical midpoint and display height in the same formula. Night uses RGB(q,q,q); Day uses RGB(255-q,255-q,255-q). Use the base palette even beside enlarged inverted cells.

Place horizontal lines at each regular row's bottom pixel except the last display row, and the vertical line at the right column's left pixel. Fit and clip to assigned bounds under [APP-34](#app-34). Reference: [full grid pattern](attachments/center-delimiters.png).

**Relations**

- part_of: [APP-1](#app-1)
- uses: [APP-34](#app-34), [APP-45](#app-45)

<a id="dvs-13"></a>
## DVS-13 — Duration values display format

Type: requirement | State: approved | Revision: 68

Truncate nonnegative durations to whole seconds. Primary is two-digit MM below one hour, then unpadded H:MM; minutes always two digits and hours never wrap. Below 10 h append `.SS` with two-digit seconds in the smaller secondary role; at >=10 h omit dot/seconds. Unit visibility does not affect components; invalid duration has no fabricated seconds.
Examples: 0 s -> 00 + .00; 65 s -> 01 + .05; 9:59:59 -> 9:59 + .59; 10 h -> 10:00; 100 h -> 100:00.

**Relations**

- allocated_to: [APP-4](#app-4)
- part_of: [DVS-1](#dvs-1)
- uses: [APP-35](#app-35), [DVS-3](#dvs-3)

<a id="dvs-7"></a>
## DVS-7 — Display valid integral values within field bounds

Type: requirement | State: approved | Revision: 61

Round finite integral-format values to the nearest whole number, exact halves away from zero. No fraction/positive sign; minus only for a negative result, suppressing negative zero.

**Relations**

- allocated_to: [APP-4](#app-4)
- part_of: [DVS-1](#dvs-1)

<a id="dvs-3"></a>
## DVS-3 — Position numeric secondary text beside the primary value

Type: requirement | State: approved | Revision: 89

Draw numeric secondary text in the label font two pixels after the primary, with aligned visible glyph tops. Align the complete group as one value. Omission reserves neither width nor gap; physical units belong in headers.

**Relations**

- allocated_to: [APP-4](#app-4)
- part_of: [DVS-1](#dvs-1)
- uses: [APP-21](#app-21), [APP-25](#app-25)

<a id="dvs-2"></a>
## DVS-2 — Format decimals using field precision and value magnitude

Type: requirement | State: approved | Revision: 64

Use declared fixed precision, or magnitude precision on abs(converted value): <10 -> 2 decimals; [10,100) -> 1; >=100 -> 0, independently of sign. Round exact halves away from zero and retain trailing zeros. If rounding crosses a band, select its precision and reround the original converted value (9.995 -> 10.0; 99.95 -> 100), including negatives. Print minus only for a negative formatted result; suppress negative zero/positive signs.

**Relations**

- allocated_to: [APP-4](#app-4)
- part_of: [DVS-1](#dvs-1)

<a id="app-23"></a>
## APP-23 — Choose grid row capacity from the assigned drawing area

Type: requirement | State: approved | Revision: 32

Try the profile's row capacity in actual assigned bounds. Only five-row profiles may retry four; four-row profiles never promote. With chosen enlargement accept only a complete permitted grid; otherwise compact fallback.

**Relations**

- allocated_to: [APP-3](#app-3)
- part_of: [APP-1](#app-1)
- uses: [APP-20](#app-20), [APP-24](#app-24), [APP-34](#app-34)

<a id="app-22"></a>
## APP-22 — Select grid independently of alignment

Type: requirement | State: approved | Revision: 68

Options: [SPEC-307](#spec-307), [SPEC-345](#spec-345). Independent of alignment; use its shared line pattern. None/compact fallback draws no grid. Refresh separator commands alone on change, preserving geometry/fonts/text/background/acquisition.

**Relations**

- allocated_to: [APP-4](#app-4)
- part_of: [APP-1](#app-1)
- uses: [HFER-7](#hfer-7), [HFER-8](#hfer-8)

**Attachments**

- [center-delimiters.png](attachments/center-delimiters.png) — illustrates
- [right-delimiters.png](attachments/right-delimiters.png) — illustrates

<a id="app-21"></a>
## APP-21 — Align field labels and values at center or right

Type: requirement | State: draft | Revision: 100

Options: [SPEC-303](#spec-303), [SPEC-341](#spec-341). Independently centre complete header/value-plus-secondary groups, or align both to the usable right edge; preserve cell order/size.
Reserve R=max(label line height, shared band height) in every cell, including effects-off. Centre primary visible bounds at y+R+(h-R)/2 with <=1 px error. Header/preferences/colors never alter R; positions change only for changed bounds. Fields may declare native value-block fitting within this same header reservation.

**Relations**

- allocated_to: [APP-4](#app-4)
- part_of: [APP-1](#app-1)
- uses: [APP-25](#app-25), [DVS-12](#dvs-12)

**Attachments**

- [center-ui-8-2.png](attachments/center-ui-8-2.png) — illustrates
- [right-ui-8-2.png](attachments/right-ui-8-2.png) — illustrates

<a id="tstfunc-5"></a>
## TSTFUNC-5 — SDK runner process ownership and cleanup

Type: test | State: approved | Revision: 5

Suite: Core (host prerequisite). Run scripts/test-sdk-runner.ps1. Exercise successful exit, nonzero exit, timeout and controller disposal with an active child; include a child surviving its immediate parent. Require bounded cleanup of every owned descendant, unchanged completed exit codes, readable preserved stdout/stderr with released file handles, and survival of an unrelated sentinel process. No simulator or physical qualification is claimed.

**Relations**

- verifies: [SPEC-153](#spec-153), [SPEC-160](#spec-160)

<a id="tstfunc-4"></a>
## TSTFUNC-4 — Core: compact properties, defaults and field applicability

Type: test | State: approved | Revision: 29

Suite: Core. Compare all 75 property keys/types/defaults/limits against generated XML and their individual requirements. Require unique lowercase keys <=8 characters, one shared Team option set and no hidden/legacy/schema properties. Verify complete numeric field mapping, both presets, editable captions and read-only per-bank fallbacks. Validate every property description field link and uses relation against its applicability list. Run typedSettingsAndHiddenSlots, secondSetSettings, presentationSettingsAndUnits and nativeSettingsCallbacks; restore native saved values. Before compilation, serialize defaults and maximum valid values with the installed Garmin SDK and require both <=8000 bytes. Record exact byte counts, current source and product. Do not infer Memory, Placement or hardware results.

Extend the catalogue by the twelve custom-zone properties in [SPEC-300](#spec-300) (75 total); the native save/reload/restart and SDK serialized-size cases are defined in [TSTFUNC-10](#tstfunc-10).

**Relations**

- verifies: [FR-16431](#fr-16431), [FR-16432](#fr-16432), [FR-16433](#fr-16433), [FR-16434](#fr-16434), [FR-16435](#fr-16435), [FR-16436](#fr-16436), [FR-16437](#fr-16437), [FR-16438](#fr-16438), [FR-16439](#fr-16439), [FR-16440](#fr-16440), [FR-16441](#fr-16441), [FR-16442](#fr-16442), [SPEC-243](#spec-243), [SPEC-244](#spec-244), [SPEC-245](#spec-245), [SPEC-301](#spec-301), [SPEC-302](#spec-302), [SPEC-303](#spec-303), [SPEC-304](#spec-304), [SPEC-305](#spec-305), [SPEC-306](#spec-306), [SPEC-307](#spec-307), [SPEC-308](#spec-308), [SPEC-310](#spec-310), [SPEC-311](#spec-311), [SPEC-312](#spec-312), [SPEC-313](#spec-313), [SPEC-314](#spec-314), [SPEC-315](#spec-315), [SPEC-316](#spec-316), [SPEC-317](#spec-317), [SPEC-318](#spec-318), [SPEC-319](#spec-319), [SPEC-320](#spec-320), [SPEC-321](#spec-321), [SPEC-322](#spec-322), [SPEC-323](#spec-323), [SPEC-324](#spec-324), [SPEC-325](#spec-325), [SPEC-326](#spec-326), [SPEC-327](#spec-327), [SPEC-328](#spec-328), [SPEC-329](#spec-329), [SPEC-330](#spec-330), [SPEC-331](#spec-331), [SPEC-332](#spec-332), [SPEC-333](#spec-333), [SPEC-334](#spec-334), [SPEC-335](#spec-335), [SPEC-336](#spec-336), [SPEC-337](#spec-337), [SPEC-338](#spec-338), [SPEC-339](#spec-339), [SPEC-340](#spec-340), [SPEC-341](#spec-341), [SPEC-342](#spec-342), [SPEC-343](#spec-343), [SPEC-344](#spec-344), [SPEC-345](#spec-345), [SPEC-346](#spec-346), [SPEC-347](#spec-347), [SPEC-348](#spec-348), [SPEC-349](#spec-349), [SPEC-350](#spec-350), [SPEC-351](#spec-351), [SPEC-352](#spec-352), [SPEC-353](#spec-353), [SPEC-354](#spec-354), [SPEC-355](#spec-355), [SPEC-356](#spec-356), [SPEC-357](#spec-357), [SPEC-358](#spec-358), [SPEC-359](#spec-359), [SPEC-360](#spec-360), [SPEC-361](#spec-361), [SPEC-362](#spec-362), [SPEC-363](#spec-363), [SPEC-364](#spec-364), [SPEC-365](#spec-365), [SPEC-669](#spec-669)

<a id="tstfunc-3"></a>
## TSTFUNC-3 — Native properties persistence and settings callback

Type: test | State: approved | Revision: 11

Suite: Core. Run native Properties writes under a separate test application identity; never change production preferences. Write numeric selections, alignment/grid and shared Team text/color source through Application.Properties, then call the app onSettingsChanged after initial layout. Verify duplicate Team values, settings in both banks, unchanged active-bank latch and reload through FieldSetsSettings.load. Restore original test-app properties. Separately save in the simulator editor and restart the normal app; verify retained values, callback application and no serialization error. Report editor/restart evidence separately from in-process tests. Executable: nativeSettingsCallbacks in tests/FieldSetTests.mc.
Regression: start with a numeric first slot, expire the layout Dc, save Team in slots 1/2 and call onSettingsChanged. Require zero native width reads during the settings callback, pending fitting, and Team text on the next redraw with a fresh scoped Dc. Expire it again; unchanged refreshes must not measure. Switch banks and edit shared text with the Dc expired; the next valid redraw must show the new text, with no retained Dc after return.

**Relations**

- verifies: [APP-32](#app-32), [SPEC-253](#spec-253)

<a id="tstfunc-2"></a>
## TSTFUNC-2 — Mixed Team and metric layouts through typed lap callbacks

Type: test | State: approved | Revision: 9

Suite: Core. After native font measurement and initial layout, call production onTimerLap2 with manual metadata on supported profiles, and onTimerLap on legacy profiles. Switch mixed Team/metric banks four times per 0/1/2-enlarged layout and None/Label/Whole cell coverage, alternating alignments. Keep slot 1 Team and slot 2 numeric in both banks, including the two-visible-slot layout. Assert active bank, shared Team text, native text draw commands and numeric draw commands. When slot 3 is visible, make it a duplicate Team and assert the same shared text. Never index a hidden slot. No stack/serialization errors or compact fallback. Executable: mixedTeamLapCallbacks in tests/FieldSetTests.mc.
Expire the drawing context after each layout/update. Deliver lap callbacks while it is expired; require no width access until a fresh drawing callback and no retained Dc afterward.

**Relations**

- verifies: [APP-26](#app-26), [SPEC-217](#spec-217), [SPEC-218](#spec-218), [SPEC-253](#spec-253)

<a id="tstfunc-1"></a>
## TSTFUNC-1 — Verify battery percentage validity before rounding

Type: test | State: approved | Revision: 9

Suite: Core. Definition; execution evidence is separate.

Through the production formatter verify [DVS-35](#dvs-35): 0, 50 and 100 remain valid; 50.4 displays 50 and 50.6 displays 51 under [DVS-7](#dvs-7). Inputs -0.01, 100.01, missing, NaN and infinities display --; do not clamp or round an out-of-range input into validity. Check battery header/unit visibility separately under [DVS-50](#dvs-50) and preserve a valid zero. No memory sampling is part of this test.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [DVS-35](#dvs-35)

<a id="spec-299"></a>
## SPEC-299 — Verify Team preparation invalidation

Type: test | State: approved | Revision: 9

Suite: Core. Definition; execution evidence is separate.

Instrument fitting, capability discovery, compute and drawing with unchanged inputs and shared text/font/source edits and isolated slot bounds/theme/coverage edits. Assert only required work runs, no font search/geometry calculation occurs in ordinary drawing, and duplicates add no samples. Shared text/font/source changes update every affected Team presentation; earlier snapshots retain their old content.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [APP-26](#app-26)

<a id="spec-298"></a>
## SPEC-298 — Verify automatic Team fitting preserves settings

Type: test | State: approved | Revision: 8

Suite: Core. Verify automatic font fitting never rewrites shared Team text, source or slot assignments/coverage. Empty text retains its header, unchanged values reuse fitted runs, and text edits refit during a current layout callback. Missing-candidate and deliberate no-fit cases remain in Placement and require an explicit request.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [SPEC-253](#spec-253)

<a id="spec-297"></a>
## SPEC-297 — Verify automatic Team font eligibility

Type: test | State: approved | Revision: 11

Suite: Core. Verify the fixed native FONT_XTINY/TINY/SMALL/MEDIUM/LARGE candidate set and largest complete-block fit with the existing tie rule. The settings and properties expose no Team font selector or font code. Verify shared text survives settings refresh and bank switches; report actual native drawing separately from deterministic wrapping metrics.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [APP-38](#app-38), [SPEC-176](#spec-176), [SPEC-177](#spec-177), [SPEC-253](#spec-253)

<a id="spec-295"></a>
## SPEC-295 — Verify Team insufficient-area handling

Type: test | State: approved | Revision: 7

Suite: Placement. On explicit request, test Team values with overlong words, oversized fonts and insufficient value area: expect !, then no value when ! cannot fit, while retaining the team header and other cells. When the fixed header itself cannot fit, use the shared grid fallback under [APP-34](#app-34). Repeat regular/enlarged cells, both alignments/themes and sets.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [SPEC-253](#spec-253)

<a id="spec-294"></a>
## SPEC-294 — Verify Team coloring regions

Type: test | State: approved | Revision: 8

Suite: Core. Render None, Label and Whole cell with semantic/neutral colors in both themes, alignments, sets and regular/enlarged slots. Assert Label fills only the common full-width team header band, Whole fills the cell, and None keeps ordinary backgrounds. Check header/value contrast independently and unchanged wrap/positions across color-only edits.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [SPEC-253](#spec-253)

<a id="spec-293"></a>
## SPEC-293 — Verify Team source binding and fallback

Type: test | State: approved | Revision: 14

Suite: Core. Definition; execution evidence is separate.

Hide all numeric power/HR fields, bind Team to each source, vary zones and verify shared classifications. Test None, zero watts, invalid HR/profile, recovery and all coverage modes while text stays unchanged.

For qualified Power binding zone 6 assert magenta #FF00FF with black text; zones >=7 use dark magenta #AA00AA with white text over the fill under [SPEC-246](#spec-246). Label coverage retains ordinary value text. Retain Team string and selected coverage. HR and cadence retain five-zone classification.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [SPEC-253](#spec-253), [SPEC-665](#spec-665)

<a id="spec-292"></a>
## SPEC-292 — Verify native Team font selection

Type: test | State: approved | Revision: 11

Suite: Core. Verify greedy space-only wrapping with repeated spaces, one-line and multiline values. Assert words remain whole and within-line spaces survive. Using deterministic metrics and native drawing, verify the largest complete-block fit and tie rule, fixed native candidate eligibility and unchanged fit cache on source/color-only changes. No-fit cases belong to Placement.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [APP-25](#app-25), [SPEC-253](#spec-253)

<a id="spec-290"></a>
## SPEC-290 — Verify Team settings isolation

Type: test | State: approved | Revision: 11

Suite: Core. Set one shared Team text and color source. Hide/reassign duplicate slots, disable the second set, switch banks and reload: all Team slots retain the shared values. Exactly two Team properties exist. Slot assignments and coverage remain independent.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [SPEC-208](#spec-208), [SPEC-253](#spec-253)

<a id="spec-289"></a>
## SPEC-289 — Verify Team literal rendering

Type: test | State: approved | Revision: 12

Suite: Core. Render TEAM, mixed case, digits, punctuation, repeated spaces and empty text in both sets with units shown/hidden. Assert the exact lowercase team header, unchanged user value and no physical unit or numeric conversion. Empty text retains the header. Render duplicate Team assignments in both sets, including regular/enlarged cells: assert the shared text updates every visible Team value and previous snapshots remain unchanged.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [DVS-12](#dvs-12), [DVS-50](#dvs-50), [SPEC-156](#spec-156), [SPEC-253](#spec-253)

<a id="spec-288"></a>
## SPEC-288 — Verify Team binding options

Type: test | State: approved | Revision: 7

Suite: Core. Definition; execution evidence is separate.

Check keys/types/captions/defaults for all 20 slots, each valid code and invalid Boolean/fraction/unknown values. Verify binding and coverage remain independent through reload and bank switching.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [SPEC-253](#spec-253)

<a id="spec-287"></a>
## SPEC-287 — Verify Team text options

Type: test | State: approved | Revision: 11

Suite: Core. Check exactly two shared Team controls before every slot control: Team name and Team color source, with no font selector, hidden font property or per-slot/second-set copies. Verify Slot N captions and text default/empty/32/33 characters/spaces/case/wrong types/non-ASCII validation. All duplicate, hidden and reassigned Team slots use the shared text and source after reload/switches; coverage remains independent.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [SPEC-253](#spec-253)

<a id="spec-286"></a>
## SPEC-286 — Verify Team catalogue compatibility

Type: test | State: approved | Revision: 8

Suite: Core. Definition; execution evidence is separate.

Check generated/runtime choices 0..32, exact team identifier/caption and all old mappings. Upgrade saved assignments in both banks and verify their layout, presets and switching remain unchanged.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [APP-46](#app-46), [SPEC-155](#spec-155), [SPEC-210](#spec-210), [SPEC-253](#spec-253)

<a id="spec-285"></a>
## SPEC-285 — Verify cadence option validation

Type: test | State: approved | Revision: 5

Suite: Core. Definition; execution evidence is separate.

Check types/keys/defaults, all boundary limits, Boolean/fractional/negative/>300 values, equal/reversed bounds and partially absent settings. Assert shared profile across both sets and unchanged stored invalid data.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [SPEC-252](#spec-252)

<a id="spec-283"></a>
## SPEC-283 — Verify classification cache isolation

Type: test | State: approved | Revision: 7

Suite: Core. Definition; execution evidence is separate.

Instrument source/classifier calls across duplicates, zone fields and Team bindings. Change one reading/profile/coverage and assert only dependent records change; old snapshots and other channels remain unchanged.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [APP-26](#app-26)

<a id="spec-282"></a>
## SPEC-282 — Verify zone fallback and recovery

Type: test | State: approved | Revision: 5

Suite: Core. Definition; execution evidence is separate.

Inject invalid readings/profiles separately and together, including malformed cadence bounds and unsupported native power metadata. Verify neutral fill, preserved valid readings, None suppression and recovery without a restart.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [SPEC-249](#spec-249)

<a id="spec-281"></a>
## SPEC-281 — Verify all metric family colors

Type: test | State: approved | Revision: 12

Suite: Core. Definition; execution evidence is separate.

Provide simultaneous current, 3s, activity-average and lap values in different zones; verify each family and numeric-zone field. Include measured zero watts/rpm, missing lap coverage and duplicate slots with different modes.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [SPEC-155](#spec-155), [SPEC-248](#spec-248)

<a id="spec-280"></a>
## SPEC-280 — Verify cadence boundary table

Type: test | State: approved | Revision: 5

Suite: Core. Definition; execution evidence is separate.

For defaults and edited thresholds test below/equal/above every bound, rounding across a bound, zero and invalid readings. Assert exactly one zone for every valid nonnegative displayed value.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [SPEC-247](#spec-247)

<a id="spec-279"></a>
## SPEC-279 — Verify exact seven-zone colors

Type: test | State: approved | Revision: 11

Suite: Core. Definition; execution evidence is separate.

Assert exact shared RGB values for HR/cadence zones 1..5 and power zones 1..7 plus native zone 10 across both themes, inversion and coverage modes. Include white foreground on dark magenta and unchanged value foreground for Label coverage. Verify grade dark-red/black and temperature cyan/white remain available and are not training zones.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [DVS-45](#dvs-45), [SPEC-246](#spec-246)

<a id="spec-278"></a>
## SPEC-278 — Verify serialized property budget

Type: test | State: approved | Revision: 6

Suite: Core build checks. Invoke scripts/check-properties.ps1 with the installed Garmin SDK serializer. Serialize all current keys/defaults and maximum allowed Team text; both sizes must be <=8000 bytes, including overhead. Require nonzero exit for an oversized dictionary or serializer failure. Verify invalid keys and duplicate declarations are rejected. Preserve exact measured counts in artifacts/property-budget.json. This host check is not runtime Memory qualification.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [SPEC-245](#spec-245)

<a id="spec-277"></a>
## SPEC-277 — Verify read-only compact property loading

Type: test | State: approved | Revision: 11

Suite: Core. In typedSettingsAndHiddenSlots, verify exactly 75 unique keys <=8 characters, complete read-only loading, no undeclared keys, zero/false/None preservation, per-bank invalid-mode fallbacks and no writes. Verify generated XML/default/caption parity and property/field description links plus uses relations. Build guard serializes defaults and maximum valid values with the Garmin SDK and requires each <=8000 bytes. No legacy migration or schema marker is required.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [SPEC-244](#spec-244)

<a id="spec-276"></a>
## SPEC-276 — Verify current coverage settings without legacy declarations

Type: test | State: approved | Revision: 17

Suite: Core. Verify all twenty compact aN_bg/bN_bg controls expose integer 0 None, 1 Label and 2 Whole cell. Match the per-slot XML defaults and independent read fallbacks. Exercise every explicit mode, missing/null/Boolean/fractional/negative/unknown values, hidden slots and reassignment. Require no legacy switches, sentinel or schema marker. Execute typedSettingsAndHiddenSlots and secondSetSettings; preserve unrelated values without runtime writes.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [APP-31](#app-31), [SPEC-155](#spec-155), [SPEC-243](#spec-243)

<a id="spec-275"></a>
## SPEC-275 — Verify color-only packet invalidation

Type: test | State: approved | Revision: 6

Suite: Core. Executable regression: tests/PresentationTests.mc, normalPresentationDrawAndAlignment with EnlargedLabelScenario. Execution evidence is recorded separately.

Hold displayed text/bounds constant while changing thresholds, source validity, theme and coverage. Verify replacement packets and complete erasure; earlier snapshots remain byte-for-byte unchanged.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [APP-26](#app-26)

<a id="spec-274"></a>
## SPEC-274 — Verify enlarged color bounds and contrast

Type: test | State: approved | Revision: 8

Suite: Core. Executable regression: tests/PresentationTests.mc, normalPresentationDrawAndAlignment with EnlargedLabelScenario. Execution evidence is recorded separately.

Compare cell commands/pixels before/after effects for zero/one/two enlarged layouts, all grid modes and both alignments. Check complete glyphs/halos, shared band bounds and neighboring cells.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [APP-34](#app-34), [DVS-12](#dvs-12), [DVS-6](#dvs-6)

<a id="spec-273"></a>
## SPEC-273 — Verify enlarged neutral fallback

Type: test | State: approved | Revision: 7

Suite: Core. Executable regression: tests/PresentationTests.mc, normalPresentationDrawAndAlignment with EnlargedLabelScenario. Execution evidence is recorded separately.

Exercise no custom source, missing/invalid/unsupported/expired/unqualified sources and recovery, including valid zero. Verify both gray shades, each mode, both sets and inversion without hiding valid values.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [DVS-51](#dvs-51), [SPEC-249](#spec-249)

<a id="spec-272"></a>
## SPEC-272 — Verify enlarged semantic label fill

Type: test | State: approved | Revision: 14

Suite: Core. Executable regression: tests/PresentationTests.mc, normalPresentationDrawAndAlignment with EnlargedLabelScenario. Execution evidence is recorded separately.

Use qualified HR/power fixtures and temperature bands with one/two enlarged slots in each set. Assert full-width/full-band fill and ordinary value pixels in both alignments/themes and inverted enlarged palettes.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [APP-49](#app-49), [DVS-12](#dvs-12)

<a id="spec-271"></a>
## SPEC-271 — Verify mode-only invalidation

Type: test | State: approved | Revision: 9

Suite: Core. Definition; execution evidence is separate.

Change one mode with unchanged text, readings and bounds. Assert new production packets/fills on next update, unchanged geometry, other slots and lap/rolling/grade/trigger state. Fitting counters remain unchanged when clearance is unchanged; otherwise only the affected cell may refit to keep complete glyphs/halos inside its bounds.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [APP-26](#app-26), [APP-32](#app-32)

<a id="spec-270"></a>
## SPEC-270 — Verify isolated mode validation

Type: test | State: approved | Revision: 9

Suite: Core. Definition; execution evidence is separate.

Inject missing/null/Boolean/fractional/negative/unknown values in one slot. Verify its bank-specific fallback and unchanged other slots/settings; valid explicit 0 survives reload.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [APP-31](#app-31), [APP-49](#app-49)

<a id="spec-269"></a>
## SPEC-269 — Verify whole-cell text contrast

Type: test | State: approved | Revision: 9

Suite: Core. Definition; execution evidence is separate.

Render all palette colors, including magenta #FF00FF with black text and an opposite white one-pixel halo, both neutral grays and all coverage modes. Assert foreground/halo colors and transparency for header, primary and secondary glyphs, including enlarged inversion. Changing coverage leaves no obsolete fill/halo.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [APP-36](#app-36), [DVS-6](#dvs-6)

<a id="spec-268"></a>
## SPEC-268 — Verify background coverage regions

Type: test | State: approved | Revision: 17

Suite: Core. Definition; execution evidence is separate.

For None/Label/Whole cell, compare production fill commands and pixels in regular/enlarged cells, both sets/themes/alignments. Assert unchanged alignment anchors and clipping at cell borders; any required clearance refit is confined to the affected cell. Exercise the Team and slope exceptions.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [APP-49](#app-49), [DVS-29](#dvs-29), [DVS-34](#dvs-34)

<a id="spec-267"></a>
## SPEC-267 — Verify background mode choices

Type: test | State: approved | Revision: 13

Suite: Core. Definition; execution evidence is separate.

Check all 20 keys, exact captions/codes/types and both bank presets. Edit duplicate and hidden slots independently; reload and verify their modes. No Boolean switch remains visible.

**Relations**

- part_of: [SPEC-233](#spec-233)
- verifies: [APP-49](#app-49), [SPEC-155](#spec-155)

<a id="spec-230"></a>
## SPEC-230 — Core: verify switching lifecycle, atomic frames and shared acquisition

Type: test | State: approved | Revision: 15

Verification definition; implementation and execution evidence are recorded separately. Use distinct first/second fields, enlarged count, alignment, theme, unit preference, effects and grid so mixed frames are observable. Verify startup/reset, pause retention, resume with an incomplete power window (first unavailable running sample returns default), post-reset finalizing laps ignored until rearmed, known activity-identity change, fresh-sample resume, page hide/show, late load, mode/selected-threshold edits, unused threshold edits and presentation-only edits. Validate the expected bank at every event and next frame. A switch publishes one bank consistently and never changes activity counters or rolling/grade/current-lap state. For N delivered samples with duplicate fields across both banks, assert N acquisition advances and one lap reset per delivered boundary. Trace clock/battery queries for active-set demand and correct values on activation; no trigger-only timer or draw-time acquisition. Inspect initialized/cached descriptors and ordinary draw replay using bounded fixture counters, not a runtime heap qualification. Include maximum supported normal layouts of each bank and prove no inherited first-set styles. This is Core; separate Memory and insufficient-area tests remain excluded.

**Relations**

- part_of: [SPEC-207](#spec-207)
- verifies: [APP-26](#app-26), [APP-33](#app-33), [SPEC-208](#spec-208), [SPEC-220](#spec-220), [SPEC-221](#spec-221)

<a id="spec-227"></a>
## SPEC-227 — Core: verify threshold hysteresis and source validity

Type: test | State: approved | Revision: 9

Verification definition; implementation and execution evidence are recorded separately. Use production transition logic with deterministic acquisition fixtures. With power A=250,R=220, fresh outputs 249,250,235,220,219 shall select default,second,second,second,default. Raw 249.6 must not activate despite displayed whole-watt 250; 219.6 returns despite displayed 220. Repeat for HR A=160,R=150 using 159,160,155,150,149. Equal A=R activates at equality and returns only below it. Test startup within hysteresis band, exact boundaries, finite zero power, null/negative/NaN/Infinity, HR zero, power before its first valid sample, partial power windows, missing/gapped samples, dropout and recovery inside the band: unavailable returns default, and recovery below activation stays default. Prove current HR and shared 3s power are used with neither selected in either bank, with duplicate slots, and while instantaneous power or HR3s disagrees. Unrelated-channel loss changes nothing. Verify no extra dwell delay beyond the producer and one decision per delivered sample. This is Core and uses no runtime Memory or deliberate overflow cases.
Power startup and recovery follow [DVS-22](#dvs-22): a first 300 W sample activates immediately at A=250; subsequent decisions use two- and three-sample means. Verify this through the real Data Field pipeline with no visible power fields; the trigger must reuse the shared producer.

**Relations**

- part_of: [SPEC-207](#spec-207)
- verifies: [DVS-22](#dvs-22), [SPEC-211](#spec-211), [SPEC-212](#spec-212), [SPEC-213](#spec-213), [SPEC-214](#spec-214), [SPEC-215](#spec-215), [SPEC-216](#spec-216)

<a id="spec-226"></a>
## SPEC-226 — Core: verify second-set settings, defaults

Type: test | State: approved | Revision: 33

Core definition; not executed here. Verify every bank-scoped property and its corresponding a/b counterpart, plus each global trigger/threshold/HR/power/cadence/Team text/color-source property, against the owning option requirements. Derive and compare complete current 75-property count, without legacy/hidden keys, without a second hardcoded inventory. Compare exact 33 choice codes, default assignments/enlargement/modes, selector captions, grouped/flat order and automatic native font fitting. Read current settings without migration or runtime writes.

Retain existing activation/threshold contracts under [SPEC-211](#spec-211)/[SPEC-212](#spec-212): Manual lap factory selection, first-set startup, first/second qualifying lap toggles, explicit None preservation, typed filtering and legacy Auto Lap restriction. Cover every threshold type/range, return>activation safe behavior and unused-invalid-pair isolation; adding presentation options must not change switching. No runtime Memory/Placement probes belong here.

**Relations**

- part_of: [SPEC-207](#spec-207)
- verifies: [APP-31](#app-31), [SPEC-155](#spec-155), [SPEC-208](#spec-208), [SPEC-210](#spec-210), [SPEC-211](#spec-211), [SPEC-212](#spec-212), [SPEC-243](#spec-243)

<a id="tui-12"></a>
## TUI-12 — Actual overflow and compact layout cache behavior

Type: test | State: approved | Revision: 13

Purpose: Actual overflow and compact layout cache behavior.

Suite: Placement. Explicit user request only; never launched by Core or a build.

Requirement references: [APP-24](#app-24), [APP-25](#app-25), [APP-34](#app-34), [APP-26](#app-26).

Procedure and expected results: Exercise oversized values, recovery to a normal value without font-size changes, reduced-area compact wrapping, repeated cached redraws and areas too small for a caption. Require the specified marker/message/background-only behavior with no repeated resource loading.

Executable source: `tests/PlacementTests.mc`; named test `actualValueFitAndCompactCache`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [APP-24](#app-24), [APP-25](#app-25), [APP-26](#app-26), [APP-34](#app-34)

<a id="tprf-8"></a>
## TPRF-8 — All three profile font resources can load

Type: test | State: approved | Revision: 12

Purpose: All three profile font resources can load.

Suite: Memory. Explicit user request only; never launched by Core or a build.

Requirement references: [APP-25](#app-25), [SPEC-177](#spec-177).

Procedure and expected results: Require exactly three referenced font resources and successful loading with positive font heights on the selected profile. This isolated resource check is not full runtime memory or physical readability qualification.

Executable source: `tests/FontTests.mc`; named test `allFontVariantsLoad`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [APP-25](#app-25), [SPEC-177](#spec-177)

<a id="tfnc-26"></a>
## TFNC-26 — Late loading and gaps do not invent lap history

Type: test | State: approved | Revision: 12

Purpose: Late loading and gaps do not invent lap history.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [FUNC-9](#func-9), [FUNC-10](#func-10), [DVS-39](#dvs-39).

Procedure and expected results: After late attachment wait for a confirmed boundary; reject unknown/regressing baselines. Missing intervals and stopped periods must not contribute to averages or recover an unobserved boundary.

Executable source: `tests/AcquisitionTests.mc`; named test `currentLapLateAttachAndGaps`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [DVS-39](#dvs-39), [FUNC-10](#func-10), [FUNC-9](#func-9)

<a id="tfnc-23"></a>
## TFNC-23 — Rolling samples use activity time and valid values

Type: test | State: approved | Revision: 11

Purpose: Rolling samples use activity time and valid values.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [DVS-41](#dvs-41), [DVS-47](#dvs-47), [DVS-22](#dvs-22), [APP-35](#app-35).

Procedure and expected results: Exercise elapsed-activity second identity, sampling state, duplicates, gaps, measured zero and invalid/negative values. Reject stale bridges without confusing wall time or resetting unrelated channels. Require power means 100,150,200 for consecutive 100,200,300 W readings while heart rate waits for three samples. Power immediately reseeds from the first valid reading after identity changes, gaps, invalid input or resume; measured zero is valid.

Executable source: `tests/AcquisitionTests.mc`; named test `rollingActivityClockAndValidity`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [APP-35](#app-35), [DVS-22](#dvs-22), [DVS-41](#dvs-41), [DVS-47](#dvs-47)

<a id="tui-7"></a>
## TUI-7 — Effect foreground contrast and exact glyph widths

Type: test | State: approved | Revision: 13

Purpose: Effect foreground contrast and exact glyph widths.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [DVS-6](#dvs-6), [APP-36](#app-36), [DVS-29](#dvs-29), [APP-26](#app-26).

Procedure and expected results: Verify Day/Night grade and colored-label foregrounds/ordinary value backgrounds. Compare cached widths with real SDK font measurement, including contour clearance.

Executable source: `tests/PresentationTests.mc`; named test `approvedForegroundAndMetricWidths`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [APP-26](#app-26), [APP-36](#app-36), [DVS-29](#dvs-29), [DVS-6](#dvs-6)

<a id="tui-6"></a>
## TUI-6 — Exactly three fixed font roles in every layout

Type: test | State: approved | Revision: 12

Purpose: Exactly three fixed font roles in every layout.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [APP-24](#app-24), [APP-25](#app-25).

Procedure and expected results: Require the fixed enlarged/regular/label sizes for every enlargement count and normal value transition. Timer, elapsed and battery use the same regular size; selected font/metric caches remain bounded by three roles. No memory sampling.

Executable source: `tests/PresentationTests.mc`; named test `fixedThreeRoleFonts`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [APP-24](#app-24), [APP-25](#app-25)

<a id="tui-5"></a>
## TUI-5 — Reviewed field formatting and stable choices

Type: test | State: approved | Revision: 14

Purpose: Reviewed field formatting and stable choices.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [SPEC-155](#spec-155), [DVS-36](#dvs-36), [DVS-13](#dvs-13).

Procedure and expected results: Verify all 33 stable field-choice codes and revised labels, lap mappings, large integers, duration/hour behavior and normalized heading/cardinal output against exact fixture expectations.

Executable source: `tests/PresentationTests.mc`; named test `reviewedFormattingAndCatalogue`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [DVS-13](#dvs-13), [DVS-36](#dvs-36), [SPEC-155](#spec-155)

<a id="tfnc-22"></a>
## TFNC-22 — Magnitude-based speed, fixed-decimal slope and integral elevation

Type: test | State: approved | Revision: 24

Purpose: Explicit speed, slope and elevation precision.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [DVS-8](#dvs-8), [DVS-9](#dvs-9), [DVS-26](#dvs-26), [DVS-29](#dvs-29), [FUNC-5](#func-5).

Procedure and expected results: Require magnitude-based precision under the shared decimal contract for current/average/lap speed after unit conversion. Verify both display-unit modes at the 10/100 boundaries and rounding carries, exact trailing zeros, negative-zero suppression and immutable prior snapshot text. Slope always uses fixed one-decimal text: 0 -> 0.0, -0.04 -> 0.0, 2.01 -> 2.0, 5.1 -> 5.1, 100 -> 100.0, -100 -> -100.0. Check both banks, regular/enlarged/duplicate assignments, and canonical two-decimal effect input before display rounding. Elevation remains integral. Temperature retains its fixed one-decimal contract. Invalid inputs remain unavailable and selected precision must not be trimmed to fit.

Executable sources: `tests/CoreTests.mc`, named test `requestedFieldPrecision`, covers speed/elevation and fixed-slope basics. `tests/AcquisitionTests.mc`, named test `gradeRegression`, calls the `fixedSlopePrecision` helper for all fixed-slope boundaries, both banks, enlarged layouts and duplicate assignments.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [DVS-26](#dvs-26), [DVS-29](#dvs-29), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-5](#func-5)

<a id="tfnc-19"></a>
## TFNC-19 — Invalid acquisition input and safe background startup

Type: test | State: approved | Revision: 26

Purpose: Invalid acquisition input and safe background startup.

Requirement references: [APP-33](#app-33), [DVS-29](#dvs-29), [DVS-34](#dvs-34).

Procedure and expected results: Check production onStart creates no foreground view/cache. Reject null, strings, Booleans, non-finite values, negative time/distance, missing running state and incorrectly typed protocol/timestamps. Grade/cache failures independently become unavailable.

Executable source: `tests/AcquisitionTests.mc`; fixture `acquisitionInvalidInputs`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [APP-33](#app-33), [DVS-29](#dvs-29), [DVS-34](#dvs-34)

<a id="tfnc-18"></a>
## TFNC-18 — Data Field callbacks preserve lap continuity

Type: test | State: approved | Revision: 22

Purpose: Data Field callbacks preserve lap continuity.

Requirement references: [APP-32](#app-32), [DVS-39](#dvs-39), [FUNC-9](#func-9).

Procedure and expected results: Invoke production callbacks around a known two-lap session. Pause/stop/resume/start, hide/show and settings reload preserve the count. Reset and old callbacks do not leak; a newly attached field stays unknown. Direct callbacks are fixtures, not physical FIT delivery evidence.

Executable source: `tests/AcquisitionTests.mc`; fixture `datafieldCallbackIsolation`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [APP-32](#app-32), [DVS-39](#dvs-39), [FUNC-9](#func-9)

<a id="tfnc-17"></a>
## TFNC-17 — Shared acquisition integration and duplicate slots

Type: test | State: approved | Revision: 30

Purpose: Shared acquisition integration and duplicate slots.

Requirement references: [DVS-29](#dvs-29), [DVS-34](#dvs-34), [DVS-39](#dvs-39), [DVS-36](#dvs-36), [FUNC-9](#func-9).

Procedure and expected results: Replay fresh-session activity -> zero-initialized average ramp (0,0,2,4,6,8,10%) -> confirmed 10% grade -> confirmed lap; duplicate grade/lap/temperature slots share one value. Check metric/statute temperature formatting with effects based on raw Celsius, cache expiry, paused grade with preserved laps, and cardinal suffix only when measured width fits.

Executable source: `tests/AcquisitionTests.mc`; fixture `acquisitionToSnapshot`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [DVS-29](#dvs-29), [DVS-34](#dvs-34), [DVS-36](#dvs-36), [DVS-39](#dvs-39), [FUNC-9](#func-9)

<a id="tfnc-16"></a>
## TFNC-16 — Legal temperature scheduling and runtime source guards

Type: test | State: approved | Revision: 26

Purpose: Legal temperature scheduling and runtime source guards.

Requirement references: [DVS-34](#dvs-34), [APP-38](#app-38).

Procedure and expected results: Assert earliest legal temporal times with no prior event, a prior event and 300s spacing. Check that an empty native registry and explicitly ONBOARD temperature metadata pass the source-registration guard; reject null/missing/malformed metadata, ANT/BLE and unknown technology, non-Number enum types (including Float 2.0), wrong sensor types and more than 32 entries, regardless of connection state. Inspect TemperatureSource.read to verify registry checks before and after Sensor.getInfo; use fixtures to verify that foreground rejects non-owned or incompatible delivery. Preserve clock/cache and invalid-value cases. Physical qualification remains separate; these fixtures do not certify real-device provenance or actual event delivery.

Executable source: `tests/AcquisitionTests.mc`; fixture `temporalAndSourceQualification`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [APP-38](#app-38), [DVS-34](#dvs-34)

<a id="tfnc-15"></a>
## TFNC-15 — Temperature delivery delay and clock guards

Type: test | State: approved | Revision: 24

Purpose: Temperature delivery delay and clock guards.

Requirement references: [DVS-34](#dvs-34).

Procedure and expected results: Include delivery delay in cache age. Check 359s/360s read-age boundaries, monotonic advancement, UTC rollback/forward jumps, monotonic wrap/rollback and rejection of non-owned worker delivery. Invalidated values remain unavailable.

Executable source: `tests/AcquisitionTests.mc`; fixture `temperatureClockAndDelivery`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [DVS-34](#dvs-34)

<a id="tfnc-14"></a>
## TFNC-14 — Temperature packet, cache-age and display precision boundaries

Type: test | State: approved | Revision: 27

Purpose: Temperature packet and cache-age boundaries.

Requirement references: [DVS-34](#dvs-34).

Procedure and expected results: Exercise owned protocol-2 four-element edge-native-v2 packets. Reject protocol-1/onboard-v1 packets from earlier builds. Valid 0C survives age 360s but expires at 361s. Reject old/duplicate/future timestamps, wrong protocol/path/type; newer invalid reads clear the cache. Through SnapshotEngine, also verify exactly one fractional digit in Celsius and Fahrenheit, trailing zeros, positive and negative half rounding, negative-zero suppression, null/unavailable values, and color bands selected from unrounded Celsius. Cover normal-range temperature endpoints and interior values via normalRangeFormatting and normalRangeCellBounds. Synthetic packets do not certify physical source provenance.

Executable source: `tests/AcquisitionTests.mc`; fixture `temperatureProtocolAndAge`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [DVS-34](#dvs-34)

<a id="tfnc-13"></a>
## TFNC-13 — Lap identity, regression and overflow invalidation

Type: test | State: approved | Revision: 21

Purpose: Lap identity, regression and overflow invalidation.

Requirement references: [DVS-39](#dvs-39), [FUNC-9](#func-9).

Procedure and expected results: Reject incomplete or ambiguous zero-baseline snapshots. Invalidate on changed identity, each timer/elapsed/distance regression, confirmed continuity loss and counter overflow; never wrap or fabricate a total.

Executable source: `tests/AcquisitionTests.mc`; fixture `lapIdentityAndOverflow`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [DVS-39](#dvs-39), [FUNC-9](#func-9)

<a id="tfnc-12"></a>
## TFNC-12 — Known-zero lap baseline and pause/reset lifecycle

Type: test | State: approved | Revision: 21

Purpose: Known-zero lap baseline and pause/reset lifecycle.

Requirement references: [DVS-39](#dvs-39), [FUNC-9](#func-9).

Procedure and expected results: Late attachment remains unknown despite start/lap callbacks. A proven fresh snapshot/reset sequence establishes zero; confirmed notifications increment once. Pause/stop/start preserve the count; old/end-session notifications cannot leak into a new session.

Executable source: `tests/AcquisitionTests.mc`; fixture `lapBaselineLifecycle`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [DVS-39](#dvs-39), [FUNC-9](#func-9)

<a id="tfnc-11"></a>
## TFNC-11 — Grade continuity and bounded sample history

Type: test | State: approved | Revision: 30

Purpose: Verify [DVS-29](#dvs-29) continuity and bounded history. Suite: Core.

Duplicate time does not refresh inactivity. Repeated distance updates altitude but not distance-progress time; at 3000 ms without progress, grade stays unavailable until movement resumes. Replacement does not evict a point from a full five-distinct-distance FIFO. Permit a 2000 ms gap; reset for 2001 ms, counter/identity regression, invalid input and non-running state. Reset regression and zero-initialized average together. Recovery with three new linear 10% points publishes 0,0,2%. Pause/reset and duplicate slots/settings/draws must not reuse stale history or advance windows.

Executable: tests/AcquisitionTests.mc, gradeResetAndBounds and gradeDistinctDistance. This is a definition, not a memory measurement or execution.

**Relations**

- verifies: [DVS-29](#dvs-29)

<a id="tfnc-10"></a>
## TFNC-10 — Grade regression, distinct distances and startup averaging

Type: test | State: approved | Revision: 35

Purpose: Verify [DVS-29](#dvs-29) regression and startup averaging. Suite: Core.

Require linear +/-10% ramps 0,0,+/-2,+/-4,+/-6,+/-8,+/-10; retain signed, large-value, rounding and degenerate-denominator checks. At unchanged distance keep only the latest altitude, without changing point count, FIFO, admission time, published grade or average cursor. A replacement must not block movement in that second. Duplicate timestamps remain ignored.

With relative altitudes -105.4,0,0,-0.2,-0.2 at distances 0,0,0,1.68,4.56 and one-second delivery, require 0,0,0,0,-0.78%; continued fixed altitude gives -0.94,-1.08,-1.08,-1.08,-0.30,-0.14,0. Original timestamp gaps follow the reset contract. Do not clamp or invent sensor data.

Executable: tests/AcquisitionTests.mc, gradeRegression, gradeDistinctDistance and gradeRepeatedDistanceStartup. Definitions are separate from execution evidence.

**Relations**

- verifies: [DVS-2](#dvs-2), [DVS-29](#dvs-29), [DVS-36](#dvs-36)

<a id="tui-1"></a>
## TUI-1 — Production drawing alignment and palettes

Type: test | State: draft | Revision: 102

Suite: Core. Executable: tests/PresentationTests.mc, normalPresentationDrawAndAlignment. Execution evidence is separate.
Run the production normal-layout scenarios across all native enlargement counts, both alignments and Day/Night. Assert complete headers/values, centered value bounds, shared header reservation, cell clipping and no overflow/compact substitution in guaranteed contexts.
Check the catalogue-wide minimum safe header-band formula against all header variants and retain one cached height through assignment, unit, theme and inversion changes. Check full-width regular/enlarged Label fills, ordinary value regions, semantic/neutral colors, white-temperature contrast, glyph halos and clean transitions between None/Label/Whole cell. Slope Whole cell retains its clipped ground and ordinary sky. Verify numeric families use their own valid color sources; invalid sources recover through neutral coverage without losing independent values.
Exercise both banks and independent duplicate/hidden slots. Include Team's fixed header, wrapped user value and native-font fit scenarios. Coverage changes preserve geometry and unchanged fits as asserted by the executable.
Exact grid-selector patterns, exhaustive normal-range endpoints, clock/duration capacity and complete callback/cache-query instrumentation are covered by their dedicated Test definitions. This test does not claim those named cases from its own PASS result. No Memory/Placement or physical qualification is implied.

Separate build prerequisite: tools/test_settings_layout.py verifies [SPEC-210](#spec-210)/[SPEC-669](#spec-669) with all current properties exactly once and in catalogue order directly on the main settings page; reject nested/empty groups, missing or duplicate controls and changed order. Report this host check separately from the named drawing test. Mobile Save/reopen persistence still requires phone verification; a simulator drawing PASS is not evidence of the phone's Save UI.

**Relations**

- verifies: [APP-21](#app-21), [APP-24](#app-24), [APP-26](#app-26), [APP-32](#app-32), [APP-34](#app-34), [APP-36](#app-36), [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-12](#dvs-12), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-51](#dvs-51), [DVS-6](#dvs-6), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-157](#spec-157), [SPEC-249](#spec-249), [SPEC-253](#spec-253)

<a id="tfnc-8"></a>
## TFNC-8 — All field unit headers and secondary-unit switches

Type: test | State: approved | Revision: 32

Purpose: Physical-unit header selection.

Requirement references: [DVS-50](#dvs-50), [DVS-32](#dvs-32), [DVS-13](#dvs-13), [SPEC-155](#spec-155), [APP-31](#app-31), [APP-35](#app-35).

Procedure and expected results: For all 33 fields, both physical-unit systems and a_hideu/b_hideu false/true, compare the exact header with the field requirement. Hidden units and empty Unit text use the full Label text without a separator. Shown nonempty units render the exact literal Header text with units, replacing its optional single {unit} placeholder when present without appending redundant unit text; an absent or empty template falls back to Label text + " | " + Unit text. Check independent distance/elevation/temperature preferences, lowercase text, preserved separator spaces, unavailable known readings and unknown fields. In particular, temperature uses temp | °c or temp | °f, and heart rate uses hr | bpm, while hidden-unit labels remain temperature and heart rate. Verify every specified physical-unit header against the actual profile font and available regular/enlarged cell widths, including applicable halos. A passing width audit does not establish whole-grid usability of other assigned fields or numeric values. No physical unit appears beside a value. Clock meridian indicators and duration components follow their own contracts independently.

Executable sources to update/verify: tests/PresentationTests.mc, presentationSettingsAndUnits, literalAndTemplateHeaderSelection and composedHeaderWidthAudit; tools/check_header_fit.py. Record a current pass only against matching source and requirement revisions.

Evidence follows [SPEC-162](#spec-162). Historical executions retain their captured scope.

Team always displays header `team` and no unit under [SPEC-253](#spec-253); physical-unit visibility does not alter its header or saved value.

**Relations**

- verifies: [APP-31](#app-31), [APP-35](#app-35), [DVS-13](#dvs-13), [DVS-32](#dvs-32), [DVS-50](#dvs-50), [SPEC-155](#spec-155)

<a id="tfnc-7"></a>
## TFNC-7 — Measured caption and duration fitting

Type: test | State: approved | Revision: 24

Purpose: Fixed-font caption fitting.

Requirement references: [APP-21](#app-21), [APP-24](#app-24), [APP-25](#app-25), [APP-34](#app-34), [DVS-3](#dvs-3), [DVS-13](#dvs-13).

Procedure and expected results: Measure complete headers and primary/secondary ink bounds in both alignments. Use exactly the three fixed profile fonts; required content must fit or use the defined overflow/fallback state. Long durations do not select another font size or drop required hour digits. Check label-height vertical inset and omitted-secondary width.

Suite: Placement. Explicit user request only.

Executable source: `tests/PlacementTests.mc`; named test `proportionalCaptionFit`.

Evidence follows [SPEC-162](#spec-162). This definition asserts no execution; historical results retain their captured scope.


**Relations**

- verifies: [APP-21](#app-21), [APP-24](#app-24), [APP-25](#app-25), [DVS-13](#dvs-13), [DVS-3](#dvs-3)

<a id="tfnc-6"></a>
## TFNC-6 — Unit conversion and complete duration formatting

Type: test | State: approved | Revision: 22

Purpose: Unit conversion and clock/duration formats.

Requirement references: [DVS-13](#dvs-13), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [SPEC-157](#spec-157).

Procedure and expected results: Check 10m/s -> 36km/h, 1609.344m -> 1mi and 0C -> 32F. Use the exact boundary cases in [DVS-13](#dvs-13) through 100h, including omission of seconds at 10h. Verify separate timer/elapsed paths, invalid times and both clock modes with the [DVS-32](#dvs-32) header indicator. Retain [DVS-42](#dvs-42) zone classification checks.

Executable source to update/verify: `tests/CoreTests.mc`, `unitsAndExplicitFormatPolicy`.

Evidence follows [SPEC-162](#spec-162). This definition asserts no execution; historical results retain their captured scope.


**Relations**

- verifies: [DVS-13](#dvs-13), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [SPEC-157](#spec-157)

<a id="tfnc-5"></a>
## TFNC-5 — Typed settings defaults and hidden-slot preservation

Type: test | State: approved | Revision: 22

Suite: Core. Verify default Right alignment, both exact ten-slot presets, per-bank enlargement and coverage defaults, and matching XML/read fallbacks. Exercise valid zero/false/None, duplicate and hidden assignments, malformed values and unknown field codes. Use compact keys only; require no migration writes or compatibility declarations. Executable: typedSettingsAndHiddenSlots in tests/CoreTests.mc, with secondSetSettings and nativeSettingsCallbacks for both-bank/native reload coverage. Requirement references: [APP-20](#app-20), [APP-30](#app-30), [APP-31](#app-31), [APP-49](#app-49), [SPEC-155](#spec-155). Evidence follows [SPEC-162](#spec-162); historical executions retain their original scope.

**Relations**

- verifies: [APP-20](#app-20), [APP-30](#app-30), [APP-31](#app-31), [APP-49](#app-49), [SPEC-155](#spec-155)

<a id="tfnc-4"></a>
## TFNC-4 — Grade and temperature effect boundaries

Type: test | State: approved | Revision: 21

Purpose: Grade and temperature effect boundaries.

Requirement references: [DVS-29](#dvs-29), [DVS-34](#dvs-34).

Procedure and expected results: Assert the literal grade/temperature boundary arrays and expected band names in exactEffectBands, including fractional boundaries, negative values and null. Check horizon clamping to +/-45 degrees. Verify [DVS-42](#dvs-42) upper-inclusive boundaries using displayed whole-number values, invalid/outside metadata, and [DVS-45](#dvs-45) exact RGB mapping. Update the production-policy fixtures before execution; historical helper-only runs do not cover this addition.

Executable source: `tests/CoreTests.mc`; fixture `exactEffectBands`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [DVS-29](#dvs-29), [DVS-34](#dvs-34)

<a id="tfnc-3"></a>
## TFNC-3 — Three-second rolling-window continuity

Type: test | State: approved | Revision: 15

Purpose: Three-second rolling-window continuity.

Requirement references: [DVS-41](#dvs-41), [DVS-47](#dvs-47), [DVS-22](#dvs-22).

Procedure and expected results: For power samples 100,200,300,400 at consecutive seconds require 100,150,200,300. Heart rate remains unavailable for its first two valid samples and publishes the three-sample mean next. Check duplicate seconds, missing/invalid input, gaps, regressing time, measured zero and explicit reset. After each reset exclude stale buffer entries and restart power from its first valid sample; no sample means unavailable.

Executable source: `tests/CoreTests.mc`; fixture `threeConsecutiveSamples`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [DVS-22](#dvs-22), [DVS-41](#dvs-41), [DVS-47](#dvs-47)

<a id="tfnc-2"></a>
## TFNC-2 — All six full-capacity logical grids

Type: test | State: approved | Revision: 21

Purpose: All six full-capacity logical grids.

Requirement references: [APP-20](#app-20).

Procedure and expected results: For four/five rows and zero/one/two enlarged fields, assert capacities 8/5/2 and 10/7/4, cell bounds and non-overlap. Check a zero-cell plan for invalid row count and bounded horizon polygons at the literal angle fixtures.

Executable source: `tests/CoreTests.mc`; fixture `logicalGridCases`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


Compare exact slope sky/ground vertices against full rectangle clipping at signed shallow, zero and steep angles, with translated regular/enlarged bounds. Skipping redundant clipping must preserve rounded vertices and cell containment.

**Relations**

- verifies: [APP-20](#app-20)

<a id="tfnc-1"></a>
## TFNC-1 — Floating-point display boundaries

Type: test | State: approved | Revision: 22

Purpose: Floating-point display boundaries.

Requirement references: [DVS-2](#dvs-2), [DVS-4](#dvs-4), [DVS-32](#dvs-32), [DVS-7](#dvs-7).

Procedure and expected results: Check zero, trailing zeros and the 10/100 magnitude transitions on both signs, exact-half rounding carries into the next band, negative-zero suppression, invalid/non-finite input and large whole-number formatting. Precision is independent of text length; measured cell overflow is separate. Use literal expected values in floatingBoundaries.

Executable source: `tests/CoreTests.mc`; fixture `floatingBoundaries`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [DVS-2](#dvs-2), [DVS-32](#dvs-32), [DVS-4](#dvs-4), [DVS-7](#dvs-7)

<a id="spec-178"></a>
## SPEC-178 — Verify exact glyph inventories across font roles and supported UI states

Type: test | State: approved | Revision: 11

Construct an independently reviewed role inventory covering all configurable values, ordinary and fallback labels, both unit systems including ft and degree units, 12/24-hour output, and supported unavailable/overflow/status presentations. For every one of the three profile roles compare the font character IDs with the role inventory; require both set differences to be empty. Verify that hidden but configurable values are covered, that whitespace appears only in a role that renders it, and that lowercase am/pm letters occur in the header/label role under [DVS-32](#dvs-32). Decode every atlas and verify all opaque pixels belong to declared glyph rectangles, with transparent padding and no additional glyph images. Record the language scope, approved/provisional decision status, input/inventory/output hashes and per-role result. Do not assert fixed counts such as 15/46 as permanent product behavior; these are implementation inventories that evolve with supported text.


**Relations**

- part_of: [SPEC-175](#spec-175)
- verifies: [SPEC-176](#spec-176)

<a id="spec-169"></a>
## SPEC-169 — Verify: run deterministic Monkey C tests for formatting, settings and sample processing

Type: test | State: approved | Revision: 25

Purpose: Production-policy mutation and test-driver guards.

Requirement references: [SPEC-157](#spec-157), [APP-24](#app-24), [APP-25](#app-25), [APP-21](#app-21), [DVS-50](#dvs-50), [SPEC-155](#spec-155), [DVS-42](#dvs-42), [DVS-45](#dvs-45).

Procedure and expected results: Run recorded fixtures against production routines. An intentionally incorrect conversion/band boundary must fail; restore it afterward. Zero tests, exceptions and skipped required cases must prevent passing. Cover fixed three-role fonts at the current profile table, vertical inset, Right default with saved Center preserved, the typed property catalogue under [SPEC-155](#spec-155) and header rules. Retain zone normalization/upper-inclusive rounded classification and exact RGB palette checks. Record summary/raw output only after updating fixtures to the current contracts.

Executable source to update/verify: Monkey C production test suite and its driver.

Evidence follows [SPEC-162](#spec-162). This definition asserts no execution; historical results retain their captured scope.

Verify the Core default and disjoint Core/Memory/Placement compiler inventories. Every declared guaranteed case is required; explicitly unsupported contexts are reported and assigned to request-only Placement, not hidden as skipped Core requirements. A Core run must contain no memory probe or deliberate compact-message scenario.

**Relations**

- part_of: [SPEC-150](#spec-150)
- verifies: [DVS-2](#dvs-2), [DVS-42](#dvs-42), [DVS-45](#dvs-45), [DVS-7](#dvs-7), [SPEC-157](#spec-157)

<a id="spec-168"></a>
## SPEC-168 — Verify: specify each displayed value acquisition path and deterministic sensor fixtures

Type: test | State: approved | Revision: 49

Verify every one of the 33 selectable identifiers has one explicit acquisition/normalization contract under [SPEC-156](#spec-156). Cover current/activity-average speed, cadence, heart rate and power; distance, elevation, ascent/descent, grade, timers, local time, calories, battery, heading, waypoint distance, zones, completed laps and the six current-lap fields. Check each Label text, Unit text, producer API/units, validity/ranges and conversion/rounding against the production adapter; do not substitute whole-activity values for lap values.

Replay zero, negative where valid, null/non-finite, absent members, sensor interruption/recovery, unit changes, activity reset and clock/timer boundaries. Verify current readings become unavailable while explicitly accumulated/cache values obey their own retention rules. Inspect all complete exact headers and the distinct unavailable/overflow markers. Unavailable navigation or zone metadata must not become fabricated zeros. Use [TFNC-21](#tfnc-21) for lap lifecycle/weighted fixtures and [TFNC-10](#tfnc-10)..[TFNC-19](#tfnc-19) for existing derived acquisitions. Physical source/callback evidence remains separate under [SPEC-171](#spec-171). Record actual results under [SPEC-162](#spec-162).

Core fixtures requestedFieldPrecision and normalRangeFormatting verify magnitude-based precision for current/average/lap speed, activity/lap/waypoint distance after unit conversion; slope always has one decimal; temperature keeps one decimal, elevation stays integral, and other field-specific precision rules remain in force. normalRangeCellBounds covers the declared per-layout intervals under [APP-34](#app-34); formatting correctness outside them does not imply fit. Preserve canonical two-decimal regression grade/effect calculations under [DVS-29](#dvs-29) and existing acquisition validity/lifecycle rules.

Team has settings-sourced literal text and no numeric/sensor acquisition under [SPEC-253](#spec-253); its optional color source is tested independently under [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-150](#spec-150)
- verifies: [APP-34](#app-34), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-33](#dvs-33), [DVS-35](#dvs-35), [DVS-37](#dvs-37), [DVS-40](#dvs-40), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [SPEC-156](#spec-156)

<a id="spec-167"></a>
## SPEC-167 — Verify: publish one typed settings catalogue shared by XML, runtime and tests

Type: test | State: approved | Revision: 28

Core definition; not executed here. Compare generated catalogue, property/settings XML and runtime validation under [SPEC-155](#spec-155): exact current property count, 33 append-only choices, stable codes, both presets, all mode/Team/cadence keys and compact keys. Verify defaults and saved/missing/malformed values independently, hidden/duplicate slots, all six layouts and grouped/flat settings order.

Check live changes preserve active recording and unrelated settings. Exercise explicit None/zero/false, source-binding independence and read-only loading through the linked new Tests. Core contains no Memory or deliberate insufficient-area probes. Record current source/product/requirement revisions only when executed.

**Relations**

- part_of: [SPEC-150](#spec-150)
- verifies: [APP-46](#app-46), [SPEC-155](#spec-155)

<a id="spec-166"></a>
## SPEC-166 — Verify: reproduce Garmin-compatible Roboto Condensed resources within the memory budget

Type: test | State: approved | Revision: 20

Regenerate or verify each checked-in resource from declared inputs; compile it on all candidate profiles. Render required glyphs, five-character numeric boundaries and largest regular/enlarged fields. Verify no missing glyph, clipping or unintended substitute typeface, and record resource/loaded-memory costs against existing ceilings. Capture actual generator configuration and asset hashes. This is a planned verification case; no passing execution is asserted.

Check the three font roles under [APP-25](#app-25) against [APP-24](#app-24) references and [SPEC-154](#spec-154) fixed role sizes, including complete current-lap labels after implementation.

Run resource/loaded-memory measurements only when Memory is explicitly requested. Verify unsupported/reduced-area behavior only when Placement is explicitly requested. Core normal-value guarantees follow each field's [APP-34](#app-34) table; fixed font sizes do not guarantee every format in every role.

**Relations**

- part_of: [SPEC-150](#spec-150)
- verifies: [APP-25](#app-25), [SPEC-154](#spec-154)

<a id="app-4"></a>
## APP-4 — Data drawer

Type: component | State: approved | Revision: 46

Consume the complete snapshot and drawing commands prepared by [APP-3](#app-3) through onUpdate(dc). [APP-26](#app-26) owns the draw-only lifecycle rule, [APP-34](#app-34) owns fitting/fallback, and the shared coverage/contrast requirements own painting. This component does not independently define field formats or geometry.

**Relations**

- part_of: [APP-1](#app-1)
- uses: [APP-2](#app-2), [APP-3](#app-3), [SWINT-1](#swint-1)

<a id="app-3"></a>
## APP-3 — Drawing params provider

Type: component | State: approved | Revision: 35

Prepare the drawing parameters consumed by [APP-4](#app-4): resolved settings, assigned bounds, font metrics and prepared presentation commands. [APP-26](#app-26) owns preparation/cache lifetime; [APP-34](#app-34) owns fitting; [APP-21](#app-21) owns the value inset and alignment; [APP-25](#app-25) owns font roles. Field-specific formats remain in the field catalogue.

**Relations**

- part_of: [APP-1](#app-1)
- uses: [APP-2](#app-2), [SWINT-1](#swint-1)

<a id="app-2"></a>
## APP-2 — Initialization handler

Type: component | State: approved | Revision: 14

Initialize settings, capability inputs and a safe snapshot for the drawing-parameter provider [APP-3](#app-3). [APP-31](#app-31) owns validation/defaults, [APP-33](#app-33) owns safe initial presentation, and [APP-38](#app-38) owns device qualification. Bounds-dependent preparation belongs to [APP-3](#app-3).

**Relations**

- part_of: [APP-1](#app-1)
- uses: [SWINT-1](#swint-1)

<a id="app-44"></a>
## APP-44 — Toybox.Graphics.Dc.fillPolygon(...)

Type: data_item | State: approved | Revision: 11

Graphics.Dc.fillPolygon(points) paints a polygon using the selected color; this contract limits the input to the API's 64-point maximum. Supply prepared, cell-clipped points. [DVS-29](#dvs-29) owns slope geometry; [APP-26](#app-26) owns preparation before drawing.

**Relations**

- part_of: [APP-1](#app-1)

<a id="app-43"></a>
## APP-43 — Toybox.UserProfile.getPowerZones(...)

Type: data_item | State: approved | Revision: 11

UserProfile.getPowerZones(Activity.SPORT_CYCLING) supplies cycling power thresholds when Connect IQ 5.2.2 and the method are supported. Guard optional availability. The API supplies thresholds, not colors; [DVS-42](#dvs-42) owns metadata interpretation/classification and [SPEC-249](#spec-249) owns unavailable-color fallback.

**Relations**

- part_of: [APP-1](#app-1)

<a id="app-12"></a>
## APP-12 — onUpdate(dc)

Type: data_item | State: approved | Revision: 29

Toybox.WatchUi.View.onUpdate(dc), inherited by DataField, is the drawing callback. [APP-26](#app-26) owns prepared-command rendering and the first/changed-bounds preparation exception; [APP-33](#app-33) owns the initial safe snapshot.
API: https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/View.html#onUpdate-instance_function

**Relations**

- part_of: [APP-1](#app-1)

<a id="app-8"></a>
## APP-8 — compute(info)

Type: data_item | State: approved | Revision: 43

Toybox.WatchUi.DataField.compute(info) delivers Activity.Info once per second. Drawing is scheduled independently, so delivery does not establish drawing order. [APP-26](#app-26) owns sample processing and preparation; field acquisition contracts own source validity and reset rules.
API: https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/DataField.html#compute-instance_function

**Relations**

- part_of: [APP-1](#app-1)

<a id="app-7"></a>
## APP-7 — onLayout(dc)

Type: data_item | State: approved | Revision: 19

Toybox.WatchUi.View.onLayout(dc), inherited by DataField, supplies the drawing context assigned to the field. dc.getWidth()/getHeight() describe assigned bounds, which can differ from physical screen resolution. Application preparation and reuse rules are owned by [APP-26](#app-26).
API: https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/View.html#onLayout-instance_function

**Relations**

- part_of: [APP-1](#app-1)

<a id="swint-1"></a>
## SWINT-1 — Garmin SDK

Type: interface | State: approved | Revision: 21

Garmin devices SDK library to use device function APIs.

**Relations**

- contains: [APP-10](#app-10), [APP-11](#app-11), [APP-12](#app-12), [APP-13](#app-13), [APP-14](#app-14), [APP-15](#app-15), [APP-16](#app-16), [APP-17](#app-17), [APP-18](#app-18), [APP-19](#app-19), [APP-39](#app-39), [APP-40](#app-40), [APP-41](#app-41), [APP-42](#app-42), [APP-43](#app-43), [APP-44](#app-44), [APP-5](#app-5), [APP-6](#app-6), [APP-7](#app-7), [APP-8](#app-8), [APP-9](#app-9)
- part_of: [APP-1](#app-1)

<a id="trgr-1"></a>
## TRGR-1 — Core

Type: test_suite | State: approved | Revision: 15

Default fast UI correctness, values/calculations, formatting, settings, acquisition/lifecycle and cache/draw regressions under [SPEC-157](#spec-157). Contains all 37 named Core Monkey C cases plus four separately identified host build/resource/publication prerequisites; these host checks are not extra Monkey C cases. Run Core after app changes. Never run Memory or Placement implicitly. Repository authority: tests/suites.json, tests.jungle and tests/service-cases.json. Linked definitions assert scope, not current execution or hardware qualification.

**Relations**

- includes_test: [SPEC-167](#spec-167), [SPEC-168](#spec-168), [SPEC-226](#spec-226), [SPEC-227](#spec-227), [SPEC-228](#spec-228), [SPEC-229](#spec-229), [SPEC-230](#spec-230), [SPEC-267](#spec-267), [SPEC-268](#spec-268), [SPEC-269](#spec-269), [SPEC-270](#spec-270), [SPEC-271](#spec-271), [SPEC-272](#spec-272), [SPEC-273](#spec-273), [SPEC-274](#spec-274), [SPEC-275](#spec-275), [SPEC-276](#spec-276), [SPEC-277](#spec-277), [SPEC-278](#spec-278), [SPEC-279](#spec-279), [SPEC-280](#spec-280), [SPEC-281](#spec-281), [SPEC-282](#spec-282), [SPEC-283](#spec-283), [SPEC-284](#spec-284), [SPEC-285](#spec-285), [SPEC-286](#spec-286), [SPEC-287](#spec-287), [SPEC-288](#spec-288), [SPEC-289](#spec-289), [SPEC-290](#spec-290), [SPEC-291](#spec-291), [SPEC-292](#spec-292), [SPEC-293](#spec-293), [SPEC-294](#spec-294), [SPEC-297](#spec-297), [SPEC-298](#spec-298), [SPEC-299](#spec-299), [TCOM-1](#tcom-1), [TFNC-1](#tfnc-1), [TFNC-10](#tfnc-10), [TFNC-11](#tfnc-11), [TFNC-12](#tfnc-12), [TFNC-13](#tfnc-13), [TFNC-14](#tfnc-14), [TFNC-15](#tfnc-15), [TFNC-16](#tfnc-16), [TFNC-17](#tfnc-17), [TFNC-18](#tfnc-18), [TFNC-19](#tfnc-19), [TFNC-2](#tfnc-2), [TFNC-20](#tfnc-20), [TFNC-22](#tfnc-22), [TFNC-23](#tfnc-23), [TFNC-24](#tfnc-24), [TFNC-25](#tfnc-25), [TFNC-26](#tfnc-26), [TFNC-3](#tfnc-3), [TFNC-4](#tfnc-4), [TFNC-5](#tfnc-5), [TFNC-6](#tfnc-6), [TFNC-8](#tfnc-8), [TFNC-9](#tfnc-9), [TINT-1](#tint-1), [TPRF-4](#tprf-4), [TPRF-5](#tprf-5), [TPRF-6](#tprf-6), [TSEC-1](#tsec-1), [TSTFUNC-1](#tstfunc-1), [TSTFUNC-10](#tstfunc-10), [TSTFUNC-11](#tstfunc-11), [TSTFUNC-2](#tstfunc-2), [TSTFUNC-3](#tstfunc-3), [TSTFUNC-4](#tstfunc-4), [TSTFUNC-5](#tstfunc-5), [TSTFUNC-6](#tstfunc-6), [TSTFUNC-7](#tstfunc-7), [TSTFUNC-8](#tstfunc-8), [TSTFUNC-9](#tstfunc-9), [TUI-1](#tui-1), [TUI-10](#tui-10), [TUI-11](#tui-11), [TUI-2](#tui-2), [TUI-3](#tui-3), [TUI-4](#tui-4), [TUI-5](#tui-5), [TUI-6](#tui-6), [TUI-7](#tui-7), [TUI-8](#tui-8), [TUI-9](#tui-9)

<a id="app-42"></a>
## APP-42 — Toybox.UserProfile.getHeartRateZones(...)

Type: data_item | State: approved | Revision: 7

Retrieve cycling heart-rate thresholds with `UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_BIKING)` when available. The app needs UserProfile permission and shall validate the returned boundaries before assigning a zone; the API supplies thresholds, not display colors.

**Relations**

- part_of: [APP-1](#app-1)

<a id="app-41"></a>
## APP-41 — Toybox.WatchUi.requestUpdate()

Type: data_item | State: approved | Revision: 9

Request a redraw of the active data-field View after a Garmin Connect setting or supported night-mode change. The next [APP-12](#app-12) shall render one consistent settings and palette snapshot.

**Relations**

- part_of: [APP-1](#app-1)

<a id="app-15"></a>
## APP-15 — Toybox.Application.Properties.getValue(key)

Type: data_item | State: approved | Revision: 10

Toybox.Application.Properties.getValue(key) retrieves an application property declared in the settings/properties resources. Read the keys/types/list mappings from [SPEC-155](#spec-155), validate each read independently under [APP-31](#app-31), and catch missing/unsupported/invalid reads to use that property's documented default. Load/cache values during initialization or [APP-6](#app-6), not each draw. Numeric list values map to stable internal identifiers; valid saved Center and hidden-slot selections/effects are preserved. Do not treat this settings API as a sensor source or as evidence of Garmin Connect transport qualification.

**Relations**

- part_of: [APP-1](#app-1)

<a id="app-5"></a>
## APP-5 — initialize()

Type: data_item | State: approved | Revision: 12

Constructor/initialization entry. The application class initializes its Toybox.Application.AppBase superclass; the Data Field class initializes Toybox.WatchUi.DataField. Establish validated default configuration, bounded sample state and a complete unavailable-safe display snapshot before the system can call drawing under [APP-33](#app-33). A constructor has no assigned Graphics.Dc; select fitted cell geometry/resources after [APP-7](#app-7), not from an assumed full-screen size. Preserve the separation of constructor, AppBase.onStart and DataField.compute responsibilities.

Initialize the bounded descriptor/presentation caches and resolved static modes required by [APP-26](#app-26). Bounds-dependent preparation remains in [APP-7](#app-7).

**Relations**

- part_of: [APP-1](#app-1)

<a id="app-11"></a>
## APP-11 — onStop(state)

Type: data_item | State: approved | Revision: 8

Toybox.Application.AppBase.onStop(state) handles application termination and bounded resource cleanup. Preserve settings as required by [APP-31](#app-31)/[APP-46](#app-46), avoid rewriting valid persisted settings with temporary defaults, and release application-owned transient state as applicable. App termination does not authorize changing or deleting the host activity's recorded data. state may be null. Source: https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/AppBase.html#onStop-instance_function

**Relations**

- part_of: [APP-1](#app-1)

<a id="app-16"></a>
## APP-16 — Toybox.Activity.getActivityInfo()

Type: data_item | State: approved | Revision: 9

Provides a snapshot of the current `Activity.Info` state outside `DataField.compute(info)` when needed, including during data-field initialization. Use `Toybox.Activity.getActivityInfo()`; `Activity.getInfo()` is not a Connect IQ method.

**Relations**

- part_of: [APP-1](#app-1)

<a id="app-6"></a>
## APP-6 — onSettingsChanged()

Type: data_item | State: approved | Revision: 10

Toybox.Application.AppBase.onSettingsChanged() is the running-application callback for delivered application setting changes, documented for Garmin Connect Mobile. Re-read each property through [APP-15](#app-15), validate independently under [APP-31](#app-31), apply one consistent configuration without clearing unrelated activity/rolling state under [APP-32](#app-32), invalidate affected presentation/layout caches and request [APP-41](#app-41). A later startup also loads saved properties; do not infer that every settings transport has an identical live-callback guarantee. Source: https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/AppBase.html#onSettingsChanged-instance_function

**Relations**

- part_of: [APP-1](#app-1)

<a id="tper-1"></a>
## TPER-1 — Memory

Type: test_suite | State: approved | Revision: 9

Explicit user request only. Run the two isolated profile font probes and the separate normal Data Field runtime validation stage under [APP-47](#app-47)/[APP-48](#app-48). Source: tests/FontTests.mc, memory-tests.jungle and validation/memory/MemoryValidation.mc. A font probe alone cannot qualify peak runtime memory. Record per-product requested scenarios, source/binary/toolchain and actual used/free/total observations. Hardware evidence and unrun cases remain separate. A build or Core run never authorizes this suite.

**Relations**

- includes_test: [SPEC-231](#spec-231), [SPEC-296](#spec-296), [TPRF-7](#tprf-7), [TPRF-8](#tprf-8), [TPRF-9](#tprf-9)

<a id="trgr-2"></a>
## TRGR-2 — Placement

Type: test_suite | State: approved | Revision: 9

Explicit user request only. Contains the four tests from tests/PlacementTests.mc / placement-tests.jungle: caption/duration fitting, overflow/compact-cache behavior, the unsupported/reduced-area drawing matrix, and documented unsupported combinations. Verify the full compact caption or bounded background-only behavior, clipping and recovery under [APP-34](#app-34). Do not treat fallback as a normal-value pass. No Memory work is implied; Core never launches this suite.

**Relations**

- includes_test: [SPEC-232](#spec-232), [SPEC-295](#spec-295), [TFNC-7](#tfnc-7), [TUI-12](#tui-12), [TUI-13](#tui-13), [TUI-14](#tui-14)

<a id="tui-14"></a>
## TUI-14 — Documented unsupported fields fail safe fitting

Type: test | State: approved | Revision: 6

Purpose: Documented unsupported fields fail safe fitting.

Suite: Placement. Explicit user request only; never launched by Core or a build.

Requirement references: [APP-24](#app-24), [APP-34](#app-34), [SPEC-157](#spec-157).

Procedure and expected results: For every documented unsupported native combination require the full intended text to fail the fit check at fixed fonts; retain explicit unsupported status rather than declaring clipped text a normal display pass.

Executable source: `tests/PlacementTests.mc`; named test `documentedUnsupportedCombinations`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [APP-24](#app-24), [APP-34](#app-34), [SPEC-157](#spec-157)

<a id="tui-13"></a>
## TUI-13 — Unsupported and reduced-area presentation matrix

Type: test | State: approved | Revision: 9

Purpose: Unsupported and reduced-area presentation matrix.

Suite: Placement. Explicit user request only; never launched by Core or a build.

Requirement references: [APP-20](#app-20), [APP-21](#app-21), [APP-34](#app-34), [APP-36](#app-36), [DVS-6](#dvs-6), [DVS-51](#dvs-51).

Procedure and expected results: Run the production drawing matrix including unsupported combinations, both alignments, themes, inversion and enlargement counts. Require correct clipping, separators, backgrounds, contours and full compact caption when it fits; never count fallback as a normal-value guarantee.

Executable source: `tests/PlacementTests.mc`; named test `presentationDrawAndAlignment`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [APP-20](#app-20), [APP-21](#app-21), [APP-34](#app-34), [APP-36](#app-36), [DVS-51](#dvs-51), [DVS-6](#dvs-6)

<a id="tprf-7"></a>
## TPRF-7 — Isolated three-font resource allocation probe

Type: test | State: approved | Revision: 6

Purpose: Isolated three-font resource allocation probe.

Suite: Memory. Explicit user request only; never launched by Core or a build.

Requirement references: [APP-47](#app-47), [APP-48](#app-48), [SPEC-177](#spec-177).

Procedure and expected results: Load the enlarged/regular/label resources on the selected product, record baseline/loaded used/free/total memory and require loaded usage within both available allocation and the profile limit. An isolated probe does not qualify full Data Field peak usage.

Executable source: `tests/FontTests.mc`; named test `profileFontLoad`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [APP-47](#app-47), [APP-48](#app-48), [SPEC-177](#spec-177)

<a id="tui-11"></a>
## TUI-11 — Guaranteed normal values stay inside native cell borders

Type: test | State: approved | Revision: 8

Purpose: Guaranteed normal values stay inside native cell borders.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [APP-24](#app-24), [APP-34](#app-34), [DVS-6](#dvs-6), [DVS-12](#dvs-12), [SPEC-157](#spec-157).

Procedure and expected results: Use real font metrics across every declared normal context, role and alignment. Require complete header/value/secondary glyph and halo bounds; no trimming, overflow sign or compact substitution. Count explicitly unsupported contexts separately.

Executable source: `tests/NormalRangeTests.mc`; named test `normalRangeCellBounds`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [APP-24](#app-24), [APP-34](#app-34), [DVS-12](#dvs-12), [DVS-6](#dvs-6), [SPEC-157](#spec-157)

<a id="tui-10"></a>
## TUI-10 — Exact formatting throughout declared normal intervals

Type: test | State: approved | Revision: 7

Purpose: Exact formatting throughout declared normal intervals.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [APP-34](#app-34), [DVS-2](#dvs-2), [DVS-3](#dvs-3), [SPEC-157](#spec-157).

Procedure and expected results: For every field normal interval check endpoints, interior samples, rounding and width transitions in each declared unit/clock mode against exact primary and mandatory secondary text.

Executable source: `tests/NormalRangeTests.mc`; named test `normalRangeFormatting`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [APP-34](#app-34), [DVS-2](#dvs-2), [DVS-3](#dvs-3), [SPEC-157](#spec-157)

<a id="tfnc-25"></a>
## TFNC-25 — Current-lap distance time and weighted averages

Type: test | State: approved | Revision: 11

Purpose: Current-lap distance time and weighted averages.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [FUNC-9](#func-9), [FUNC-10](#func-10).

Procedure and expected results: Use known boundaries/counters to verify lap distance, active duration, distance/time speed and time-weighted HR/power/cadence. Include measured zero, valid endpoints and pause behavior.

Executable source: `tests/AcquisitionTests.mc`; named test `currentLapAcquisition`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [FUNC-10](#func-10), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [FUNC-9](#func-9)

<a id="tui-9"></a>
## TUI-9 — Complete clock and duration groups fit native cells

Type: test | State: approved | Revision: 7

Purpose: Complete clock and duration groups fit native cells.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [APP-24](#app-24), [DVS-13](#dvs-13), [DVS-32](#dvs-32), [APP-34](#app-34).

Procedure and expected results: Require complete 00:00, 13:05 and 1:00.00 groups at fixed fonts in every native enlargement count and alignment, including required secondary seconds and one-pixel halos. No overflow or compact substitution.

Executable source: `tests/PresentationTests.mc`; named test `clockAndDurationFitEveryLayout`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [APP-24](#app-24), [APP-34](#app-34), [DVS-13](#dvs-13), [DVS-32](#dvs-32)

<a id="tui-8"></a>
## TUI-8 — Default-on grid visibility and unchanged cell drawing

Type: test | State: approved | Revision: 10

Purpose: Independent grid type selection and unchanged cell drawing.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [APP-22](#app-22), [SPEC-155](#spec-155), [HFER-7](#hfer-7), [HFER-8](#hfer-8), [APP-26](#app-26), [APP-32](#app-32).

Procedure and expected results: Run gridTypeAndRepaint across both alignments, Day/Night, enlarged-theme inversion on/off and all native enlargement counts. Require Horizontal lines as constructor and missing/null/malformed fallback; accept numeric codes 0/1/2 and canonical none/horizontal/full identifiers, and ignore retired show_grid. In one reused renderer, switch Horizontal/None/Full/None/Horizontal/Full. Independently check the exact pattern line counts, horizontal/vertical orientations, clipping and [HFER-7](#hfer-7)/[HFER-8](#hfer-8) palette gradients for the selected type, without reading alignment to choose the style. None must issue zero drawLine calls. Require unchanged cell drawing records, field-fit/layout/geometry/font-load counters, backgrounds and grade polygons during grid-only changes. Compact fallback remains separator-free under every choice. Acquisition state must not reset.

Executable source: `tests/PresentationTests.mc`; named test `gridTypeAndRepaint`.

Evidence follows [SPEC-162](#spec-162). This definition does not record an execution or hardware qualification. Historical executions retain their captured scope.

**Relations**

- verifies: [APP-22](#app-22), [APP-26](#app-26), [APP-32](#app-32), [HFER-7](#hfer-7), [HFER-8](#hfer-8), [SPEC-155](#spec-155)

<a id="tui-4"></a>
## TUI-4 — Normal default ride headers and cell bounds

Type: test | State: approved | Revision: 7

Purpose: Normal default ride headers and cell bounds.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [APP-20](#app-20), [APP-24](#app-24), [DVS-50](#dvs-50), [APP-34](#app-34).

Procedure and expected results: Draw default sample values with shown/hidden units, both themes and alignments. Require every native visible cell, exact headers and values, no overflow or compact substitution.

Executable source: `tests/PresentationTests.mc`; named test `sampleDefaultUnitHeaderGrid`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [APP-20](#app-20), [APP-24](#app-24), [APP-34](#app-34), [DVS-50](#dvs-50)

<a id="tui-3"></a>
## TUI-3 — Literal and unit-template header selection

Type: test | State: approved | Revision: 6

Purpose: Literal and unit-template header selection.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [DVS-50](#dvs-50), [DVS-4](#dvs-4), [DVS-32](#dvs-32).

Procedure and expected results: Require exact literal overrides, optional unit substitution, spaced vertical bars and lowercase clock indicators. Hidden/empty units use the full label without extra separators.

Executable source: `tests/PresentationTests.mc`; named test `literalAndTemplateHeaderSelection`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [DVS-32](#dvs-32), [DVS-4](#dvs-4), [DVS-50](#dvs-50)

<a id="tui-2"></a>
## TUI-2 — Measure complete label and unit headers

Type: test | State: approved | Revision: 7

Purpose: Measure complete label and unit headers.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [DVS-12](#dvs-12), [DVS-50](#dvs-50), [APP-24](#app-24), [APP-34](#app-34).

Procedure and expected results: Measure every complete resolved header with real SDK fonts in both alignments and unit modes. Require the documented oversized-header inventory and zero newly oversized headers; do not draw deliberately rejected grids.

Executable source: `tests/PresentationTests.mc`; named test `composedHeaderWidthAudit`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [APP-24](#app-24), [APP-34](#app-34), [DVS-12](#dvs-12), [DVS-50](#dvs-50)

<a id="spec-171"></a>
## SPEC-171 — Verify: provide physical-device and memory-performance qualification procedures

Type: test | State: approved | Revision: 15

Review the selected hardware/firmware coverage and executable procedure, then run it with declared durations/repetitions. Compare measured allocation/timing with [APP-37](#app-37), [APP-47](#app-47) and [APP-48](#app-48) criteria and distinguish simulator observations. Inspect per-model temperature provenance and age tests; insufficient or absent evidence prevents the affected support claim. This is a planned verification case; no passing execution is asserted.

Explicitly evaluate the [APP-47](#app-47) published ceiling and [APP-48](#app-48) runtime allocation separately for each measured device; retain missing device records as blocked, never extrapolate a pass.


Simulator-only runtime Memory procedure is specified separately in [TPRF-9](#tprf-9). Preserve its failed attempts and fixture corrections; missing physical evidence remains blocked.

**Relations**

- part_of: [SPEC-150](#spec-150)
- verifies: [APP-47](#app-47), [APP-48](#app-48), [SPEC-159](#spec-159)

<a id="tsec-1"></a>
## TSEC-1 — Publication privacy, export integrity and current project consistency

Type: test | State: approved | Revision: 11

Purpose: Publication privacy, export integrity and current project consistency.

Requirement references: [SPEC-153](#spec-153), [SPEC-155](#spec-155), [SPEC-162](#spec-162).

Procedure and expected results: Run check_project.py and check_publication.py. Require pinned Approved requirement/supporting hashes and revisions, settings/catalogue/XML consistency, all export descriptions/identifiers/revisions, document and attachment links, sanitized PNG metadata and matching export checksums. Scan current Git publication candidates for private keys, literal credentials, personal machine paths and emails; machine configuration and build outputs must be ignored. Git history is explicitly retained by user choice and excluded from this working-file privacy claim.

Executable source: `tools/check_publication.py`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [SPEC-153](#spec-153), [SPEC-155](#spec-155), [SPEC-162](#spec-162)

<a id="tfnc-20"></a>
## TFNC-20 — Reject semantic font defects with refreshed cached hashes

Type: test | State: approved | Revision: 9

Purpose: Reject semantic font defects with refreshed cached hashes.

Requirement references: [SPEC-177](#spec-177).

Procedure and expected results: Run all isolated negative fixtures in test_font_validation.py. Require the intended semantic diagnostic for missing f, unused numeric letter, undeclared opaque pixels, duplicate/missing IDs, bounds/overlap and changed masks/metrics even when cached hashes are refreshed. Check controlled presentation-text inventory changes and unstable/stale regeneration. No simulator font-loading or memory probe.

Executable source: `tools/test_font_validation.py`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [SPEC-177](#spec-177)

<a id="tcom-1"></a>
## TCOM-1 — Exact glyph inventories and reproducible font resources

Type: test | State: approved | Revision: 10

Purpose: Exact glyph inventories and reproducible font resources.

Requirement references: [SPEC-176](#spec-176), [SPEC-177](#spec-177).

Procedure and expected results: Run the complete font validator and two isolated deterministic regenerations. For every current manifest variant require exact derived numeric/label character sets, transparent padding, valid rectangles, original glyph masks/metrics, verified source fonts and identical generated resource hashes. A pass covers atlas/role correctness and regeneration; it does not measure loaded memory or certify physical readability.

Executable source: `tools/validate_fonts.py`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [SPEC-176](#spec-176), [SPEC-177](#spec-177)

<a id="tfnc-9"></a>
## TFNC-9 — Independent theme inversion and sample preservation

Type: test | State: approved | Revision: 11

Purpose: Independent theme inversion and sample preservation.

Requirement references: [DVS-51](#dvs-51), [APP-32](#app-32), [APP-45](#app-45).

Procedure and expected results: Check explicit Day/Night and Auto capability fallback, every base-theme/enlarged/inversion combination, and preservation of the known rolling average through presentation-setting changes.

Executable source: `tests/PresentationTests.mc`; fixture `presentationThemeAndActivity`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [APP-32](#app-32), [APP-45](#app-45), [DVS-51](#dvs-51)

<a id="spec-179"></a>
## SPEC-179 — Verify font subset rejection, regeneration and nine-profile compatibility

Type: test | State: approved | Revision: 3

Run the normal font validator on valid generated assets. In isolated fixture copies remove the f glyph while retaining the ft unit, add an unused numeric-role letter with a font record/image, and add opaque pixels outside all glyph rectangles. Each must be rejected for the intended defect, not fail merely because a cached hash differs. Also reject duplicate IDs, bad bounds/overlap and altered retained glyph metrics/masks. Regenerate twice from the same recorded source fonts and presentation inventory and compare all output hashes. Make a controlled presentation-text change in a fixture and verify its traced inventory changes and affected fonts require regeneration. Compile and load regenerated resources on edge530, edge540, edge550, edge830, edge840, edge850, edge1030, edge1040 and edge1050. Save exact SDK/tool versions, revisions, fixture definitions and per-product outcomes. Source/atlas byte counts, SDK unit-runtime font-load samples and actual Data Field/physical-device memory results must be labelled separately; missing visual/hardware evidence is unrun, not a pass.

**Relations**

- part_of: [SPEC-175](#spec-175)
- verifies: [SPEC-177](#spec-177)

<a id="spec-174"></a>
## SPEC-174 — Verify: define development milestones and traceable release evidence

Type: test | State: approved | Revision: 3

Review the milestone exit criteria and the traceability map. Verify every original approved requirement has a named verification method before release; missing implementation or evidence is explicit. Confirm new linked environment tests are not counted as covering all product behavior and that build-only or draft-only states cannot satisfy the release gate. This is a planned verification case; no passing execution is asserted.

**Relations**

- part_of: [SPEC-150](#spec-150)
- verifies: [SPEC-162](#spec-162)

<a id="spec-173"></a>
## SPEC-173 — Verify: record unresolved product decisions before closing dependent development tasks

Type: test | State: approved | Revision: 3

Inspect all listed decisions and their affected requirements/tasks. Verify open entries prevent only dependent acceptance, and independently implemented features remain assessable. For resolved entries, confirm reviewer/decision provenance and matching contract/fixture updates; no fabricated temperature source, grade method or arbitrary visual goldens may close an unresolved entry. This is a planned verification case; no passing execution is asserted.

**Relations**

- part_of: [SPEC-150](#spec-150)
- verifies: [SPEC-161](#spec-161)

<a id="spec-172"></a>
## SPEC-172 — Verify: gate changes on repeatable compilation and explicit test evidence

Type: test | State: approved | Revision: 3

Run a clean CI job and a cached job with declared inputs; change the SDK/device/resource inputs and verify cache invalidation. Inject a compiler error, failing test and unavailable simulator and verify honest failures or unrun classifications. Check per-product artifacts, raw logs and separate hardware/visual-review gates. This is a planned verification case; no passing execution is asserted.

**Relations**

- part_of: [SPEC-150](#spec-150)
- verifies: [SPEC-160](#spec-160)

<a id="spec-165"></a>
## SPEC-165 — Verify: provide repeatable CLI build, simulator-test and package commands

Type: test | State: approved | Revision: 3

Build from two different checkout paths, including one with spaces, using the same toolchain and declared inputs. Record equivalent product/resource selection; bit-for-bit signed output is not required unless established. Verify debug/test/release separation, missing-key and invalid-product failure, simulator timeout/crash/zero-test failure, and absence of secrets in tracked files/logs. Verify release-key identity metadata without exposing key material. This is a planned verification case; no passing execution is asserted.

**Relations**

- part_of: [SPEC-150](#spec-150)
- verifies: [SPEC-153](#spec-153)

<a id="app-40"></a>
## APP-40 — Toybox.Application.AppBase.onNightModeChanged()

Type: data_item | State: approved | Revision: 5

The AppBase callback for a device switch between day and night mode on supported devices. Re-read `System.getDeviceSettings().isNightModeEnabled`, update the active palette and request a redraw without altering the configured fields or numeric values.

**Relations**

- part_of: [APP-1](#app-1)

<a id="app-39"></a>
## APP-39 — Toybox.System.getDeviceSettings().isNightModeEnabled

Type: data_item | State: approved | Revision: 5

Read the current device night-color state through `System.getDeviceSettings().isNightModeEnabled` when this member is present. It is available on newer supported Edge devices but not every target in [APP-24](#app-24); use a capability check and the explicit theme fallback instead of assuming this property exists.

**Relations**

- part_of: [APP-1](#app-1)

<a id="app-19"></a>
## APP-19 — Toybox.WatchUi.DataField.createField(...)

Type: data_item | State: approved | Revision: 5

A DataField may call `Toybox.WatchUi.DataField.createField(...)` to create a `FitContributor.Field` for optional custom FIT recording. The returned field is updated with `setData(...)` when the data is valid. This is not required to display values on screen. Garmin API: https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/DataField.html

**Relations**

- part_of: [APP-1](#app-1)

<a id="app-18"></a>
## APP-18 — Toybox.UserProfile.getProfile()

Type: data_item | State: approved | Revision: 6

Retrieves the user's general profile data, such as body metrics, when the UserProfile permission is granted. Training-zone thresholds are retrieved separately through `Toybox.UserProfile.getHeartRateZones(...)` and, on supported devices, `getPowerZones(...)`; `getProfile()` alone is not a source of zone boundaries.

**Relations**

- part_of: [APP-1](#app-1)

<a id="app-17"></a>
## APP-17 — Toybox.System.getSystemStats()

Type: data_item | State: approved | Revision: 5

Toybox.System.getSystemStats() returns System.Stats, including battery percentage and application-runtime totalMemory, usedMemory and freeMemory in bytes. Validate battery under [DVS-35](#dvs-35); use the named memory members for the separate qualification measurements under [APP-48](#app-48). These are not device physical RAM or filesystem-free-storage values, and no free-storage member is documented by this contract. Label foreground/background/simulator/hardware measurement provenance separately; published limits alone are not measured free memory. Source: https://developer.garmin.com/connect-iq/api-docs/Toybox/System/Stats.html

**Relations**

- part_of: [APP-1](#app-1)

<a id="app-14"></a>
## APP-14 — onHide()

Type: data_item | State: approved | Revision: 4

Toybox.WatchUi.View.onHide() is the inherited View hide callback when delivered by the system. It may suspend display-only work, but shall not stop required activity sample processing, clear rolling samples solely because the field is hidden or reset timer/settings state. Do not depend on an onHide callback for every Data Field visibility transition; the documented Data Field lifecycle primarily lists onLayout/onShow/onUpdate. Restore current rendering under [APP-13](#app-13) without inventing samples. Source: https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/View.html

**Relations**

- part_of: [APP-1](#app-1)

<a id="app-13"></a>
## APP-13 — onShow()

Type: data_item | State: approved | Revision: 4

Toybox.WatchUi.View.onShow(), inherited by DataField, is a visibility callback. When the view becomes visible, render/request the current complete snapshot using the current validated settings and rebuilt layout as needed. Becoming visible shall not reset activity timers, rolling samples, hidden assignments or saved settings. Do not assume visibility callbacks supply Activity.Info or replace [APP-8](#app-8) acquisition. Source: https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/View.html#onShow-instance_function

**Relations**

- part_of: [APP-1](#app-1)

<a id="app-10"></a>
## APP-10 — onStart(state)

Type: data_item | State: approved | Revision: 4

Toybox.Application.AppBase.onStart(state) is called at application startup before getInitialView(). Handle application startup and load/validate saved configuration without assuming state is non-null, an activity sample is already available or a final drawing area has been assigned. Layout preparation follows [APP-7](#app-7) and safe snapshot initialization follows [APP-33](#app-33). App startup is not an instruction to reset the host Garmin activity. Source: https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/AppBase.html#onStart-instance_function

**Relations**

- part_of: [APP-1](#app-1)

<a id="app-9"></a>
## APP-9 — getInitialView()

Type: data_item | State: approved | Revision: 4

Toybox.Application.AppBase.getInitialView() returns the initial view array, containing this application's WatchUi.DataField instance. That view receives layout/update and activity-compute callbacks. An input delegate is optional when supported/needed; do not require an on-device settings editor under [APP-46](#app-46). Initialize a complete safe display state under [APP-33](#app-33) before returning the view. Source: https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/AppBase.html#getInitialView-instance_function

**Relations**

- part_of: [APP-1](#app-1)

<a id="spec-660"></a>
## SPEC-660 — Custom training zones

Type: document | State: approved | Revision: 13

Global custom HR and power zone selection. Individual property definitions belong in [SPEC-300](#spec-300); selectable fields remain in [DVS-1](#dvs-1). Shared palette belongs in [SPEC-246](#spec-246).

<a id="spec-661"></a>
## SPEC-661 — Classify custom heart rate into five zones

Type: requirement | State: approved | Revision: 4

A usable custom HR profile has four integer upper limits, each 30..250 bpm, strictly increasing. For a finite positive raw reading, round to whole bpm using the metric rounding rule; assign the first zone whose upper limit is >= the rounded value, or zone 5 above the fourth limit. Equality stays in the lower zone. Missing, zero, negative and non-finite raw readings have no zone. Positive readings above 250 bpm still classify; do not clamp readings.

**Relations**

- part_of: [SPEC-660](#spec-660)

<a id="spec-662"></a>
## SPEC-662 — Classify custom power into seven zones

Type: requirement | State: approved | Revision: 4

A usable custom power profile has six integer upper limits, each 1..3000 W, strictly increasing. For a finite nonnegative raw reading, round to whole watts using the metric rounding rule; assign the first zone whose upper limit is >= the rounded value, or zone 7 above the sixth limit. Equality stays in the lower zone; zero watts is valid. Missing, negative and non-finite raw readings have no zone. Values above 3000 W still classify. Fixed zone names, in order: Active Recovery, Endurance, Tempo, Threshold, VO2 Max, Anaerobic, Neuromuscular.

**Relations**

- part_of: [SPEC-660](#spec-660)

<a id="spec-663"></a>
## SPEC-663 — Select the global power zone source

Type: requirement | State: approved | Revision: 7

[FR-16431](#fr-16431) Off selects qualified device power zones under [DVS-42](#dvs-42); On selects only the custom profile under [SPEC-662](#spec-662). This source is global across both field sets. Device-profile qualification and its numeric zone domain remain unchanged; custom selection works without device power-zone metadata.

**Relations**

- part_of: [SPEC-660](#spec-660)
- uses: [DVS-42](#dvs-42), [FR-16431](#fr-16431), [SPEC-662](#spec-662)

<a id="spec-664"></a>
## SPEC-664 — Select the global heart rate zone source

Type: requirement | State: approved | Revision: 7

[FR-16438](#fr-16438) Off selects qualified device HR zones under [DVS-42](#dvs-42); On selects only the custom profile under [SPEC-661](#spec-661). This source is global across both field sets. Custom selection works without device HR-zone metadata.

**Relations**

- part_of: [SPEC-660](#spec-660)
- uses: [DVS-42](#dvs-42), [FR-16438](#fr-16438), [SPEC-661](#spec-661)

<a id="spec-665"></a>
## SPEC-665 — Share the selected zone profile with all consumers

Type: requirement | State: approved | Revision: 7

All current, rolling-three-second, activity-average and lap-average HR/power metrics classify their own value under [SPEC-248](#spec-248) using the selected family profile. Numeric zone fields use current HR/power and display the resulting index. Team binds current HR/power even when numeric source slots are hidden. Both sets and regular/enlarged/duplicate slots share each family profile; coverage affects drawing only. Colors come exclusively from [SPEC-246](#spec-246).

**Relations**

- part_of: [SPEC-660](#spec-660)
- uses: [SPEC-246](#spec-246), [SPEC-248](#spec-248), [SPEC-663](#spec-663), [SPEC-664](#spec-664)

<a id="spec-666"></a>
## SPEC-666 — Keep invalid custom zone profiles unavailable

Type: requirement | State: approved | Revision: 4

When a selected custom tuple is missing, malformed, non-integer, non-finite, out of its usable range or not strictly increasing, expose no family zone. Never fall back to device zones, sort, clamp or rewrite the tuple. Preserve valid metric values and Team text; zone-number fields are unavailable and enabled effects use [SPEC-249](#spec-249). A later valid edit restores classification without restarting the activity.

**Relations**

- part_of: [SPEC-660](#spec-660)
- uses: [SPEC-249](#spec-249), [SPEC-661](#spec-661), [SPEC-662](#spec-662)

<a id="spec-667"></a>
## SPEC-667 — Prepare zone profiles outside compute and drawing

Type: requirement | State: approved | Revision: 6

Validate immutable shared HR/power profiles at initialization and settings reload under [APP-26](#app-26). Query device metadata only for families selecting device mode, at the existing metadata lifecycle boundary. Do not parse properties, validate tuples or query profiles in ordinary compute/onUpdate drawing. Source or limit edits invalidate affected zone/color/prepared-cell caches for both sets before their next display; retain shared references rather than copies per slot. Reuse the unchanged family profile and its classifications after unrelated settings edits.

**Relations**

- part_of: [SPEC-660](#spec-660)
- uses: [APP-26](#app-26), [SPEC-663](#spec-663), [SPEC-664](#spec-664)

<a id="spec-668"></a>
## SPEC-668 — Preserve activity state when editing zone settings

Type: requirement | State: approved | Revision: 3

Zone-source and threshold edits must not change numeric metric values, rolling samples, lap history, trigger thresholds or the active field set. Persist custom limits while their switch is Off and use them when it is turned On. Loading and classification never rewrite saved properties or device training zones; settings saving follows the existing platform persistence contract.

**Relations**

- part_of: [SPEC-660](#spec-660)
- uses: [SPEC-663](#spec-663), [SPEC-664](#spec-664)

<a id="spec-669"></a>
## SPEC-669 — Keep shared training zone controls contiguous on the main settings page

Type: requirement | State: draft | Revision: 8

Keep shared training zone options in one contiguous section on the main settings page under [SPEC-210](#spec-210), outside both slot banks: custom power switch, six named power upper limits, custom HR switch, four HR upper limits, then the existing cadence options. Use direct setting elements, without an SDK group or nested page. Preserve all existing property keys, types, defaults and saved values.

Prompts state units and that limits apply only while their switch is On; describe open-ended final zones without editable upper limits. Power prompts use names under [SPEC-662](#spec-662). Keep the shared Team name before all slot options. Do not add editable heading/divider properties; conditional visibility is not required.

**Relations**

- part_of: [SPEC-660](#spec-660)
- uses: [SPEC-155](#spec-155), [SPEC-662](#spec-662)

<a id="fr-16431"></a>
## FR-16431 — Use custom power zones (cpz)

Type: requirement | State: approved | Revision: 16

Key: `cpz`. Caption: Use custom power zones. Type/values: Boolean. Default: `false`. Only Boolean true enables custom power zones; missing or malformed values read as false without rewriting storage.

Behavior: [SPEC-663](#spec-663). Fields: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [FUNC-7](#func-7), [DVS-24](#dvs-24), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [FUNC-7](#func-7), [SPEC-253](#spec-253), [SPEC-663](#spec-663)

<a id="fr-16432"></a>
## FR-16432 — Power zone 1 (Active Recovery): upper W (pw1)

Type: requirement | State: approved | Revision: 16

Key: `pw1`. Caption: Power zone 1 (Active Recovery): upper W. Type/values: Integer 0..3000. Default: `0`. Zero is unset, never a valid cutoff. Global upper limit for zone 1; validate the complete tuple under [SPEC-662](#spec-662). Missing input reads as 0; present invalid input invalidates the profile without rewriting storage. Retain the stored value while custom mode is Off.

Behavior: [SPEC-663](#spec-663). Fields: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [FUNC-7](#func-7), [DVS-24](#dvs-24), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [FUNC-7](#func-7), [SPEC-253](#spec-253), [SPEC-662](#spec-662), [SPEC-663](#spec-663)

<a id="fr-16433"></a>
## FR-16433 — Power zone 2 (Endurance): upper W (pw2)

Type: requirement | State: approved | Revision: 16

Key: `pw2`. Caption: Power zone 2 (Endurance): upper W. Type/values: Integer 0..3000. Default: `0`. Zero is unset, never a valid cutoff. Global upper limit for zone 2; validate the complete tuple under [SPEC-662](#spec-662). Missing input reads as 0; present invalid input invalidates the profile without rewriting storage. Retain the stored value while custom mode is Off.

Behavior: [SPEC-663](#spec-663). Fields: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [FUNC-7](#func-7), [DVS-24](#dvs-24), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [FUNC-7](#func-7), [SPEC-253](#spec-253), [SPEC-662](#spec-662), [SPEC-663](#spec-663)

<a id="fr-16434"></a>
## FR-16434 — Power zone 3 (Tempo): upper W (pw3)

Type: requirement | State: approved | Revision: 16

Key: `pw3`. Caption: Power zone 3 (Tempo): upper W. Type/values: Integer 0..3000. Default: `0`. Zero is unset, never a valid cutoff. Global upper limit for zone 3; validate the complete tuple under [SPEC-662](#spec-662). Missing input reads as 0; present invalid input invalidates the profile without rewriting storage. Retain the stored value while custom mode is Off.

Behavior: [SPEC-663](#spec-663). Fields: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [FUNC-7](#func-7), [DVS-24](#dvs-24), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [FUNC-7](#func-7), [SPEC-253](#spec-253), [SPEC-662](#spec-662), [SPEC-663](#spec-663)

<a id="fr-16435"></a>
## FR-16435 — Power zone 4 (Threshold): upper W (pw4)

Type: requirement | State: approved | Revision: 16

Key: `pw4`. Caption: Power zone 4 (Threshold): upper W. Type/values: Integer 0..3000. Default: `0`. Zero is unset, never a valid cutoff. Global upper limit for zone 4; validate the complete tuple under [SPEC-662](#spec-662). Missing input reads as 0; present invalid input invalidates the profile without rewriting storage. Retain the stored value while custom mode is Off.

Behavior: [SPEC-663](#spec-663). Fields: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [FUNC-7](#func-7), [DVS-24](#dvs-24), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [FUNC-7](#func-7), [SPEC-253](#spec-253), [SPEC-662](#spec-662), [SPEC-663](#spec-663)

<a id="fr-16436"></a>
## FR-16436 — Power zone 5 (VO2 Max): upper W (pw5)

Type: requirement | State: approved | Revision: 16

Key: `pw5`. Caption: Power zone 5 (VO2 Max): upper W. Type/values: Integer 0..3000. Default: `0`. Zero is unset, never a valid cutoff. Global upper limit for zone 5; validate the complete tuple under [SPEC-662](#spec-662). Missing input reads as 0; present invalid input invalidates the profile without rewriting storage. Retain the stored value while custom mode is Off.

Behavior: [SPEC-663](#spec-663). Fields: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [FUNC-7](#func-7), [DVS-24](#dvs-24), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [FUNC-7](#func-7), [SPEC-253](#spec-253), [SPEC-662](#spec-662), [SPEC-663](#spec-663)

<a id="fr-16437"></a>
## FR-16437 — Power zone 6 (Anaerobic): upper W (pw6)

Type: requirement | State: approved | Revision: 16

Key: `pw6`. Caption: Power zone 6 (Anaerobic): upper W. Type/values: Integer 0..3000. Default: `0`. Zero is unset, never a valid cutoff. Global upper limit for zone 6; validate the complete tuple under [SPEC-662](#spec-662). Missing input reads as 0; present invalid input invalidates the profile without rewriting storage. Retain the stored value while custom mode is Off.

Behavior: [SPEC-663](#spec-663). Fields: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [FUNC-7](#func-7), [DVS-24](#dvs-24), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [FUNC-7](#func-7), [SPEC-253](#spec-253), [SPEC-662](#spec-662), [SPEC-663](#spec-663)

<a id="fr-16438"></a>
## FR-16438 — Use custom heart rate zones (chz)

Type: requirement | State: approved | Revision: 16

Key: `chz`. Caption: Use custom heart rate zones. Type/values: Boolean. Default: `false`. Only Boolean true enables custom heart rate zones; missing or malformed values read as false without rewriting storage.

Behavior: [SPEC-664](#spec-664). Fields: [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-47](#dvs-47), [FUNC-6](#func-6), [DVS-20](#dvs-20), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-47](#dvs-47), [FUNC-6](#func-6), [SPEC-253](#spec-253), [SPEC-664](#spec-664)

<a id="fr-16439"></a>
## FR-16439 — Heart rate zone 1: upper bpm (hr1)

Type: requirement | State: approved | Revision: 16

Key: `hr1`. Caption: Heart rate zone 1: upper bpm. Type/values: Integer 0..250. Default: `0`. Zero is unset, never a valid cutoff. Global upper limit for zone 1; validate the complete tuple under [SPEC-661](#spec-661). Missing input reads as 0; present invalid input invalidates the profile without rewriting storage. Retain the stored value while custom mode is Off.

Behavior: [SPEC-664](#spec-664). Fields: [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-47](#dvs-47), [FUNC-6](#func-6), [DVS-20](#dvs-20), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-47](#dvs-47), [FUNC-6](#func-6), [SPEC-253](#spec-253), [SPEC-661](#spec-661), [SPEC-664](#spec-664)

<a id="fr-16440"></a>
## FR-16440 — Heart rate zone 2: upper bpm (hr2)

Type: requirement | State: approved | Revision: 16

Key: `hr2`. Caption: Heart rate zone 2: upper bpm. Type/values: Integer 0..250. Default: `0`. Zero is unset, never a valid cutoff. Global upper limit for zone 2; validate the complete tuple under [SPEC-661](#spec-661). Missing input reads as 0; present invalid input invalidates the profile without rewriting storage. Retain the stored value while custom mode is Off.

Behavior: [SPEC-664](#spec-664). Fields: [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-47](#dvs-47), [FUNC-6](#func-6), [DVS-20](#dvs-20), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-47](#dvs-47), [FUNC-6](#func-6), [SPEC-253](#spec-253), [SPEC-661](#spec-661), [SPEC-664](#spec-664)

<a id="fr-16441"></a>
## FR-16441 — Heart rate zone 3: upper bpm (hr3)

Type: requirement | State: approved | Revision: 16

Key: `hr3`. Caption: Heart rate zone 3: upper bpm. Type/values: Integer 0..250. Default: `0`. Zero is unset, never a valid cutoff. Global upper limit for zone 3; validate the complete tuple under [SPEC-661](#spec-661). Missing input reads as 0; present invalid input invalidates the profile without rewriting storage. Retain the stored value while custom mode is Off.

Behavior: [SPEC-664](#spec-664). Fields: [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-47](#dvs-47), [FUNC-6](#func-6), [DVS-20](#dvs-20), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-47](#dvs-47), [FUNC-6](#func-6), [SPEC-253](#spec-253), [SPEC-661](#spec-661), [SPEC-664](#spec-664)

<a id="fr-16442"></a>
## FR-16442 — Heart rate zone 4: upper bpm (hr4)

Type: requirement | State: approved | Revision: 16

Key: `hr4`. Caption: Heart rate zone 4: upper bpm. Type/values: Integer 0..250. Default: `0`. Zero is unset, never a valid cutoff. Global upper limit for zone 4; validate the complete tuple under [SPEC-661](#spec-661). Missing input reads as 0; present invalid input invalidates the profile without rewriting storage. Retain the stored value while custom mode is Off.

Behavior: [SPEC-664](#spec-664). Fields: [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-47](#dvs-47), [FUNC-6](#func-6), [DVS-20](#dvs-20), [SPEC-253](#spec-253).

**Relations**

- part_of: [SPEC-300](#spec-300)
- uses: [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-47](#dvs-47), [FUNC-6](#func-6), [SPEC-253](#spec-253), [SPEC-661](#spec-661), [SPEC-664](#spec-664)

<a id="tstfunc-6"></a>
## TSTFUNC-6 — Core: custom HR boundaries and validation

Type: test | State: approved | Revision: 3

Suite: Core. Definition for implementation; no execution result.

Use limits 100/120/140/160 bpm. Assert 99/100 ->1, 101/120 ->2, 121/140 ->3, 141/160 ->4, 161/251 ->5; include half-unit rounding carries. Reject raw zero, negative, missing and non-finite readings. Cover valid edge limits 30 and 250, repeated/descending/missing/zero/fractional/string/non-finite/out-of-range cutoffs; invalid tuples expose no zone. Positive raw values rounding to zero remain zone 1.

**Relations**

- verifies: [SPEC-661](#spec-661), [SPEC-666](#spec-666)

<a id="tstfunc-7"></a>
## TSTFUNC-7 — Core: custom power boundaries and names

Type: test | State: approved | Revision: 3

Suite: Core. Definition for implementation; no execution result.

Use limits 100/150/200/250/300/350 W. Check each boundary minus/at/plus one and half-unit rounding carries; zero ->1 and 351/3001 ->7. Reject negative/missing/non-finite raw input. Verify all seven exact names and open final zone. Cover valid limit edges 1/3000, repeated/descending/missing/zero/fractional/string/non-finite/out-of-range cutoffs.

**Relations**

- verifies: [SPEC-662](#spec-662), [SPEC-666](#spec-666)

<a id="tstfunc-8"></a>
## TSTFUNC-8 — Core: independent zone selection and recovery

Type: test | State: approved | Revision: 3

Suite: Core. Definition for implementation; no execution result.

Exercise Off/Off, On/Off, Off/On, On/On with disagreeing device/custom fixtures. Check absent device profiles and older-API absence do not block valid custom classification. Invalid selected custom profiles never fall back; valid edits recover. Missing/malformed switch reads Off. Switch Off then On retains edited limits. Verify device mode retains native bounds and indices, including 10.

**Relations**

- verifies: [FR-16431](#fr-16431), [FR-16438](#fr-16438), [SPEC-663](#spec-663), [SPEC-664](#spec-664), [SPEC-666](#spec-666), [SPEC-668](#spec-668)

<a id="tstfunc-9"></a>
## TSTFUNC-9 — Core: selected profiles and seven exact colors

Type: test | State: approved | Revision: 8

Suite: Core. Definition for implementation; no execution result.

For HR/power current, 3s, activity/lap averages, numeric zone and Team, give different metric values and assert each uses its own selected profile/value. Hide numeric sources; cover both sets, regular/enlarged/duplicate slots, themes/inversion, None/Label/Whole cell. Assert palette zones 1..7 and native 10; dark magenta uses white label text, white value text only for Whole cell, Label retains normal value area. Invalid/recovered zones retain valid values/text and use neutral/recovered effects. Cadence, grade and temperature classification remain unchanged.

**Relations**

- verifies: [DVS-20](#dvs-20), [DVS-24](#dvs-24), [SPEC-246](#spec-246), [SPEC-248](#spec-248), [SPEC-253](#spec-253), [SPEC-663](#spec-663), [SPEC-664](#spec-664), [SPEC-665](#spec-665), [SPEC-666](#spec-666)

<a id="tstfunc-10"></a>
## TSTFUNC-10 — Core: custom zone properties and settings persistence

Type: test | State: approved | Revision: 6

Suite: Core. Definition for implementation; no execution result.

Compare twelve new keys/types/defaults/captions/ranges with property owners and generated catalogue; require 75 total unique properties, no schema or migration keys. Verify Training zones order, named power limits, units, open-final prompts and Team-before-slots. Save nondefault switches/limits through native settings callback, reload and app restart; test false/zero preservation and zero runtime writes. Serialize complete defaults and maximum allowed dictionary with Garmin SDK; both must be <=8000 bytes. Do not substitute XML byte length.

**Relations**

- verifies: [FR-16431](#fr-16431), [FR-16432](#fr-16432), [FR-16433](#fr-16433), [FR-16434](#fr-16434), [FR-16435](#fr-16435), [FR-16436](#fr-16436), [FR-16437](#fr-16437), [FR-16438](#fr-16438), [FR-16439](#fr-16439), [FR-16440](#fr-16440), [FR-16441](#fr-16441), [FR-16442](#fr-16442), [SPEC-155](#spec-155), [SPEC-245](#spec-245), [SPEC-300](#spec-300), [SPEC-668](#spec-668), [SPEC-669](#spec-669)

<a id="tstfunc-11"></a>
## TSTFUNC-11 — Core: zone preparation and activity isolation

Type: test | State: approved | Revision: 4

Suite: Core. Definition for implementation; no execution result.

Instrument init, settings reload, compute and drawing. Count one shared validation per changed family at preparation, no property parsing/profile validation/device-zone query in ordinary compute/draw, and no device lookup for custom-selected families. Reload source/limits while both banks contain duplicate, hidden and enlarged consumers; require next display updated and no stale cached zone/color/packet. Compare metric snapshots, rolling samples, lap history, active bank and trigger thresholds before/after: unchanged. Custom profiles share identity across consumers.

**Relations**

- verifies: [APP-26](#app-26), [SPEC-665](#spec-665), [SPEC-667](#spec-667), [SPEC-668](#spec-668)
