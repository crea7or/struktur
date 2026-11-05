# Struktur — current requirements snapshot

Working specification updated: **5 November 2026**. This specification preserves current review states. Test definitions are separate from execution results.

Field identity, labels, units, header templates and precision are stored as typed attributes. Conditional precision uses PRECISION_RULE rather than numeric PRECISION.

## Index

- [FR-16442 — Heart rate zone 4: upper bpm (hr4)](#fr-16442)
- [FR-16441 — Heart rate zone 3: upper bpm (hr3)](#fr-16441)
- [FR-16440 — Heart rate zone 2: upper bpm (hr2)](#fr-16440)
- [FR-16439 — Heart rate zone 1: upper bpm (hr1)](#fr-16439)
- [FR-16438 — Use custom heart rate zones (chz)](#fr-16438)
- [FR-16437 — Power zone 6 (Anaerobic): upper W (pw6)](#fr-16437)
- [FR-16436 — Power zone 5 (VO2 Max): upper W (pw5)](#fr-16436)
- [FR-16435 — Power zone 4 (Threshold): upper W (pw4)](#fr-16435)
- [FR-16434 — Power zone 3 (Tempo): upper W (pw3)](#fr-16434)
- [FR-16433 — Power zone 2 (Endurance): upper W (pw2)](#fr-16433)
- [FR-16432 — Power zone 1 (Active Recovery): upper W (pw1)](#fr-16432)
- [FR-16431 — Use custom power zones (cpz)](#fr-16431)
- [SPEC-666 — Keep invalid custom zone profiles unavailable](#spec-666)
- [SPEC-662 — Classify custom power into seven zones](#spec-662)
- [SPEC-661 — Classify custom heart rate into five zones](#spec-661)
- [SPEC-324 — Slot 7: background (a7_bg)](#spec-324)
- [SPEC-323 — Slot 7: value (a7)](#spec-323)
- [SPEC-322 — Slot 6: background (a6_bg)](#spec-322)
- [SPEC-321 — Slot 6: value (a6)](#spec-321)
- [SPEC-320 — Slot 5: background (a5_bg)](#spec-320)
- [SPEC-319 — Slot 5: value (a5)](#spec-319)
- [SPEC-310 — Team color source (tsrc)](#spec-310)
- [SPEC-252 — Configure four cadence upper boundaries](#spec-252)
- [SPEC-248 — Color each metric from its own value](#spec-248)
- [SPEC-247 — Classify cadence using five disjoint zones](#spec-247)
- [SPEC-246 — Use seven explicit training colors](#spec-246)
- [SPEC-244 — Read current properties without compatibility migration](#spec-244)
- [SPEC-243 — Use compact property keys](#spec-243)
- [SPEC-212 — Configure separate activation and return thresholds](#spec-212)
- [SPEC-211 — Select one activation event with Manual lap as default](#spec-211)
- [FUNC-8 — Lap cadence](#func-8)
- [FUNC-7 — Lap power](#func-7)
- [FUNC-6 — Lap heart rate](#func-6)
- [FUNC-3 — Lap distance](#func-3)
- [DVS-51 — Inverse theme for enlarged fields option](#dvs-51)
- [APP-49 — Select background coverage independently per field slot](#app-49)
- [DVS-47 — Display three-second average heart rate](#dvs-47)
- [DVS-45 — Keep slope and temperature palette extensions separate](#dvs-45)
- [APP-45 — Support day and night themes on Garmin devices](#app-45)
- [DVS-40 — Convert SDK units before displaying values](#dvs-40)
- [APP-30 — Configure visible count and value of each grid field](#app-30)
- [DVS-37 — Distance to next waypoint](#dvs-37)
- [DVS-33 — Calories](#dvs-33)
- [DVS-32 — Time of day](#dvs-32)
- [DVS-28 — Total descent](#dvs-28)
- [DVS-27 — Total ascent](#dvs-27)
- [DVS-26 — Elevation](#dvs-26)
- [DVS-25 — Distance](#dvs-25)
- [DVS-24 — Power zone](#dvs-24)
- [DVS-23 — Average power](#dvs-23)
- [DVS-21 — Current power](#dvs-21)
- [DVS-20 — Heart rate zone](#dvs-20)
- [DVS-19 — Average heart rate](#dvs-19)
- [DVS-18 — Current heart rate](#dvs-18)
- [DVS-11 — Average Cadence](#dvs-11)
- [DVS-10 — Current Cadence](#dvs-10)
- [DVS-9 — Average speed](#dvs-9)
- [DVS-8 — Current speed](#dvs-8)
- [DVS-7 — Display valid integral values within field bounds](#dvs-7)
- [DVS-4 — App shall support metric and imperial values](#dvs-4)
- [DVS-3 — Position numeric secondary text beside the primary value](#dvs-3)
- [DVS-2 — Format decimals using field precision and value magnitude](#dvs-2)
- [APP-25 — Use the three specified Roboto Condensed font roles](#app-25)
- [APP-22 — Select grid independently of alignment](#app-22)
- [FR-16465 — Classify a reading within qualified device zone boundaries](#fr-16465)
- [FR-16464 — Invalidate affected zone caches after source or limit edits](#fr-16464)
- [FR-16463 — Replace field-set presentation atomically](#fr-16463)
- [FR-16446 — Read battery only for retained active-bank needs](#fr-16446)
- [APP-53 — Keep preparation callbacks within the virtual-machine stack limit](#app-53)
- [APP-52 — Bound active configuration-bank resources](#app-52)
- [APP-51 — Advance shared acquisition once per compute callback](#app-51)
- [SPEC-669 — Order the shared training-zone controls](#spec-669)
- [SPEC-667 — Prepare shared zone profiles outside compute and drawing](#spec-667)
- [SPEC-665 — Share the selected zone profile with all consumers](#spec-665)
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
- [SPEC-318 — Slot 4: background (a4_bg)](#spec-318)
- [SPEC-317 — Slot 4: value (a4)](#spec-317)
- [SPEC-316 — Slot 3: background (a3_bg)](#spec-316)
- [SPEC-315 — Slot 3: value (a3)](#spec-315)
- [SPEC-314 — Slot 2: background (a2_bg)](#spec-314)
- [SPEC-313 — Slot 2: value (a2)](#spec-313)
- [SPEC-312 — Slot 1: background (a1_bg)](#spec-312)
- [SPEC-311 — Slot 1: value (a1)](#spec-311)
- [SPEC-307 — Grid type (a_grid)](#spec-307)
- [SPEC-306 — Inverse theme for enlarged slots (a_inv)](#spec-306)
- [SPEC-305 — Hide physical units in headers (a_hideu)](#spec-305)
- [SPEC-304 — Theme mode (a_theme)](#spec-304)
- [SPEC-303 — Alignment (a_align)](#spec-303)
- [SPEC-302 — Enlarged slot count (a_big)](#spec-302)
- [SPEC-245 — Bound the serialized settings dictionary](#spec-245)
- [SPEC-220 — Reset field-set switching at app and activity boundaries](#spec-220)
- [SPEC-218 — Switch field sets from legacy lap callbacks under manual-only setup](#spec-218)
- [SPEC-215 — Evaluate the heart-rate event from current heart rate](#spec-215)
- [SPEC-214 — Evaluate the power event from the shared three-second average](#spec-214)
- [SPEC-213 — Switch threshold modes with defined hysteresis](#spec-213)
- [SPEC-210 — Keep all settings on one savable main page](#spec-210)
- [SPEC-208 — Configure two independent field sets](#spec-208)
- [FUNC-10 — Integrate valid current-lap sensor intervals](#func-10)
- [DVS-50 — Show or hide physical units in field headers](#dvs-50)
- [SPEC-176 — Bundle exactly the glyphs that each application font role can render](#spec-176)
- [SPEC-162 — Gate development milestones on traceable requirement evidence](#spec-162)
- [SPEC-161 — Record unresolved product decisions before closing dependent development tasks](#spec-161)
- [SPEC-160 — Gate changes on repeatable compilation and explicit test evidence](#spec-160)
- [SPEC-157 — Keep Core, Memory, and Placement tests separate](#spec-157)
- [SPEC-156 — Generate field acquisition traceability from canonical owners](#spec-156)
- [SPEC-155 — Generate one typed settings catalogue](#spec-155)
- [SPEC-154 — Generate reproducible Garmin font resources](#spec-154)
- [SPEC-153 — Provide repeatable command-line build and package commands](#spec-153)
- [SPEC-152 — Version the Data Field project inputs](#spec-152)
- [SPEC-151 — Record the reproducible Connect IQ toolchain](#spec-151)
- [APP-46 — Configure visible fields in Garmin Connect](#app-46)
- [DVS-42 — Qualify device training-zone metadata before use](#dvs-42)
- [DVS-41 — Compute shared three-second windows](#dvs-41)
- [APP-38 — Qualify the declared Garmin device matrix](#app-38)
- [APP-37 — Meet the compute snapshot deadline](#app-37)
- [APP-36 — Keep text readable when effects and themes change](#app-36)
- [APP-33 — Publish a complete display snapshot before drawing](#app-33)
- [HFER-8 — Draw the Horizontal lines pattern](#hfer-8)
- [HFER-7 — Draw the Full grid pattern](#hfer-7)
- [DVS-35 — Device battery level](#dvs-35)
- [DVS-22 — Three-second average power](#dvs-22)
- [DVS-12 — Define field headers and their common band height](#dvs-12)
- [APP-21 — Align complete headers and value groups horizontally](#app-21)
- [APP-20 — Configure the two-column Garmin field grid](#app-20)
- [PERF-14 — Keep memory observers bounded and report their overhead](#perf-14)
- [PERF-13 — Apply runtime allocation and growth acceptance criteria](#perf-13)
- [NFR-20 — Record test executions against their captured evidence](#nfr-20)
- [NFR-19 — Qualify onboard temperature provenance per model and firmware](#nfr-19)
- [NFR-18 — Verify captured simulator images against explicit expectations](#nfr-18)
- [NFR-17 — Keep font probes and Data Field allocation qualification in Memory](#nfr-17)
- [NFR-16 — Keep deliberate insufficient-area cases in Placement](#nfr-16)
- [NFR-15 — Cover functional and ordinary UI behavior in Core tests](#nfr-15)
- [NFR-14 — Provide deterministic timestamped sensor fixtures](#nfr-14)
- [NFR-13 — Verify signed package compatibility gates before distribution](#nfr-13)
- [NFR-12 — Build store packages with an isolated device metadata overlay](#nfr-12)
- [NFR-11 — Clean up only owned SDK runner processes](#nfr-11)
- [NFR-10 — Use consistent code-size optimization for every build mode](#nfr-10)
- [NFR-9 — Protect and retain the external signing identity](#nfr-9)
- [NFR-8 — Fail simulator orchestration on incomplete or failed execution](#nfr-8)
- [NFR-7 — Apply the evidenced per-model firmware and API floors](#nfr-7)
- [NFR-6 — Record device API capabilities and guarded fallbacks](#nfr-6)
- [NFR-5 — Provide reproducible developer and CI setup instructions](#nfr-5)
- [NFR-4 — Test font validation with known invalid fixtures](#nfr-4)
- [NFR-3 — Record traceable glyph generation inputs and outputs](#nfr-3)
- [FR-16469 — Explain training-zone units and active custom limits](#fr-16469)
- [HFE-3 — Use consistent settings captions and prompts](#hfe-3)
- [HFE-2 — Order the main settings page consistently](#hfe-2)
- [NFR-2 — Keep corresponding bank property domains and defaults independent](#nfr-2)
- [FR-16468 — Reject old event notifications after activity reset](#fr-16468)
- [FR-16467 — Keep switching state through pause and resume](#fr-16467)
- [FR-16466 — Explain the legacy Manual lap setup restriction](#fr-16466)
- [PERF-12 — Keep production memory and deadline diagnostics disabled](#perf-12)
- [FR-16462 — Keep settings across saves and restarts](#fr-16462)
- [PERF-11 — Load API 4+ outline fonts only for visible painted roles](#perf-11)
- [PERF-10 — Validate temperature cache age before each use](#perf-10)
- [PERF-9 — Read clock values only when an active retained field needs them](#perf-9)
- [PERF-8 — Refresh device presentation preferences during compute](#perf-8)
- [PERF-7 — Release outgoing display resources before a property reload](#perf-7)
- [PERF-6 — Bound retained state and release replaced caches](#perf-6)
- [PERF-5 — Release drawing contexts at their callback boundary](#perf-5)
- [FR-16461 — Measure native Team text only with the current layout drawing context](#fr-16461)
- [FR-16460 — Place the Team text block within the value area](#fr-16460)
- [FR-16459 — Guarantee the normal temperature display range](#fr-16459)
- [FR-16458 — Expire cached temperature without extending its age](#fr-16458)
- [FR-16457 — Deliver and validate background temperature packets](#fr-16457)
- [FR-16456 — Accept temperature only with onboard sensor provenance](#fr-16456)
- [FR-16455 — Guarantee the normal grade display range](#fr-16455)
- [FR-16454 — Draw the grade horizon for Whole cell coverage](#fr-16454)
- [FR-16453 — Reset grade history after invalid input or lost progress](#fr-16453)
- [FR-16452 — Average the latest five grade estimates](#fr-16452)
- [FR-16451 — Keep or invalidate the completed-lap count](#fr-16451)
- [FR-16450 — Reject discontinuous current-lap sensor intervals](#fr-16450)
- [FR-16449 — Invalidate current-lap values when continuity is lost](#fr-16449)
- [FR-16448 — Process each delivered lap boundary once](#fr-16448)
- [FR-16447 — Recover current-lap tracking after late loading](#fr-16447)
- [FR-16445 — Select the halo renderer for the device profile](#fr-16445)
- [NFR-1 — Verify the fixed numeric fonts with clock and timer groups](#nfr-1)
- [HFE-1 — Center values below the reserved header area](#hfe-1)
- [APP-55 — Guarantee inclusive normal display ranges across device profiles](#app-55)
- [APP-54 — Display centered fallback message when grid cannot fit drawing bounds](#app-54)
- [DVS-59 — Keep current-lap state through pause and presentation changes](#dvs-59)
- [DVS-58 — Capture current-lap baselines at each confirmed boundary](#dvs-58)
- [DVS-57 — Bind Team colors to the selected current-value zone source](#dvs-57)
- [DVS-56 — Select automatic Team font candidates with fit fallback](#dvs-56)
- [DVS-55 — Select temperature background colors with explicit band boundaries](#dvs-55)
- [DVS-54 — Schedule background temperature reads at the permitted interval](#dvs-54)
- [DVS-53 — Select grade background colors with explicit band boundaries](#dvs-53)
- [DVS-52 — Calculate a grade estimate by linear regression](#dvs-52)
- [APP-50 — Cache layout geometry and refit text only on content changes](#app-50)
- [SPEC-670 — Text outline on colored backgrounds (halo)](#spec-670)
- [SPEC-668 — Keep activity state when editing zone settings](#spec-668)
- [SPEC-664 — Select the global heart rate zone source](#spec-664)
- [SPEC-663 — Select the global power zone source](#spec-663)
- [SPEC-308 — Team name (team)](#spec-308)
- [SPEC-301 — Property field-selection codes](#spec-301)
- [SPEC-253 — Wrap the Team field text without splitting words](#spec-253)
- [SPEC-249 — Fall back without discarding a valid metric](#spec-249)
- [SPEC-221 — Apply settings changes without replaying old events](#spec-221)
- [SPEC-219 — Latch the second set from workout start until timer reset](#spec-219)
- [SPEC-217 — Toggle on manual typed lap events exactly once](#spec-217)
- [SPEC-216 — Return threshold modes to default on unavailable input](#spec-216)
- [FUNC-9 — Confirm a fresh session before using zero lap baselines](#func-9)
- [FUNC-5 — Lap speed](#func-5)
- [FUNC-4 — Lap time](#func-4)
- [SPEC-177 — Reject invalid generated glyph inventories and masks](#spec-177)
- [SPEC-159 — Define and record physical-device qualification](#spec-159)
- [SPEC-158 — Run the declared-device simulator scenario matrix](#spec-158)
- [APP-48 — Measure runtime memory across the required configurations](#app-48)
- [APP-47 — Apply per-device Connect IQ Data Field memory ceilings](#app-47)
- [APP-35 — Show unavailable activity values without stale readings](#app-35)
- [APP-34 — Fit cell headers and values within numeric margins without scaling](#app-34)
- [APP-32 — Apply changed settings through one coherent presentation](#app-32)
- [APP-31 — Validate saved settings and use safe display defaults](#app-31)
- [DVS-39 — Count confirmed completed laps in a fresh observed session](#dvs-39)
- [DVS-36 — Heading](#dvs-36)
- [DVS-34 — Read native temperature only in the background worker](#dvs-34)
- [DVS-31 — Elapsed time](#dvs-31)
- [DVS-30 — Activity timer](#dvs-30)
- [DVS-29 — Estimate grade from altitude and distance with FIFO sampling](#dvs-29)
- [DVS-13 — Duration values display format](#dvs-13)
- [DVS-6 — Render transparent text and a one-pixel contrast halo](#dvs-6)
- [APP-26 — Replay prepared drawing with a bounded dirty-layout exception](#app-26)
- [APP-24 — Target Garmin Edge full-screen design profiles](#app-24)
- [APP-23 — Choose grid row capacity from the assigned drawing area](#app-23)
- [PERF-4 — Test Requirement](#perf-4)
- [TFNC-6 — Unit conversion and complete duration formatting](#tfnc-6)
- [TUI-9 — Complete clock and duration groups fit native cells](#tui-9)
- [SPEC-170 — Verify the complete declared-device simulator scenario matrix](#spec-170)
- [TPRF-9 — Normal Data Field runtime memory validation](#tprf-9)
- [TPRF-6 — Optional battery clock and diagnostic work](#tprf-6)
- [TUI-1 — Production drawing alignment and palettes](#tui-1)
- [TFNC-15 — Temperature delivery delay and clock guards](#tfnc-15)
- [TPRF-4 — Bounded snapshot caches and live-input invalidation](#tprf-4)
- [TPRF-5 — Changed-cell fitting and prepared-only rendering](#tprf-5)
- [SPEC-299 — Verify Team preparation invalidation](#spec-299)
- [SPEC-174 — Verify: define development milestones and traceable release evidence](#spec-174)
- [SPEC-171 — Verify: provide physical-device and memory-performance qualification procedures](#spec-171)
- [SPEC-169 — Verify: run deterministic Monkey C tests for formatting, settings and sample processing](#spec-169)
- [SPEC-168 — Verify: specify each displayed value acquisition path and deterministic sensor fixtures](#spec-168)
- [SPEC-165 — Verify: provide repeatable CLI build, simulator-test and package commands](#spec-165)
- [TSTFUNC-5 — SDK runner process ownership and cleanup](#tstfunc-5)
- [TINT-1 — Compile the production Data Field for each declared profile](#tint-1)
- [SPEC-164 — Verify: version the Data Field project and per-device API capability matrix](#spec-164)
- [SPEC-163 — Verify: record and verify a reproducible Connect IQ development toolchain](#spec-163)
- [SPEC-179 — Verify font rejection, regeneration and declared-profile compatibility](#spec-179)
- [SPEC-226 — Core: verify second-set settings, defaults](#spec-226)
- [TSTFUNC-4 — Core: compact properties, defaults and field applicability](#tstfunc-4)
- [TSTFUNC-10 — Core: custom zone properties and settings persistence](#tstfunc-10)
- [SPEC-229 — Core: verify workout-start latch and timer-reset return](#spec-229)
- [SPEC-230 — Core: verify switching lifecycle, atomic frames and shared acquisition](#spec-230)
- [SPEC-228 — Core: verify manual-lap adapters and exactly-once boundaries](#spec-228)
- [SPEC-284 — Verify native power-zone mapping](#spec-284)
- [TFNC-24 — Validated zone metadata and snapshot classification](#tfnc-24)
- [TSTFUNC-11 — Core: zone preparation and activity isolation](#tstfunc-11)
- [TSTFUNC-3 — Native properties persistence and settings callback](#tstfunc-3)
- [SPEC-298 — Verify automatic Team fitting preserves settings](#spec-298)
- [SPEC-291 — Verify Team native text bounds](#spec-291)
- [TUI-11 — Guaranteed normal values stay inside native cell borders](#tui-11)
- [TFNC-14 — Temperature packet, cache-age and display precision boundaries](#tfnc-14)
- [TFNC-16 — Legal temperature scheduling and runtime source guards](#tfnc-16)
- [TFNC-4 — Grade and temperature effect boundaries](#tfnc-4)
- [TFNC-11 — Grade continuity and bounded sample history](#tfnc-11)
- [TFNC-10 — Grade regression, distinct distances and startup averaging](#tfnc-10)
- [TFNC-18 — Data Field callbacks preserve lap continuity](#tfnc-18)
- [TFNC-13 — Lap identity, regression and overflow invalidation](#tfnc-13)
- [TFNC-26 — Late loading and gaps do not invent lap history](#tfnc-26)
- [TFNC-25 — Current-lap distance time and weighted averages](#tfnc-25)
- [TCOM-1 — Exact glyph inventories and reproducible font resources](#tcom-1)
- [TFNC-12 — Known-zero lap baseline and pause/reset lifecycle](#tfnc-12)
- [SPEC-293 — Verify Team source binding and fallback](#spec-293)
- [SPEC-297 — Verify automatic Team font eligibility](#spec-297)
- [SPEC-292 — Verify native Team font selection](#spec-292)
- [TUI-7 — Effect foreground contrast and exact glyph widths](#tui-7)
- [TUI-10 — Exact formatting throughout declared normal intervals](#tui-10)
- [TUI-13 — Unsupported and reduced-area presentation matrix](#tui-13)
- [SPEC-232 — Placement: verify compact fallback independently for both field sets](#spec-232)
- [TSTFUNC-2 — Mixed Team and metric layouts through typed lap callbacks](#tstfunc-2)
- [SPEC-231 — Memory: verify bounded allocation while switching both field sets](#spec-231)
- [TFNC-17 — Shared acquisition integration and duplicate slots](#tfnc-17)
- [TFNC-5 — Typed settings defaults and hidden-slot preservation](#tfnc-5)
- [SPEC-167 — Verify: publish one typed settings catalogue shared by XML, runtime and tests](#spec-167)
- [SPEC-277 — Verify read-only compact property loading](#spec-277)
- [SPEC-150 — Development and Verification](#spec-150)
- [SPEC-207 — Triggered Field Sets](#spec-207)
- [SPEC-233 — Shared Coloring and Settings Compatibility](#spec-233)
- [APP-1 — Application Design](#app-1)
- [SPEC-175 — Bundled Glyph Inventory](#spec-175)
- [SPEC-660 — Custom Training Zones](#spec-660)
- [DVS-1 — Selectable Fields and Shared Display Rules](#dvs-1)
- [SPEC-300 — Application Properties](#spec-300)
- [SPEC-276 — Verify current coverage settings without legacy declarations](#spec-276)
- [SPEC-272 — Verify enlarged semantic label fill](#spec-272)
- [SPEC-268 — Verify background coverage regions](#spec-268)
- [SPEC-267 — Verify background mode choices](#spec-267)
- [TRGR-2 — Placement](#trgr-2)
- [TPER-1 — Memory](#tper-1)
- [TSTFUNC-9 — Core: selected profiles and seven exact colors](#tstfunc-9)
- [TSTFUNC-8 — Core: independent zone selection and recovery](#tstfunc-8)
- [TSTFUNC-7 — Core: custom power boundaries and names](#tstfunc-7)
- [TSTFUNC-6 — Core: custom HR boundaries and validation](#tstfunc-6)
- [TRGR-1 — Core](#trgr-1)
- [SPEC-279 — Verify exact seven-zone colors](#spec-279)
- [TFNC-21 — Verify current-lap fields, averages and boundary lifecycle](#tfnc-21)
- [SPEC-296 — Verify Team and coloring runtime memory](#spec-296)
- [TSTFUNC-1 — Verify battery percentage validity before rounding](#tstfunc-1)
- [SPEC-295 — Verify Team insufficient-area handling](#spec-295)
- [SPEC-294 — Verify Team coloring regions](#spec-294)
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
- [SPEC-278 — Verify serialized property budget](#spec-278)
- [SPEC-275 — Verify color-only packet invalidation](#spec-275)
- [SPEC-274 — Verify enlarged color bounds and contrast](#spec-274)
- [SPEC-273 — Verify enlarged neutral fallback](#spec-273)
- [SPEC-271 — Verify mode-only invalidation](#spec-271)
- [SPEC-270 — Verify isolated mode validation](#spec-270)
- [SPEC-269 — Verify whole-cell text contrast](#spec-269)
- [SPEC-227 — Core: verify threshold hysteresis and source validity](#spec-227)
- [TUI-12 — Actual overflow and compact layout cache behavior](#tui-12)
- [TPRF-8 — All three profile font resources can load](#tprf-8)
- [TFNC-23 — Rolling samples use activity time and valid values](#tfnc-23)
- [TUI-6 — Exactly three fixed font roles in every layout](#tui-6)
- [TUI-5 — Reviewed field formatting and stable choices](#tui-5)
- [TFNC-22 — Magnitude-based speed, fixed-decimal slope and integral elevation](#tfnc-22)
- [TFNC-19 — Invalid acquisition input and safe background startup](#tfnc-19)
- [TFNC-8 — All field unit headers and secondary-unit switches](#tfnc-8)
- [TFNC-7 — Measured caption and duration fitting](#tfnc-7)
- [TFNC-3 — Three-second rolling-window continuity](#tfnc-3)
- [TFNC-2 — All six full-capacity logical grids](#tfnc-2)
- [TFNC-1 — Floating-point display boundaries](#tfnc-1)
- [SPEC-178 — Verify exact glyph inventories across font roles and supported UI states](#spec-178)
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
- [APP-42 — Toybox.UserProfile.getHeartRateZones(...)](#app-42)
- [APP-41 — Toybox.WatchUi.requestUpdate()](#app-41)
- [APP-15 — Toybox.Application.Properties.getValue(key)](#app-15)
- [APP-5 — initialize()](#app-5)
- [APP-11 — onStop(state)](#app-11)
- [APP-16 — Toybox.Activity.getActivityInfo()](#app-16)
- [APP-6 — onSettingsChanged()](#app-6)
- [TUI-14 — Documented unsupported fields fail safe fitting](#tui-14)
- [TPRF-7 — Isolated three-font resource allocation probe](#tprf-7)
- [TUI-8 — Default-on grid visibility and unchanged cell drawing](#tui-8)
- [TUI-4 — Normal default ride headers and cell bounds](#tui-4)
- [TUI-3 — Literal and unit-template header selection](#tui-3)
- [TUI-2 — Measure complete label and unit headers](#tui-2)
- [TSEC-1 — Publication privacy, export integrity and current project consistency](#tsec-1)
- [TFNC-20 — Reject semantic font defects with refreshed cached hashes](#tfnc-20)
- [TFNC-9 — Independent theme inversion and sample preservation](#tfnc-9)
- [SPEC-173 — Verify: record unresolved product decisions before closing dependent development tasks](#spec-173)
- [SPEC-172 — Verify: gate changes on repeatable compilation and explicit test evidence](#spec-172)
- [APP-40 — Toybox.Application.AppBase.onNightModeChanged()](#app-40)
- [APP-39 — Toybox.System.getDeviceSettings().isNightModeEnabled](#app-39)
- [APP-19 — Toybox.WatchUi.DataField.createField(...)](#app-19)
- [APP-18 — Toybox.UserProfile.getProfile()](#app-18)
- [APP-17 — Toybox.System.getSystemStats()](#app-17)
- [APP-14 — onHide()](#app-14)
- [APP-13 — onShow()](#app-13)
- [APP-10 — onStart(state)](#app-10)
- [APP-9 — getInitialView()](#app-9)

<a id="fr-16442"></a>
## FR-16442 — Heart rate zone 4: upper bpm (hr4)

Type: requirement | State: approved | Revision: 20

Key: `hr4`
Caption: Heart rate zone 4: upper bpm
Type and values: Integer 0..250
Default: `0`

Zero means unset and is not a valid limit. The app must use this global upper limit for zone 4. The app must validate the full tuple under [SPEC-661](#spec-661). The app must read missing input as zero. Present invalid input invalidates the profile without changing storage. The app must keep the stored value while custom mode is Off.

The app must use [SPEC-664](#spec-664) for the option behavior.

**Relations**

- uses: [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-47](#dvs-47), [FUNC-6](#func-6), [SPEC-253](#spec-253), [SPEC-661](#spec-661), [SPEC-664](#spec-664)

<a id="fr-16441"></a>
## FR-16441 — Heart rate zone 3: upper bpm (hr3)

Type: requirement | State: approved | Revision: 20

Key: `hr3`
Caption: Heart rate zone 3: upper bpm
Type and values: Integer 0..250
Default: `0`

Zero means unset and is not a valid limit. The app must use this global upper limit for zone 3. The app must validate the full tuple under [SPEC-661](#spec-661). The app must read missing input as zero. Present invalid input invalidates the profile without changing storage. The app must keep the stored value while custom mode is Off.

The app must use [SPEC-664](#spec-664) for the option behavior.

**Relations**

- uses: [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-47](#dvs-47), [FUNC-6](#func-6), [SPEC-253](#spec-253), [SPEC-661](#spec-661), [SPEC-664](#spec-664)

<a id="fr-16440"></a>
## FR-16440 — Heart rate zone 2: upper bpm (hr2)

Type: requirement | State: approved | Revision: 20

Key: `hr2`
Caption: Heart rate zone 2: upper bpm
Type and values: Integer 0..250
Default: `0`

Zero means unset and is not a valid limit. The app must use this global upper limit for zone 2. The app must validate the full tuple under [SPEC-661](#spec-661). The app must read missing input as zero. Present invalid input invalidates the profile without changing storage. The app must keep the stored value while custom mode is Off.

The app must use [SPEC-664](#spec-664) for the option behavior.

**Relations**

- uses: [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-47](#dvs-47), [FUNC-6](#func-6), [SPEC-253](#spec-253), [SPEC-661](#spec-661), [SPEC-664](#spec-664)

<a id="fr-16439"></a>
## FR-16439 — Heart rate zone 1: upper bpm (hr1)

Type: requirement | State: approved | Revision: 20

Key: `hr1`
Caption: Heart rate zone 1: upper bpm
Type and values: Integer 0..250
Default: `0`

Zero means unset and is not a valid limit. The app must use this global upper limit for zone 1. The app must validate the full tuple under [SPEC-661](#spec-661). The app must read missing input as zero. Present invalid input invalidates the profile without changing storage. The app must keep the stored value while custom mode is Off.

The app must use [SPEC-664](#spec-664) for the option behavior.

**Relations**

- uses: [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-47](#dvs-47), [FUNC-6](#func-6), [SPEC-253](#spec-253), [SPEC-661](#spec-661), [SPEC-664](#spec-664)

<a id="fr-16438"></a>
## FR-16438 — Use custom heart rate zones (chz)

Type: requirement | State: approved | Revision: 20

Key: `chz`
Caption: Use custom heart rate zones
Type and values: Boolean
Default: `false`

Only Boolean true enables custom heart rate zones. Missing or malformed values read as false without changing storage.
The app must use [SPEC-664](#spec-664) for the option behavior.

**Relations**

- uses: [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-47](#dvs-47), [FUNC-6](#func-6), [SPEC-253](#spec-253), [SPEC-664](#spec-664)

<a id="fr-16437"></a>
## FR-16437 — Power zone 6 (Anaerobic): upper W (pw6)

Type: requirement | State: approved | Revision: 20

Key: `pw6`
Caption: Power zone 6 (Anaerobic): upper W
Type and values: Integer 0..3000
Default: `0`

Zero means unset and is not a valid limit. The app must use this global upper limit for zone 6. The app must validate the full tuple under [SPEC-662](#spec-662). The app must read missing input as zero. Present invalid input invalidates the profile without changing storage. The app must keep the stored value while custom mode is Off.

The app must use [SPEC-663](#spec-663) for the option behavior.

**Relations**

- uses: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [FUNC-7](#func-7), [SPEC-253](#spec-253), [SPEC-662](#spec-662), [SPEC-663](#spec-663)

<a id="fr-16436"></a>
## FR-16436 — Power zone 5 (VO2 Max): upper W (pw5)

Type: requirement | State: approved | Revision: 20

Key: `pw5`
Caption: Power zone 5 (VO2 Max): upper W
Type and values: Integer 0..3000
Default: `0`

Zero means unset and is not a valid limit. The app must use this global upper limit for zone 5. The app must validate the full tuple under [SPEC-662](#spec-662). The app must read missing input as zero. Present invalid input invalidates the profile without changing storage. The app must keep the stored value while custom mode is Off.

The app must use [SPEC-663](#spec-663) for the option behavior.

**Relations**

- uses: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [FUNC-7](#func-7), [SPEC-253](#spec-253), [SPEC-662](#spec-662), [SPEC-663](#spec-663)

<a id="fr-16435"></a>
## FR-16435 — Power zone 4 (Threshold): upper W (pw4)

Type: requirement | State: approved | Revision: 20

Key: `pw4`
Caption: Power zone 4 (Threshold): upper W
Type and values: Integer 0..3000
Default: `0`

Zero means unset and is not a valid limit. The app must use this global upper limit for zone 4. The app must validate the full tuple under [SPEC-662](#spec-662). The app must read missing input as zero. Present invalid input invalidates the profile without changing storage. The app must keep the stored value while custom mode is Off.

The app must use [SPEC-663](#spec-663) for the option behavior.

**Relations**

- uses: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [FUNC-7](#func-7), [SPEC-253](#spec-253), [SPEC-662](#spec-662), [SPEC-663](#spec-663)

<a id="fr-16434"></a>
## FR-16434 — Power zone 3 (Tempo): upper W (pw3)

Type: requirement | State: approved | Revision: 20

Key: `pw3`
Caption: Power zone 3 (Tempo): upper W
Type and values: Integer 0..3000
Default: `0`

Zero means unset and is not a valid limit. The app must use this global upper limit for zone 3. The app must validate the full tuple under [SPEC-662](#spec-662). The app must read missing input as zero. Present invalid input invalidates the profile without changing storage. The app must keep the stored value while custom mode is Off.

The app must use [SPEC-663](#spec-663) for the option behavior.

**Relations**

- uses: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [FUNC-7](#func-7), [SPEC-253](#spec-253), [SPEC-662](#spec-662), [SPEC-663](#spec-663)

<a id="fr-16433"></a>
## FR-16433 — Power zone 2 (Endurance): upper W (pw2)

Type: requirement | State: approved | Revision: 20

Key: `pw2`
Caption: Power zone 2 (Endurance): upper W
Type and values: Integer 0..3000
Default: `0`

Zero means unset and is not a valid limit. The app must use this global upper limit for zone 2. The app must validate the full tuple under [SPEC-662](#spec-662). The app must read missing input as zero. Present invalid input invalidates the profile without changing storage. The app must keep the stored value while custom mode is Off.

The app must use [SPEC-663](#spec-663) for the option behavior.

**Relations**

- uses: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [FUNC-7](#func-7), [SPEC-253](#spec-253), [SPEC-662](#spec-662), [SPEC-663](#spec-663)

<a id="fr-16432"></a>
## FR-16432 — Power zone 1 (Active Recovery): upper W (pw1)

Type: requirement | State: approved | Revision: 20

Key: `pw1`
Caption: Power zone 1 (Active Recovery): upper W
Type and values: Integer 0..3000
Default: `0`

Zero means unset and is not a valid limit. The app must use this global upper limit for zone 1. The app must validate the full tuple under [SPEC-662](#spec-662). The app must read missing input as zero. Present invalid input invalidates the profile without changing storage. The app must keep the stored value while custom mode is Off.

The app must use [SPEC-663](#spec-663) for the option behavior.

**Relations**

- uses: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [FUNC-7](#func-7), [SPEC-253](#spec-253), [SPEC-662](#spec-662), [SPEC-663](#spec-663)

<a id="fr-16431"></a>
## FR-16431 — Use custom power zones (cpz)

Type: requirement | State: approved | Revision: 20

Key: `cpz`
Caption: Use custom power zones
Type and values: Boolean
Default: `false`

Only Boolean true enables custom power zones. Missing or malformed values read as false without changing storage.
The app must use [SPEC-663](#spec-663) for the option behavior.

**Relations**

- uses: [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [FUNC-7](#func-7), [SPEC-253](#spec-253), [SPEC-663](#spec-663)

<a id="spec-666"></a>
## SPEC-666 — Keep invalid custom zone profiles unavailable

Type: requirement | State: approved | Revision: 8

A selected custom tuple must contain finite integers within its usable range, in strictly increasing order.
For a missing, malformed, out-of-range, or unordered tuple, the app must make that family's zones unavailable.
The app must not select device zones, sort, clamp, or change stored values.
The app must keep valid metrics and Team text. Zone-number fields show unavailable, and enabled effects use [SPEC-249](#spec-249).
A later valid edit restores classification without an activity restart.

**Relations**

- uses: [SPEC-249](#spec-249), [SPEC-661](#spec-661), [SPEC-662](#spec-662)

<a id="spec-662"></a>
## SPEC-662 — Classify custom power into seven zones

Type: requirement | State: approved | Revision: 8

The app must classify finite, nonnegative power against six strictly increasing integer limits from 1 to 3000 watts.
The app must round the reading to whole watts under [DVS-7](#dvs-7). The app must select the first zone whose upper limit includes the rounded reading.
The app must use zone 7 above the sixth limit. Equality remains in the lower zone. Zero watts is valid.

Missing, negative, and non-finite raw readings have no zone. Readings above 3000 watts still classify.
The app must use these zone names in order: Active Recovery, Endurance, Tempo, Threshold, VO2 Max, Anaerobic, Neuromuscular.

<a id="spec-661"></a>
## SPEC-661 — Classify custom heart rate into five zones

Type: requirement | State: approved | Revision: 8

The app must classify a finite positive heart rate against four strictly increasing integer limits from 30 to 250 bpm.
The app must round the reading to whole bpm under [DVS-7](#dvs-7). The app must select the first zone whose upper limit includes the rounded reading.
The app must use zone 5 above the fourth limit. Equality remains in the lower zone.
Missing, zero, negative, and non-finite raw readings have no zone.

Positive readings above 250 bpm still classify. The app must not clamp them.

<a id="spec-324"></a>
## SPEC-324 — Slot 7: background (a7_bg)

Type: requirement | State: approved | Revision: 43

Key: `a7_bg`
Caption: Slot 7: background
Type and values: Integer 0, 1, 2
Default: `0`

The app must apply this option to slot 7 in the default set.
The app must use [APP-49](#app-49) for the option behavior.

**Relations**

- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-323"></a>
## SPEC-323 — Slot 7: value (a7)

Type: requirement | State: approved | Revision: 42

Key: `a7`
Caption: Slot 7: value
Type and values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
Default: `12`

The app must apply this option to slot 7 in the default set.
The app must use [APP-30](#app-30) for the option behavior.

**Relations**

- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-322"></a>
## SPEC-322 — Slot 6: background (a6_bg)

Type: requirement | State: approved | Revision: 43

Key: `a6_bg`
Caption: Slot 6: background
Type and values: Integer 0, 1, 2
Default: `0`

The app must apply this option to slot 6 in the default set.
The app must use [APP-49](#app-49) for the option behavior.

**Relations**

- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-321"></a>
## SPEC-321 — Slot 6: value (a6)

Type: requirement | State: approved | Revision: 42

Key: `a6`
Caption: Slot 6: value
Type and values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
Default: `8`

The app must apply this option to slot 6 in the default set.
The app must use [APP-30](#app-30) for the option behavior.

**Relations**

- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-320"></a>
## SPEC-320 — Slot 5: background (a5_bg)

Type: requirement | State: approved | Revision: 43

Key: `a5_bg`
Caption: Slot 5: background
Type and values: Integer 0, 1, 2
Default: `0`

The app must apply this option to slot 5 in the default set.
The app must use [APP-49](#app-49) for the option behavior.

**Relations**

- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-319"></a>
## SPEC-319 — Slot 5: value (a5)

Type: requirement | State: approved | Revision: 42

Key: `a5`
Caption: Slot 5: value
Type and values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
Default: `4`

The app must apply this option to slot 5 in the default set.
The app must use [APP-30](#app-30) for the option behavior.

**Relations**

- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-310"></a>
## SPEC-310 — Team color source (tsrc)

Type: requirement | State: approved | Revision: 15

Key: `tsrc`
Caption: Team color source
Type and values: Integer 0, 1, 2
Default: `0`

The app must select the shared Team color source: 0 None, 1 current Power, 2 current Heart rate. Heart rate and power use their selected global zone profiles under [SPEC-664](#spec-664) and [SPEC-663](#spec-663). Source selection does not enable slot coverage. For invalid or missing input, the app must use 0 without changing storage.

**Relations**

- uses: [SPEC-253](#spec-253), [SPEC-663](#spec-663), [SPEC-664](#spec-664)

<a id="spec-252"></a>
## SPEC-252 — Configure four cadence upper boundaries

Type: requirement | State: approved | Revision: 17

The app must use [SPEC-331](#spec-331) through [SPEC-334](#spec-334) as the global cadence upper limits.
A valid profile must satisfy t1 < t2 < t3 < t4.
The app must use the individual default for a missing limit.
Present invalid limits make cadence coloring neutral. The app must not sort, clamp, or change stored limits.

**Relations**

- uses: [APP-31](#app-31), [SPEC-249](#spec-249)

<a id="spec-248"></a>
## SPEC-248 — Color each metric from its own value

Type: requirement | State: approved | Revision: 62

Color each numeric metric from its own displayed whole-unit value using its declared heart rate, power, or cadence source.
The app must apply this rule to current, rolling, activity-average, and lap-average values.
Heart rate and power use [SPEC-664](#spec-664) and [SPEC-663](#spec-663). Cadence uses [SPEC-252](#spec-252).
Zone-number fields reuse their derived index. The app must not classify a zone index as bpm or watts.

**Relations**

- allocated_to: [APP-3](#app-3), [APP-4](#app-4)
- uses: [DVS-7](#dvs-7), [SPEC-246](#spec-246), [SPEC-663](#spec-663), [SPEC-664](#spec-664)

<a id="spec-247"></a>
## SPEC-247 — Classify cadence using five disjoint zones

Type: requirement | State: approved | Revision: 15

The app must classify finite, nonnegative displayed whole rpm against t1 through t4.
Zone 1 includes zero through t1. Zones 2 through 4 are above the preceding limit and at or below their own limit.
Zone 5 contains values above t4.
Zero is valid. Missing, negative, and non-finite readings have no zone.

**Relations**

- uses: [DVS-7](#dvs-7), [SPEC-252](#spec-252)

<a id="spec-246"></a>
## SPEC-246 — Use seven explicit training colors

Type: requirement | State: approved | Revision: 28

The app must use these training-zone colors:

| Zone | Color | RGB |
| --- | --- | --- |
| 1 | Blue | #00AAFF |
| 2 | Green | #00FF00 |
| 3 | Yellow | #FFAA00 |
| 4 | Orange | #FF5500 |
| 5 | Red | #FF0000 |
| 6 | Magenta | #FF00FF |
| 7 and above | Dark magenta | #AA00AA |

The app must keep the actual numeric zone index. Heart rate and cadence keep five-zone domains.
The app must use neutral coverage for unsupported or out-of-domain metadata. Themes and enlargement must not change semantic RGB colors.
The app must use [APP-36](#app-36) for text contrast, including white text over dark magenta.

<a id="spec-244"></a>
## SPEC-244 — Read current properties without compatibility migration

Type: requirement | State: approved | Revision: 19

The app must load only the current property catalogue. The app must not read, convert, or migrate legacy settings.
The app must not add legacy switches, schema markers, or installation-origin properties.
The app must validate read fallbacks without changing settings or clearing storage. The app must use each property owner's factory default.

**Relations**

- uses: [SPEC-155](#spec-155)

<a id="spec-243"></a>
## SPEC-243 — Use compact property keys

Type: requirement | State: approved | Revision: 34

The app must store only keys declared in [SPEC-300](#spec-300).
The app must use unique lowercase ASCII letters, digits, and underscores. Each key must start with a letter and contain at most eight characters.
Prefix default-set keys with a and second-set keys with b where the catalogue specifies banked keys.
The app must keep readable captions and the wording Slot N. The app must not add legacy aliases.

**Relations**

- uses: [APP-49](#app-49), [SPEC-155](#spec-155), [SPEC-244](#spec-244)

<a id="spec-212"></a>
## SPEC-212 — Configure separate activation and return thresholds

Type: requirement | State: approved | Revision: 19

The app must configure separate power and heart rate activation and return thresholds through [SPEC-336](#spec-336) to [SPEC-339](#spec-339).
Each valid pair must satisfy return <= activation. The app must state this condition in the prompts.
The app must validate each property's type and range under [APP-31](#app-31), using its own default for missing or malformed input.
If the selected pair has return > activation, the app must keep the default set until correction.
The app must not reorder, clamp, swap, or change the saved pair.

An invalid unused pair must not disable another mode. Equal thresholds are valid under [SPEC-213](#spec-213).

**Relations**

- uses: [SPEC-213](#spec-213)

<a id="spec-211"></a>
## SPEC-211 — Select one activation event with Manual lap as default

Type: requirement | State: approved | Revision: 26

The app must use [SPEC-335](#spec-335) to select exactly one activation mode. Manual lap is the default.
Only events for the selected mode can change the active set.
None always selects the default set and keeps the saved second-set settings.
The app must not provide an independent enable switch. The default mode does not remove the legacy Auto Lap restriction.

**Relations**

- uses: [SPEC-218](#spec-218), [SPEC-221](#spec-221)

<a id="func-8"></a>
## FUNC-8 — Lap cadence

Type: requirement | State: approved | Revision: 53

| Attribute | Value |
| --- | --- |
| CODE | 31 |
| IDENTIFIER | lap_cadence |
| LABEL | lap cadence |
| LABEL_AND_UNIT | `lap cad \| rpm` |
| PRECISION | 0 |
| UNIT | rpm |

The app must display the observed-lap time-weighted mean of currentCadence under [FUNC-10](#func-10).
The app must accept finite values at least zero. The app must include measured zero, independently of the device zero-averaging preference.
Missing intervals add no time and no artificial zero. Without covered active time, the app must display unavailable.

The app must keep raw accumulation precision. The app must not use activity averages.
Color source: cadence.
Normal display range: 0 to 250 rpm. Apply [APP-55](#app-55).

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [FUNC-10](#func-10), [FUNC-9](#func-9), [SPEC-247](#spec-247), [SPEC-248](#spec-248)

<a id="func-7"></a>
## FUNC-7 — Lap power

Type: requirement | State: approved | Revision: 62

| Attribute | Value |
| --- | --- |
| CODE | 30 |
| IDENTIFIER | lap_power |
| LABEL | lap watts |
| LABEL_AND_UNIT | `lap watts` |
| PRECISION | 0 |
| UNIT | w |

The app must display the observed-lap time-weighted mean of currentPower under [FUNC-10](#func-10).
The app must accept finite values at least zero. The app must include measured zero, independently of the device zero-averaging preference.
Missing intervals add no time and no artificial zero. Without covered active time, the app must display unavailable.

The app must keep raw accumulation precision. The app must not use activity averages.
Color source: power.
Normal display range: 0 to 3000 watts. Apply [APP-55](#app-55).

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-42](#dvs-42), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [FUNC-10](#func-10), [FUNC-9](#func-9), [SPEC-248](#spec-248), [SPEC-663](#spec-663), [SPEC-665](#spec-665)

<a id="func-6"></a>
## FUNC-6 — Lap heart rate

Type: requirement | State: approved | Revision: 63

| Attribute | Value |
| --- | --- |
| CODE | 29 |
| IDENTIFIER | lap_heart_rate |
| LABEL | lap heart rate |
| LABEL_AND_UNIT | `lap hr \| bpm` |
| PRECISION | 0 |
| UNIT | bpm |

The app must display the observed-lap time-weighted mean of currentHeartRate under [FUNC-10](#func-10).
The app must accept finite values greater than zero.
Missing intervals add no time and no artificial zero. Without covered active time, the app must display unavailable.
The app must keep raw accumulation precision. The app must not use activity averages.

Color source: heart rate.
Normal display range: 30 to 250 bpm. Apply [APP-55](#app-55).

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-42](#dvs-42), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [FUNC-10](#func-10), [FUNC-9](#func-9), [SPEC-248](#spec-248), [SPEC-664](#spec-664), [SPEC-665](#spec-665)

<a id="func-3"></a>
## FUNC-3 — Lap distance

Type: requirement | State: approved | Revision: 58

| Attribute | Value |
| --- | --- |
| CODE | 26 |
| IDENTIFIER | lap_distance |
| LABEL | lap distance |
| LABEL_AND_UNIT | `lap dist \| {unit}` |
| PRECISION_RULE | magnitude-based |
| UNIT | km (metric), mi (statute) |

The app must calculate lap distance as elapsedDistance minus the known lap-start distance, in metres.
The calculation is valid only with finite, nonnegative totals and a known baseline. Zero is valid at a known new lap.
Counter regression invalidates lap distance and speed until a confirmed boundary.
The app must use host-recorded distance, including stopped movement recorded by the host. The app must not use whole-activity distance.

Color source: none.
Normal display range: 0 to 1000 in the selected distance unit. Apply [APP-55](#app-55).

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-2](#dvs-2), [DVS-4](#dvs-4), [DVS-40](#dvs-40), [DVS-50](#dvs-50), [FUNC-9](#func-9)

<a id="dvs-51"></a>
## DVS-51 — Inverse theme for enlarged fields option

Type: requirement | State: approved | Revision: 82

The app must use [SPEC-306](#spec-306) or [SPEC-344](#spec-344) to invert the base Day or Night palette in enlarged cells.
True selects the opposite palette. False keeps the base palette.
The app must not invert regular cells, separators, fallback messages, or semantic RGB colors.
The app must apply the effective palette to ordinary and neutral regions without changing acquisition or layout.

**Relations**

- uses: [APP-45](#app-45)

<a id="app-49"></a>
## APP-49 — Select background coverage independently per field slot

Type: requirement | State: approved | Revision: 142

The app must select background coverage independently for each saved slot through [SPEC-300](#spec-300).
The app must keep valid choices when a slot is hidden or reassigned. A color-source selection does not enable coverage.
The app must use 0 for None, 1 for Label, and 2 for Whole cell.

None adds no effect fill. Label fills the common full-width band under [DVS-12](#dvs-12). Whole cell fills the clipped cell.
The app must apply the same choices to regular and enlarged cells. Field-specific geometry, including slope, overrides the generic fill.

The app must keep acquisition, alignment, and geometry. Refit text only if halo clearance changes.
The app must use [SPEC-249](#spec-249) when a semantic color is unavailable.

**Relations**

- uses: [APP-31](#app-31), [APP-36](#app-36), [DVS-12](#dvs-12), [DVS-6](#dvs-6), [SPEC-155](#spec-155), [SPEC-244](#spec-244), [SPEC-249](#spec-249)

<a id="dvs-47"></a>
## DVS-47 — Display three-second average heart rate

Type: requirement | State: approved | Revision: 100

| Attribute | Value |
| --- | --- |
| CODE | 25 |
| IDENTIFIER | heart_rate_3s |
| LABEL | 3s heart rate |
| LABEL_AND_UNIT | `3s hr \| {unit}` |
| PRECISION | 0 |
| UNIT | bpm |

The app must display the shared three-second arithmetic mean of finite currentHeartRate samples greater than zero, in bpm.
An incomplete window is unavailable. The app must use [DVS-41](#dvs-41) for window lifecycle rules.
Color source: heart rate.
Normal display range: 30 to 250 bpm. Apply [APP-55](#app-55).

**Relations**

- allocated_to: [APP-3](#app-3)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-41](#dvs-41), [DVS-42](#dvs-42), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [SPEC-248](#spec-248), [SPEC-664](#spec-664), [SPEC-665](#spec-665)

<a id="dvs-45"></a>
## DVS-45 — Keep slope and temperature palette extensions separate

Type: requirement | State: approved | Revision: 47

The app must use dark red #AA0000, black #000000, cyan #00FFFF, and white #FFFFFF for declared slope and temperature bands.
These colors do not create training zones. Field band tables can also select the shared blue, green, yellow, orange, or red.
Themes must not change semantic RGB colors.

**Relations**

- allocated_to: [APP-4](#app-4)
- uses: [SPEC-246](#spec-246)

<a id="app-45"></a>
## APP-45 — Support day and night themes on Garmin devices

Type: requirement | State: approved | Revision: 64

The app must use [SPEC-304](#spec-304) or [SPEC-342](#spec-342) to select Auto, Day, or Night.
Auto follows the supported device night state and notifications. If unavailable, the app must use Day.
Regular cells, separators, and fallback messages use the base palette.
Enlarged cells use [DVS-51](#dvs-51). Theme changes keep data, layout, and semantic RGB colors.

**Relations**

- allocated_to: [APP-4](#app-4)
- uses: [APP-39](#app-39), [APP-40](#app-40)

<a id="dvs-40"></a>
## DVS-40 — Convert SDK units before displaying values

Type: requirement | State: approved | Revision: 34

The app must convert raw SDK units once before formatting:
- Metres per second to the selected speed unit.
- Metres to the selected distance or elevation unit.
- Celsius to the selected temperature unit.
- Milliseconds to duration seconds.
- Radians to degrees where declared.

The app must not convert a normalized value again.

**Relations**

- allocated_to: [APP-3](#app-3)
- uses: [DVS-4](#dvs-4)

<a id="app-30"></a>
## APP-30 — Configure visible count and value of each grid field

Type: requirement | State: approved | Revision: 53

The app must draw the first capacity slots from the assignments defined in [SPEC-300](#spec-300).
The app must keep all ten assignments and their order through restart, hiding, and smaller layouts.
The app must allow duplicate selections. The app must restore the saved assignments when capacity increases.
The app must validate selections under [APP-31](#app-31).

**Relations**

- allocated_to: [APP-3](#app-3)
- uses: [APP-20](#app-20), [APP-31](#app-31)

<a id="dvs-37"></a>
## DVS-37 — Distance to next waypoint

Type: requirement | State: approved | Revision: 58

| Attribute | Value |
| --- | --- |
| CODE | 23 |
| IDENTIFIER | distance_next_waypoint |
| LABEL | next waypoint |
| LABEL_AND_UNIT | `next \| {unit}` |
| PRECISION_RULE | magnitude-based |
| UNIT | km (metric) or mi (imperial) |

The app must display Activity.Info.distanceToNextPoint, supplied in m.
The app must accept finite numeric values, including zero. The app must apply the shared unavailable rule to invalid input.
Color source: none.
Normal display range: 0 to 1000, in the selected display units.
The app must apply [APP-55](#app-55) to this range.

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-2](#dvs-2), [DVS-4](#dvs-4), [DVS-40](#dvs-40), [DVS-50](#dvs-50)

<a id="dvs-33"></a>
## DVS-33 — Calories

Type: requirement | State: approved | Revision: 57

| Attribute | Value |
| --- | --- |
| CODE | 19 |
| IDENTIFIER | calories |
| LABEL | calories |
| LABEL_AND_UNIT | `kcal` |
| PRECISION | 0 |
| UNIT | kcal |

The app must display Activity.Info.calories, supplied in kcal.
The app must accept finite numeric values, including zero. The app must apply the shared unavailable rule to invalid input.
Color source: none.
Normal display range: 0 to 9999, in the selected display units.
The app must apply [APP-55](#app-55) to this range.

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-50](#dvs-50), [DVS-7](#dvs-7)

<a id="dvs-32"></a>
## DVS-32 — Time of day

Type: requirement | State: approved | Revision: 72

| Attribute | Value |
| --- | --- |
| CODE | 18 |
| IDENTIFIER | time_of_day |
| LABEL | time |
| LABEL_AND_UNIT | "" |
| PRECISION_RULE | 1 minute |
| UNIT | "" |

The app must read the local time from System.getClockTime(). The app must use the device is24Hour preference, or 24-hour mode if the preference is missing.
In 24-hour mode, the app must display HH:MM with hours from 00 to 23. The app must display no period indicator.
In 12-hour mode, the app must display h:MM with unpadded hours from 1 to 12.
The app must append ` | am` to the header before noon, or ` | pm` from noon onward.

Midnight and noon display 12:00. Always display two-digit minutes.
The period indicator is not a physical unit. Unit visibility must not hide it.
The app must not infer an indicator from invalid time input.
Color source: none.

Normal display range: the full day, from 00:00 through 23:59 in 24-hour notation. Apply [APP-55](#app-55).

**Relations**

- allocated_to: [APP-4](#app-4)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12)

<a id="dvs-28"></a>
## DVS-28 — Total descent

Type: requirement | State: approved | Revision: 53

| Attribute | Value |
| --- | --- |
| CODE | 14 |
| IDENTIFIER | total_descent |
| LABEL | descent |
| LABEL_AND_UNIT | `descent \| {unit}` |
| PRECISION | 0 |
| UNIT | m (metric) or ft (imperial) |

The app must display Activity.Info.totalDescent, supplied in m.
The app must accept finite numeric values, including zero. The app must apply the shared unavailable rule to invalid input.
Color source: none.
Normal display range: 0 to 9999, in the selected display units.
The app must apply [APP-55](#app-55) to this range.

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-4](#dvs-4), [DVS-40](#dvs-40), [DVS-50](#dvs-50), [DVS-7](#dvs-7)

<a id="dvs-27"></a>
## DVS-27 — Total ascent

Type: requirement | State: approved | Revision: 53

| Attribute | Value |
| --- | --- |
| CODE | 13 |
| IDENTIFIER | total_ascent |
| LABEL | ascent |
| LABEL_AND_UNIT | `ascent \| {unit}` |
| PRECISION | 0 |
| UNIT | m (metric) or ft (imperial) |

The app must display Activity.Info.totalAscent, supplied in m.
The app must accept finite numeric values, including zero. The app must apply the shared unavailable rule to invalid input.
Color source: none.
Normal display range: 0 to 9999, in the selected display units.
The app must apply [APP-55](#app-55) to this range.

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-4](#dvs-4), [DVS-40](#dvs-40), [DVS-50](#dvs-50), [DVS-7](#dvs-7)

<a id="dvs-26"></a>
## DVS-26 — Elevation

Type: requirement | State: approved | Revision: 63

| Attribute | Value |
| --- | --- |
| CODE | 12 |
| IDENTIFIER | elevation |
| LABEL | elevation |
| LABEL_AND_UNIT | `elevation \| {unit}` |
| PRECISION | 0 |
| UNIT | m (metric) or ft (imperial) |

The app must display Activity.Info.altitude, supplied in m.
The app must accept finite numeric values, including zero. The app must apply the shared unavailable rule to invalid input.
Color source: none.
Normal display range: -999 to 9999, in the selected display units.
The app must apply [APP-55](#app-55) to this range.

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-4](#dvs-4), [DVS-40](#dvs-40), [DVS-50](#dvs-50), [DVS-7](#dvs-7)

<a id="dvs-25"></a>
## DVS-25 — Distance

Type: requirement | State: approved | Revision: 59

| Attribute | Value |
| --- | --- |
| CODE | 11 |
| IDENTIFIER | distance |
| LABEL | distance |
| LABEL_AND_UNIT | `distance \| {unit}` |
| PRECISION_RULE | magnitude-based |
| UNIT | km (metric) or mi (imperial) |

The app must display Activity.Info.elapsedDistance, supplied in m.
The app must accept finite numeric values, including zero. The app must apply the shared unavailable rule to invalid input.
Color source: none.
Normal display range: 0 to 1000, in the selected display units.
The app must apply [APP-55](#app-55) to this range.

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-2](#dvs-2), [DVS-4](#dvs-4), [DVS-40](#dvs-40), [DVS-50](#dvs-50)

<a id="dvs-24"></a>
## DVS-24 — Power zone

Type: requirement | State: approved | Revision: 69

| Attribute | Value |
| --- | --- |
| CODE | 10 |
| IDENTIFIER | power_zone |
| LABEL | power zone |
| LABEL_AND_UNIT | "" |
| PRECISION | 0 |
| UNIT | "" |

The app must classify Activity.Info.currentPower with the selected global power profile and display its one-based integer zone.
Custom profiles have seven zones. Qualified device profiles keep their actual indices, including indices above seven.
An invalid selected profile or out-of-domain reading makes the zone unavailable.
Color source: power.

Normal display range: 1 to 7. Apply [APP-55](#app-55).

**Relations**

- allocated_to: [APP-4](#app-4)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-42](#dvs-42), [DVS-7](#dvs-7), [SPEC-248](#spec-248), [SPEC-663](#spec-663), [SPEC-665](#spec-665)

<a id="dvs-23"></a>
## DVS-23 — Average power

Type: requirement | State: approved | Revision: 75

| Attribute | Value |
| --- | --- |
| CODE | 9 |
| IDENTIFIER | average_power |
| LABEL | avg watts |
| LABEL_AND_UNIT | `avg watts` |
| PRECISION | 0 |
| UNIT | w |

The app must display Activity.Info.averagePower, supplied in watts.
The app must accept finite numeric values, including zero. The app must apply the shared unavailable rule to invalid input.
Color source: power.
Normal display range: 0 to 3000, in the selected display units.
The app must apply [APP-55](#app-55) to this range.

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-42](#dvs-42), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [SPEC-248](#spec-248), [SPEC-663](#spec-663), [SPEC-665](#spec-665)

<a id="dvs-21"></a>
## DVS-21 — Current power

Type: requirement | State: approved | Revision: 76

| Attribute | Value |
| --- | --- |
| CODE | 7 |
| IDENTIFIER | current_power |
| LABEL | watts |
| LABEL_AND_UNIT | `watts` |
| PRECISION | 0 |
| UNIT | w |

The app must display Activity.Info.currentPower, supplied in watts.
The app must accept finite numeric values, including zero. The app must apply the shared unavailable rule to invalid input.
Color source: power.
Normal display range: 0 to 3000, in the selected display units.
The app must apply [APP-55](#app-55) to this range.

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-42](#dvs-42), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [SPEC-248](#spec-248), [SPEC-663](#spec-663), [SPEC-665](#spec-665)

<a id="dvs-20"></a>
## DVS-20 — Heart rate zone

Type: requirement | State: approved | Revision: 69

| Attribute | Value |
| --- | --- |
| CODE | 6 |
| IDENTIFIER | heart_rate_zone |
| LABEL | hr zone |
| LABEL_AND_UNIT | "" |
| PRECISION | 0 |
| UNIT | "" |

The app must classify Activity.Info.currentHeartRate with the selected global heart rate profile and display its one-based integer zone.
The app must use the five-zone heart rate domain.
An invalid selected profile or out-of-domain reading makes the zone unavailable.
Color source: heart rate.
Normal display range: 1 to 5. Apply [APP-55](#app-55).

**Relations**

- allocated_to: [APP-4](#app-4)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-42](#dvs-42), [DVS-7](#dvs-7), [SPEC-248](#spec-248), [SPEC-664](#spec-664), [SPEC-665](#spec-665)

<a id="dvs-19"></a>
## DVS-19 — Average heart rate

Type: requirement | State: approved | Revision: 77

| Attribute | Value |
| --- | --- |
| CODE | 5 |
| IDENTIFIER | average_heart_rate |
| LABEL | average hr |
| LABEL_AND_UNIT | `avg hr \| bpm` |
| PRECISION | 0 |
| UNIT | bpm |

The app must display Activity.Info.averageHeartRate, supplied in bpm.
The app must accept finite numeric values, including zero. The app must apply the shared unavailable rule to invalid input.
Color source: heart rate.
Normal display range: 30 to 250, in the selected display units.
The app must apply [APP-55](#app-55) to this range.

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-42](#dvs-42), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [SPEC-248](#spec-248), [SPEC-664](#spec-664), [SPEC-665](#spec-665)

<a id="dvs-18"></a>
## DVS-18 — Current heart rate

Type: requirement | State: approved | Revision: 80

| Attribute | Value |
| --- | --- |
| CODE | 4 |
| IDENTIFIER | current_heart_rate |
| LABEL | heart rate |
| LABEL_AND_UNIT | `hr \| {unit}` |
| PRECISION | 0 |
| UNIT | bpm |

The app must display Activity.Info.currentHeartRate, supplied in bpm.
The app must accept finite numeric values, including zero. The app must apply the shared unavailable rule to invalid input.
Color source: heart rate.
Normal display range: 30 to 250, in the selected display units.
The app must apply [APP-55](#app-55) to this range.

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-42](#dvs-42), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [SPEC-248](#spec-248), [SPEC-664](#spec-664), [SPEC-665](#spec-665)

<a id="dvs-11"></a>
## DVS-11 — Average Cadence

Type: requirement | State: approved | Revision: 60

| Attribute | Value |
| --- | --- |
| CODE | 3 |
| IDENTIFIER | average_cadence |
| LABEL | avg cadence |
| LABEL_AND_UNIT | `avg cad \| rpm` |
| PRECISION | 0 |
| UNIT | rpm |

The app must display Activity.Info.averageCadence, supplied in rpm.
The app must accept finite numeric values, including zero. The app must apply the shared unavailable rule to invalid input.
Color source: cadence.
Normal display range: 0 to 250, in the selected display units.
The app must apply [APP-55](#app-55) to this range.

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [SPEC-247](#spec-247), [SPEC-248](#spec-248)

<a id="dvs-10"></a>
## DVS-10 — Current Cadence

Type: requirement | State: approved | Revision: 60

| Attribute | Value |
| --- | --- |
| CODE | 2 |
| IDENTIFIER | current_cadence |
| LABEL | cadence |
| LABEL_AND_UNIT | `cad \| rpm` |
| PRECISION | 0 |
| UNIT | rpm |

The app must display Activity.Info.currentCadence, supplied in rpm.
The app must accept finite numeric values, including zero. The app must apply the shared unavailable rule to invalid input.
Color source: cadence.
Normal display range: 0 to 250, in the selected display units.
The app must apply [APP-55](#app-55) to this range.

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [SPEC-247](#spec-247), [SPEC-248](#spec-248)

<a id="dvs-9"></a>
## DVS-9 — Average speed

Type: requirement | State: approved | Revision: 67

| Attribute | Value |
| --- | --- |
| CODE | 1 |
| IDENTIFIER | average_speed |
| LABEL | avg speed |
| LABEL_AND_UNIT | `avg \| {unit}` |
| PRECISION_RULE | magnitude-based |
| UNIT | `km/h` (metric) or `mph` (imperial) |

The app must display Activity.Info.averageSpeed, supplied in m/s.
The app must accept finite numeric values, including zero. The app must apply the shared unavailable rule to invalid input.
Color source: none.
Normal display range: 0 to 200, in the selected display units.
The app must apply [APP-55](#app-55) to this range.

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-2](#dvs-2), [DVS-4](#dvs-4), [DVS-40](#dvs-40), [DVS-50](#dvs-50)

<a id="dvs-8"></a>
## DVS-8 — Current speed

Type: requirement | State: approved | Revision: 70

| Attribute | Value |
| --- | --- |
| CODE | 0 |
| IDENTIFIER | current_speed |
| LABEL | speed |
| LABEL_AND_UNIT | `speed \| {unit}` |
| PRECISION_RULE | magnitude-based |
| UNIT | km/h (metric) or mph (imperial) |

The app must display Activity.Info.currentSpeed, supplied in m/s.
The app must accept finite numeric values, including zero. The app must apply the shared unavailable rule to invalid input.
Color source: none.
Normal display range: 0 to 200, in the selected display units.
The app must apply [APP-55](#app-55) to this range.

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-2](#dvs-2), [DVS-4](#dvs-4), [DVS-40](#dvs-40), [DVS-50](#dvs-50)

<a id="dvs-7"></a>
## DVS-7 — Display valid integral values within field bounds

Type: requirement | State: approved | Revision: 65

The app must round finite integral-format values to the nearest whole number. The app must round exact halves away from zero.
The app must not display a fraction or positive sign. The app must display a minus sign only for a negative rounded result.
The app must not display negative zero.

**Relations**

- allocated_to: [APP-4](#app-4)

<a id="dvs-4"></a>
## DVS-4 — App shall support metric and imperial values

Type: requirement | State: approved | Revision: 57

The app must read distanceUnits, elevationUnits, and temperatureUnits independently from System.getDeviceSettings().
The app must use metric units when an individual preference is unavailable.
The app must use each field's UNIT attribute. The app must apply a changed preference to its value and unit together.

**Relations**

- allocated_to: [APP-3](#app-3)

<a id="dvs-3"></a>
## DVS-3 — Position numeric secondary text beside the primary value

Type: requirement | State: approved | Revision: 93

The app must draw numeric secondary text with the label font, two pixels after the primary text.
Align their visible glyph tops. Align the full group as one value.
When secondary text is missing, the app must reserve no width or gap for it. The app must display physical units in the header.

**Relations**

- allocated_to: [APP-4](#app-4)
- uses: [APP-21](#app-21), [APP-25](#app-25)

<a id="dvs-2"></a>
## DVS-2 — Format decimals using field precision and value magnitude

Type: requirement | State: approved | Revision: 68

The app must use the field's fixed precision, or select magnitude precision from the absolute converted value:
- Below 10: two decimal places.
- From 10 to below 100: one decimal place.
- At least 100: no decimal places.

The app must round exact halves away from zero and keep necessary trailing zeros.
If rounding crosses a magnitude boundary, the app must select the new precision and round the original converted value again.
For example, 9.995 becomes 10.0, and 99.95 becomes 100. The app must apply the same rule to negative values.
The app must display a minus sign only for a negative formatted result. The app must not display negative zero or a positive sign.

**Relations**

- allocated_to: [APP-4](#app-4)

<a id="app-25"></a>
## APP-25 — Use the three specified Roboto Condensed font roles

Type: requirement | State: approved | Revision: 60

The app must use exactly three fixed font roles for numeric fields:

| Role | Source face |
| --- | --- |
| Enlarged primary | [Roboto Condensed Black](attachments/Roboto_Condensed_Black.ttf) |
| Regular primary | [Roboto Condensed Black](attachments/Roboto_Condensed_Black.ttf) |
| Header and numeric secondary | [Roboto Condensed SemiBold](attachments/Roboto_Condensed_SemiBold.ttf) |

The app must use the profile sizes in [APP-24](#app-24). The app must not select a different size for individual numeric values.
API 4+ profiles include one outline companion for each role under [DVS-6](#dvs-6).
An outline companion does not create another role or size.
Native-text fields use their declared system-font policy without additional font atlases.

**Relations**

- allocated_to: [APP-4](#app-4)
- uses: [APP-24](#app-24)

<a id="app-22"></a>
## APP-22 — Select grid independently of alignment

Type: requirement | State: approved | Revision: 72

The app must select the grid pattern through [SPEC-307](#spec-307) or [SPEC-345](#spec-345), independently of text alignment.
The app must use [HFER-7](#hfer-7) for Full grid and [HFER-8](#hfer-8) for Horizontal lines.
The app must draw no separators for None or the fallback message.
When only this option changes, the app must replace separator commands without changing cells, fonts, text, backgrounds, or acquisition.

**Relations**

- allocated_to: [APP-4](#app-4)
- uses: [HFER-7](#hfer-7), [HFER-8](#hfer-8)

<a id="fr-16465"></a>
## FR-16465 — Classify a reading within qualified device zone boundaries

Type: requirement | State: approved | Revision: 7

The app must use the displayed whole-unit value v with qualified boundaries b[0..n].
Zone 1 includes b0 <= v <= b1. A value belongs to zone i > 1 only when b[i-1] < v <= b[i].
Values outside b0 through bn have no zone. Upper-bound equality remains in the lower zone.
Zone-number fields and backgrounds use this same classifier.

Invalid metadata must not invalidate an independently valid metric.

**Relations**

- derived_from: [DVS-42](#dvs-42)

<a id="fr-16464"></a>
## FR-16464 — Invalidate affected zone caches after source or limit edits

Type: requirement | State: approved | Revision: 7

A zone-source or limit edit invalidates the affected zone, color, and prepared-cell caches in the two banks before their next display.
The app must keep the unaffected family profile and classifications.

**Relations**

- derived_from: [SPEC-667](#spec-667)

<a id="fr-16463"></a>
## FR-16463 — Replace field-set presentation atomically

Type: requirement | State: approved | Revision: 6

Before redrawing a changed field set, the app must prepare assignments, layout, labels, values, alignment, units, theme, effects, and grid together.
The app must not mix banks or expose a partial layout.
The switch must operate without a page change, timer action, or activity restart.

**Relations**

- derived_from: [APP-33](#app-33)

<a id="fr-16446"></a>
## FR-16446 — Read battery only for retained active-bank needs

Type: requirement | State: approved | Revision: 7

The app must read battery once per delivered compute() call when a retained active-bank slot needs it, including hidden slots.
If not, the app must not query system statistics only for battery.
After reassignment or bank activation, get a fresh reading before the next frame.

**Relations**

- derived_from: [DVS-35](#dvs-35)

<a id="app-53"></a>
## APP-53 — Keep preparation callbacks within the virtual-machine stack limit

Type: requirement | State: approved | Revision: 6

The app must keep callback preparation within the target virtual-machine stack limit.
The app must apply this limit to mixed native Team and sprite fields in layout, settings, and lap callbacks.

<a id="app-52"></a>
## APP-52 — Bound active configuration-bank resources

Type: requirement | State: approved | Revision: 7

The app must keep at most two configuration banks, one acquisition state, and one active prepared presentation.
The app must reuse valid active geometry and fonts when switching banks.

<a id="app-51"></a>
## APP-51 — Advance shared acquisition once per compute callback

Type: requirement | State: approved | Revision: 9

The app must advance sensor inputs, rolling averages, grade, lap values, and lifecycle state once per delivered compute() call.
The app must not repeat sampling for individual slots or configuration banks.

<a id="spec-669"></a>
## SPEC-669 — Order the shared training-zone controls

Type: requirement | State: approved | Revision: 17

The app must place shared training-zone controls in one contiguous section outside the two slot banks.
The app must use this sequence:
1. Custom power switch.
2. Six named power upper limits.
3. Custom heart rate switch.
4. Four heart rate upper limits.
5. Cadence options.
The app must use direct setting elements, without SDK groups, nested pages, or editable headings.
The app must keep the declared keys, types, defaults, and saved values.

**Relations**

- uses: [SPEC-155](#spec-155), [SPEC-662](#spec-662)

<a id="spec-667"></a>
## SPEC-667 — Prepare shared zone profiles outside compute and drawing

Type: requirement | State: approved | Revision: 11

The app must validate immutable shared heart rate and power profiles at initialization and settings reload.
The app must query device metadata only for families using device mode, at the existing metadata lifecycle boundary.
The app must not parse properties, validate tuples, or query profiles during ordinary compute() or onUpdate() calls.
The app must share profile references across slots. The app must reuse an unchanged family profile and its classifications after unrelated settings edits.

**Relations**

- uses: [APP-26](#app-26), [SPEC-663](#spec-663), [SPEC-664](#spec-664)

<a id="spec-665"></a>
## SPEC-665 — Share the selected zone profile with all consumers

Type: requirement | State: approved | Revision: 12

The app must share each selected family profile across the two field sets and regular, enlarged, and duplicate slots.
Each current, three-second, activity-average, or lap-average metric classifies its own value under [SPEC-248](#spec-248).
Zone-number fields classify current heart rate or power. Team uses current values even when numeric fields are hidden.
Coverage changes drawing only. The app must use [SPEC-246](#spec-246) for colors.

**Relations**

- uses: [SPEC-246](#spec-246), [SPEC-248](#spec-248), [SPEC-663](#spec-663), [SPEC-664](#spec-664)

<a id="spec-365"></a>
## SPEC-365 — Second set: Slot 10: background (b10_bg)

Type: requirement | State: approved | Revision: 43

Key: `b10_bg`
Caption: Second set: Slot 10: background
Type and values: Integer 0, 1, 2
Default: `0`

The app must apply this option to slot 10 in the second set.
The app must use [APP-49](#app-49) for the option behavior.

**Relations**

- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-364"></a>
## SPEC-364 — Second set: Slot 10: value (b10)

Type: requirement | State: approved | Revision: 42

Key: `b10`
Caption: Second set: Slot 10: value
Type and values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
Default: `20`

The app must apply this option to slot 10 in the second set.
The app must use [APP-30](#app-30) for the option behavior.

**Relations**

- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-363"></a>
## SPEC-363 — Second set: Slot 9: background (b9_bg)

Type: requirement | State: approved | Revision: 43

Key: `b9_bg`
Caption: Second set: Slot 9: background
Type and values: Integer 0, 1, 2
Default: `0`

The app must apply this option to slot 9 in the second set.
The app must use [APP-49](#app-49) for the option behavior.

**Relations**

- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-362"></a>
## SPEC-362 — Second set: Slot 9: value (b9)

Type: requirement | State: approved | Revision: 42

Key: `b9`
Caption: Second set: Slot 9: value
Type and values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
Default: `12`

The app must apply this option to slot 9 in the second set.
The app must use [APP-30](#app-30) for the option behavior.

**Relations**

- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-361"></a>
## SPEC-361 — Second set: Slot 8: background (b8_bg)

Type: requirement | State: approved | Revision: 43

Key: `b8_bg`
Caption: Second set: Slot 8: background
Type and values: Integer 0, 1, 2
Default: `0`

The app must apply this option to slot 8 in the second set.
The app must use [APP-49](#app-49) for the option behavior.

**Relations**

- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-360"></a>
## SPEC-360 — Second set: Slot 8: value (b8)

Type: requirement | State: approved | Revision: 42

Key: `b8`
Caption: Second set: Slot 8: value
Type and values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
Default: `27`

The app must apply this option to slot 8 in the second set.
The app must use [APP-30](#app-30) for the option behavior.

**Relations**

- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-359"></a>
## SPEC-359 — Second set: Slot 7: background (b7_bg)

Type: requirement | State: approved | Revision: 43

Key: `b7_bg`
Caption: Second set: Slot 7: background
Type and values: Integer 0, 1, 2
Default: `0`

The app must apply this option to slot 7 in the second set.
The app must use [APP-49](#app-49) for the option behavior.

**Relations**

- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-358"></a>
## SPEC-358 — Second set: Slot 7: value (b7)

Type: requirement | State: approved | Revision: 42

Key: `b7`
Caption: Second set: Slot 7: value
Type and values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
Default: `26`

The app must apply this option to slot 7 in the second set.
The app must use [APP-30](#app-30) for the option behavior.

**Relations**

- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-357"></a>
## SPEC-357 — Second set: Slot 6: background (b6_bg)

Type: requirement | State: approved | Revision: 43

Key: `b6_bg`
Caption: Second set: Slot 6: background
Type and values: Integer 0, 1, 2
Default: `0`

The app must apply this option to slot 6 in the second set.
The app must use [APP-49](#app-49) for the option behavior.

**Relations**

- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-356"></a>
## SPEC-356 — Second set: Slot 6: value (b6)

Type: requirement | State: approved | Revision: 42

Key: `b6`
Caption: Second set: Slot 6: value
Type and values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
Default: `0`

The app must apply this option to slot 6 in the second set.
The app must use [APP-30](#app-30) for the option behavior.

**Relations**

- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-355"></a>
## SPEC-355 — Second set: Slot 5: background (b5_bg)

Type: requirement | State: approved | Revision: 43

Key: `b5_bg`
Caption: Second set: Slot 5: background
Type and values: Integer 0, 1, 2
Default: `0`

The app must apply this option to slot 5 in the second set.
The app must use [APP-49](#app-49) for the option behavior.

**Relations**

- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-354"></a>
## SPEC-354 — Second set: Slot 5: value (b5)

Type: requirement | State: approved | Revision: 42

Key: `b5`
Caption: Second set: Slot 5: value
Type and values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
Default: `30`

The app must apply this option to slot 5 in the second set.
The app must use [APP-30](#app-30) for the option behavior.

**Relations**

- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-353"></a>
## SPEC-353 — Second set: Slot 4: background (b4_bg)

Type: requirement | State: approved | Revision: 43

Key: `b4_bg`
Caption: Second set: Slot 4: background
Type and values: Integer 0, 1, 2
Default: `1`

The app must apply this option to slot 4 in the second set.
The app must use [APP-49](#app-49) for the option behavior.

**Relations**

- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-352"></a>
## SPEC-352 — Second set: Slot 4: value (b4)

Type: requirement | State: approved | Revision: 42

Key: `b4`
Caption: Second set: Slot 4: value
Type and values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
Default: `15`

The app must apply this option to slot 4 in the second set.
The app must use [APP-30](#app-30) for the option behavior.

**Relations**

- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-351"></a>
## SPEC-351 — Second set: Slot 3: background (b3_bg)

Type: requirement | State: approved | Revision: 43

Key: `b3_bg`
Caption: Second set: Slot 3: background
Type and values: Integer 0, 1, 2
Default: `1`

The app must apply this option to slot 3 in the second set.
The app must use [APP-49](#app-49) for the option behavior.

**Relations**

- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-350"></a>
## SPEC-350 — Second set: Slot 3: value (b3)

Type: requirement | State: approved | Revision: 42

Key: `b3`
Caption: Second set: Slot 3: value
Type and values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
Default: `2`

The app must apply this option to slot 3 in the second set.
The app must use [APP-30](#app-30) for the option behavior.

**Relations**

- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-349"></a>
## SPEC-349 — Second set: Slot 2: background (b2_bg)

Type: requirement | State: approved | Revision: 43

Key: `b2_bg`
Caption: Second set: Slot 2: background
Type and values: Integer 0, 1, 2
Default: `1`

The app must apply this option to slot 2 in the second set.
The app must use [APP-49](#app-49) for the option behavior.

**Relations**

- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-348"></a>
## SPEC-348 — Second set: Slot 2: value (b2)

Type: requirement | State: approved | Revision: 42

Key: `b2`
Caption: Second set: Slot 2: value
Type and values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
Default: `4`

The app must apply this option to slot 2 in the second set.
The app must use [APP-30](#app-30) for the option behavior.

**Relations**

- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-347"></a>
## SPEC-347 — Second set: Slot 1: background (b1_bg)

Type: requirement | State: approved | Revision: 43

Key: `b1_bg`
Caption: Second set: Slot 1: background
Type and values: Integer 0, 1, 2
Default: `1`

The app must apply this option to slot 1 in the second set.
The app must use [APP-49](#app-49) for the option behavior.

**Relations**

- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-346"></a>
## SPEC-346 — Second set: Slot 1: value (b1)

Type: requirement | State: approved | Revision: 42

Key: `b1`
Caption: Second set: Slot 1: value
Type and values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
Default: `8`

The app must apply this option to slot 1 in the second set.
The app must use [APP-30](#app-30) for the option behavior.

**Relations**

- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-345"></a>
## SPEC-345 — Second set: Grid type (b_grid)

Type: requirement | State: approved | Revision: 41

Key: `b_grid`
Caption: Second set: Grid type
Type and values: Integer 0, 1, 2
Default: `1`

The app must apply this option to the second set. The app must select 0 None, 1 Horizontal lines, 2 Full grid. For invalid or missing input, the app must use 1 without changing storage.
The app must use [APP-22](#app-22) for the option behavior.

**Relations**

- uses: [APP-22](#app-22), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-344"></a>
## SPEC-344 — Second set: Inverse theme for enlarged slots (b_inv)

Type: requirement | State: approved | Revision: 41

Key: `b_inv`
Caption: Second set: Inverse theme for enlarged slots
Type and values: Boolean
Default: `true`

The app must apply this option to the second set. True inverts the theme in enlarged slots. False keeps the base theme. For invalid or missing input, the app must use true without changing storage.
The app must use [DVS-51](#dvs-51) for the option behavior.

**Relations**

- uses: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-51](#dvs-51), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-343"></a>
## SPEC-343 — Second set: Hide physical units in headers (b_hideu)

Type: requirement | State: approved | Revision: 33

Key: `b_hideu`
Caption: Second set: Hide physical units in headers
Type and values: Boolean
Default: `true`

The app must apply this option to the second set. True hides physical units in headers. False uses the field-specific header with units. For invalid or missing input, the app must use true without changing storage.
The app must use [DVS-50](#dvs-50) for the option behavior.

**Relations**

- uses: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-47](#dvs-47), [DVS-50](#dvs-50), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8)

<a id="spec-342"></a>
## SPEC-342 — Second set: Theme mode (b_theme)

Type: requirement | State: approved | Revision: 41

Key: `b_theme`
Caption: Second set: Theme mode
Type and values: Integer 0, 1, 2
Default: `0`

The app must apply this option to the second set. The app must select 0 Auto, 1 Day, 2 Night. For invalid or missing input, the app must use 0 without changing storage.
The app must use [APP-45](#app-45) for the option behavior.

**Relations**

- uses: [APP-45](#app-45), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-341"></a>
## SPEC-341 — Second set: Alignment (b_align)

Type: requirement | State: approved | Revision: 41

Key: `b_align`
Caption: Second set: Alignment
Type and values: Integer 0, 1
Default: `1`

The app must apply this option to the second set. The app must select label and value alignment: 0 Center, 1 Right. For invalid or missing input, the app must use 1 without changing storage.
The app must use [APP-21](#app-21) for the option behavior.

**Relations**

- uses: [APP-21](#app-21), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-340"></a>
## SPEC-340 — Second set: Enlarged slot count (b_big)

Type: requirement | State: approved | Revision: 41

Key: `b_big`
Caption: Second set: Enlarged slot count
Type and values: Integer 0, 1, 2
Default: `1`

The app must apply this option to the second set. The app must select the number of enlarged top slots. For invalid or missing input, the app must use 1 without changing storage.
The app must use [APP-20](#app-20) for the option behavior.

**Relations**

- uses: [APP-20](#app-20), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-339"></a>
## SPEC-339 — Heart rate: return below (bpm) (hr_off)

Type: requirement | State: approved | Revision: 9

Key: `hr_off`
Caption: Heart rate: return below (bpm)
Type and values: Integer 30..250
Default: `150`

Return to the default set when the selected valid reading is below this value. The app must use this limit only for its matching trigger. The return limit must not exceed activation. Invalid selected pairs keep the default set. For invalid or missing input, the app must use 150 without changing storage.
The app must use [SPEC-212](#spec-212) for the option behavior.

**Relations**

- uses: [DVS-18](#dvs-18), [SPEC-212](#spec-212)

<a id="spec-338"></a>
## SPEC-338 — Heart rate: activate at (bpm) (hr_on)

Type: requirement | State: approved | Revision: 9

Key: `hr_on`
Caption: Heart rate: activate at (bpm)
Type and values: Integer 30..250
Default: `160`

Activate the second set when the selected valid reading is at least this value. The app must use this limit only for its matching trigger. The return limit must not exceed activation. Invalid selected pairs keep the default set. For invalid or missing input, the app must use 160 without changing storage.
The app must use [SPEC-212](#spec-212) for the option behavior.

**Relations**

- uses: [DVS-18](#dvs-18), [SPEC-212](#spec-212)

<a id="spec-337"></a>
## SPEC-337 — Power: return below (W) (p_off)

Type: requirement | State: approved | Revision: 9

Key: `p_off`
Caption: Power: return below (W)
Type and values: Integer 1..3000
Default: `220`

Return to the default set when the selected valid reading is below this value. The app must use this limit only for its matching trigger. The return limit must not exceed activation. Invalid selected pairs keep the default set. For invalid or missing input, the app must use 220 without changing storage.
The app must use [SPEC-212](#spec-212) for the option behavior.

**Relations**

- uses: [DVS-22](#dvs-22), [SPEC-212](#spec-212)

<a id="spec-336"></a>
## SPEC-336 — Power: activate at (W) (p_on)

Type: requirement | State: approved | Revision: 9

Key: `p_on`
Caption: Power: activate at (W)
Type and values: Integer 1..3000
Default: `250`

Activate the second set when the selected valid reading is at least this value. The app must use this limit only for its matching trigger. The return limit must not exceed activation. Invalid selected pairs keep the default set. For invalid or missing input, the app must use 250 without changing storage.
The app must use [SPEC-212](#spec-212) for the option behavior.

**Relations**

- uses: [DVS-22](#dvs-22), [SPEC-212](#spec-212)

<a id="spec-335"></a>
## SPEC-335 — Second field set - activation event (trig)

Type: requirement | State: approved | Revision: 10

Key: `trig`
Caption: Second field set - activation event
Type and values: Integer 0, 1, 2, 3, 4
Default: `3`

The app must select 0 None, 1 3s power, 2 Heart rate, 3 Manual lap, 4 Workout started. Only the selected mode acts. For invalid or missing input, the app must use 3 without changing storage.
The app must use [SPEC-211](#spec-211) for the option behavior.

**Relations**

- uses: [DVS-18](#dvs-18), [DVS-22](#dvs-22), [SPEC-211](#spec-211)

<a id="spec-334"></a>
## SPEC-334 — Cadence zone 4: upper rpm (cad4)

Type: requirement | State: approved | Revision: 12

Key: `cad4`
Caption: Cadence zone 4: upper rpm
Type and values: Integer 0..300
Default: `120`

The app must use this shared rpm upper limit for zone 4. The app must use the validation and fallback rules in [SPEC-252](#spec-252).

**Relations**

- uses: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [FUNC-8](#func-8), [SPEC-252](#spec-252)

<a id="spec-333"></a>
## SPEC-333 — Cadence zone 3: upper rpm (cad3)

Type: requirement | State: approved | Revision: 12

Key: `cad3`
Caption: Cadence zone 3: upper rpm
Type and values: Integer 0..300
Default: `100`

The app must use this shared rpm upper limit for zone 3. The app must use the validation and fallback rules in [SPEC-252](#spec-252).

**Relations**

- uses: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [FUNC-8](#func-8), [SPEC-252](#spec-252)

<a id="spec-332"></a>
## SPEC-332 — Cadence zone 2: upper rpm (cad2)

Type: requirement | State: approved | Revision: 12

Key: `cad2`
Caption: Cadence zone 2: upper rpm
Type and values: Integer 0..300
Default: `80`

The app must use this shared rpm upper limit for zone 2. The app must use the validation and fallback rules in [SPEC-252](#spec-252).

**Relations**

- uses: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [FUNC-8](#func-8), [SPEC-252](#spec-252)

<a id="spec-331"></a>
## SPEC-331 — Cadence zone 1: upper rpm (cad1)

Type: requirement | State: approved | Revision: 12

Key: `cad1`
Caption: Cadence zone 1: upper rpm
Type and values: Integer 0..300
Default: `60`

The app must use this shared rpm upper limit for zone 1. The app must use the validation and fallback rules in [SPEC-252](#spec-252).

**Relations**

- uses: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [FUNC-8](#func-8), [SPEC-252](#spec-252)

<a id="spec-330"></a>
## SPEC-330 — Slot 10: background (a10_bg)

Type: requirement | State: approved | Revision: 43

Key: `a10_bg`
Caption: Slot 10: background
Type and values: Integer 0, 1, 2
Default: `0`

The app must apply this option to slot 10 in the default set.
The app must use [APP-49](#app-49) for the option behavior.

**Relations**

- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-329"></a>
## SPEC-329 — Slot 10: value (a10)

Type: requirement | State: approved | Revision: 42

Key: `a10`
Caption: Slot 10: value
Type and values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
Default: `20`

The app must apply this option to slot 10 in the default set.
The app must use [APP-30](#app-30) for the option behavior.

**Relations**

- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-328"></a>
## SPEC-328 — Slot 9: background (a9_bg)

Type: requirement | State: approved | Revision: 43

Key: `a9_bg`
Caption: Slot 9: background
Type and values: Integer 0, 1, 2
Default: `0`

The app must apply this option to slot 9 in the default set.
The app must use [APP-49](#app-49) for the option behavior.

**Relations**

- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-327"></a>
## SPEC-327 — Slot 9: value (a9)

Type: requirement | State: approved | Revision: 42

Key: `a9`
Caption: Slot 9: value
Type and values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
Default: `13`

The app must apply this option to slot 9 in the default set.
The app must use [APP-30](#app-30) for the option behavior.

**Relations**

- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-326"></a>
## SPEC-326 — Slot 8: background (a8_bg)

Type: requirement | State: approved | Revision: 43

Key: `a8_bg`
Caption: Slot 8: background
Type and values: Integer 0, 1, 2
Default: `0`

The app must apply this option to slot 8 in the default set.
The app must use [APP-49](#app-49) for the option behavior.

**Relations**

- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-325"></a>
## SPEC-325 — Slot 8: value (a8)

Type: requirement | State: approved | Revision: 42

Key: `a8`
Caption: Slot 8: value
Type and values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
Default: `15`

The app must apply this option to slot 8 in the default set.
The app must use [APP-30](#app-30) for the option behavior.

**Relations**

- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-318"></a>
## SPEC-318 — Slot 4: background (a4_bg)

Type: requirement | State: approved | Revision: 43

Key: `a4_bg`
Caption: Slot 4: background
Type and values: Integer 0, 1, 2
Default: `0`

The app must apply this option to slot 4 in the default set.
The app must use [APP-49](#app-49) for the option behavior.

**Relations**

- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-317"></a>
## SPEC-317 — Slot 4: value (a4)

Type: requirement | State: approved | Revision: 42

Key: `a4`
Caption: Slot 4: value
Type and values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
Default: `18`

The app must apply this option to slot 4 in the default set.
The app must use [APP-30](#app-30) for the option behavior.

**Relations**

- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-316"></a>
## SPEC-316 — Slot 3: background (a3_bg)

Type: requirement | State: approved | Revision: 43

Key: `a3_bg`
Caption: Slot 3: background
Type and values: Integer 0, 1, 2
Default: `0`

The app must apply this option to slot 3 in the default set.
The app must use [APP-49](#app-49) for the option behavior.

**Relations**

- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-315"></a>
## SPEC-315 — Slot 3: value (a3)

Type: requirement | State: approved | Revision: 42

Key: `a3`
Caption: Slot 3: value
Type and values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
Default: `16`

The app must apply this option to slot 3 in the default set.
The app must use [APP-30](#app-30) for the option behavior.

**Relations**

- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-314"></a>
## SPEC-314 — Slot 2: background (a2_bg)

Type: requirement | State: approved | Revision: 43

Key: `a2_bg`
Caption: Slot 2: background
Type and values: Integer 0, 1, 2
Default: `0`

The app must apply this option to slot 2 in the default set.
The app must use [APP-49](#app-49) for the option behavior.

**Relations**

- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-313"></a>
## SPEC-313 — Slot 2: value (a2)

Type: requirement | State: approved | Revision: 42

Key: `a2`
Caption: Slot 2: value
Type and values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
Default: `11`

The app must apply this option to slot 2 in the default set.
The app must use [APP-30](#app-30) for the option behavior.

**Relations**

- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-312"></a>
## SPEC-312 — Slot 1: background (a1_bg)

Type: requirement | State: approved | Revision: 43

Key: `a1_bg`
Caption: Slot 1: background
Type and values: Integer 0, 1, 2
Default: `0`

The app must apply this option to slot 1 in the default set.
The app must use [APP-49](#app-49) for the option behavior.

**Relations**

- uses: [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-311"></a>
## SPEC-311 — Slot 1: value (a1)

Type: requirement | State: approved | Revision: 42

Key: `a1`
Caption: Slot 1: value
Type and values: Integer 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
Default: `0`

The app must apply this option to slot 1 in the default set.
The app must use [APP-30](#app-30) for the option behavior.

**Relations**

- uses: [APP-30](#app-30), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253), [SPEC-301](#spec-301)

<a id="spec-307"></a>
## SPEC-307 — Grid type (a_grid)

Type: requirement | State: approved | Revision: 41

Key: `a_grid`
Caption: Grid type
Type and values: Integer 0, 1, 2
Default: `1`

The app must apply this option to the default set. The app must select 0 None, 1 Horizontal lines, 2 Full grid. For invalid or missing input, the app must use 1 without changing storage.
The app must use [APP-22](#app-22) for the option behavior.

**Relations**

- uses: [APP-22](#app-22), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-306"></a>
## SPEC-306 — Inverse theme for enlarged slots (a_inv)

Type: requirement | State: approved | Revision: 41

Key: `a_inv`
Caption: Inverse theme for enlarged slots
Type and values: Boolean
Default: `true`

The app must apply this option to the default set. True inverts the theme in enlarged slots. False keeps the base theme. For invalid or missing input, the app must use true without changing storage.
The app must use [DVS-51](#dvs-51) for the option behavior.

**Relations**

- uses: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-51](#dvs-51), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-305"></a>
## SPEC-305 — Hide physical units in headers (a_hideu)

Type: requirement | State: approved | Revision: 33

Key: `a_hideu`
Caption: Hide physical units in headers
Type and values: Boolean
Default: `true`

The app must apply this option to the default set. True hides physical units in headers. False uses the field-specific header with units. For invalid or missing input, the app must use true without changing storage.
The app must use [DVS-50](#dvs-50) for the option behavior.

**Relations**

- uses: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-47](#dvs-47), [DVS-50](#dvs-50), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8)

<a id="spec-304"></a>
## SPEC-304 — Theme mode (a_theme)

Type: requirement | State: approved | Revision: 41

Key: `a_theme`
Caption: Theme mode
Type and values: Integer 0, 1, 2
Default: `0`

The app must apply this option to the default set. The app must select 0 Auto, 1 Day, 2 Night. For invalid or missing input, the app must use 0 without changing storage.
The app must use [APP-45](#app-45) for the option behavior.

**Relations**

- uses: [APP-45](#app-45), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-303"></a>
## SPEC-303 — Alignment (a_align)

Type: requirement | State: approved | Revision: 41

Key: `a_align`
Caption: Alignment
Type and values: Integer 0, 1
Default: `1`

The app must apply this option to the default set. The app must select label and value alignment: 0 Center, 1 Right. For invalid or missing input, the app must use 1 without changing storage.
The app must use [APP-21](#app-21) for the option behavior.

**Relations**

- uses: [APP-21](#app-21), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-302"></a>
## SPEC-302 — Enlarged slot count (a_big)

Type: requirement | State: approved | Revision: 41

Key: `a_big`
Caption: Enlarged slot count
Type and values: Integer 0, 1, 2
Default: `0`

The app must apply this option to the default set. The app must select the number of enlarged top slots. For invalid or missing input, the app must use 0 without changing storage.
The app must use [APP-20](#app-20) for the option behavior.

**Relations**

- uses: [APP-20](#app-20), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-245"></a>
## SPEC-245 — Bound the serialized settings dictionary

Type: requirement | State: approved | Revision: 17

Before app or test compilation, the development process must serialize the full property dictionary with the installed Garmin SDK.
The factory-default dictionary and maximum-value dictionary must each fit within 8000 bytes.
The development process must include all keys and serialization overhead. The development process must use 32 printable ASCII characters for maximum Team text.
The development process must fail compilation if either dictionary exceeds the limit or serialization fails. The development process must record the two measured sizes.

This check does not qualify runtime memory.

**Relations**

- uses: [SPEC-244](#spec-244)

<a id="spec-220"></a>
## SPEC-220 — Reset field-set switching at app and activity boundaries

Type: requirement | State: approved | Revision: 21

The app must start each foreground app instance on the default set. The app must not restore prior switching state.
onTimerReset() selects default and clears all switching state, including after save or discard.
Page changes and redraws must not reset switching.
A confirmed activity-start identity change clears switching state. Missing identity data alone does not indicate a change.

Threshold modes then check the fresh sample. Event modes wait for a new qualifying event.

**Relations**

- uses: [SPEC-211](#spec-211), [SPEC-216](#spec-216)

<a id="spec-218"></a>
## SPEC-218 — Switch field sets from legacy lap callbacks under manual-only setup

Type: requirement | State: approved | Revision: 17

On Edge 530, 830, and 1030, each onTimerLap() callback toggles Manual lap mode once.
The app must support this switching mode only when Auto Lap and other automatic lap sources are disabled in the activity profile.
The callback cannot distinguish manual, automatic, or workout-generated laps. The app cannot reliably check or enforce Auto Lap settings.
If automatic sources remain active, their callbacks can toggle the set.

This restriction affects switching only. Ordinary lap acquisition still processes delivered boundaries.
Modern devices keep typed filtering even when Auto Lap is enabled.

**Relations**

- uses: [FUNC-9](#func-9), [SPEC-211](#spec-211)

<a id="spec-215"></a>
## SPEC-215 — Evaluate the heart-rate event from current heart rate

Type: requirement | State: approved | Revision: 18

For Heart rate mode, the app must compare unrounded Activity.Info.currentHeartRate from [DVS-18](#dvs-18) against the selected heart rate thresholds.
The app must accept finite readings greater than zero. Zero, missing, negative, and non-finite readings are invalid.
The app must not use a three-second mean, activity mean, lap mean, or zone.
The app must examine independently of visible assignments. The app must apply [SPEC-213](#spec-213) once per eligible sample.

**Relations**

- uses: [DVS-18](#dvs-18), [SPEC-213](#spec-213)

<a id="spec-214"></a>
## SPEC-214 — Evaluate the power event from the shared three-second average

Type: requirement | State: approved | Revision: 20

For 3s power mode, the app must compare the shared unrounded producer from [DVS-22](#dvs-22) against the selected power thresholds.
The app must use its existing sample, zero, gap, active-timer, and reset rules.
The app must not use instantaneous power, display text, a zone, or another moving average.
The app must examine this producer even when no visible slot displays power. Duplicate slots must not add samples.
Finite, nonnegative values are eligible, including measured zero and startup partial-window means.

The first valid sample can activate the second set. The app must use [SPEC-216](#spec-216) before a valid producer result exists.

**Relations**

- uses: [DVS-22](#dvs-22), [SPEC-213](#spec-213)

<a id="spec-213"></a>
## SPEC-213 — Switch threshold modes with defined hysteresis

Type: requirement | State: approved | Revision: 21

Let x be the selected valid unrounded reading, A the activation threshold, and R the return threshold.
From the default set, the app must select the second set when x >= A. If not, the app must keep the default set.
From the second set, return to default when x < R. If not, the app must keep the second set.
Thus, R <= x < A keeps the current state.

The app must apply one transition per eligible delivered sample.
The app must not add dwell time, debounce, or smoothing beyond the source contract. The app must use [SPEC-216](#spec-216) for missing input.

**Relations**

- uses: [SPEC-212](#spec-212), [SPEC-216](#spec-216), [SPEC-220](#spec-220)

<a id="spec-210"></a>
## SPEC-210 — Keep all settings on one savable main page

Type: requirement | State: approved | Revision: 43

The app must place each app control directly under the SDK settings element on one main Garmin settings page.
The app must not use SDK groups or secondary pages for field sets or training zones.
The app must use the platform Save action. The app must not add a dummy divider property or a Save property.
Inactive controls remain editable and savable. Conditional hiding is not necessary.

**Relations**

- uses: [SPEC-208](#spec-208), [SPEC-211](#spec-211), [SPEC-212](#spec-212), [SPEC-252](#spec-252), [SPEC-253](#spec-253)

<a id="spec-208"></a>
## SPEC-208 — Configure two independent field sets

Type: requirement | State: approved | Revision: 31

The app must keep independent default and second saved banks.
Each bank has ten ordered slots and the same available field and layout options.
The app must keep background coverage independently for each slot, including hidden and duplicate assignments.
The app must display exactly one full bank. The second bank replaces the default bank.
The app must share Team text and color source, device units, clock format, and acquisition across the two banks.

**Relations**

- uses: [APP-20](#app-20), [APP-30](#app-30)

<a id="func-10"></a>
## FUNC-10 — Integrate valid current-lap sensor intervals

Type: requirement | State: approved | Revision: 30

The app must keep a fixed-size sum, covered active milliseconds, and previous endpoint for each lap sensor channel.
The app must pair endpoints a and b only within one activity and lap epoch, with recording ON at the two endpoints.
The two endpoints must have finite timestamps and valid channel values.
An eligible pair must satisfy 0 < elapsed_b - elapsed_a <= 2000 milliseconds.
Let dt = timer_b - timer_a. An eligible pair must also satisfy 0 < dt <= elapsed_b - elapsed_a.

The app must update sum by ((a + b)/2)*dt, and add dt to covered milliseconds.
The app must publish sum divided by covered milliseconds, without display rounding during accumulation.
Without covered time, the mean is unavailable. Boundary capture can seed an endpoint. If not, the first active compute only seeds.

**Relations**

- uses: [FUNC-9](#func-9)

<a id="dvs-50"></a>
## DVS-50 — Show or hide physical units in field headers

Type: requirement | State: approved | Revision: 71

The app must use [SPEC-305](#spec-305) or [SPEC-343](#spec-343) to control physical units in headers.
When units are hidden or UNIT is empty, the app must display LABEL alone.
If not, the app must use nonempty LABEL_AND_UNIT text. The app must replace its optional `{unit}` placeholder with UNIT at most once.
The app must treat overrides as literal lowercase text. The app must not append redundant units.

Without an override, the app must combine LABEL, ` | `, and UNIT.
The app must keep spaces around ` | ` and slashes within units.
An unavailable known reading keeps its normal header. The app must not infer a unit for an unknown field.
Physical units belong only in headers. The app must keep nonphysical indicators under their field-specific rules.

**Relations**

- uses: [DVS-4](#dvs-4)

<a id="spec-176"></a>
## SPEC-176 — Bundle exactly the glyphs that each application font role can render

Type: requirement | State: approved | Revision: 33

For each bundled role and language, derive RequiredGlyphs from each reachable field, setting, unit, format, and status.
The development process must use English initially. The development process must include spaces and case variants only when they can be drawn.
Generated glyph identifiers must equal RequiredGlyphs exactly. The development process must keep undeclared atlas and padding pixels transparent.
The development process must not use the source-font inventory or nonrendered metadata as the runtime inventory.

The development process must not restrict glyphs to the current screen.
The development process must exclude native user text, but include its fixed bundled header.

**Relations**

- uses: [APP-25](#app-25)

<a id="spec-162"></a>
## SPEC-162 — Gate development milestones on traceable requirement evidence

Type: requirement | State: approved | Revision: 30

Development milestones must separate environment setup, core behavior, and effects and acquisition qualification.
Each release requirement needs implemented code and a verification method with evidence.
Traceability must identify requirement, code, Test, scenario, product, revision, and outcome.
Release acceptance requires reviewed decisions, compatible resources and settings, and all required simulator and hardware evidence.
An environment check or missing evidence does not establish full product coverage.
New or split requirements need explicit applicable Test links; existing historical passes retain their captured revisions.

**Relations**

- uses: [SPEC-159](#spec-159), [SPEC-160](#spec-160), [SPEC-161](#spec-161)

<a id="spec-161"></a>
## SPEC-161 — Record unresolved product decisions before closing dependent development tasks

Type: requirement | State: approved | Revision: 26

The development process must keep a versioned decision register with each unresolved decision, owner, affected requirements, selected rule, rationale, and review state.
An unresolved decision blocks only dependent acceptance.
The development process must record specification approval, implementation, and qualification separately.
The development process must not infer source provenance or measured results.

<a id="spec-160"></a>
## SPEC-160 — Gate changes on repeatable compilation and explicit test evidence

Type: requirement | State: approved | Revision: 17

The development process must accept changes only after repeatable compilation and explicit test evidence.
Missing prerequisites, timeout, zero tests, necessary skips, and compiler or test failures must not pass a necessary gate.
The development process must bind logs, results, and artifacts to source, toolchain, device, and fixture hashes. The development process must invalidate stale cached evidence.
Define necessary checks and warning dispositions before accepting a baseline.

Physical and visual gates remain independent. CI must not publish or change device support automatically.

**Relations**

- uses: [SPEC-151](#spec-151), [SPEC-153](#spec-153), [SPEC-157](#spec-157), [SPEC-162](#spec-162)

<a id="spec-157"></a>
## SPEC-157 — Keep Core, Memory, and Placement tests separate

Type: requirement | State: approved | Revision: 80

The development process must maintain three separate test inventories:
- Core: default fast regression after changes and in CI.
- Memory: explicit request only.
- Placement: explicit request only.

Core must not invoke Memory, Placement, or memory instrumentation.
The development process must run production routines through Toybox.Test and Run No Evil. Host approximations do not replace Monkey C execution.
The development process must record the selected suite, named results, failures, and matching inputs.
Operation assertions do not establish battery, runtime-memory, or hardware qualification.

**Relations**

- uses: [APP-24](#app-24), [APP-26](#app-26), [APP-34](#app-34), [SPEC-162](#spec-162)

<a id="spec-156"></a>
## SPEC-156 — Generate field acquisition traceability from canonical owners

Type: requirement | State: approved | Revision: 28

The development process must generate acquisition, code, and fixture traceability from the canonical field and shared acquisition owners.
The development process must record source member or algorithm, context, raw type and unit, validity, clock, update authority, reset authority, and qualification state.
The development process must not maintain a second normative field catalogue.

<a id="spec-155"></a>
## SPEC-155 — Generate one typed settings catalogue

Type: requirement | State: approved | Revision: 132

The development process must generate one typed catalogue for settings XML, runtime code, and tests from [SPEC-300](#spec-300).
The development process must use field codes, identifiers, labels, units, and precision from the owning [DVS-1](#dvs-1) item attributes.
Each property owner defines its key, type, allowed values, default, and applicable fields.
XML defaults and runtime fallbacks must agree. The development process must generate counts from the catalogue. Captions and dividers are not properties.

**Relations**

- uses: [APP-20](#app-20), [APP-21](#app-21), [APP-22](#app-22), [APP-30](#app-30), [APP-31](#app-31), [APP-45](#app-45), [APP-49](#app-49), [DVS-50](#dvs-50), [DVS-51](#dvs-51), [SPEC-208](#spec-208), [SPEC-211](#spec-211), [SPEC-212](#spec-212), [SPEC-244](#spec-244), [SPEC-252](#spec-252), [SPEC-253](#spec-253)

<a id="spec-154"></a>
## SPEC-154 — Generate reproducible Garmin font resources

Type: requirement | State: approved | Revision: 51

The development process must generate the three exact profile roles and sizes from versioned, licensed Roboto Condensed source fonts.
For API 4+ profiles, the development process must generate the declared outline companions.
The development process must record source and license identifiers, generator and dependency versions, and input and output hashes.
The development process must provide a deterministic regeneration command with matching outputs.

**Relations**

- uses: [APP-24](#app-24), [APP-25](#app-25), [SPEC-176](#spec-176), [SPEC-177](#spec-177)

<a id="spec-153"></a>
## SPEC-153 — Provide repeatable command-line build and package commands

Type: requirement | State: approved | Revision: 71

The development process must provide documented clean, build, test, and package commands with product, mode, SDK, and external signing-key inputs.
The development process must make commands deterministic and independent of IDE and checkout location. Return a nonzero status on failure.
The development process must use verified pinned-SDK options. The development process must distinguish debug, test, and release outputs.

The development process must produce per-product PRG and debug artifacts, and supported IQ packages. The development process must exclude test and diagnostic fixtures from release packages.
The development process must log product, invocation, source, resource, and toolchain hashes without secrets.

**Relations**

- uses: [SPEC-151](#spec-151), [SPEC-152](#spec-152)

<a id="spec-152"></a>
## SPEC-152 — Version the Data Field project inputs

Type: requirement | State: approved | Revision: 65

Version Monkey C sources, manifest and Jungle files, resources, settings XML, tests, fixtures, and build scripts.
The development process must use relative project paths. The development process must configure tool and signing-key locations externally.
The development process must exclude generated binaries, caches, and secrets.
The development process must keep a stable Data Field application identifier and entry point in the manifest.

**Relations**

- uses: [APP-24](#app-24), [SPEC-151](#spec-151)

<a id="spec-151"></a>
## SPEC-151 — Record the reproducible Connect IQ toolchain

Type: requirement | State: approved | Revision: 15

The development process must keep a versioned toolchain manifest.
It must identify developer and CI operating systems, SDK, compiler, simulator, device packages, Java distribution, and font tools.
The development process must include versions and device-package hashes. The development process must distinguish SDK version from minimum app API.
The development process must use compatible versions tested by compiling each declared product. The development process must not use unrecorded floating versions.

**Relations**

- uses: [APP-24](#app-24)

<a id="app-46"></a>
## APP-46 — Configure visible fields in Garmin Connect

Type: requirement | State: approved | Revision: 78

The app must expose the declared typed settings for the two banks through Garmin Connect.
The app must use the specified captions and order. The app must keep valid saved choices and apply edits without restarting the activity.
An on-device settings editor is not necessary.

**Relations**

- allocated_to: [APP-3](#app-3)
- uses: [SPEC-155](#spec-155), [SPEC-210](#spec-210)

<a id="dvs-42"></a>
## DVS-42 — Qualify device training-zone metadata before use

Type: requirement | State: approved | Revision: 66

For device-selected cycling profiles, the app must retrieve personal thresholds only with the necessary UserProfile permission and API capability.
The app must not infer FTP or use defaults.
The app must normalize qualified metadata to finite, nonnegative, strictly increasing boundaries b[0..n].
The b0 boundary is the zone-1 minimum. The b1 through bn boundaries are successive upper limits.
Heart rate requires five zones and six boundaries.

Power requires getPowerZones support from API 5.2.2 and b0 = 0 watts.
Any other first power boundary is an unrecognized layout.
Null, older-API, ambiguous, or unsupported metadata is unavailable. The app must identify the power layout separately on physical devices.
Custom profiles use [SPEC-661](#spec-661) and [SPEC-662](#spec-662).

**Relations**

- allocated_to: [APP-3](#app-3)
- uses: [APP-42](#app-42), [APP-43](#app-43), [DVS-7](#dvs-7)

<a id="dvs-41"></a>
## DVS-41 — Compute shared three-second windows

Type: requirement | State: approved | Revision: 57

Each source must have one shared three-sample window, keyed by floor(elapsedTime/1000).
The window accepts at most one valid sample per second, independently of slots and drawing.
It uses the field's valid-sample rules and startup count; the default count is three.
After startup, it publishes the unrounded mean of retained samples.

Invalid input or an invalid time key clears the window, including invalid input within a previously sampled second.
A valid duplicate second adds no sample.
A skipped or decreasing second clears the window before a valid new sample seeds it.
Pause, stop, resume, reset, or an activity identity change also clears it.
Each delivered compute() call is processed once.

**Relations**

- allocated_to: [APP-3](#app-3)

<a id="app-38"></a>
## APP-38 — Qualify the declared Garmin device matrix

Type: requirement | State: approved | Revision: 63

The verification process must qualify each declared target independently.
Coverage includes APIs, resources, layouts, enlargement, alignment, themes, missing data, settings delivery, field types, effect colors, and native drawing capabilities.
A constant or source-font glyph alone does not qualify a runtime font.
Failing or unqualified candidates must not be advertised as supported.
Simulator results remain separate from model and firmware-specific source and callback qualification under [SPEC-159](#spec-159).

**Relations**

- allocated_to: [APP-2](#app-2)
- uses: [APP-24](#app-24), [APP-47](#app-47), [APP-48](#app-48), [SPEC-159](#spec-159)

<a id="app-37"></a>
## APP-37 — Meet the compute snapshot deadline

Type: requirement | State: approved | Revision: 42

The app must process each delivered compute() call once and prepare its snapshot in less than 1000 milliseconds without a backlog.
The app must apply any stricter device limit.
Drawing consumes the latest full snapshot independently of callback order.

**Relations**

- allocated_to: [APP-3](#app-3), [APP-4](#app-4)
- uses: [APP-26](#app-26)

<a id="app-36"></a>
## APP-36 — Keep text readable when effects and themes change

Type: requirement | State: approved | Revision: 88

The app must use black text on white in Day mode, and white text on black in Night mode.
For text over a colored fill, the app must use these foreground colors:

| Fill | Foreground |
| --- | --- |
| White, yellow, cyan, green, magenta, light gray | Black |
| Blue, orange, red, dark red, black, dark gray, dark magenta | White |

The app must apply fill contrast only to text over the fill: headers in Label mode, or all text in Whole cell mode.
For the slope horizon, the app must keep the ordinary effective foreground across the two sky and ground.

**Relations**

- allocated_to: [APP-4](#app-4)
- uses: [APP-45](#app-45), [DVS-45](#dvs-45), [DVS-51](#dvs-51)

<a id="app-33"></a>
## APP-33 — Publish a complete display snapshot before drawing

Type: requirement | State: approved | Revision: 52

The app must prepare a full, unavailable-safe snapshot before asynchronous drawing.
The app must keep headers and valid settings-sourced values before the first sample.
The app must publish full replacement snapshots. Drawing uses the latest snapshot without assumptions about callback order.

**Relations**

- allocated_to: [APP-3](#app-3), [APP-4](#app-4)
- uses: [APP-26](#app-26), [APP-34](#app-34), [APP-35](#app-35), [SPEC-208](#spec-208)

<a id="hfer-8"></a>
## HFER-8 — Draw the Horizontal lines pattern

Type: requirement | State: approved | Revision: 33

The app must apply this pattern only when Grid type is Horizontal lines under [APP-22](#app-22), independently of text alignment.

The app must draw no vertical separator. The app must draw a one-pixel horizontal line at each regular cell bottom, including the last row.
No line crosses an enlarged cell. Split each cell width into 16 equal integer-bounded segments from left to right. The app must remove empty segments.

For segment index i=0..15, q = floor(96*(i+1)/16). Night uses RGB(q,q,q). Day uses RGB(255-q,255-q,255-q), giving increasing contrast toward the right. The app must use the base palette. The app must keep cell boundaries and clip under [APP-34](#app-34). Reference: [horizontal line pattern](attachments/right-delimiters.png).

**Relations**

- uses: [APP-34](#app-34), [APP-45](#app-45)

<a id="hfer-7"></a>
## HFER-7 — Draw the Full grid pattern

Type: requirement | State: approved | Revision: 33

The app must apply this pattern only when Grid type is Full grid under [APP-22](#app-22), independently of text alignment.

The app must draw one-pixel horizontal separators between regular rows and a vertical separator between regular columns. The app must not cross enlarged cells or add an outer border. Split each cell-length line into 16 equal integer-bounded segments. The app must remove empty segments.

For horizontal segments, the app must use their global horizontal midpoint p and display width W. The app must calculate intensity q = floor(96 * clamp(1 - abs(p-W/2)/(W/2), 0, 1)). For vertical segments, the app must use the global vertical midpoint and display height in the same formula. Night uses RGB(q,q,q). Day uses RGB(255-q,255-q,255-q). The app must use the base palette even beside enlarged inverted cells.

The app must place horizontal lines at each regular row's bottom pixel, except the last display row.
The vertical line must use the right column's left pixel. The app must fit and clip to assigned bounds under [APP-34](#app-34). Reference: [full grid pattern](attachments/center-delimiters.png).

**Relations**

- uses: [APP-34](#app-34), [APP-45](#app-45)

<a id="dvs-35"></a>
## DVS-35 — Device battery level

Type: requirement | State: approved | Revision: 63

| Attribute | Value |
| --- | --- |
| CODE | 21 |
| IDENTIFIER | battery |
| LABEL | battery |
| LABEL_AND_UNIT | `battery \| {unit}` |
| PRECISION | 0 |
| UNIT | % |

The app must display System.getSystemStats().battery when it is finite and between 0 and 100 inclusive.
The app must not clamp invalid readings.
Color source: none.
Normal display range: 0 to 100 percent. Apply [APP-55](#app-55).

**Relations**

- allocated_to: [APP-4](#app-4)
- uses: [APP-17](#app-17), [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-50](#dvs-50), [DVS-7](#dvs-7)

<a id="dvs-22"></a>
## DVS-22 — Three-second average power

Type: requirement | State: approved | Revision: 88

| Attribute | Value |
| --- | --- |
| CODE | 8 |
| IDENTIFIER | power_3s |
| LABEL | 3s watts |
| LABEL_AND_UNIT | `3s watts` |
| PRECISION | 0 |
| UNIT | w |

The app must display the shared three-second arithmetic mean of finite, nonnegative currentPower samples in watts, including measured zero.
The app must publish the first valid sample unchanged, then the mean of the first two samples.
After three samples, the app must publish the rolling mean of the latest three.
The app must use the same startup sequence after each [DVS-41](#dvs-41) reset. Before the first valid sample, the app must display unavailable.
Color source: power.

Normal display range: 0 to 3000 watts. Apply [APP-55](#app-55).

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-41](#dvs-41), [DVS-42](#dvs-42), [DVS-50](#dvs-50), [DVS-7](#dvs-7), [SPEC-248](#spec-248), [SPEC-663](#spec-663), [SPEC-665](#spec-665)

<a id="dvs-12"></a>
## DVS-12 — Define field headers and their common band height

Type: requirement | State: approved | Revision: 119

The app must place each full header three pixels below the cell top, using the label font.
At catalogue or label-font initialization, the app must measure visible header bounds [a,b) relative to the header origin.
The app must include each supported header, unit variant, hidden assignment, and clock indicator. The app must exclude user-entered values.
With p = 3 pixels, the app must calculate:
- M = min(2*p + a + b) across all headers.
- S = max(p + b + 1) across all headers.
- H = max(M,S).

The app must include one-pixel halo clearance. The app must cache H for the catalogue and font revision.
Each regular or enlarged Label band spans the cell width and ends at cell_y + H.
Assignments, preferences, visibility, theme, alignment, values, and enlargement must not resize H.

**Relations**

- allocated_to: [APP-4](#app-4)
- uses: [APP-25](#app-25), [DVS-50](#dvs-50), [DVS-6](#dvs-6)

<a id="app-21"></a>
## APP-21 — Align complete headers and value groups horizontally

Type: requirement | State: approved | Revision: 108

The app must use [SPEC-303](#spec-303) or [SPEC-341](#spec-341) to select Center or Right alignment.
In Center mode, the app must center each full header and each full value group independently.
In Right mode, align the two groups to their usable right edge.
The app must not change cell size or slot order.

**Relations**

- allocated_to: [APP-4](#app-4)
- uses: [APP-25](#app-25), [DVS-12](#dvs-12)

<a id="app-20"></a>
## APP-20 — Configure the two-column Garmin field grid

Type: requirement | State: approved | Revision: 100

The app must use two grid columns. A regular cell occupies one column and one row.
An enlarged cell occupies the two columns and two rows.
The app must place enlarged cells first, in slot order. The app must fill regular cells from left to right, then from top to bottom.
The app must permit only these full combinations:

| Row capacity | Enlarged cells | Regular cells | Total cells |
| --- | --- | --- | --- |
| 4 | 0 | 8 | 8 |
| 4 | 1 | 4 | 5 |
| 4 | 2 | 0 | 2 |
| 5 | 0 | 10 | 10 |
| 5 | 1 | 6 | 7 |
| 5 | 2 | 2 | 4 |

The app must use [SPEC-302](#spec-302) or [SPEC-340](#spec-340) to select enlargement. The app must not provide an independent cell-count selector.

**Relations**

- allocated_to: [APP-3](#app-3), [APP-4](#app-4)

<a id="perf-14"></a>
## PERF-14 — Keep memory observers bounded and report their overhead

Type: requirement | State: approved | Revision: 7

The development process must keep fixed counters and stage identifiers in the sampling path. The development process must not print or format diagnostics while sampling.
The development process must emit records after fixture temporaries are released.
The development process must use a separate observer for native callbacks and default configurations without synthetic driver state.
The development process must identify observer scope and overhead. The development process must apply limits to unadjusted instrumented usage.

The development process must not subtract estimated overhead to get a pass.

**Relations**

- derived_from: [APP-48](#app-48)

<a id="perf-13"></a>
## PERF-13 — Apply runtime allocation and growth acceptance criteria

Type: requirement | State: approved | Revision: 8

Pass only within actual runtime allocation and the Data Field ceiling.
The development process must reject allocation failures, out-of-memory errors, or sustained unreclaimed growth after returning to the same configuration.
Bound and reuse resources, buffers, and caches.

**Relations**

- derived_from: [APP-48](#app-48)

<a id="nfr-20"></a>
## NFR-20 — Record test executions against their captured evidence

Type: requirement | State: approved | Revision: 7

An execution must record captured requirement and test revisions, baseline where applicable, environment, product, inputs, observations, and actual outcome.
Source, binary, fixture, and raw-log hashes must identify the evidence used.
A Monkey C test pass needs its named PASS result and a successful nonempty suite summary.
Host checks need their native successful result and raw output. Visual or physical checks need recorded observations against their criteria.

A missing automated PASS block must not be invented for a manual check.
Suite duration is not per-case duration. Approval does not create a pass.
Historical executions retain their captured scope. Changed unexecuted scope remains unrun or blocked.
Execution records link to Test definitions, not directly to requirement items.

**Relations**

- derived_from: [SPEC-162](#spec-162)

<a id="nfr-19"></a>
## NFR-19 — Qualify onboard temperature provenance per model and firmware

Type: requirement | State: approved | Revision: 11

Physical temperature qualification requires onboard-source and external-pairing evidence for each claimed model and firmware combination.
Representative sampling must not waive that evidence.
Missing or unresolved evidence blocks the affected release or support claim.
It does not disable runtime readings that pass [FR-16456](#fr-16456) and [FR-16458](#fr-16458).
Physical qualification records are not a runtime model allow-list and must not replace the sensor checks.

**Relations**

- derived_from: [SPEC-159](#spec-159)
- uses: [FR-16456](#fr-16456), [FR-16458](#fr-16458)

<a id="nfr-18"></a>
## NFR-18 — Verify captured simulator images against explicit expectations

Type: requirement | State: approved | Revision: 7

The development process must capture scenario images with expected cell, text, and unused-area rules.
The development process must record the observed result against those rules. An image file alone is not a visual pass.

**Relations**

- derived_from: [SPEC-158](#spec-158)

<a id="nfr-17"></a>
## NFR-17 — Keep font probes and Data Field allocation qualification in Memory

Type: requirement | State: approved | Revision: 9

The Memory suite contains runtime font-loading probes and Data Field allocation qualification.
It runs only after an explicit user request.
Build-time glyph inventories, mask validation, reproducibility, compilation, and serialized-property checks are not runtime Memory tests.
Those build checks do not establish runtime allocation qualification.

**Relations**

- derived_from: [SPEC-157](#spec-157)

<a id="nfr-16"></a>
## NFR-16 — Keep deliberate insufficient-area cases in Placement

Type: requirement | State: approved | Revision: 7

Placement contains deliberate insufficient-area, reduced-area, unsupported-layout, and rendered compact-fallback scenarios.
The suite runs only after an explicit request.
Core may check formatting decisions and unavailable or overflow markers without launching those layout scenarios.
Core normal-range drawing cases must fail if the required value overflows or the grid falls back.

**Relations**

- derived_from: [SPEC-157](#spec-157)

<a id="nfr-15"></a>
## NFR-15 — Cover functional and ordinary UI behavior in Core tests

Type: requirement | State: approved | Revision: 9

Core must cover values, settings, formatting, normal UI, acquisition and lifecycle boundaries, cache invalidation, and ordinary drawing purity.
Every guaranteed range needs minimum, interior, maximum, and width-transition cases with exact text and actual glyph and halo bounds.
Coverage includes applicable units, clocks, roles, alignments, rounded-equivalent readings, profile invalidation, snapshots, polygons, and optional queries.
Required cases must fail on overflow or compact substitution.

Tests must distinguish ordinary drawing from the dirty-layout exception in [APP-26](#app-26).
Unchanged frames must not repeat fitting, measurement, geometry preparation, or resource loading.
These assertions do not qualify runtime memory, battery use, or hardware behavior.

**Relations**

- derived_from: [SPEC-157](#spec-157)
- uses: [APP-26](#app-26)

<a id="nfr-14"></a>
## NFR-14 — Provide deterministic timestamped sensor fixtures

Type: requirement | State: approved | Revision: 6

The development process must use anonymized timestamped fixtures for missing, non-finite, and zero readings, gaps, units, pause, resume, and boundaries.
A successful fixture test does not qualify the physical source.

**Relations**

- derived_from: [SPEC-156](#spec-156)

<a id="nfr-13"></a>
## NFR-13 — Verify signed package compatibility gates before distribution

Type: requirement | State: approved | Revision: 7

The development process must compile and sign packages with SDK 9.2.0. The development process must not edit a signed package.
Independently verify each exported regional firmware and API gate against its declared compatibility target.
The development process must verify that installed device metadata remains unchanged.
The development process must report package success only after these checks pass. SDK version alone does not establish the exported gates.

**Relations**

- derived_from: [SPEC-153](#spec-153)

<a id="nfr-12"></a>
## NFR-12 — Build store packages with an isolated device metadata overlay

Type: requirement | State: approved | Revision: 6

The development process must keep the installed device library unchanged.
For store packaging, copy definitions to a project-local overlay.
The development process must apply only model and part overrides declared in config/firmware-compatibility.json.
The development process must accept only device-report or release-family-inference evidence. An inferred target must have a model release notice and an API evidence anchor.
The development process must reject missing evidence, unknown evidence kinds, missing or duplicate parts, and unexpected upstream firmware or API values.

The development process must keep all undeclared metadata unchanged.

**Relations**

- derived_from: [SPEC-153](#spec-153)

<a id="nfr-11"></a>
## NFR-11 — Clean up only owned SDK runner processes

Type: requirement | State: approved | Revision: 6

Establish ownership of automated SDK validation and preview runner descendants before startup.
The development process must close the full owned process group after success, failure, timeout, or controller exit, including descendants of an exited parent.
The development process must keep exit codes and logs. The development process must not stop unrelated processes or wait indefinitely for inherited output pipes.

**Relations**

- derived_from: [SPEC-153](#spec-153)

<a id="nfr-10"></a>
## NFR-10 — Use consistent code-size optimization for every build mode

Type: requirement | State: approved | Revision: 7

The development process must use the SDK option `-O 3z` for app, package, preview, and test builds.

**Relations**

- derived_from: [SPEC-153](#spec-153)

<a id="nfr-9"></a>
## NFR-9 — Protect and retain the external signing identity

Type: requirement | State: approved | Revision: 6

The development process must supply signing identities and tokens externally through protected configuration.
The development process must exclude them from commits, artifacts, and logs. The development process must keep the signing identity across upgrades.

**Relations**

- derived_from: [SPEC-153](#spec-153)

<a id="nfr-8"></a>
## NFR-8 — Fail simulator orchestration on incomplete or failed execution

Type: requirement | State: approved | Revision: 6

Connect to or start the documented simulator.
A passing run must have named test results and a successful, nonempty suite summary.
The development process must fail on timeout, crash, assertion, or zero tests. Compilation alone is not runtime qualification.

**Relations**

- derived_from: [SPEC-153](#spec-153)

<a id="nfr-7"></a>
## NFR-7 — Apply the evidenced per-model firmware and API floors

Type: requirement | State: approved | Revision: 7

Build all ten profiles with SDK 9.2.0 and the floors in config/firmware-compatibility.json.
Edge 540, 550, 840, 850, worldwide 1040, and 1050 targets must use firmware 30.18 and API 6.0.0 minimum gates.
For 540, 550, 840, and 850, the development process must keep model release notices and explicit release-family API inference from 1040 or 1050 evidence.
The development process must not describe inferred API evidence as a direct model capture.
The development process must keep installed gates for legacy 530, 830, 1030, APAC 1040, and 1060.

Power zones and typed laps must use API 5.2.2 or later. The development process must not lower target floors by disabling these features.
Historical virtual-machine versions do not prove API availability.
The development process must treat floors as evidenced compatibility targets, not exhaustive earliest-firmware or physical qualification claims.

**Relations**

- derived_from: [SPEC-152](#spec-152)

<a id="nfr-6"></a>
## NFR-6 — Record device API capabilities and guarded fallbacks

Type: requirement | State: approved | Revision: 7

For each candidate, the development process must record minimum firmware and API, optional APIs, and fallbacks for properties, zones, night mode, temperature, and graphics.
Justify all permissions, including UserProfile, Background, and Sensor.
The development process must keep older targets through guarded fallbacks. Optional power zones must not impose a global API 5.2.2 minimum.
The development process must compile typed-lap adapters only where supported. The development process must guard optional power APIs.

The development process must not remove failing candidates or equate compilation with supported-device qualification.

**Relations**

- derived_from: [SPEC-152](#spec-152)

<a id="nfr-5"></a>
## NFR-5 — Provide reproducible developer and CI setup instructions

Type: requirement | State: approved | Revision: 6

The development process must document Garmin-supported dependency and account setup for new developers and CI.
The development process must provide copyable setup, check, build, and test commands with expected results.
Environment checks report resolved paths, versions, device packages, and missing prerequisites.
The command line is authoritative. Optional VS Code and Monkey C settings must use the same toolchain.

**Relations**

- derived_from: [SPEC-151](#spec-151)

<a id="nfr-4"></a>
## NFR-4 — Test font validation with known invalid fixtures

Type: requirement | State: approved | Revision: 9

Font validation must reject a missing `f` needed for `ft`, an unused numeric letter, and opaque padding.
Reachable-text changes require resource regeneration and compilation for every declared profile.
Runtime font-loading probes run only with the explicitly requested Memory suite under [NFR-17](#nfr-17).
Successful compilation does not establish native-font or runtime-memory qualification.

**Relations**

- derived_from: [SPEC-177](#spec-177)
- uses: [NFR-17](#nfr-17)

<a id="nfr-3"></a>
## NFR-3 — Record traceable glyph generation inputs and outputs

Type: requirement | State: approved | Revision: 6

The development process must record input revisions and hashes, role, size, language, expected and generated code points, encoding, source ink, and advance metrics.
The development process must record output hashes in a reproducible font manifest.

**Relations**

- derived_from: [SPEC-177](#spec-177)

<a id="fr-16469"></a>
## FR-16469 — Explain training-zone units and active custom limits

Type: requirement | State: approved | Revision: 6

The development process must state each limit's unit in its prompt. The development process must state that custom limits apply only while their switch is On.
Describe the open-ended final zone without an editable upper limit.
The development process must use the power-zone names from [SPEC-662](#spec-662).

**Relations**

- derived_from: [SPEC-669](#spec-669)

<a id="hfe-3"></a>
## HFE-3 — Use consistent settings captions and prompts

Type: requirement | State: approved | Revision: 7

Prefix each second-set presentation and slot caption with 'Second set:'.
The development process must use 'Slot N: value' and 'Slot N: background', not 'Field N'.
Put the second-set explanation in the activation prompt.
The development process must use the owning property captions, keys, types, choice codes, and defaults without adding duplicate shared controls.

**Relations**

- derived_from: [SPEC-210](#spec-210)

<a id="hfe-2"></a>
## HFE-2 — Order the main settings page consistently

Type: requirement | State: approved | Revision: 8

The development process must use this order:
1. First-set general controls.
2. Shared text-outline control on API 3 profiles only.
3. The two shared Team controls.
4. First-set slot controls.
5. Shared training-zone controls under [SPEC-669](#spec-669).
6. Second-set activation, thresholds, presentation controls, and slots.

Order activation controls as event, power activation, power return, heart rate activation, then heart rate return.
Within each slot, the development process must place value before background. The development process must keep shared Team and zone controls outside the two banks.

**Relations**

- derived_from: [SPEC-210](#spec-210)

<a id="nfr-2"></a>
## NFR-2 — Keep corresponding bank property domains and defaults independent

Type: requirement | State: approved | Revision: 6

Corresponding a and b properties must have the same type and range, with their own declared defaults.
Missing second-set properties must not copy the current first-set choices.
Team, training-zone, and activation properties are global. The app must validate them without changing storage under [APP-31](#app-31).

**Relations**

- derived_from: [SPEC-155](#spec-155)

<a id="fr-16468"></a>
## FR-16468 — Reject old event notifications after activity reset

Type: requirement | State: approved | Revision: 7

After onTimerReset(), the app must ignore lap and workout-step notifications until onTimerStart(), onTimerResume(), or onWorkoutStarted().
A new workout-start callback arms the new activity and activates Workout started mode.
After app attachment, only newly delivered events can activate an event mode. The app must not reconstruct earlier event history.

**Relations**

- derived_from: [SPEC-220](#spec-220)

<a id="fr-16467"></a>
## FR-16467 — Keep switching state through pause and resume

Type: requirement | State: approved | Revision: 8

Pause, Auto Pause, and manual stop keep the active set and suspend threshold checks.
After resume, the app must examine the next delivered sample without using pre-pause input.
The app must use partial power-window results immediately. An unavailable result selects default under [SPEC-216](#spec-216).
The app must not wait for three power samples while retaining the second set.

Lap and workout latches persist across pause, stop, and resume. Qualifying delivered callbacks still apply.

**Relations**

- derived_from: [SPEC-220](#spec-220)

<a id="fr-16466"></a>
## FR-16466 — Explain the legacy Manual lap setup restriction

Type: requirement | State: approved | Revision: 6

The development process must include this text in the settings prompt and user guide:
"Edge 530/830/1030: disable Auto Lap. This device cannot distinguish manual from automatic lap events."
Also state that other automatic lap sources, including workout-generated laps, must not be active.

**Relations**

- derived_from: [SPEC-218](#spec-218)

<a id="perf-12"></a>
## PERF-12 — Keep production memory and deadline diagnostics disabled

Type: requirement | State: approved | Revision: 6

Disable continuous memory and deadline diagnostics in production.
Enable diagnostic sampling only in explicitly selected validation builds.
The app must not query statistics only for production diagnostics. The app must not claim battery savings without measurements.

**Relations**

- derived_from: [APP-37](#app-37)

<a id="fr-16462"></a>
## FR-16462 — Keep settings across saves and restarts

Type: requirement | State: approved | Revision: 9

The app must keep saved selections and shared Team text through restart.
Settings serialization, callback validation, and presentation replacement must succeed within the unmodified target limits.
The app must not report a failed save as applied.

**Relations**

- derived_from: [APP-32](#app-32)

<a id="perf-11"></a>
## PERF-11 — Load API 4+ outline fonts only for visible painted roles

Type: requirement | State: approved | Revision: 8

On API 4+ profiles, a visible painted header may load its label outline resource.
A visible painted numeric value may load its outline only for Whole cell or slope-horizon coverage.
The app must not load outlines solely for hidden slots, None coverage, or unknown unpainted fields.
It must reuse required cached handles and load a newly required role before its next painted frame.
Native Team value text uses no outline resource.

**Relations**

- derived_from: [APP-50](#app-50)

<a id="perf-10"></a>
## PERF-10 — Validate temperature cache age before each use

Type: requirement | State: approved | Revision: 7

The app must validate each nonempty temperature cache on each delivered compute() call and each presentation refresh.
The app must apply the cache-expiry contract before preparing a displayed value.

**Relations**

- derived_from: [APP-51](#app-51)

<a id="perf-9"></a>
## PERF-9 — Read clock values only when an active retained field needs them

Type: requirement | State: approved | Revision: 6

The app must query the clock only for active retained field needs.
The app must get a newly active bank's necessary clock value before its first frame.

**Relations**

- derived_from: [APP-51](#app-51)

<a id="perf-8"></a>
## PERF-8 — Refresh device presentation preferences during compute

Type: requirement | State: approved | Revision: 6

The app must read device units, clock format, and automatic-theme preferences on each delivered compute() call.
The app must apply changed preferences to one coherent presentation, including when no app-settings callback occurs.

**Relations**

- derived_from: [APP-51](#app-51)

<a id="perf-7"></a>
## PERF-7 — Release outgoing display resources before a property reload

Type: requirement | State: approved | Revision: 8

On a full property reload, the app must release outgoing presentation records, geometry, and font handles before loading replacement banks.
The app must keep metric tables and acquisition history. Reload only the necessary fixed font roles.

**Relations**

- derived_from: [APP-52](#app-52)

<a id="perf-6"></a>
## PERF-6 — Bound retained state and release replaced caches

Type: requirement | State: approved | Revision: 7

The app must use bounded, packed structures for slot and geometry state.
The app must release replaced raw frames before constructing their successors.
The app must release obsolete caches. The app must not keep unbounded history.

**Relations**

- derived_from: [APP-53](#app-53)

<a id="perf-5"></a>
## PERF-5 — Release drawing contexts at their callback boundary

Type: requirement | State: approved | Revision: 10

The app must not retain a native Dc after its callback returns.
Native measurements must use the current Dc during layout preparation.
That path may run from onLayout(), or from a dirty onUpdate() under [APP-26](#app-26).
The app must release the measurement context before drawing prepared commands.

**Relations**

- derived_from: [APP-26](#app-26)
- uses: [APP-26](#app-26)

<a id="fr-16461"></a>
## FR-16461 — Measure native Team text only with the current layout drawing context

Type: requirement | State: approved | Revision: 12

The app must measure native Team text only during layout preparation with the current Dc.
After settings or bank changes, it must defer required native fitting until that context is available.
The permitted entry points and lifetime rules are [APP-26](#app-26) and [PERF-5](#perf-5).

**Relations**

- derived_from: [DVS-57](#dvs-57)
- uses: [APP-26](#app-26), [PERF-5](#perf-5)

<a id="fr-16460"></a>
## FR-16460 — Place the Team text block within the value area

Type: requirement | State: approved | Revision: 8

The app must reserve ceil(0.05*cell_width) horizontally and ceil(0.05*cell_height) vertically at each value-area edge.
The app must reserve one pixel for halo clearance in each display mode.
The app must center the wrapped text block vertically. The app must apply the selected alignment to each line.

**Relations**

- derived_from: [SPEC-253](#spec-253)

<a id="fr-16459"></a>
## FR-16459 — Guarantee the normal temperature display range

Type: requirement | State: approved | Revision: 8

The app must display -40 to 60 C or -40 to 140 F without trimming or an overflow indicator.
The app must apply [APP-55](#app-55) across all supported devices and the two value roles.

**Relations**

- derived_from: [DVS-55](#dvs-55)

<a id="fr-16458"></a>
## FR-16458 — Expire cached temperature without extending its age

Type: requirement | State: approved | Revision: 10

A temperature reading remains usable through 360 seconds of age inclusive. The cache expires after that limit.
The receiver must validate wall-clock and monotonic-clock continuity. A rollback or invalid clock invalidates the reading.
Age must satisfy both wall time since reading and delivery age plus monotonic time since receipt.
Neither clock may extend the reading beyond 360 seconds.
Pause, settings, units, and visibility changes must not extend cache age.

**Relations**

- derived_from: [DVS-54](#dvs-54)

<a id="fr-16457"></a>
## FR-16457 — Deliver and validate background temperature packets

Type: requirement | State: approved | Revision: 9

The worker must send a four-element Background.exit array: protocol version 2, nullable Celsius value, UTC read time, and `edge-native-v2`.
Only the app's owned background callback establishes packet origin. The string marker alone does not establish origin.
The receiver must reject incompatible shapes, protocols, future timestamps, and timestamps no newer than its accepted watermark.
Those rejected packets must not advance the watermark or replace a valid reading.

A compatible newer packet advances the watermark and replaces the older reading.
A null, non-finite, or already expired value invalidates that older reading immediately; it must not extend the previous cache.
The app must refresh presentation after background delivery, including invalidation.
Clock failures and cache age follow [FR-16458](#fr-16458).

**Relations**

- derived_from: [DVS-54](#dvs-54)
- uses: [FR-16458](#fr-16458)

<a id="fr-16456"></a>
## FR-16456 — Accept temperature only with onboard sensor provenance

Type: requirement | State: approved | Revision: 8

The app must enumerate registered SENSOR_TEMPERATURE sensors before and after each read.
The app must accept an empty iterator or entries with SENSOR_TECHNOLOGY_ONBOARD.
The app must reject null metadata, exceptions, unknown technologies, ANT or BLE registrations, and lists longer than 32 entries.
A remote registration blocks acquisition even when the sensor is disconnected or disabled.

**Relations**

- derived_from: [DVS-34](#dvs-34)

<a id="fr-16455"></a>
## FR-16455 — Guarantee the normal grade display range

Type: requirement | State: approved | Revision: 8

The app must display canonical grade from -99.9 to 99.9 percent without trimming or an overflow indicator.
The app must apply [APP-55](#app-55) across all supported devices and the two value roles.

**Relations**

- derived_from: [DVS-53](#dvs-53)

<a id="fr-16454"></a>
## FR-16454 — Draw the grade horizon for Whole cell coverage

Type: requirement | State: approved | Revision: 8

For Whole cell grade coverage, the app must draw a horizon through the cell center at clamp(2*g, -45, 45) degrees.
Positive grade slopes up from left to right. Clip the ground fill below the horizon and the sky fill above it.
The app must use the effective ordinary background for the sky. The app must use the grade band color for the ground.

This geometry overrides generic Whole cell coverage. The app must remove the horizon when grade is unavailable.

**Relations**

- derived_from: [DVS-53](#dvs-53)

<a id="fr-16453"></a>
## FR-16453 — Reset grade history after invalid input or lost progress

Type: requirement | State: approved | Revision: 7

The app must clear regression history and set all five average slots to zero after invalid input, decreasing distance, or decreasing time.
Also reset after a gap over 2000 milliseconds, pause, stop, or reset.
After three seconds without distance progress, the app must keep grade unavailable until progress resumes.

**Relations**

- derived_from: [DVS-52](#dvs-52)

<a id="fr-16452"></a>
## FR-16452 — Average the latest five grade estimates

Type: requirement | State: approved | Revision: 7

The app must initialize five estimate slots to zero.
For each newly admitted point, the app must replace the oldest slot with the regression estimate.
Immediately publish the mean of all five slots. Unfilled startup slots contribute zero.
The app must round the mean to two decimal places, with exact halves away from zero. The app must not publish negative zero.

**Relations**

- derived_from: [DVS-52](#dvs-52)

<a id="fr-16451"></a>
## FR-16451 — Keep or invalidate the completed-lap count

Type: requirement | State: approved | Revision: 10

Pause, stop, resume, settings, and visibility changes retain a continuously observed completed-lap count.
onTimerReset() ends the old activity and arms FRESH_READY. Finalization events from that activity must not increment the count.
An identity change, counter regression without reset, unproven activity continuity, or count overflow makes the total unknown.
Missing identity or temporary sensor samples alone do not prove lost activity continuity.

After late loading, UNKNOWN remains unknown for that activity, including after later laps.
Only a confirmed fresh session under [FUNC-9](#func-9) restores a known zero baseline.
The app must not infer missing lap history or restore an unproven total.

**Relations**

- derived_from: [DVS-39](#dvs-39)
- uses: [FUNC-9](#func-9)

<a id="fr-16450"></a>
## FR-16450 — Reject discontinuous current-lap sensor intervals

Type: requirement | State: approved | Revision: 10

Invalid channel input clears only that channel endpoint, retaining earlier sums without adding time or artificial zero.
The app must not pair samples across lap boundaries, pause, resume, or gaps longer than 2000 milliseconds.
Duplicate samples add no weight. Older samples must not pair with newer endpoints.
A valid sample after a gap seeds the next pair.

Counter regression follows the affected-value rules in [FR-16449](#fr-16449).
Non-finite or overflowing sums or denominators invalidate that sensor mean until the next lap.
Settings and visibility changes retain sums. Later samples cannot repair an unknown lap baseline.
The app must not derive lap means from activity or three-second averages.

**Relations**

- derived_from: [FUNC-10](#func-10)
- uses: [FR-16449](#fr-16449)

<a id="fr-16449"></a>
## FR-16449 — Invalidate current-lap values when continuity is lost

Type: requirement | State: approved | Revision: 10

onTimerReset(), save, or discard ends the current lap epoch. The app must ignore finalization events from that ended epoch.
An activity identity change or decreasing elapsedTime invalidates all current-lap baselines and sensor sums until a confirmed boundary.
A distance regression invalidates lap distance and speed, while valid lap time and sensor means remain independent.
A timerTime regression invalidates lap time, speed, and sensor means, while valid lap distance remains independent.

Missing identity alone is not a change. A temporary missing channel or a sampling gap follows [FR-16450](#fr-16450), not global invalidation.
Lost continuity means that the activity or lap epoch cannot be established; it does not mean an ordinary missing sensor interval.
Overflow invalidates its affected calculation. The app must not reconstruct history or stopped-distance corrections.

**Relations**

- derived_from: [DVS-59](#dvs-59)
- uses: [FR-16450](#fr-16450)

<a id="fr-16448"></a>
## FR-16448 — Process each delivered lap boundary once

Type: requirement | State: approved | Revision: 8

The app must process each delivered lap callback once for shared lap acquisition, regardless of the selected switching mode.
A supported typed adapter must return true after processing to prevent fallback invocation of onTimerLap().
Workout-step callbacks must not reset lap acquisition.

**Relations**

- derived_from: [DVS-58](#dvs-58)

<a id="fr-16447"></a>
## FR-16447 — Recover current-lap tracking after late loading

Type: requirement | State: approved | Revision: 10

Without a confirmed fresh session, current-lap fields must wait for a later confirmed lap boundary before tracking.
The boundary follows [DVS-58](#dvs-58) and [FR-16448](#fr-16448).
Recovery establishes only the current lap. It must not invent a historical completed-lap count under [DVS-39](#dvs-39).

**Relations**

- derived_from: [FUNC-9](#func-9)
- uses: [DVS-39](#dvs-39), [DVS-58](#dvs-58), [FR-16448](#fr-16448)

<a id="fr-16445"></a>
## FR-16445 — Select the halo renderer for the device profile

Type: requirement | State: approved | Revision: 12

For bundled text on API 4+ profiles, the renderer must draw the generated outline resource before the foreground glyphs.
The outline mask follows [SPEC-177](#spec-177), with a one-pixel border, offset -1 pixel, and unchanged advance.
The final composite must equal foreground text over the eight shifted runtime masks; the raw masks need not be equal.

Edge 530, 830, and 1030 use eight shifted draws when [SPEC-670](#spec-670) enables halos.
Native Team value text uses that runtime method on all profiles when a halo is required and enabled.
Disabled halos leave contrast colors, geometry, margins, and reserved clearance unchanged.

**Relations**

- derived_from: [DVS-6](#dvs-6)
- uses: [SPEC-177](#spec-177), [SPEC-670](#spec-670)

<a id="nfr-1"></a>
## NFR-1 — Verify the fixed numeric fonts with clock and timer groups

Type: requirement | State: approved | Revision: 8

At full-screen bounds, the two primary font roles must fit the full text `00:00`.
The two roles must also fit primary text `59`, secondary text `.59`, and a two-pixel gap below one hour. From one hour, the duration fit checks must use primary text without secondary seconds, under [DVS-13](#dvs-13).
The development process must include the four-pixel horizontal margins, maximum one-pixel halo, reserved header height, and vertical gap.
The development process must examine this constraint during font generation and verification. The development process must not scale fonts at runtime.
Other values and full headers use their field-specific normal ranges.

**Relations**

- derived_from: [APP-24](#app-24)

<a id="hfe-1"></a>
## HFE-1 — Center values below the reserved header area

Type: requirement | State: approved | Revision: 7

The app must reserve R = max(label line height, common header-band height) at the top of each cell, including cells without effects.
For a cell at y with height h, the app must center the primary visible glyph bounds at y + R + (h - R)/2.
The app must permit an error of at most one pixel.
Header text, preferences, colors, and enlargement do not change this reservation for unchanged cell bounds.
Native-text fields fit their value block within the same reserved area.

**Relations**

- derived_from: [APP-21](#app-21)

<a id="app-55"></a>
## APP-55 — Guarantee inclusive normal display ranges across device profiles

Type: requirement | State: approved | Revision: 11

Normal display ranges include their endpoints after unit conversion and display rounding.
They apply at [APP-24](#app-24) full-screen bounds, to each supported visible role and permitted enlargement configuration.
They cover Center and Right alignment, Day and Night, shown and hidden physical units, and the maximum applicable halo.
An absent role does not require a fit assertion.

Duration limits use elapsed h:mm:ss. Clock limits use 24-hour notation, including guarantees tested in 12-hour display mode.
Normal ranges are fit guarantees, not sensor-validity limits or clamps.
Outside them, [APP-35](#app-35) and [APP-23](#app-23) apply. Other visible cells must also satisfy their fit contracts for a complete grid.

**Relations**

- uses: [APP-23](#app-23), [APP-24](#app-24), [APP-35](#app-35)

<a id="app-54"></a>
## APP-54 — Display centered fallback message when grid cannot fit drawing bounds

Type: requirement | State: approved | Revision: 8

If no full permitted grid fits, the app must display 'full grid needs larger area'.
The app must center the message in the assigned bounds with the base palette and label font.
The app must wrap the message at spaces. The app must not display a partial grid.
If the full message cannot fit, the app must display only the background.

<a id="dvs-59"></a>
## DVS-59 — Keep current-lap state through pause and presentation changes

Type: requirement | State: approved | Revision: 9

Pause and stop keep current-lap baselines and sums, but clear sample interval endpoints.
Resume seeds a new active sample pair.
Settings changes, visibility changes, and drawing keep lap state.

<a id="dvs-58"></a>
## DVS-58 — Capture current-lap baselines at each confirmed boundary

Type: requirement | State: approved | Revision: 11

At each confirmed lap boundary, the app must advance the lap epoch and clear its accumulators.
It must capture timerTime, elapsedDistance, elapsedTime, available startTime.value(), and optional sample seeds from Activity.getActivityInfo().
Missing counters must not become zero or be reconstructed from history or stale snapshots.

A known valid distance baseline permits lap distance. A known valid timer baseline permits lap time and sensor means.
Lap speed needs both baselines and positive lap time under [FUNC-5](#func-5).
Only running compute() samples contribute weighted intervals. Boundary callbacks may seed endpoints but must not integrate them.
Pause retains valid displayed totals and earlier sums under [DVS-59](#dvs-59).

**Relations**

- uses: [DVS-59](#dvs-59), [FUNC-5](#func-5)

<a id="dvs-57"></a>
## DVS-57 — Bind Team colors to the selected current-value zone source

Type: requirement | State: approved | Revision: 12

Team colors use the selected global power or heart rate profile under [SPEC-663](#spec-663) or [SPEC-664](#spec-664).
The source is current power or heart rate, even when the numeric source field is hidden.
None, missing, or unqualified sources retain the text and use [SPEC-249](#spec-249) when coverage is enabled.
None coverage still paints no effect background.
Hidden, duplicate, or reassigned slots retain the shared text and source binding.
Native fitting follows [FR-16461](#fr-16461), independently of source classification.

**Relations**

- uses: [FR-16461](#fr-16461), [SPEC-249](#spec-249), [SPEC-663](#spec-663), [SPEC-664](#spec-664)

<a id="dvs-56"></a>
## DVS-56 — Select automatic Team font candidates with fit fallback

Type: requirement | State: approved | Revision: 8

Team font selection must be automatic, without a saved font code or user selector.
Candidates are FONT_XTINY, FONT_TINY, FONT_SMALL, FONT_MEDIUM, and FONT_LARGE.
Unsupported candidates or candidates without a positive measured height are excluded.
The app must select the complete-block fit with the greatest measured height, breaking ties with the lowest font constant.

If no candidate fits nonempty text, it must try `!` with the same candidate policy.
If no candidate fits that marker, the value area is blank.
The app must not truncate text, substitute glyphs, add custom atlases, or scale fonts at runtime.

<a id="dvs-55"></a>
## DVS-55 — Select temperature background colors with explicit band boundaries

Type: requirement | State: approved | Revision: 7

The app must select the temperature color from the unrounded Celsius value:

| Temperature t | Color |
| --- | --- |
| t <= -10 C | Blue |
| -10 C < t <= 0 C | Cyan |
| 0 C < t <= 10 C | White |
| 10 C < t <= 20 C | Green |
| 20 C < t <= 30 C | Yellow |
| t > 30 C | Red |

For rejected or expired input, the app must use the selected neutral coverage. The app must not add hysteresis.

<a id="dvs-54"></a>
## DVS-54 — Schedule background temperature reads at the permitted interval

Type: requirement | State: approved | Revision: 8

The app must schedule background temporal events at least 300 seconds apart, including across app restarts.
The app must read temperature once per event.

<a id="dvs-53"></a>
## DVS-53 — Select grade background colors with explicit band boundaries

Type: requirement | State: approved | Revision: 9

The app must select the grade color from the unrounded canonical grade:

| Grade g | Color |
| --- | --- |
| g <= 0% | Green |
| 0% < g <= 2% | Blue |
| 2% < g <= 5% | Yellow |
| 5% < g <= 8% | Orange |
| 8% < g <= 15% | Red |
| 15% < g <= 20% | Dark red |
| g > 20% | Black |

In Label mode, the app must apply this color only to the header. For unavailable grade, the app must use the selected neutral coverage.

<a id="dvs-52"></a>
## DVS-52 — Calculate a grade estimate by linear regression

Type: requirement | State: approved | Revision: 8

With at least three distinct-distance points, the app must calculate the least-squares slope:
- D = n*sum(x*x) - sum(x)^2.
- N = n*sum(x*y) - sum(x)*sum(y).
- g = 100*N/D.

The app must use zero when abs(D) < 1e-9. For other values, the calculation is valid only with finite arithmetic and positive D.
With fewer than three points, the app must use zero.
The app must round each estimate to two decimal places, with exact halves away from zero.

<a id="app-50"></a>
## APP-50 — Cache layout geometry and refit text only on content changes

Type: requirement | State: approved | Revision: 11

The app must cache geometry, header dimensions, separators, and selected fonts for the active presentation.
For retained caches, changed text, font face, cell bounds, or halo clearance permits the affected fit to be recalculated.
Alignment changes may replace positions without changing the selected fixed numeric role.
Initial preparation, a new bank presentation, and a full reload may construct missing caches under [PERF-7](#perf-7).

Unchanged frames must reuse wrapped lines, drawing packets, and equal-angle polygons.
The app must release obsolete geometry before replacing it. Native measurements follow [PERF-5](#perf-5).

**Relations**

- uses: [PERF-5](#perf-5), [PERF-7](#perf-7)

<a id="spec-670"></a>
## SPEC-670 — Text outline on colored backgrounds (halo)

Type: requirement | State: approved | Revision: 43

Key: `halo`
Caption: Text outline on colored backgrounds
Type: Boolean
Default: `true`

Show this global control only on Edge 530, 830, and 1030.
True enables [DVS-6](#dvs-6). False omits the halo without changing contrast colors, geometry, margins, or reserved clearance.
On API 4+ profiles, hide this control and always enable halos, including when storage contains false.
The app must read missing or malformed values as true without changing storage.

**Relations**

- uses: [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-6](#dvs-6), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-668"></a>
## SPEC-668 — Keep activity state when editing zone settings

Type: requirement | State: approved | Revision: 10

Zone-source and zone-limit edits must keep numeric values, rolling samples, lap history, trigger thresholds, and the active field set.
The app must keep custom limits while their switch is Off, and use them when it becomes On.
Loading and classification must not change saved properties or device training zones.
Settings persistence follows [FR-16462](#fr-16462).

**Relations**

- uses: [FR-16462](#fr-16462), [SPEC-663](#spec-663), [SPEC-664](#spec-664)

<a id="spec-664"></a>
## SPEC-664 — Select the global heart rate zone source

Type: requirement | State: approved | Revision: 13

The app must use [FR-16438](#fr-16438) to select the global heart rate zone source for the two field sets.
Off selects qualified device zones under [DVS-42](#dvs-42). On selects only the custom profile under [SPEC-661](#spec-661).
Custom selection operates without device zone metadata.

**Relations**

- uses: [DVS-42](#dvs-42), [FR-16438](#fr-16438), [SPEC-661](#spec-661)

<a id="spec-663"></a>
## SPEC-663 — Select the global power zone source

Type: requirement | State: approved | Revision: 13

The app must use [FR-16431](#fr-16431) to select the global power-zone source for the two field sets.
Off selects qualified device zones under [DVS-42](#dvs-42). On selects only the custom profile under [SPEC-662](#spec-662).
Custom selection operates without device zone metadata.
Device selection keeps the qualified device profile's numeric zone domain.

**Relations**

- uses: [DVS-42](#dvs-42), [FR-16431](#fr-16431), [SPEC-662](#spec-662)

<a id="spec-308"></a>
## SPEC-308 — Team name (team)

Type: requirement | State: approved | Revision: 11

Key: `team`
Caption: Team name
Type and values: String
Default: `"TEAM"`

The app must use one shared Team name for each Team slot in the two sets. The app must accept 0..32 printable ASCII characters. The app must keep spaces and case, including empty text. For invalid or missing input, the app must use "TEAM" without changing storage.

**Relations**

- uses: [SPEC-253](#spec-253)

<a id="spec-301"></a>
## SPEC-301 — Property field-selection codes

Type: requirement | State: approved | Revision: 43

The Garmin settings UI must save field selections as integer codes from 0 to 32.
Runtime handling of well-formed unknown selections follows [APP-31](#app-31).
The app must use this mapping independently of display captions. The linked field owns its behavior.

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

- uses: [APP-31](#app-31), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [SPEC-253](#spec-253)

<a id="spec-253"></a>
## SPEC-253 — Wrap the Team field text without splitting words

Type: requirement | State: approved | Revision: 69

| Attribute | Value |
| --- | --- |
| CODE | 32 |
| IDENTIFIER | team |
| LABEL | team |
| LABEL_AND_UNIT | "" |
| PRECISION_RULE | not applicable |
| UNIT | "" |

The Team field must display the text validated under [SPEC-308](#spec-308), with its normal header.
It must retain original case and spaces within a rendered line. Empty text leaves the header visible.
Wrapping is greedy at ASCII spaces, without splitting words.
Spaces that separate two automatically wrapped lines are consumed at that boundary.
The app must use native font line spacing and [FR-16460](#fr-16460) for placement.
Physical unit settings do not affect this field. User-entered line-break characters are not accepted by the printable-ASCII property contract.

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-42](#dvs-42), [FR-16460](#fr-16460), [SPEC-246](#spec-246), [SPEC-308](#spec-308), [SPEC-663](#spec-663), [SPEC-664](#spec-664), [SPEC-665](#spec-665)

<a id="spec-249"></a>
## SPEC-249 — Fall back without discarding a valid metric

Type: requirement | State: approved | Revision: 27

For a known field with coverage enabled, the app must use its valid semantic color.
If not, the app must use #CCCCCC in effective Day mode or #333333 in effective Night mode, including inversion.
Invalid, expired, unsupported, or unqualified color sources must not hide independently valid values.
The app must restore semantic coloring on the next valid snapshot.
None coverage and unknown fields keep ordinary backgrounds.

**Relations**

- uses: [APP-45](#app-45), [DVS-51](#dvs-51)

<a id="spec-221"></a>
## SPEC-221 — Apply settings changes without replaying old events

Type: requirement | State: approved | Revision: 22

If the selected trigger or its effective threshold pair changes, the app must clear switching state and select default.
The app must examine threshold modes on the next eligible sample. Event modes wait for the next qualifying callback.
None or an invalid selected pair selects default immediately.
Presentation edits, slot edits, and unused threshold edits keep switching state.

The app must not replay cached events. The app must keep totals, lap baselines, grade history, and rolling samples.
The app must keep saved values for inactive sets and modes. The app must apply presentation changes under [APP-32](#app-32).

**Relations**

- uses: [APP-32](#app-32), [SPEC-211](#spec-211), [SPEC-212](#spec-212)

<a id="spec-219"></a>
## SPEC-219 — Latch the second set from workout start until timer reset

Type: requirement | State: approved | Revision: 22

In Workout started mode, onWorkoutStarted() selects the second set. Repeated notifications keep it selected.
The app must keep this latch within the same observed activity until onTimerReset().
A mode change, app restart, or confirmed activity identity change follows [SPEC-221](#spec-221) and [SPEC-220](#spec-220).
Pause, stop, resume, same-activity start, laps, workout steps, workout completion, and missing sensor data must not clear it.
After late loading or selecting this mode, wait for a new workout-start callback.
The app must not infer an earlier event from samples or workout steps.

The app must use this callback on all ten declared profiles.

**Relations**

- uses: [SPEC-211](#spec-211), [SPEC-220](#spec-220), [SPEC-221](#spec-221)

<a id="spec-217"></a>
## SPEC-217 — Toggle on manual typed lap events exactly once

Type: requirement | State: approved | Revision: 23

On Edge 540, 550, 840, 850, 1040, 1050, and 1060, the app must use onTimerLap2() for typed Manual lap switching.
The app must toggle between default and second only when trigger[:lapTrigger] equals WatchUi.DataField.LAP_TRIGGER_MANUAL.
Other or missing trigger values leave the active set unchanged.
The app must not infer event type from lap count, timing, or workout-step callbacks.
The app must compile this adapter only for profiles exposing the API. Shared lap acquisition still processes each delivered lap once under [FR-16448](#fr-16448), even when the event does not toggle this mode.

**Relations**

- uses: [FR-16448](#fr-16448), [FUNC-9](#func-9), [SPEC-211](#spec-211)

<a id="spec-216"></a>
## SPEC-216 — Return threshold modes to default on unavailable input

Type: requirement | State: approved | Revision: 19

During threshold evaluation, invalid or missing selected input immediately selects default and clears hysteresis state.
The app must not substitute zero or a stale last-good reading.
After recovery, activation must reach its threshold again from the default state.
An unrelated channel dropout must not change the selected trigger.
Pause and resume retention follow [FR-16467](#fr-16467); they must not be treated as an active invalid-input sample.

**Relations**

- uses: [FR-16467](#fr-16467), [SPEC-220](#spec-220)

<a id="func-9"></a>
## FUNC-9 — Confirm a fresh session before using zero lap baselines

Type: requirement | State: approved | Revision: 46

The app must maintain one activity and lap epoch shared by all slots.
The app must identify a fresh session only after an observed completed reset followed by a new timer start.
Alternatively, accept a full pre-activity snapshot followed by a timer start.
The snapshot requires startTime = null, timerState = OFF, and zero timerTime, elapsedTime, and elapsedDistance.
Missing counters are not zero. A call to onTimerStart() alone does not confirm a fresh session.

The app must use zero first-lap baselines only after this confirmation.

**Relations**

- uses: [APP-16](#app-16)

<a id="func-5"></a>
## FUNC-5 — Lap speed

Type: requirement | State: approved | Revision: 60

| Attribute | Value |
| --- | --- |
| CODE | 28 |
| IDENTIFIER | lap_speed |
| LABEL | lap speed |
| LABEL_AND_UNIT | `lap \| {unit}` |
| PRECISION_RULE | magnitude-based |
| UNIT | km/h (metric), mph (statute) |

The app must calculate lap speed as lap distance in metres divided by lap active time in seconds.
The calculation is valid only with known, valid distance and active-time baselines, and lap active time greater than zero.
Zero distance gives zero speed.
The app must not use current speed, activity-average speed, moving-time speed, or a sample mean.
Color source: none.

Normal display range: 0 to 200 in the selected speed unit. Apply [APP-55](#app-55).

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-2](#dvs-2), [DVS-4](#dvs-4), [DVS-40](#dvs-40), [DVS-50](#dvs-50), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-9](#func-9)

<a id="func-4"></a>
## FUNC-4 — Lap time

Type: requirement | State: approved | Revision: 48

| Attribute | Value |
| --- | --- |
| CODE | 27 |
| IDENTIFIER | lap_time |
| LABEL | lap time |
| LABEL_AND_UNIT | "" |
| PRECISION_RULE | 1 second below 1 h; 1 minute from 1 h |
| UNIT | "" |

The app must calculate lap time as timerTime minus the known lap-start active-timer baseline, in milliseconds.
The calculation is valid only with valid, nonnegative counters and a known baseline. Pauses add no active time.
Missing or decreasing counters make lap time unavailable. Format it under [DVS-13](#dvs-13).
Color source: none.

Normal display range: 0:00:00 to 99:59:59 elapsed h:mm:ss. Apply [APP-55](#app-55).

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-13](#dvs-13), [DVS-40](#dvs-40), [FUNC-9](#func-9)

<a id="spec-177"></a>
## SPEC-177 — Reject invalid generated glyph inventories and masks

Type: requirement | State: approved | Revision: 47

The development process must fail generation or build verification for missing, unwanted, or duplicate glyphs, or opaque undeclared pixels.
Also reject invalid or overlapping rectangles, source mask or metric mismatches, and nonreproducible output.
The development process must identify each failing role, size, and code point.
Each outline must equal the base glyph's one-pixel eight-neighbor dilation, with offset -1 pixel and unchanged advance.
The development process must reject any other opaque outline pixels.

**Relations**

- uses: [SPEC-154](#spec-154), [SPEC-176](#spec-176)

<a id="spec-159"></a>
## SPEC-159 — Define and record physical-device qualification

Type: requirement | State: approved | Revision: 19

Before hardware qualification, the development process must review model coverage, test duration, repetitions, and instrumentation method and overhead.
Actual-device procedures must exercise compute and drawing, settings delivery and persistence, themes, sensor loss and recovery, and maximum resources.
They must measure deadlines and application-memory total, used, and free bytes.
Evidence must record environment, build, settings, source, timings, peak used memory, minimum free memory, errors, and outcome.
Foreground, background, and graphics-pool scopes must be identified separately.
Missing hardware or an unreviewed plan remains unverified. Temperature provenance follows [NFR-19](#nfr-19).

**Relations**

- uses: [APP-37](#app-37), [APP-38](#app-38), [APP-48](#app-48), [DVS-34](#dvs-34), [NFR-19](#nfr-19)

<a id="spec-158"></a>
## SPEC-158 — Run the declared-device simulator scenario matrix

Type: requirement | State: approved | Revision: 19

The simulator matrix must identify scenarios for every declared product, with exact settings, fixtures, and assigned bounds.
Requested Core runs cover ordinary layouts, enlargement, alignment, themes, valid and missing values, lifecycle boundaries, settings, and effect boundaries.
Placement scenarios and Memory diagnostics run only when those suites are explicitly requested.
Unrequested or unexecuted required scenarios remain unrun; a partial matrix is not full qualification.

Each missing product, compiler failure, or runtime failure must be reported independently.
Evidence must identify its inputs. Images follow [NFR-18](#nfr-18). Simulator results do not replace hardware qualification.

**Relations**

- uses: [APP-24](#app-24), [APP-38](#app-38), [NFR-18](#nfr-18), [SPEC-157](#spec-157), [SPEC-162](#spec-162)

<a id="app-48"></a>
## APP-48 — Measure runtime memory across the required configurations

Type: requirement | State: approved | Revision: 49

Only explicitly requested Memory validation may enable diagnostic sampling.
It must record application-memory total, used, and free bytes after initialization and resource loading.
Coverage must include maximum grids, themes, effects, rolling buffers, sensor interruptions, settings reloads, and repeated bank switches.
Each profile requires independent observations, including profiles with equal screens, fonts, or ceilings.

The report must identify sampled scopes, resource hashes, maximum used bytes, and minimum free bytes.
API 4+ runs must exercise drawn label, regular, and enlarged outline roles; legacy runs use their three base roles.
Loading a resource alone does not prove its drawing coverage.
Heap sampling must not be reported as graphics-pool measurement or proof that no between-sample peak occurred.
Acceptance and observer rules are [PERF-13](#perf-13) and [PERF-14](#perf-14). Hardware evidence remains separate.

**Relations**

- uses: [APP-37](#app-37), [APP-47](#app-47), [PERF-13](#perf-13), [PERF-14](#perf-14)

<a id="app-47"></a>
## APP-47 — Apply per-device Connect IQ Data Field memory ceilings

Type: requirement | State: approved | Revision: 28

Each declared Data Field profile has an application-memory ceiling of 131072 bytes.
Qualification must satisfy that ceiling and the actual runtime allocation. The ceiling is not measured free heap.
Before API 4.0, loaded font resources share application memory.
On API 4+, graphics resources use a separate pool; heap readings do not measure that pool's usage.
Graphics-resource failures still fail validation under [PERF-13](#perf-13).
Vendor or device-package limit changes require review before a supported profile changes.

**Relations**

- uses: [APP-24](#app-24), [PERF-13](#perf-13)

<a id="app-35"></a>
## APP-35 — Show unavailable activity values without stale readings

Type: requirement | State: approved | Revision: 59

A missing, unsupported, invalid-type, out-of-domain, or non-finite numeric reading displays `--`, with its header retained.
The owning acquisition contract defines the valid domain. A normal display range does not define that domain.
A valid finite value whose complete required group cannot fit displays `!` if that marker and the header fit.
The app must not fabricate zero or retain invalid current readings.

Accumulated values and caches follow their own retention contracts.
Heading may omit its optional cardinal text before using `!` under [DVS-36](#dvs-36).
Native Team text follows [DVS-56](#dvs-56). If a complete grid still cannot fit, [APP-23](#app-23) and [APP-54](#app-54) apply.

**Relations**

- allocated_to: [APP-3](#app-3)
- uses: [APP-23](#app-23), [APP-54](#app-54), [DVS-36](#dvs-36), [DVS-56](#dvs-56)

<a id="app-34"></a>
## APP-34 — Fit cell headers and values within numeric margins without scaling

Type: requirement | State: approved | Revision: 111

The app must measure complete headers and the value group selected under [APP-35](#app-35).
Numeric values must keep four-pixel horizontal margins, plus any required halo clearance.
The header and value must have at least a two-pixel visible gap, including halos.
Required text must not be clipped, truncated, rescaled, or assigned less precision to fit.

An unavailable or overflow marker replaces a value only under [APP-35](#app-35).
Grid selection follows [APP-23](#app-23). Native-text fields use their declared fitting policy.

**Relations**

- allocated_to: [APP-3](#app-3), [APP-4](#app-4)
- uses: [APP-20](#app-20), [APP-21](#app-21), [APP-23](#app-23), [APP-24](#app-24), [APP-35](#app-35), [DVS-3](#dvs-3), [DVS-6](#dvs-6)

<a id="app-32"></a>
## APP-32 — Apply changed settings through one coherent presentation

Type: requirement | State: approved | Revision: 89

After settings change, the app must validate them and prepare one coherent presentation before the next redraw.
It must not restart or reset the activity.
Incremental changes must reuse unaffected descriptors, fits, geometry, and resources while those caches remain available.
An incremental grid-only change replaces separators alone.

A full property reload follows [PERF-7](#perf-7) and may reconstruct released presentation resources.
That exception must preserve acquisition history and saved choices.
The app must not repeat native text measurement during ordinary drawing.

**Relations**

- allocated_to: [APP-2](#app-2)
- uses: [APP-26](#app-26), [APP-41](#app-41), [PERF-7](#perf-7)

<a id="app-31"></a>
## APP-31 — Validate saved settings and use safe display defaults

Type: requirement | State: approved | Revision: 122

The app must validate each property against its owning read contract and bank default.
Missing or malformed input uses that property's fallback without changing storage.
The app must retain valid zero, false, and None values, including hidden, duplicate, reassigned, and inactive options.

The field-selection adapter accepts nonnegative integer codes and nonempty internal field identifiers.
An unrecognized value of either shape displays `--` with the header `field`, without a guessed unit or effect.
A negative code, empty identifier, or other malformed selection uses the slot default.
The Garmin settings UI offers only the integer choices in [SPEC-301](#spec-301).
Invalid configuration must not prevent startup.

**Relations**

- allocated_to: [APP-2](#app-2)
- uses: [SPEC-301](#spec-301)

<a id="dvs-39"></a>
## DVS-39 — Count confirmed completed laps in a fresh observed session

Type: requirement | State: approved | Revision: 137

| Attribute | Value |
| --- | --- |
| CODE | 24 |
| IDENTIFIER | completed_laps |
| LABEL | laps |
| LABEL_AND_UNIT | "" |
| PRECISION | 0 |
| UNIT | "" |

The app must display the exact app-observed completed-lap count, excluding the unfinished lap.
The app must use states UNKNOWN, FRESH_READY, and TRACKING.
A reset or full pre-activity snapshot arms FRESH_READY. The app must start TRACKING at zero only after [FUNC-9](#func-9) confirms a fresh session.
The app must bind available startTime.value(). During TRACKING, the app must increment once per confirmed callback after lap-record writing.

The app must not increment for updates, pause, stop, or button events. Trigger metadata is not a unique history identifier.
Color source: none.
Normal display range: 0 to 999. Apply [APP-55](#app-55).

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-7](#dvs-7), [FUNC-9](#func-9)

<a id="dvs-36"></a>
## DVS-36 — Heading

Type: requirement | State: approved | Revision: 99

| Attribute | Value |
| --- | --- |
| CODE | 22 |
| IDENTIFIER | heading |
| LABEL | heading |
| LABEL_AND_UNIT | `heading \| {unit}` |
| PRECISION | 0 |
| UNIT | ° |

The app must read true-north heading from Activity.Info.currentHeading in radians. The app must not use GPS course.
The app must convert to degrees and normalize to [0,360). The app must round to whole degrees, then map rounded 360 to zero.
The app must use floor((degrees + 22.5)/45) modulo 8 for N, NE, E, SE, S, SW, W, or NW secondary text.
If the full group cannot fit, remove only the direction text and keep the degrees.

Cardinal direction is value information. Unit visibility must not hide it.
Color source: none.
Normal display range: 0 to 359 degrees. Apply [APP-55](#app-55).

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-3](#dvs-3), [DVS-40](#dvs-40), [DVS-50](#dvs-50), [DVS-7](#dvs-7)

<a id="dvs-34"></a>
## DVS-34 — Read native temperature only in the background worker

Type: requirement | State: approved | Revision: 187

| Attribute | Value |
| --- | --- |
| CODE | 20 |
| IDENTIFIER | temperature |
| LABEL | temperature |
| LABEL_AND_UNIT | `temp \| {unit}` |
| PRECISION | 1 |
| UNIT | °c (Celsius) or °f (Fahrenheit) |

The app must read Sensor.getInfo().temperature in Celsius only within ServiceDelegate.onTemporalEvent().
The manifest must declare Background and Sensor permissions. The app must not read sensors in the foreground.
The app must not use weather, phone, or historical readings. Measured zero is valid.
Onboard device temperature does not establish ambient air temperature.
Physical evidence gates release and support claims under [NFR-19](#nfr-19), not runtime acquisition.
Source checks use [FR-16456](#fr-16456). Scheduling, delivery, and cache age use [DVS-54](#dvs-54), [FR-16457](#fr-16457), and [FR-16458](#fr-16458).
The normal display range is defined by [FR-16459](#fr-16459). Coloring uses [DVS-55](#dvs-55).

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-2](#dvs-2), [DVS-4](#dvs-4), [DVS-40](#dvs-40), [DVS-45](#dvs-45), [DVS-50](#dvs-50), [DVS-54](#dvs-54), [DVS-55](#dvs-55), [FR-16456](#fr-16456), [FR-16457](#fr-16457), [FR-16458](#fr-16458), [FR-16459](#fr-16459), [NFR-19](#nfr-19)

<a id="dvs-31"></a>
## DVS-31 — Elapsed time

Type: requirement | State: approved | Revision: 67

| Attribute | Value |
| --- | --- |
| CODE | 17 |
| IDENTIFIER | elapsed_time |
| LABEL | elapsed |
| LABEL_AND_UNIT | "" |
| PRECISION_RULE | 1 second below 1 h; 1 minute from 1 h |
| UNIT | "" |

The app must display Activity.Info.elapsedTime in milliseconds as the elapsed duration, including pauses.
The app must accept nonnegative values. Format the duration under [DVS-13](#dvs-13).
Color source: none.
Normal display range: 0:00:00 to 99:59:59 elapsed h:mm:ss. Apply [APP-55](#app-55).

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-13](#dvs-13), [DVS-40](#dvs-40)

<a id="dvs-30"></a>
## DVS-30 — Activity timer

Type: requirement | State: approved | Revision: 67

| Attribute | Value |
| --- | --- |
| CODE | 16 |
| IDENTIFIER | activity_timer |
| LABEL | timer |
| LABEL_AND_UNIT | "" |
| PRECISION_RULE | 1 second below 1 h; 1 minute from 1 h |
| UNIT | "" |

The app must display Activity.Info.timerTime in milliseconds as the active duration, excluding stopped time.
The app must accept nonnegative values. Format the duration under [DVS-13](#dvs-13).
Color source: none.
Normal display range: 0:00:00 to 99:59:59 elapsed h:mm:ss. Apply [APP-55](#app-55).

**Relations**

- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-13](#dvs-13), [DVS-40](#dvs-40)

<a id="dvs-29"></a>
## DVS-29 — Estimate grade from altitude and distance with FIFO sampling

Type: requirement | State: approved | Revision: 187

| Attribute | Value |
| --- | --- |
| CODE | 15 |
| IDENTIFIER | grade |
| LABEL | slope |
| LABEL_AND_UNIT | `slope \| %` |
| PRECISION | 1 |
| UNIT | % |

The app must estimate grade from running Activity.Info altitude, distance, elapsedTime, timerState, and available startTime.value().
The app must not poll hardware sensors or assume a native grade member.
The app must admit at most one point per elapsed second. The app must ignore duplicate timestamps.
The app must keep at most five distinct-distance points in a first-in, first-out queue.
At unchanged distance, the app must replace only the newest altitude.

The app must keep its admission time, point count, published grade, and average slots unchanged.
At the next admitted distance increase, the app must add one point and calculate once.
Settings, units, and visibility changes keep the history.
Regression uses [DVS-52](#dvs-52), averaging uses [FR-16452](#fr-16452), and invalidation uses [FR-16453](#fr-16453).
The normal display range is defined by [FR-16455](#fr-16455). Coloring and horizon geometry use [DVS-53](#dvs-53) and [FR-16454](#fr-16454).

**Relations**

- allocated_to: [APP-4](#app-4)
- uses: [APP-21](#app-21), [APP-34](#app-34), [APP-35](#app-35), [APP-44](#app-44), [APP-49](#app-49), [DVS-12](#dvs-12), [DVS-2](#dvs-2), [DVS-45](#dvs-45), [DVS-50](#dvs-50), [DVS-52](#dvs-52), [DVS-53](#dvs-53), [FR-16452](#fr-16452), [FR-16453](#fr-16453), [FR-16454](#fr-16454), [FR-16455](#fr-16455)

<a id="dvs-13"></a>
## DVS-13 — Duration values display format

Type: requirement | State: approved | Revision: 73

The app must truncate nonnegative durations to whole seconds.
Below one hour, the app must display two-digit minutes as the primary value and append two-digit seconds as `.SS` in the numeric secondary role.
At one hour or more, the app must display unpadded hours followed by a colon and two-digit minutes. The app must omit the dot and seconds.
Hours must not wrap.

Unit visibility must not change these components. The app must not create seconds for an invalid duration.

| Duration | Primary | Secondary |
| --- | --- | --- |
| 0 seconds | 00 | .00 |
| 65 seconds | 01 | .05 |
| 59:59 | 59 | .59 |
| 1 hour | 1:00 | None |
| 9:59:59 | 9:59 | None |
| 10 hours | 10:00 | None |
| 100 hours | 100:00 | None |

**Relations**

- allocated_to: [APP-4](#app-4)
- uses: [APP-35](#app-35), [DVS-3](#dvs-3)

<a id="dvs-6"></a>
## DVS-6 — Render transparent text and a one-pixel contrast halo

Type: requirement | State: approved | Revision: 117

Text must use transparent glyph masks without rectangular text panels.
Over a colored region, the visible halo is the one-pixel eight-neighbor dilation of the glyph, excluding its foreground ink.
The halo uses the opposite black or white color from the foreground.
An outline resource may include the original glyph ink because the foreground draw covers that ink.

Text and halos must be clipped to their painted region and cell.
Label coverage applies halos to the header only. Whole cell coverage applies them to text over the fill.
The app must use [APP-36](#app-36) for contrast and remove obsolete pixels before repainting.
The profile-specific drawing method is [FR-16445](#fr-16445).

**Relations**

- allocated_to: [APP-4](#app-4)
- uses: [APP-36](#app-36), [FR-16445](#fr-16445)

<a id="app-26"></a>
## APP-26 — Replay prepared drawing with a bounded dirty-layout exception

Type: requirement | State: approved | Revision: 121

Ordinary onUpdate() calls must replay prepared drawing and clipping commands only.
If layout is dirty or a required outline role is missing, onUpdate() may first invoke the layout-preparation path with its current Dc.
This exception permits required fitting, native measurement, geometry preparation, resource loading, and command allocation for the dirty presentation only.
It must finish before drawing. Subsequent unchanged redraws must not repeat that work.

onUpdate() must not acquire sensors, read settings, calculate metric values, or change published value records.
Value formatting and unit conversion remain outside drawing.
The renderer must fill a cell base only when its prepared background differs from the cleared background.

**Relations**

- allocated_to: [APP-3](#app-3)
- uses: [APP-12](#app-12), [APP-7](#app-7), [APP-8](#app-8)

<a id="app-24"></a>
## APP-24 — Target Garmin Edge full-screen design profiles

Type: requirement | State: approved | Revision: 92

The app must use these design bounds, row capacities, and fixed font sizes. The app must not apply percentage scaling.

| Model | Resolution | Height / width, truncated to two decimals | Rows | Enlarged Font Size | Regular Font Size | Label Font Size |
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

The app must use [APP-34](#app-34) to check the assigned drawing bounds.

<a id="app-23"></a>
## APP-23 — Choose grid row capacity from the assigned drawing area

Type: requirement | State: approved | Revision: 42

The app must first try the profile row capacity with the selected enlargement and complete displayed value groups.
If values do not fit, it may retry that capacity with `!` for unfit values under [APP-35](#app-35).
Headers must remain complete.
Only if that capacity still fails may a five-row profile retry four rows, using the same sequence.
A four-row profile must not try five rows.

The app must accept only a complete [APP-20](#app-20) combination.
If no combination fits, it must use [APP-54](#app-54).

**Relations**

- allocated_to: [APP-3](#app-3)
- uses: [APP-20](#app-20), [APP-24](#app-24), [APP-34](#app-34), [APP-35](#app-35), [APP-54](#app-54)

<a id="perf-4"></a>
## PERF-4 — Test Requirement

Type: requirement | State: obsolete | Revision: 2

Test description

<a id="tfnc-6"></a>
## TFNC-6 — Unit conversion and complete duration formatting

Type: test | State: draft | Revision: 24

Purpose: Unit conversion and clock/duration formats.

Requirement references: [DVS-13](#dvs-13), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [SPEC-157](#spec-157).

Procedure and expected results: Check 10m/s -> 36km/h, 1609.344m -> 1mi and 0C -> 32F. Use the exact boundary cases in [DVS-13](#dvs-13) through 100h, including omission of seconds from exactly 1h for timer, elapsed time and lap time. Verify separate timer/elapsed paths, invalid times and both clock modes with the [DVS-32](#dvs-32) header indicator. Retain [DVS-42](#dvs-42) zone classification checks.

Executable source to update/verify: `tests/CoreTests.mc`, `unitsAndExplicitFormatPolicy`.

Evidence follows [SPEC-162](#spec-162). This definition asserts no execution; historical results retain their captured scope.


**Relations**

- verifies: [DVS-13](#dvs-13), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [SPEC-157](#spec-157)

<a id="tui-9"></a>
## TUI-9 — Complete clock and duration groups fit native cells

Type: test | State: draft | Revision: 10

Purpose: Complete clock and duration groups fit native cells.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [APP-24](#app-24), [DVS-13](#dvs-13), [DVS-32](#dvs-32), [APP-34](#app-34).

Procedure and expected results: Require complete 00:00 and 13:05 clocks, 59 with secondary .59 below one hour, and 1:00 without secondary seconds from one hour at fixed fonts in every native enlargement count and alignment, including required secondary seconds and one-pixel halos. No overflow or compact substitution.

Executable source: `tests/PresentationTests.mc`; named test `clockAndDurationFitEveryLayout`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [APP-24](#app-24), [APP-34](#app-34), [DVS-13](#dvs-13), [DVS-32](#dvs-32), [NFR-1](#nfr-1)

<a id="spec-170"></a>
## SPEC-170 — Verify the complete declared-device simulator scenario matrix

Type: test | State: draft | Revision: 34

Execute the recorded matrix for all ten products and check coverage against scenario IDs. Verify compact fallback has no overlap, all cells stay within assigned bounds, settings leave no obsolete effect pixels and every supported effect has explicit assertions. Inspect product-specific images/logs and record simulator provenance; report unrun scenarios separately. This is a planned verification case; no passing execution is asserted.

Explicitly verify [APP-23](#app-23) capacity selection, [APP-26](#app-26) cached drawing, [DVS-12](#dvs-12) headers, [APP-21](#app-21) alignment and [HFER-7](#hfer-7)/[HFER-8](#hfer-8) exact separator geometry/grayscale; cover [SPEC-248](#spec-248) independently averaged zone effects and [APP-37](#app-37) callback ordering/deadlines.


**Relations**

- verifies: [APP-21](#app-21), [APP-23](#app-23), [APP-26](#app-26), [APP-37](#app-37), [DVS-12](#dvs-12), [HFER-7](#hfer-7), [HFER-8](#hfer-8), [NFR-18](#nfr-18), [SPEC-158](#spec-158), [SPEC-248](#spec-248)

<a id="tprf-9"></a>
## TPRF-9 — Normal Data Field runtime memory validation

Type: test | State: draft | Revision: 40

Purpose: Normal Data Field runtime memory validation. Suite: Memory; explicit request only.

References: [APP-47](#app-47), [APP-48](#app-48), [APP-37](#app-37), [APP-38](#app-38), [SPEC-162](#spec-162), [SPEC-231](#spec-231), [SPEC-296](#spec-296).

After isolated font probes, run scripts/validate-memory.ps1 for each requested profile with identical production sources/resources and current hashes. Run separately:
1. Native/default observer: real production callbacks, no synthetic fixtures, RuntimeMetrics disabled; at least 10 computes, three draws and 30 seconds.
2. Matrix: three cycles of 216 cases; at least 54 complete native grids, three font roles and all 33 fields in fitting roles, including maximum Team text, effects/themes/inversion, missing values, settings/lifecycle and bounded acquisition history. Cache header eligibility; substitute a compatible field only for unsupported regular headers and report substitutions. Unsupported placements remain in Placement.
3. Switching: all [SPEC-231](#spec-231) transitions, settings changes and repeated-state checkpoints.

Use native full-bounds Dc directly. Retain at most the app's two configuration banks, one acquisition and one active presentation; recreate reference settings between cycles rather than retaining a third bank. Release outgoing raw/presentation state before replacements and synthetic presentation before native producer callbacks. Supply known validated synthetic zone bounds without cloning presentation records; this does not qualify sensor provenance.

Sampling retains fixed counters without I/O or formatting. Defer diagnostics until fixture locals are released. Record initialization/first-draw values and peak/free/total for each run; identify native observer and driver overhead without subtracting estimates to obtain a pass. Run host regressions for sampler I/O, incomplete/duplicate/crashed records and absolute limit violations.

Require all three current-source normal Data Field reports, no allocation/stack failure, unchanged runtime/published limits and no sustained growth over repeated returns to the same configuration. Partial diagnosis runs cannot qualify a profile. Preserve failed attempts, environment, source/binary hashes and exact coverage. Observer overhead is included; default observation and sparse sampling do not establish uninstrumented/maximal/transient peaks. Missing physical evidence stays unrun/blocked.

The maximal API 4+ matrix must reach six loaded base/outline resources and draw label, regular, and enlarged outline roles. Require max_fonts=6 and outline_roles=7. Legacy profiles require max_fonts=3 and outline_roles=0. The switching observer may use a smaller role set. Reject old or incomplete matrix records without these metrics. Heap observations do not measure the API 4+ graphics pool. No execution is created by this definition update.

**Relations**

- verifies: [APP-37](#app-37), [APP-38](#app-38), [APP-47](#app-47), [APP-48](#app-48), [FR-16445](#fr-16445), [NFR-17](#nfr-17), [PERF-11](#perf-11), [PERF-13](#perf-13), [PERF-14](#perf-14)

<a id="tprf-6"></a>
## TPRF-6 — Optional battery clock and diagnostic work

Type: test | State: draft | Revision: 16

Purpose: Optional queries and temperature-cache freshness.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [APP-26](#app-26), [APP-37](#app-37), [DVS-35](#dvs-35), [DVS-34](#dvs-34).

Procedure and expected results: Require battery/clock selection flags to include hidden assignments, no battery reading on the disabled adapter path, and disabled production RuntimeMetrics counters through real activity callbacks. Core does not collect runtime memory samples.

Executable source: `tests/PerformanceTests.mc`; named test `optionalRuntimeQueries`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

Regression: Through real StrukturField activity processing and app temperature-cache dispatch, keep temperature absent from the active bank. Require a nonempty cache age check each sample, expiry after 360 seconds and clock-rollback rejection while unassigned; switching to a temperature bank must not revive the invalid reading. A valid zero remains valid. Empty caches perform no age/clock queries. Restore the test app cache after the fixture; do not modify production settings.

**Relations**

- verifies: [APP-26](#app-26), [APP-37](#app-37), [APP-51](#app-51), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [FR-16446](#fr-16446), [PERF-12](#perf-12), [PERF-9](#perf-9)

<a id="tui-1"></a>
## TUI-1 — Production drawing alignment and palettes

Type: test | State: draft | Revision: 111

Suite: Core. Executable: tests/PresentationTests.mc, normalPresentationDrawAndAlignment. Execution evidence is separate.
Run the production normal-layout scenarios across all native enlargement counts, both alignments and Day/Night. Assert complete headers/values, centered value bounds, shared header reservation, cell clipping and no overflow/compact substitution in guaranteed contexts.
Check the catalogue-wide minimum safe header-band formula against all header variants and retain one cached height through assignment, unit, theme and inversion changes. Check full-width regular/enlarged Label fills, ordinary value regions, semantic/neutral colors, white-temperature contrast, glyph halos and clean transitions between None/Label/Whole cell. Slope Whole cell retains its clipped ground and ordinary sky. Verify numeric families use their own valid color sources; invalid sources recover through neutral coverage without losing independent values.
Exercise both banks and independent duplicate/hidden slots. Include Team's fixed header, wrapped user value and native-font fit scenarios. Coverage changes preserve geometry and unchanged fits as asserted by the executable.
Exact grid-selector patterns, exhaustive normal-range endpoints, clock/duration capacity and complete callback/cache-query instrumentation are covered by their dedicated Test definitions. This test does not claim those named cases from its own PASS result. No Memory/Placement or physical qualification is implied.

Separate build prerequisite: tools/test_settings_layout.py verifies [SPEC-210](#spec-210)/[SPEC-669](#spec-669) with all current properties exactly once and in catalogue order directly on the main settings page; reject nested/empty groups, missing or duplicate controls and changed order. Report this host check separately from the named drawing test. Mobile Save/reopen persistence still requires phone verification; a simulator drawing PASS is not evidence of the phone's Save UI.

For [FR-16445](#fr-16445) and [PERF-11](#perf-11), distinguish three base font roles from API 4+ outline companions. Verify the final outline-plus-foreground image matches legacy shifted rendering. API 4+ ignores stored halo=false; API 3 honors it without moving text. Unknown unpainted slots must not request outlines. Resource counters here verify selection only, without runtime memory sampling.

**Relations**

- verifies: [APP-21](#app-21), [APP-24](#app-24), [APP-26](#app-26), [APP-32](#app-32), [APP-34](#app-34), [APP-36](#app-36), [APP-49](#app-49), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-12](#dvs-12), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-29](#dvs-29), [DVS-30](#dvs-30), [DVS-31](#dvs-31), [DVS-32](#dvs-32), [DVS-33](#dvs-33), [DVS-34](#dvs-34), [DVS-35](#dvs-35), [DVS-36](#dvs-36), [DVS-37](#dvs-37), [DVS-39](#dvs-39), [DVS-47](#dvs-47), [DVS-51](#dvs-51), [DVS-6](#dvs-6), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [FR-16445](#fr-16445), [FR-16454](#fr-16454), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [HFE-1](#hfe-1), [HFE-2](#hfe-2), [PERF-11](#perf-11), [SPEC-157](#spec-157), [SPEC-249](#spec-249), [SPEC-253](#spec-253)

<a id="tfnc-15"></a>
## TFNC-15 — Temperature delivery delay and clock guards

Type: test | State: draft | Revision: 27

Purpose: Temperature delivery delay and clock guards.

Requirement references: [DVS-34](#dvs-34).

Procedure and expected results: Include delivery delay in cache age. Check 359s/360s read-age boundaries, monotonic advancement, UTC rollback/forward jumps, monotonic wrap/rollback and rejection of non-owned worker delivery. Invalidated values remain unavailable.

Executable source: `tests/AcquisitionTests.mc`; fixture `temperatureClockAndDelivery`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [DVS-34](#dvs-34), [FR-16458](#fr-16458), [PERF-10](#perf-10)

<a id="tprf-4"></a>
## TPRF-4 — Bounded snapshot caches and live-input invalidation

Type: test | State: draft | Revision: 21

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

- verifies: [APP-26](#app-26), [APP-50](#app-50), [DVS-32](#dvs-32), [DVS-4](#dvs-4), [DVS-50](#dvs-50), [PERF-6](#perf-6), [PERF-8](#perf-8), [SPEC-667](#spec-667)

<a id="tprf-5"></a>
## TPRF-5 — Changed-cell fitting and prepared-only rendering

Type: test | State: draft | Revision: 41

Purpose: Verify [APP-26](#app-26) changed-cell preparation and draw-only replay. Suite: Core.

Unchanged immutable visible records, including raw changes with equal displayed text, require zero record-field comparisons, geometry scans, refits and packet rebuilds. One changed value refits one cell. Equal-angle slope polygons survive unrelated changes. Theme, effects, layout and settings changes refresh affected presentation; hidden slots beyond preferred capacity do not scan geometry or refit visible cells.

Lock preparation, fitting, measurement and color-selection methods during ordinary drawing. Verify production callbacks replay prepared commands; packed separator decoding permitted by [APP-26](#app-26) preserves exact endpoints/colors. After clear, ordinary cells perform zero base fills. Inverted or whole-cell backgrounds still fill when different; label bands, horizons and text retain the same rendered result.

Bank replacements release outgoing fits/packets/headers before successors, preserving retained records and acquisition. Repeated spans share bounded separator tables.

Executable: tests/PerformanceTests.mc, rendererCacheAndDrawPurity. Supporting horizon vertices are checked by logicalGridCases. Record executions separately under [SPEC-162](#spec-162); no Memory, Placement or hardware qualification is implied.

Assert active geometry/separator caches contain at most one selected plan. An unchanged-geometry switch reuses that plan; geometry replacement releases the previous plan before constructing a new one. Verify ordinary draw purity, fallback recovery and cache invalidation remain correct.
Exercise full settings reload with three cached font roles: outgoing handles/packets/obsolete geometry are released before property loading, metric tables and acquisition history survive, and the rebuilt view uses the same three base roles and, on API 4+ profiles, only the required outline companions. It must draw correctly. Verify ordinary bank-switch reuse remains intact.

Custom source/threshold edits must invalidate affected prepared colors before next display; retain draw-only and changed-cell constraints. See [TSTFUNC-11](#tstfunc-11).

Distinguish ordinary prepared-command replay from the dirty-layout exception in [APP-26](#app-26). After a dirty layout, repeated unchanged onUpdate() calls must not refit, measure, reload fonts, or rebuild geometry. Full property reloads may reconstruct released caches under [PERF-7](#perf-7); incremental grid-only updates must retain unaffected fits.

**Relations**

- verifies: [APP-12](#app-12), [APP-26](#app-26), [APP-32](#app-32), [APP-50](#app-50), [APP-52](#app-52), [DVS-29](#dvs-29), [PERF-6](#perf-6), [PERF-7](#perf-7), [SPEC-667](#spec-667)

<a id="spec-299"></a>
## SPEC-299 — Verify Team preparation invalidation

Type: test | State: draft | Revision: 13

Suite: Core. Definition; execution evidence is separate.

Instrument fitting, capability discovery, compute and drawing with unchanged inputs and shared text/font/source edits and isolated slot bounds/theme/coverage edits. Assert only required work runs, no font search/geometry calculation occurs in ordinary drawing, and duplicates add no samples. Shared text/font/source changes update every affected Team presentation; earlier snapshots retain their old content.

**Relations**

- verifies: [APP-26](#app-26), [DVS-57](#dvs-57), [FR-16461](#fr-16461), [PERF-5](#perf-5)

<a id="spec-174"></a>
## SPEC-174 — Verify: define development milestones and traceable release evidence

Type: test | State: draft | Revision: 6

Review the milestone exit criteria and the traceability map. Verify every original approved requirement has a named verification method before release; missing implementation or evidence is explicit. Confirm new linked environment tests are not counted as covering all product behavior and that build-only or draft-only states cannot satisfy the release gate. This is a planned verification case; no passing execution is asserted.

Review execution evidence under [NFR-20](#nfr-20) by runner kind. Named Monkey C results and suite summaries apply to Monkey C execution; host, visual and hardware checks use their own results and observations. Require captured revisions and explicit unrun/blocked scope. Execution relations must point to Tests only, with no direct requirement-execution relations.

**Relations**

- verifies: [NFR-20](#nfr-20), [SPEC-162](#spec-162)

<a id="spec-171"></a>
## SPEC-171 — Verify: provide physical-device and memory-performance qualification procedures

Type: test | State: draft | Revision: 17

Review the selected hardware/firmware coverage and executable procedure, then run it with declared durations/repetitions. Compare measured allocation/timing with [APP-37](#app-37), [APP-47](#app-47) and [APP-48](#app-48) criteria and distinguish simulator observations. Inspect per-model temperature provenance and age tests; insufficient or absent evidence prevents the affected support claim. This is a planned verification case; no passing execution is asserted.

Explicitly evaluate the [APP-47](#app-47) published ceiling and [APP-48](#app-48) runtime allocation separately for each measured device; retain missing device records as blocked, never extrapolate a pass.


Simulator-only runtime Memory procedure is specified separately in [TPRF-9](#tprf-9). Preserve its failed attempts and fixture corrections; missing physical evidence remains blocked.

**Relations**

- verifies: [APP-47](#app-47), [APP-48](#app-48), [NFR-19](#nfr-19), [SPEC-159](#spec-159)

<a id="spec-169"></a>
## SPEC-169 — Verify: run deterministic Monkey C tests for formatting, settings and sample processing

Type: test | State: draft | Revision: 30

Purpose: Production-policy mutation and test-driver guards.

Requirement references: [SPEC-157](#spec-157), [APP-24](#app-24), [APP-25](#app-25), [APP-21](#app-21), [DVS-50](#dvs-50), [SPEC-155](#spec-155), [DVS-42](#dvs-42), [DVS-45](#dvs-45).

Procedure and expected results: Run recorded fixtures against production routines. An intentionally incorrect conversion/band boundary must fail; restore it afterward. Zero tests, exceptions and skipped required cases must prevent passing. Cover fixed three-role fonts at the current profile table, vertical inset, Right default with saved Center preserved, the typed property catalogue under [SPEC-155](#spec-155) and header rules. Retain zone normalization/upper-inclusive rounded classification and exact RGB palette checks. Record summary/raw output only after updating fixtures to the current contracts.

Executable source to update/verify: Monkey C production test suite and its driver.

Evidence follows [SPEC-162](#spec-162). This definition asserts no execution; historical results retain their captured scope.

Verify the Core default and disjoint Core/Memory/Placement compiler inventories. Every declared guaranteed case is required; explicitly unsupported contexts are reported and assigned to request-only Placement, not hidden as skipped Core requirements. A Core run must contain no memory probe or deliberate compact-message scenario.

Verify [NFR-15](#nfr-15), [NFR-16](#nfr-16) and [NFR-17](#nfr-17) separately: Core may test pure formatting/marker decisions but must not launch deliberate reduced-area rendering or allocation probes. Build-time glyph, compilation and property-budget checks do not count as runtime Memory qualification. Report absent suite coverage as unrun.

**Relations**

- verifies: [DVS-2](#dvs-2), [DVS-42](#dvs-42), [DVS-45](#dvs-45), [DVS-7](#dvs-7), [NFR-15](#nfr-15), [NFR-16](#nfr-16), [NFR-17](#nfr-17), [SPEC-157](#spec-157)

<a id="spec-168"></a>
## SPEC-168 — Verify: specify each displayed value acquisition path and deterministic sensor fixtures

Type: test | State: draft | Revision: 51

Verify every one of the 33 selectable identifiers has one explicit acquisition/normalization contract under [SPEC-156](#spec-156). Cover current/activity-average speed, cadence, heart rate and power; distance, elevation, ascent/descent, grade, timers, local time, calories, battery, heading, waypoint distance, zones, completed laps and the six current-lap fields. Check each Label text, Unit text, producer API/units, validity/ranges and conversion/rounding against the production adapter; do not substitute whole-activity values for lap values.

Replay zero, negative where valid, null/non-finite, absent members, sensor interruption/recovery, unit changes, activity reset and clock/timer boundaries. Verify current readings become unavailable while explicitly accumulated/cache values obey their own retention rules. Inspect all complete exact headers and the distinct unavailable/overflow markers. Unavailable navigation or zone metadata must not become fabricated zeros. Use [TFNC-21](#tfnc-21) for lap lifecycle/weighted fixtures and [TFNC-10](#tfnc-10)..[TFNC-19](#tfnc-19) for existing derived acquisitions. Physical source/callback evidence remains separate under [SPEC-171](#spec-171). Record actual results under [SPEC-162](#spec-162).

Core fixtures requestedFieldPrecision and normalRangeFormatting verify magnitude-based precision for current/average/lap speed, activity/lap/waypoint distance after unit conversion; slope always has one decimal; temperature keeps one decimal, elevation stays integral, and other field-specific precision rules remain in force. normalRangeCellBounds covers the declared per-layout intervals under [APP-34](#app-34); formatting correctness outside them does not imply fit. Preserve canonical two-decimal regression grade/effect calculations under [DVS-29](#dvs-29) and existing acquisition validity/lifecycle rules.

Team has settings-sourced literal text and no numeric/sensor acquisition under [SPEC-253](#spec-253); its optional color source is tested independently under [SPEC-253](#spec-253).

**Relations**

- verifies: [APP-34](#app-34), [DVS-10](#dvs-10), [DVS-11](#dvs-11), [DVS-18](#dvs-18), [DVS-19](#dvs-19), [DVS-20](#dvs-20), [DVS-21](#dvs-21), [DVS-22](#dvs-22), [DVS-23](#dvs-23), [DVS-24](#dvs-24), [DVS-25](#dvs-25), [DVS-26](#dvs-26), [DVS-27](#dvs-27), [DVS-28](#dvs-28), [DVS-33](#dvs-33), [DVS-35](#dvs-35), [DVS-37](#dvs-37), [DVS-40](#dvs-40), [DVS-8](#dvs-8), [DVS-9](#dvs-9), [NFR-14](#nfr-14), [SPEC-156](#spec-156)

<a id="spec-165"></a>
## SPEC-165 — Verify: provide repeatable CLI build, simulator-test and package commands

Type: test | State: draft | Revision: 11

Build from two different checkout paths, including one with spaces, using the same toolchain and declared inputs. Record equivalent product/resource selection; bit-for-bit signed output is not required unless established. Verify debug/test/release separation, missing-key and invalid-product failure, simulator timeout/crash/zero-test failure, and absence of secrets in tracked files/logs. Verify release-key identity metadata without exposing key material. This is a planned verification case; no passing execution is asserted.

Verify the package overlay under [NFR-12](#nfr-12) and signed-gate checks under [NFR-13](#nfr-13): unchanged installed metadata, exact declared model/part overrides, evidence kind and anchors, rejected missing/duplicate/unknown inputs, and all exported regional gates. Verify -O 3z in app/test/preview/package invocations under [NFR-10](#nfr-10). Check process ownership through [TSTFUNC-5](#tstfunc-5). Record each check with its own runner evidence; host checks do not need fabricated Monkey C PASS blocks.

**Relations**

- verifies: [NFR-10](#nfr-10), [NFR-12](#nfr-12), [NFR-13](#nfr-13), [NFR-7](#nfr-7), [NFR-8](#nfr-8), [NFR-9](#nfr-9), [SPEC-153](#spec-153)

<a id="tstfunc-5"></a>
## TSTFUNC-5 — SDK runner process ownership and cleanup

Type: test | State: draft | Revision: 7

Suite: Core (host prerequisite). Run scripts/test-sdk-runner.ps1. Exercise successful exit, nonzero exit, timeout and controller disposal with an active child; include a child surviving its immediate parent. Require bounded cleanup of every owned descendant, unchanged completed exit codes, readable preserved stdout/stderr with released file handles, and survival of an unrelated sentinel process. No simulator or physical qualification is claimed.

**Relations**

- verifies: [NFR-11](#nfr-11), [SPEC-153](#spec-153), [SPEC-160](#spec-160)

<a id="tint-1"></a>
## TINT-1 — Compile the production Data Field for each declared profile

Type: test | State: draft | Revision: 32

Purpose: Compile the production Data Field for each declared profile.

Requirement references: [SPEC-152](#spec-152), [SPEC-153](#spec-153).

Procedure and expected results: Run build.ps1 -Mode all with the declared toolchain and external signing key. For each of the ten profiles require compiler exit 0, a nonempty PRG, a recorded SHA256 matching the file and matching current source-input hashes. Normal application compilation only; no tests or memory measurements are invoked by this case.

Executable source: `scripts/build.ps1`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.
Run tools/test_compile_package.py in Core: verify all six declared 30.18/API 6.0.0 modern targets, unchanged input, languages and undeclared products/regions; reject upstream drift, missing/duplicate parts, invalid floors, unknown evidence kinds and missing inference anchors. Export a candidate package; tools/verify_package_compatibility.py must verify all regional gates against policy and installed definitions, plus unchanged installed hashes. Core simulator execution does not qualify historical firmware on hardware.

**Relations**

- verifies: [NFR-10](#nfr-10), [SPEC-152](#spec-152), [SPEC-153](#spec-153)

<a id="spec-164"></a>
## SPEC-164 — Verify: version the Data Field project and per-device API capability matrix

Type: test | State: draft | Revision: 14

Inspect the manifest and build inputs; compile all ten candidates as Data Fields and compare product coverage with the matrix. Exercise unavailable newer APIs on an older candidate and verify the approved neutral/theme fallback. Fail on unsupported product/API references, unexplained permissions or an unreported missing candidate. This is a planned verification case; no passing execution is asserted.

**Relations**

- verifies: [NFR-6](#nfr-6), [NFR-7](#nfr-7), [SPEC-152](#spec-152)

<a id="spec-163"></a>
## SPEC-163 — Verify: record and verify a reproducible Connect IQ development toolchain

Type: test | State: draft | Revision: 9

On a clean checkout on the documented host, follow only the guide, verify tool versions and resolve all ten product packages. Exercise missing Java, mismatched SDK and missing device-package cases; each must fail with a useful diagnostic. Compare optional IDE and CLI resolved SDK paths. Record versions and command output; this case is planned, not executed. This is a planned verification case; no passing execution is asserted.

**Relations**

- verifies: [NFR-5](#nfr-5), [SPEC-151](#spec-151)

<a id="spec-179"></a>
## SPEC-179 — Verify font rejection, regeneration and declared-profile compatibility

Type: test | State: draft | Revision: 7

Run the normal font validator on valid generated assets. In isolated fixture copies remove the f glyph while retaining the ft unit, add an unused numeric-role letter with a font record/image, and add opaque pixels outside all glyph rectangles. Each must be rejected for the intended defect, not fail merely because a cached hash differs. Also reject duplicate IDs, bad bounds/overlap and altered retained glyph metrics/masks. Regenerate twice from the same recorded source fonts and presentation inventory and compare all output hashes. Make a controlled presentation-text change in a fixture and verify its traced inventory changes and affected fonts require regeneration. Compile regenerated resources for every declared profile under [APP-24](#app-24). Runtime font-loading probes require an explicit Memory request under [NFR-17](#nfr-17). Save exact SDK/tool versions, revisions, fixture definitions and per-product outcomes. Source/atlas byte counts, SDK unit-runtime font-load samples and actual Data Field/physical-device memory results must be labelled separately; missing visual/hardware evidence is unrun, not a pass.

**Relations**

- verifies: [NFR-3](#nfr-3), [NFR-4](#nfr-4), [SPEC-177](#spec-177)

<a id="spec-226"></a>
## SPEC-226 — Core: verify second-set settings, defaults

Type: test | State: draft | Revision: 37

Core definition; not executed here. Verify every bank-scoped property and its corresponding a/b counterpart, plus each global trigger/threshold/HR/power/cadence/Team text/color-source property, against the owning option requirements. Derive and compare current property count from the catalogue, without legacy/hidden keys, without a second hardcoded inventory. Compare exact 33 choice codes, default assignments/enlargement/modes, selector captions, the required flat main-page order and automatic native font fitting. Read current settings without migration or runtime writes.

Retain existing activation/threshold contracts under [SPEC-211](#spec-211)/[SPEC-212](#spec-212): Manual lap factory selection, first-set startup, first/second qualifying lap toggles, explicit None preservation, typed filtering and legacy Auto Lap restriction. Cover every threshold type/range, return>activation safe behavior and unused-invalid-pair isolation; adding presentation options must not change switching. No runtime Memory/Placement probes belong here.

**Relations**

- verifies: [APP-31](#app-31), [HFE-2](#hfe-2), [NFR-2](#nfr-2), [SPEC-155](#spec-155), [SPEC-208](#spec-208), [SPEC-210](#spec-210), [SPEC-211](#spec-211), [SPEC-212](#spec-212), [SPEC-243](#spec-243)

<a id="tstfunc-4"></a>
## TSTFUNC-4 — Core: compact properties, defaults and field applicability

Type: test | State: draft | Revision: 36

Suite: Core. Compare all current catalogue property keys/types/defaults/limits against generated XML and their individual requirements. Require unique lowercase keys <=8 characters, one shared Team option set and no hidden/legacy/schema properties. Verify complete numeric field mapping, both presets, editable captions and read-only per-bank fallbacks. Validate each property contract and its applicable shared-behavior relations; derive field applicability from the catalogue. Run typedSettingsAndHiddenSlots, secondSetSettings, presentationSettingsAndUnits and nativeSettingsCallbacks; restore native saved values. Before compilation, serialize defaults and maximum valid values with the installed Garmin SDK and require both <=8000 bytes. Record exact byte counts, current source and product. Do not infer Memory, Placement or hardware results.

Extend the catalogue by the twelve custom-zone properties in [SPEC-300](#spec-300) (within the current generated total); the native save/reload/restart and SDK serialized-size cases are defined in [TSTFUNC-10](#tstfunc-10).

**Relations**

- verifies: [FR-16431](#fr-16431), [FR-16432](#fr-16432), [FR-16433](#fr-16433), [FR-16434](#fr-16434), [FR-16435](#fr-16435), [FR-16436](#fr-16436), [FR-16437](#fr-16437), [FR-16438](#fr-16438), [FR-16439](#fr-16439), [FR-16440](#fr-16440), [FR-16441](#fr-16441), [FR-16442](#fr-16442), [HFE-3](#hfe-3), [SPEC-243](#spec-243), [SPEC-244](#spec-244), [SPEC-245](#spec-245), [SPEC-301](#spec-301), [SPEC-302](#spec-302), [SPEC-303](#spec-303), [SPEC-304](#spec-304), [SPEC-305](#spec-305), [SPEC-306](#spec-306), [SPEC-307](#spec-307), [SPEC-308](#spec-308), [SPEC-310](#spec-310), [SPEC-311](#spec-311), [SPEC-312](#spec-312), [SPEC-313](#spec-313), [SPEC-314](#spec-314), [SPEC-315](#spec-315), [SPEC-316](#spec-316), [SPEC-317](#spec-317), [SPEC-318](#spec-318), [SPEC-319](#spec-319), [SPEC-320](#spec-320), [SPEC-321](#spec-321), [SPEC-322](#spec-322), [SPEC-323](#spec-323), [SPEC-324](#spec-324), [SPEC-325](#spec-325), [SPEC-326](#spec-326), [SPEC-327](#spec-327), [SPEC-328](#spec-328), [SPEC-329](#spec-329), [SPEC-330](#spec-330), [SPEC-331](#spec-331), [SPEC-332](#spec-332), [SPEC-333](#spec-333), [SPEC-334](#spec-334), [SPEC-335](#spec-335), [SPEC-336](#spec-336), [SPEC-337](#spec-337), [SPEC-338](#spec-338), [SPEC-339](#spec-339), [SPEC-340](#spec-340), [SPEC-341](#spec-341), [SPEC-342](#spec-342), [SPEC-343](#spec-343), [SPEC-344](#spec-344), [SPEC-345](#spec-345), [SPEC-346](#spec-346), [SPEC-347](#spec-347), [SPEC-348](#spec-348), [SPEC-349](#spec-349), [SPEC-350](#spec-350), [SPEC-351](#spec-351), [SPEC-352](#spec-352), [SPEC-353](#spec-353), [SPEC-354](#spec-354), [SPEC-355](#spec-355), [SPEC-356](#spec-356), [SPEC-357](#spec-357), [SPEC-358](#spec-358), [SPEC-359](#spec-359), [SPEC-360](#spec-360), [SPEC-361](#spec-361), [SPEC-362](#spec-362), [SPEC-363](#spec-363), [SPEC-364](#spec-364), [SPEC-365](#spec-365), [SPEC-669](#spec-669), [SPEC-670](#spec-670)

<a id="tstfunc-10"></a>
## TSTFUNC-10 — Core: custom zone properties and settings persistence

Type: test | State: draft | Revision: 10

Suite: Core. Definition for implementation; no execution result.

Compare twelve new keys/types/defaults/captions/ranges with property owners and generated catalogue; require the complete current catalogue with unique properties, no schema or migration keys. Verify Training zones order, named power limits, units, open-final prompts and Team-before-slots. Save nondefault switches/limits through native settings callback, reload and app restart; test false/zero preservation and zero runtime writes. Serialize complete defaults and maximum allowed dictionary with Garmin SDK; both must be <=8000 bytes. Do not substitute XML byte length.

**Relations**

- verifies: [FR-16431](#fr-16431), [FR-16432](#fr-16432), [FR-16433](#fr-16433), [FR-16434](#fr-16434), [FR-16435](#fr-16435), [FR-16436](#fr-16436), [FR-16437](#fr-16437), [FR-16438](#fr-16438), [FR-16439](#fr-16439), [FR-16440](#fr-16440), [FR-16441](#fr-16441), [FR-16442](#fr-16442), [FR-16462](#fr-16462), [FR-16469](#fr-16469), [SPEC-155](#spec-155), [SPEC-245](#spec-245), [SPEC-668](#spec-668), [SPEC-669](#spec-669)

<a id="spec-229"></a>
## SPEC-229 — Core: verify workout-start latch and timer-reset return

Type: test | State: draft | Revision: 10

Verification definition; implementation and execution evidence are recorded separately. For Workout started mode, initialize default; onWorkoutStarted -> second; repeated workout-start -> second. While second, pause/stop/resume, timer start in the same activity, manual/automatic laps, workout-step completion, workout completion and sensor loss shall all retain second. onTimerReset -> default and repeated reset stays default; next activity remains default until a new workout-start event. Loading late or selecting this mode after an earlier start shall not replay it. Events in other modes do not activate Workout started. Verify onWorkoutStarted and onTimerReset symbols on all ten profiles; production callback entry points must share fixture-tested behavior. Physical workout/callback delivery is blocked until model/firmware evidence exists. This is Core, without Memory/Placement execution.

**Relations**

- verifies: [FR-16468](#fr-16468), [SPEC-211](#spec-211), [SPEC-219](#spec-219), [SPEC-220](#spec-220)

<a id="spec-230"></a>
## SPEC-230 — Core: verify switching lifecycle, atomic frames and shared acquisition

Type: test | State: draft | Revision: 19

Verification definition; implementation and execution evidence are recorded separately. Use distinct first/second fields, enlarged count, alignment, theme, unit preference, effects and grid so mixed frames are observable. Verify startup/reset, pause retention, resume with an incomplete power window (first unavailable running sample returns default), post-reset finalizing laps ignored until rearmed, known activity-identity change, fresh-sample resume, page hide/show, late load, mode/selected-threshold edits, unused threshold edits and presentation-only edits. Validate the expected bank at every event and next frame. A switch publishes one bank consistently and never changes activity counters or rolling/grade/current-lap state. For N delivered samples with duplicate fields across both banks, assert N acquisition advances and one lap reset per delivered boundary. Trace clock/battery queries for active-set demand and correct values on activation; no trigger-only timer or draw-time acquisition. Inspect initialized/cached descriptors and ordinary draw replay using bounded fixture counters, not a runtime heap qualification. Include maximum supported normal layouts of each bank and prove no inherited first-set styles. This is Core; separate Memory and insufficient-area tests remain excluded.

**Relations**

- verifies: [APP-26](#app-26), [APP-33](#app-33), [FR-16463](#fr-16463), [FR-16467](#fr-16467), [FR-16468](#fr-16468), [SPEC-208](#spec-208), [SPEC-220](#spec-220), [SPEC-221](#spec-221)

<a id="spec-228"></a>
## SPEC-228 — Core: verify manual-lap adapters and exactly-once boundaries

Type: test | State: draft | Revision: 17

Verification definition; implementation and execution evidence are recorded separately. Compile/inspect adapters for all ten SDK profiles. For modern profiles, inject manual,manual,manual -> second,default,second. Inject every non-manual enum plus absent/unknown metadata: bank unchanged, shared lap-boundary processing still once, handler returns true and legacy fallback is not invoked. In None/power/HR/workout modes, a lap still updates lap metrics once without acting as a manual toggle. Legacy fixtures deliver three callbacks -> second,default,second; verify the exact Auto Lap-off prompt and guide restriction on other automatic lap sources. Legacy cannot prove manual origin: do not report filtering support. Confirm no reset twice through modern/legacy dispatch and no changes from workout-step-only events. Actual physical callback origin/order and Auto Lap setup are a separate per-model/firmware integration check; mark those portions blocked if hardware evidence is unavailable. Core fixtures alone do not qualify physical delivery.
After native layout, exercise onTimerLap2 itself with mixed Team/metric banks, 0/1/2 enlarged fields, both alignments and all coverage modes. Repeated manual toggles must prepare drawable headers/values without stack overflow; do not substitute onLapNotification for the typed entry point.

**Relations**

- verifies: [APP-26](#app-26), [FR-16448](#fr-16448), [FR-16466](#fr-16466), [SPEC-217](#spec-217), [SPEC-218](#spec-218)

<a id="spec-284"></a>
## SPEC-284 — Verify native power-zone mapping

Type: test | State: draft | Revision: 20

Suite: Core. Requirements: [DVS-42](#dvs-42), [SPEC-246](#spec-246).

For zones 1..5 assert the specified colors; zone 6 uses magenta #FF00FF and zones 7 and 10 use dark magenta #AA00AA while numeric zones remain unchanged. Cover every power metric, power-zone and Power-bound Team, both themes/inversion and Label/Whole cell; None suppresses fill. Unknown metadata and invalid/out-of-range readings use neutral fallback. Include production metadata loading, invalid-profile clearing and valid-profile recovery through approvedZoneSnapshot in tests/AcquisitionTests.mc.

Synthetic fixtures do not confirm the native device layout. Execution evidence is separate.

**Relations**

- verifies: [DVS-42](#dvs-42), [FR-16465](#fr-16465), [SPEC-246](#spec-246), [SPEC-663](#spec-663)

<a id="tfnc-24"></a>
## TFNC-24 — Validated zone metadata and snapshot classification

Type: test | State: draft | Revision: 29

Suite: Core. Requirements: [DVS-42](#dvs-42), [DVS-45](#dvs-45), [SPEC-248](#spec-248).

Run approvedZoneSnapshot in tests/AcquisitionTests.mc, including verifyNativePowerZoneMetadata through production metadata() with only the native read substituted. Accept strictly increasing bounds starting at 0 W; reject null, nonzero first bounds and duplicate bounds. Check displayed-value rounding, upper-inclusive equality, zone 6/magenta and out-of-range unavailability. Reload invalid metadata after a valid profile: clear stale zones and colors while retaining valid watts; recover on the next valid reload. Compute must not reread native metadata; retained snapshots remain unchanged.

Synthetic inputs verify the adapter contract, not the device array layout. Record actual product, source, toolchain and named results under [SPEC-162](#spec-162); this definition records no execution.

Custom modes additionally verify [TSTFUNC-6](#tstfunc-6), [TSTFUNC-7](#tstfunc-7) and [TSTFUNC-8](#tstfunc-8); device-mode metadata qualification remains unchanged.

**Relations**

- verifies: [DVS-42](#dvs-42), [DVS-45](#dvs-45), [FR-16465](#fr-16465), [SPEC-248](#spec-248), [SPEC-661](#spec-661), [SPEC-662](#spec-662), [SPEC-663](#spec-663), [SPEC-664](#spec-664)

<a id="tstfunc-11"></a>
## TSTFUNC-11 — Core: zone preparation and activity isolation

Type: test | State: draft | Revision: 6

Suite: Core. Definition for implementation; no execution result.

Instrument init, settings reload, compute and drawing. Count one shared validation per changed family at preparation, no property parsing/profile validation/device-zone query in ordinary compute/draw, and no device lookup for custom-selected families. Reload source/limits while both banks contain duplicate, hidden and enlarged consumers; require next display updated and no stale cached zone/color/packet. Compare metric snapshots, rolling samples, lap history, active bank and trigger thresholds before/after: unchanged. Custom profiles share identity across consumers.

**Relations**

- verifies: [APP-26](#app-26), [FR-16464](#fr-16464), [SPEC-665](#spec-665), [SPEC-667](#spec-667), [SPEC-668](#spec-668)

<a id="tstfunc-3"></a>
## TSTFUNC-3 — Native properties persistence and settings callback

Type: test | State: draft | Revision: 13

Suite: Core. Run native Properties writes under a separate test application identity; never change production preferences. Write numeric selections, alignment/grid and shared Team text/color source through Application.Properties, then call the app onSettingsChanged after initial layout. Verify duplicate Team values, settings in both banks, unchanged active-bank latch and reload through FieldSetsSettings.load. Restore original test-app properties. Separately save in the simulator editor and restart the normal app; verify retained values, callback application and no serialization error. Report editor/restart evidence separately from in-process tests. Executable: nativeSettingsCallbacks in tests/FieldSetTests.mc.
Regression: start with a numeric first slot, expire the layout Dc, save Team in slots 1/2 and call onSettingsChanged. Require zero native width reads during the settings callback, pending fitting, and Team text on the next redraw with a fresh scoped Dc. Expire it again; unchanged refreshes must not measure. Switch banks and edit shared text with the Dc expired; the next valid redraw must show the new text, with no retained Dc after return.

**Relations**

- verifies: [APP-32](#app-32), [FR-16462](#fr-16462), [SPEC-253](#spec-253)

<a id="spec-298"></a>
## SPEC-298 — Verify automatic Team fitting preserves settings

Type: test | State: draft | Revision: 10

Suite: Core. Verify automatic font fitting never rewrites shared Team text, source or slot assignments/coverage. Empty text retains its header, unchanged values reuse fitted runs, and text edits refit during a current layout callback. Missing-candidate and deliberate no-fit cases remain in Placement and require an explicit request.

**Relations**

- verifies: [FR-16461](#fr-16461), [SPEC-253](#spec-253)

<a id="spec-291"></a>
## SPEC-291 — Verify Team native text bounds

Type: test | State: draft | Revision: 17

Suite: Core. On all ten profiles verify fitting native Team lines below the shared header in regular/enlarged slots, both sets and alignments. Check five-percent value-area padding, one-pixel clearance, per-line alignment and vertically centered block. Markers do not count as normal-fit evidence.

**Relations**

- verifies: [APP-21](#app-21), [APP-34](#app-34), [FR-16460](#fr-16460), [SPEC-253](#spec-253)

<a id="tui-11"></a>
## TUI-11 — Guaranteed normal values stay inside native cell borders

Type: test | State: draft | Revision: 12

Purpose: Guaranteed normal values stay inside native cell borders.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [APP-24](#app-24), [APP-34](#app-34), [DVS-6](#dvs-6), [DVS-12](#dvs-12), [SPEC-157](#spec-157).

Procedure and expected results: Use real font metrics across every declared normal context, role and alignment. Require complete header/value/secondary glyph and halo bounds; no trimming, overflow sign or compact substitution. Count explicitly unsupported contexts separately.

Executable source: `tests/NormalRangeTests.mc`; named test `normalRangeCellBounds`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [APP-24](#app-24), [APP-34](#app-34), [APP-55](#app-55), [DVS-12](#dvs-12), [DVS-6](#dvs-6), [FR-16455](#fr-16455), [FR-16459](#fr-16459), [SPEC-157](#spec-157)

<a id="tfnc-14"></a>
## TFNC-14 — Temperature packet, cache-age and display precision boundaries

Type: test | State: draft | Revision: 30

Purpose: Temperature packet and cache-age boundaries.

Requirement references: [DVS-34](#dvs-34).

Procedure and expected results: Exercise owned protocol-2 four-element edge-native-v2 packets. Reject protocol-1/onboard-v1 packets from earlier builds. Valid 0C survives age 360s but expires at 361s. Reject old/duplicate/future timestamps, wrong protocol/path/type; newer invalid reads clear the cache. Through SnapshotEngine, also verify exactly one fractional digit in Celsius and Fahrenheit, trailing zeros, positive and negative half rounding, negative-zero suppression, null/unavailable values, and color bands selected from unrounded Celsius. Cover normal-range temperature endpoints and interior values via normalRangeFormatting and normalRangeCellBounds. Synthetic packets do not certify physical source provenance.

Executable source: `tests/AcquisitionTests.mc`; fixture `temperatureProtocolAndAge`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


Under [FR-16457](#fr-16457), a compatible newer null/non-finite/expired worker reading must clear an older valid value and advance the timestamp watermark. Malformed, future and duplicate packets must not replace the accepted cache or advance that watermark. Source identity comes from the owned callback, not merely its marker string.

**Relations**

- verifies: [DVS-34](#dvs-34), [FR-16457](#fr-16457)

<a id="tfnc-16"></a>
## TFNC-16 — Legal temperature scheduling and runtime source guards

Type: test | State: draft | Revision: 29

Purpose: Legal temperature scheduling and runtime source guards.

Requirement references: [DVS-34](#dvs-34), [APP-38](#app-38).

Procedure and expected results: Assert earliest legal temporal times with no prior event, a prior event and 300s spacing. Check that an empty native registry and explicitly ONBOARD temperature metadata pass the source-registration guard; reject null/missing/malformed metadata, ANT/BLE and unknown technology, non-Number enum types (including Float 2.0), wrong sensor types and more than 32 entries, regardless of connection state. Inspect TemperatureSource.read to verify registry checks before and after Sensor.getInfo; use fixtures to verify that foreground rejects non-owned or incompatible delivery. Preserve clock/cache and invalid-value cases. Physical qualification remains separate; these fixtures do not certify real-device provenance or actual event delivery.

Executable source: `tests/AcquisitionTests.mc`; fixture `temporalAndSourceQualification`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [APP-38](#app-38), [DVS-34](#dvs-34), [DVS-54](#dvs-54), [FR-16456](#fr-16456)

<a id="tfnc-4"></a>
## TFNC-4 — Grade and temperature effect boundaries

Type: test | State: draft | Revision: 25

Purpose: Grade and temperature effect boundaries.

Requirement references: [DVS-29](#dvs-29), [DVS-34](#dvs-34).

Procedure and expected results: Assert the literal grade/temperature boundary arrays and expected band names in exactEffectBands, including fractional boundaries, negative values and null. Check horizon clamping to +/-45 degrees. Verify [DVS-42](#dvs-42) upper-inclusive boundaries using displayed whole-number values, invalid/outside metadata, and [DVS-45](#dvs-45) exact RGB mapping. Update the production-policy fixtures before execution; historical helper-only runs do not cover this addition.

Executable source: `tests/CoreTests.mc`; fixture `exactEffectBands`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [DVS-29](#dvs-29), [DVS-34](#dvs-34), [DVS-53](#dvs-53), [DVS-55](#dvs-55), [FR-16454](#fr-16454)

<a id="tfnc-11"></a>
## TFNC-11 — Grade continuity and bounded sample history

Type: test | State: draft | Revision: 32

Purpose: Verify [DVS-29](#dvs-29) continuity and bounded history. Suite: Core.

Duplicate time does not refresh inactivity. Repeated distance updates altitude but not distance-progress time; at 3000 ms without progress, grade stays unavailable until movement resumes. Replacement does not evict a point from a full five-distinct-distance FIFO. Permit a 2000 ms gap; reset for 2001 ms, counter/identity regression, invalid input and non-running state. Reset regression and zero-initialized average together. Recovery with three new linear 10% points publishes 0,0,2%. Pause/reset and duplicate slots/settings/draws must not reuse stale history or advance windows.

Executable: tests/AcquisitionTests.mc, gradeResetAndBounds and gradeDistinctDistance. This is a definition, not a memory measurement or execution.

**Relations**

- verifies: [DVS-29](#dvs-29), [FR-16453](#fr-16453)

<a id="tfnc-10"></a>
## TFNC-10 — Grade regression, distinct distances and startup averaging

Type: test | State: draft | Revision: 38

Purpose: Verify [DVS-29](#dvs-29) regression and startup averaging. Suite: Core.

Require linear +/-10% ramps 0,0,+/-2,+/-4,+/-6,+/-8,+/-10; retain signed, large-value, rounding and degenerate-denominator checks. At unchanged distance keep only the latest altitude, without changing point count, FIFO, admission time, published grade or average cursor. A replacement must not block movement in that second. Duplicate timestamps remain ignored.

With relative altitudes -105.4,0,0,-0.2,-0.2 at distances 0,0,0,1.68,4.56 and one-second delivery, require 0,0,0,0,-0.78%; continued fixed altitude gives -0.94,-1.08,-1.08,-1.08,-0.30,-0.14,0. Original timestamp gaps follow the reset contract. Do not clamp or invent sensor data.

Executable: tests/AcquisitionTests.mc, gradeRegression, gradeDistinctDistance and gradeRepeatedDistanceStartup. Definitions are separate from execution evidence.

**Relations**

- verifies: [DVS-2](#dvs-2), [DVS-29](#dvs-29), [DVS-36](#dvs-36), [DVS-52](#dvs-52), [FR-16452](#fr-16452)

<a id="tfnc-18"></a>
## TFNC-18 — Data Field callbacks preserve lap continuity

Type: test | State: draft | Revision: 25

Purpose: Data Field callbacks preserve lap continuity.

Requirement references: [APP-32](#app-32), [DVS-39](#dvs-39), [FUNC-9](#func-9).

Procedure and expected results: Invoke production callbacks around a known two-lap session. Pause/stop/resume/start, hide/show and settings reload preserve the count. Reset and old callbacks do not leak; a newly attached field stays unknown. Direct callbacks are fixtures, not physical FIT delivery evidence.

Executable source: `tests/AcquisitionTests.mc`; fixture `datafieldCallbackIsolation`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [APP-32](#app-32), [DVS-39](#dvs-39), [DVS-58](#dvs-58), [FR-16451](#fr-16451), [FUNC-9](#func-9)

<a id="tfnc-13"></a>
## TFNC-13 — Lap identity, regression and overflow invalidation

Type: test | State: draft | Revision: 24

Purpose: Lap identity, regression and overflow invalidation.

Requirement references: [DVS-39](#dvs-39), [FUNC-9](#func-9).

Procedure and expected results: Reject incomplete or ambiguous zero-baseline snapshots. Invalidate on changed identity, each timer/elapsed/distance regression, confirmed continuity loss and counter overflow; never wrap or fabricate a total.

Executable source: `tests/AcquisitionTests.mc`; fixture `lapIdentityAndOverflow`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [DVS-39](#dvs-39), [FR-16449](#fr-16449), [FR-16451](#fr-16451), [FUNC-9](#func-9)

<a id="tfnc-26"></a>
## TFNC-26 — Late loading and gaps do not invent lap history

Type: test | State: draft | Revision: 17

Purpose: Late loading and gaps do not invent lap history.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [FUNC-9](#func-9), [FUNC-10](#func-10), [DVS-39](#dvs-39).

Procedure and expected results: After late attachment wait for a confirmed boundary; reject unknown/regressing baselines. Missing intervals and stopped periods must not contribute to averages or recover an unobserved boundary.

Executable source: `tests/AcquisitionTests.mc`; named test `currentLapLateAttachAndGaps`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [DVS-39](#dvs-39), [DVS-59](#dvs-59), [FR-16447](#fr-16447), [FR-16449](#fr-16449), [FR-16450](#fr-16450), [FUNC-10](#func-10), [FUNC-9](#func-9)

<a id="tfnc-25"></a>
## TFNC-25 — Current-lap distance time and weighted averages

Type: test | State: draft | Revision: 14

Purpose: Current-lap distance time and weighted averages.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [FUNC-9](#func-9), [FUNC-10](#func-10).

Procedure and expected results: Use known boundaries/counters to verify lap distance, active duration, distance/time speed and time-weighted HR/power/cadence. Include measured zero, valid endpoints and pause behavior.

Executable source: `tests/AcquisitionTests.mc`; named test `currentLapAcquisition`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [DVS-58](#dvs-58), [FR-16450](#fr-16450), [FUNC-10](#func-10), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [FUNC-9](#func-9)

<a id="tcom-1"></a>
## TCOM-1 — Exact glyph inventories and reproducible font resources

Type: test | State: draft | Revision: 12

Purpose: Exact glyph inventories and reproducible font resources.

Requirement references: [SPEC-176](#spec-176), [SPEC-177](#spec-177).

Procedure and expected results: Run the complete font validator and two isolated deterministic regenerations. For every current manifest variant require exact derived numeric/label character sets, transparent padding, valid rectangles, original glyph masks/metrics, verified source fonts and identical generated resource hashes. A pass covers atlas/role correctness and regeneration; it does not measure loaded memory or certify physical readability.

Executable source: `tools/validate_fonts.py`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [FR-16445](#fr-16445), [SPEC-176](#spec-176), [SPEC-177](#spec-177)

<a id="tfnc-12"></a>
## TFNC-12 — Known-zero lap baseline and pause/reset lifecycle

Type: test | State: draft | Revision: 23

Purpose: Known-zero lap baseline and pause/reset lifecycle.

Requirement references: [DVS-39](#dvs-39), [FUNC-9](#func-9).

Procedure and expected results: Late attachment remains unknown despite start/lap callbacks. A proven fresh snapshot/reset sequence establishes zero; confirmed notifications increment once. Pause/stop/start preserve the count; old/end-session notifications cannot leak into a new session.

Executable source: `tests/AcquisitionTests.mc`; fixture `lapBaselineLifecycle`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [DVS-39](#dvs-39), [DVS-59](#dvs-59), [FUNC-9](#func-9)

<a id="spec-293"></a>
## SPEC-293 — Verify Team source binding and fallback

Type: test | State: draft | Revision: 16

Suite: Core. Definition; execution evidence is separate.

Hide all numeric power/HR fields, bind Team to each source, vary zones and verify shared classifications. Test None, zero watts, invalid HR/profile, recovery and all coverage modes while text stays unchanged.

For qualified Power binding zone 6 assert magenta #FF00FF with black text; zones >=7 use dark magenta #AA00AA with white text over the fill under [SPEC-246](#spec-246). Label coverage retains ordinary value text. Retain Team string and selected coverage. HR and cadence retain five-zone classification.

**Relations**

- verifies: [DVS-57](#dvs-57), [SPEC-253](#spec-253), [SPEC-665](#spec-665)

<a id="spec-297"></a>
## SPEC-297 — Verify automatic Team font eligibility

Type: test | State: draft | Revision: 13

Suite: Core. Verify the fixed native FONT_XTINY/TINY/SMALL/MEDIUM/LARGE candidate set and largest complete-block fit with the existing tie rule. The settings and properties expose no Team font selector or font code. Verify shared text survives settings refresh and bank switches; report actual native drawing separately from deterministic wrapping metrics.

**Relations**

- verifies: [APP-38](#app-38), [DVS-56](#dvs-56), [SPEC-176](#spec-176), [SPEC-177](#spec-177), [SPEC-253](#spec-253)

<a id="spec-292"></a>
## SPEC-292 — Verify native Team font selection

Type: test | State: draft | Revision: 14

Suite: Core. Verify greedy space-only wrapping with repeated spaces, one-line and multiline values. Assert words remain whole and within-line spaces survive. Using deterministic metrics and native drawing, verify the largest complete-block fit and tie rule, fixed native candidate eligibility and unchanged fit cache on source/color-only changes. No-fit cases belong to Placement.

Select the largest complete fit among supported positive-height candidates under [DVS-56](#dvs-56). FONT_XTINY is not a separate veto when another candidate fits. Deliberate no-candidate and marker-fallback cases remain Placement-only.

**Relations**

- verifies: [APP-25](#app-25), [DVS-56](#dvs-56), [SPEC-253](#spec-253)

<a id="tui-7"></a>
## TUI-7 — Effect foreground contrast and exact glyph widths

Type: test | State: draft | Revision: 15

Purpose: Effect foreground contrast and exact glyph widths.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [DVS-6](#dvs-6), [APP-36](#app-36), [DVS-29](#dvs-29), [APP-26](#app-26).

Procedure and expected results: Verify Day/Night grade and colored-label foregrounds/ordinary value backgrounds. Compare cached widths with real SDK font measurement, including contour clearance.

Executable source: `tests/PresentationTests.mc`; named test `approvedForegroundAndMetricWidths`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [APP-26](#app-26), [APP-36](#app-36), [DVS-29](#dvs-29), [DVS-53](#dvs-53), [DVS-6](#dvs-6)

<a id="tui-10"></a>
## TUI-10 — Exact formatting throughout declared normal intervals

Type: test | State: draft | Revision: 9

Purpose: Exact formatting throughout declared normal intervals.

Suite: Core. Default fast regression after app changes; no Memory or Placement work.

Requirement references: [APP-34](#app-34), [DVS-2](#dvs-2), [DVS-3](#dvs-3), [SPEC-157](#spec-157).

Procedure and expected results: For every field normal interval check endpoints, interior samples, rounding and width transitions in each declared unit/clock mode against exact primary and mandatory secondary text.

Executable source: `tests/NormalRangeTests.mc`; named test `normalRangeFormatting`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [APP-34](#app-34), [APP-55](#app-55), [DVS-2](#dvs-2), [DVS-3](#dvs-3), [SPEC-157](#spec-157)

<a id="tui-13"></a>
## TUI-13 — Unsupported and reduced-area presentation matrix

Type: test | State: draft | Revision: 11

Purpose: Unsupported and reduced-area presentation matrix.

Suite: Placement. Explicit user request only; never launched by Core or a build.

Requirement references: [APP-20](#app-20), [APP-21](#app-21), [APP-34](#app-34), [APP-36](#app-36), [DVS-6](#dvs-6), [DVS-51](#dvs-51).

Procedure and expected results: Run the production drawing matrix including unsupported combinations, both alignments, themes, inversion and enlargement counts. Require correct clipping, separators, backgrounds, contours and full compact caption when it fits; never count fallback as a normal-value guarantee.

Executable source: `tests/PlacementTests.mc`; named test `presentationDrawAndAlignment`.

Evidence follows [SPEC-162](#spec-162): record actual selected suite, baseline/source/toolchain/product and named results. This is a definition, not a new execution or a qualification claim. Historical evidence retains its captured scope.

**Relations**

- verifies: [APP-20](#app-20), [APP-21](#app-21), [APP-34](#app-34), [APP-36](#app-36), [APP-54](#app-54), [DVS-51](#dvs-51), [DVS-6](#dvs-6)

<a id="spec-232"></a>
## SPEC-232 — Placement: verify compact fallback independently for both field sets

Type: test | State: draft | Revision: 18

Verification definition; implementation and execution evidence are recorded separately. Run only when Placement is explicitly requested. On all ten profiles, give one bank a fitting supported layout and the other an intentionally insufficient assigned area/header combination, then switch both ways. Verify the existing exact compact fallback in the failing bank and recovery to the preferred fitting capacity in the other, with no pinned fallback, mixed set or silent partial grid. Repeat for enlarged layout, both alignments, unit-header visibility and each grid type; evaluate resource/glyph bounds and expected overflow markers only in deliberately unsupported contexts. Preserve active trigger state during repeated layout notifications. Record assigned bounds, both configurations and observed messages. These deliberate compact-message cases shall not enter the default Core inventory.

**Relations**

- verifies: [APP-33](#app-33), [APP-54](#app-54), [SPEC-208](#spec-208)

<a id="tstfunc-2"></a>
## TSTFUNC-2 — Mixed Team and metric layouts through typed lap callbacks

Type: test | State: draft | Revision: 11

Suite: Core. After native font measurement and initial layout, call production onTimerLap2 with manual metadata on supported profiles, and onTimerLap on legacy profiles. Switch mixed Team/metric banks four times per 0/1/2-enlarged layout and None/Label/Whole cell coverage, alternating alignments. Keep slot 1 Team and slot 2 numeric in both banks, including the two-visible-slot layout. Assert active bank, shared Team text, native text draw commands and numeric draw commands. When slot 3 is visible, make it a duplicate Team and assert the same shared text. Never index a hidden slot. No stack/serialization errors or compact fallback. Executable: mixedTeamLapCallbacks in tests/FieldSetTests.mc.
Expire the drawing context after each layout/update. Deliver lap callbacks while it is expired; require no width access until a fresh drawing callback and no retained Dc afterward.

**Relations**

- verifies: [APP-26](#app-26), [APP-53](#app-53), [SPEC-217](#spec-217), [SPEC-218](#spec-218), [SPEC-253](#spec-253)

<a id="spec-231"></a>
## SPEC-231 — Memory: verify bounded allocation while switching both field sets

Type: test | State: draft | Revision: 21

Verification definition; implementation and execution evidence are recorded separately. Run only when Memory is explicitly requested. For all ten actual Data Field simulator runtimes, measure initialize/peak/retained heap under [APP-48](#app-48) limits with distinct maximum-complexity sets, both trigger sources, lap/workout events and repeated mode/configuration changes. Include 1000 compute-driven bank transitions and 200 alternating settings changes; sample after warm-up, at 500 and 1000 transitions, and after settings cycles. Assert every measured heap remains within its profile ceiling, font resources stay shared, and retained object/cache counts remain within the declared two banks/one acquisition/one active presentation rather than growing with switch count. Report source fingerprint, SDK/profile, exact sequence, measurements, limits and any failure. Compare repeated steady-state cycles to distinguish retained growth from transient peak. Simulator evidence is not physical qualification; mark unavailable hardware portions blocked.

Execute the switching driver (`validation/memory/MemorySwitching.mc`) separately from the 648-case layout/resource driver (`validation/memory/MemoryValidation.mc`), each in the normal bounded Data Field runtime with the same production sources and resources. Both runs must pass; retain separate source/binary hashes, logs and measurements and aggregate the worst measured usage. This prevents unrelated qualification drivers from occupying the measured heap together; it does not change the app limit, font sizes or required scenarios.

Dispatch bounded batches of transitions/settings changes across native drawing callbacks so harness batching does not trigger the watchdog. Preserve all 1000 transitions, 200 changes and repeated-state checkpoints; require completion within the declared runner timeout.

**Relations**

- verifies: [APP-26](#app-26), [APP-52](#app-52)

<a id="tfnc-17"></a>
## TFNC-17 — Shared acquisition integration and duplicate slots

Type: test | State: draft | Revision: 32

Purpose: Shared acquisition integration and duplicate slots.

Requirement references: [DVS-29](#dvs-29), [DVS-34](#dvs-34), [DVS-39](#dvs-39), [DVS-36](#dvs-36), [FUNC-9](#func-9).

Procedure and expected results: Replay fresh-session activity -> zero-initialized average ramp (0,0,2,4,6,8,10%) -> confirmed 10% grade -> confirmed lap; duplicate grade/lap/temperature slots share one value. Check metric/statute temperature formatting with effects based on raw Celsius, cache expiry, paused grade with preserved laps, and cardinal suffix only when measured width fits.

Executable source: `tests/AcquisitionTests.mc`; fixture `acquisitionToSnapshot`.

Evidence follows [SPEC-162](#spec-162); this focused definition is not a full product qualification. Historical executions retain their original scope.


**Relations**

- verifies: [APP-51](#app-51), [DVS-29](#dvs-29), [DVS-34](#dvs-34), [DVS-36](#dvs-36), [DVS-39](#dvs-39), [FUNC-9](#func-9)

<a id="tfnc-5"></a>
## TFNC-5 — Typed settings defaults and hidden-slot preservation

Type: test | State: draft | Revision: 24

Suite: Core. Verify default Right alignment, both exact ten-slot presets, per-bank enlargement and coverage defaults, and matching XML/read fallbacks. Exercise valid zero/false/None, duplicate and hidden assignments, malformed values and unknown field codes. Use compact keys only; require no migration writes or compatibility declarations. Executable: typedSettingsAndHiddenSlots in tests/CoreTests.mc, with secondSetSettings and nativeSettingsCallbacks for both-bank/native reload coverage. Requirement references: [APP-20](#app-20), [APP-30](#app-30), [APP-31](#app-31), [APP-49](#app-49), [SPEC-155](#spec-155). Evidence follows [SPEC-162](#spec-162); historical executions retain their original scope.

Through SettingsStore.read with a missing-property fixture, verify that absent cadence keys select individual factory defaults. A present malformed cadence value must invalidate the cadence profile without rewriting input. Keep explicit zero and false distinguishable from missing keys.

**Relations**

- verifies: [APP-20](#app-20), [APP-30](#app-30), [APP-31](#app-31), [APP-49](#app-49), [SPEC-155](#spec-155)

<a id="spec-167"></a>
## SPEC-167 — Verify: publish one typed settings catalogue shared by XML, runtime and tests

Type: test | State: draft | Revision: 30

Core definition; not executed here. Compare generated catalogue, property/settings XML and runtime validation under [SPEC-155](#spec-155): exact current property count, 33 append-only choices, stable codes, both presets, all mode/Team/cadence keys and compact keys. Verify defaults and saved/missing/malformed values independently, hidden/duplicate slots, all six layouts and the required flat main-page settings order.

Check live changes preserve active recording and unrelated settings. Exercise explicit None/zero/false, source-binding independence and read-only loading through the linked new Tests. Core contains no Memory or deliberate insufficient-area probes. Record current source/product/requirement revisions only when executed.

**Relations**

- verifies: [APP-46](#app-46), [SPEC-155](#spec-155)

<a id="spec-277"></a>
## SPEC-277 — Verify read-only compact property loading

Type: test | State: draft | Revision: 13

Suite: Core. In typedSettingsAndHiddenSlots, verify the complete current set of unique keys <=8 characters, complete read-only loading, no undeclared keys, zero/false/None preservation, per-bank invalid-mode fallbacks and no writes. Verify generated XML/default/caption parity and property contracts and applicable shared-behavior relations. Build guard serializes defaults and maximum valid values with the Garmin SDK and requires each <=8000 bytes. No legacy migration or schema marker is required.

**Relations**

- verifies: [SPEC-244](#spec-244)

<a id="spec-150"></a>
## SPEC-150 — Development and Verification

Type: document | State: draft | Revision: 90

This document covers toolchain setup, generated inputs, build and test commands, qualification, and evidence gates.
Linked requirements define individual development obligations. Field definitions remain in [DVS-1](#dvs-1).

Technical vocabulary:
- A bank is one saved field configuration.
- A slot is one ordered field assignment.
- A snapshot is one prepared display state.
- An epoch is one continuously tracked activity or lap interval.
- A glyph is one drawable character mask. A halo is its one-pixel contrast outline.
- A profile defines a device target or a training-zone boundary set, as identified by its qualifier.
- A fixture is a fixed test input. An artifact is a recorded build or test output.
- A callback is a function invoked by the Garmin runtime.
- A cache holds reusable data or resources. The heap and graphics pool are separate allocation domains where the API specifies them.
API names, mathematical notation, property keys, and literal UI text keep their specified spelling.
Software operations such as compile, serialize, validate, classify, and generate are technical verbs for the corresponding computer processes.

<a id="spec-207"></a>
## SPEC-207 — Triggered Field Sets

Type: document | State: draft | Revision: 73

This document covers two saved configurations and their activation and return rules.
Linked requirements define individual switching behaviors. The two configurations reuse the shared field and presentation definitions.

<a id="spec-233"></a>
## SPEC-233 — Shared Coloring and Settings Compatibility

Type: document | State: draft | Revision: 114

This document covers background coverage, training-zone colors, cadence thresholds, and current-schema settings compatibility.
Field-specific behavior belongs to the field catalogue. Settings migration is outside this document scope.

<a id="app-1"></a>
## APP-1 — Application Design

Type: document | State: draft | Revision: 123

This document covers shared layout, presentation options, runtime lifecycle, and resource limits.
Selectable field behavior belongs to [DVS-1](#dvs-1). Each linked requirement owns one feature.

<a id="spec-175"></a>
## SPEC-175 — Bundled Glyph Inventory

Type: document | State: draft | Revision: 27

This document covers reachable glyph inventories, reproducible generation, and separate validation checks.
Native-text qualification and runtime-memory qualification remain separate.

<a id="spec-660"></a>
## SPEC-660 — Custom Training Zones

Type: document | State: draft | Revision: 19

This document covers global custom heart rate and power zone selection.
Individual properties belong to [SPEC-300](#spec-300). Selectable fields belong to [DVS-1](#dvs-1). Shared colors belong to [SPEC-246](#spec-246).

<a id="dvs-1"></a>
## DVS-1 — Selectable Fields and Shared Display Rules

Type: document | State: draft | Revision: 196

This document covers selectable fields and their shared display rules.
Each field owns its source, validity, presentation parameters, and normal range. Independent acquisition and rendering features use separate requirements.
CODE, IDENTIFIER, LABEL, UNIT, and LABEL_AND_UNIT store field identity and header parameters.
PRECISION defines fixed decimal precision. PRECISION_RULE defines conditional or non-decimal formats.

An empty UNIT means no physical unit. An empty LABEL_AND_UNIT selects the shared header fallback.
Shared rules apply through explicit relations.

<a id="spec-300"></a>
## SPEC-300 — Application Properties

Type: document | State: draft | Revision: 110

This document covers the current compact settings schema.
Each property requirement owns one key, type, range, default, and option behavior. Shared behavior uses linked requirements.
The a bank is the default set. The b bank is the second set.

The catalogue supplies property counts. The schema has no compatibility aliases or migration.
Field definitions belong only to [DVS-1](#dvs-1).

<a id="spec-276"></a>
## SPEC-276 — Verify current coverage settings without legacy declarations

Type: test | State: approved | Revision: 17

Suite: Core. Verify all twenty compact aN_bg/bN_bg controls expose integer 0 None, 1 Label and 2 Whole cell. Match the per-slot XML defaults and independent read fallbacks. Exercise every explicit mode, missing/null/Boolean/fractional/negative/unknown values, hidden slots and reassignment. Require no legacy switches, sentinel or schema marker. Execute typedSettingsAndHiddenSlots and secondSetSettings; preserve unrelated values without runtime writes.

**Relations**

- verifies: [APP-31](#app-31), [SPEC-155](#spec-155), [SPEC-243](#spec-243)

<a id="spec-272"></a>
## SPEC-272 — Verify enlarged semantic label fill

Type: test | State: approved | Revision: 14

Suite: Core. Executable regression: tests/PresentationTests.mc, normalPresentationDrawAndAlignment with EnlargedLabelScenario. Execution evidence is recorded separately.

Use qualified HR/power fixtures and temperature bands with one/two enlarged slots in each set. Assert full-width/full-band fill and ordinary value pixels in both alignments/themes and inverted enlarged palettes.

**Relations**

- verifies: [APP-49](#app-49), [DVS-12](#dvs-12)

<a id="spec-268"></a>
## SPEC-268 — Verify background coverage regions

Type: test | State: approved | Revision: 17

Suite: Core. Definition; execution evidence is separate.

For None/Label/Whole cell, compare production fill commands and pixels in regular/enlarged cells, both sets/themes/alignments. Assert unchanged alignment anchors and clipping at cell borders; any required clearance refit is confined to the affected cell. Exercise the Team and slope exceptions.

**Relations**

- verifies: [APP-49](#app-49), [DVS-29](#dvs-29), [DVS-34](#dvs-34)

<a id="spec-267"></a>
## SPEC-267 — Verify background mode choices

Type: test | State: approved | Revision: 13

Suite: Core. Definition; execution evidence is separate.

Check all 20 keys, exact captions/codes/types and both bank presets. Edit duplicate and hidden slots independently; reload and verify their modes. No Boolean switch remains visible.

**Relations**

- verifies: [APP-49](#app-49), [SPEC-155](#spec-155)

<a id="trgr-2"></a>
## TRGR-2 — Placement

Type: test_suite | State: approved | Revision: 9

Explicit user request only. Contains the four tests from tests/PlacementTests.mc / placement-tests.jungle: caption/duration fitting, overflow/compact-cache behavior, the unsupported/reduced-area drawing matrix, and documented unsupported combinations. Verify the full compact caption or bounded background-only behavior, clipping and recovery under [APP-34](#app-34). Do not treat fallback as a normal-value pass. No Memory work is implied; Core never launches this suite.

**Relations**

- includes_test: [SPEC-232](#spec-232), [SPEC-295](#spec-295), [TFNC-7](#tfnc-7), [TUI-12](#tui-12), [TUI-13](#tui-13), [TUI-14](#tui-14)

<a id="tper-1"></a>
## TPER-1 — Memory

Type: test_suite | State: approved | Revision: 9

Explicit user request only. Run the two isolated profile font probes and the separate normal Data Field runtime validation stage under [APP-47](#app-47)/[APP-48](#app-48). Source: tests/FontTests.mc, memory-tests.jungle and validation/memory/MemoryValidation.mc. A font probe alone cannot qualify peak runtime memory. Record per-product requested scenarios, source/binary/toolchain and actual used/free/total observations. Hardware evidence and unrun cases remain separate. A build or Core run never authorizes this suite.

**Relations**

- includes_test: [SPEC-231](#spec-231), [SPEC-296](#spec-296), [TPRF-7](#tprf-7), [TPRF-8](#tprf-8), [TPRF-9](#tprf-9)

<a id="tstfunc-9"></a>
## TSTFUNC-9 — Core: selected profiles and seven exact colors

Type: test | State: approved | Revision: 8

Suite: Core. Definition for implementation; no execution result.

For HR/power current, 3s, activity/lap averages, numeric zone and Team, give different metric values and assert each uses its own selected profile/value. Hide numeric sources; cover both sets, regular/enlarged/duplicate slots, themes/inversion, None/Label/Whole cell. Assert palette zones 1..7 and native 10; dark magenta uses white label text, white value text only for Whole cell, Label retains normal value area. Invalid/recovered zones retain valid values/text and use neutral/recovered effects. Cadence, grade and temperature classification remain unchanged.

**Relations**

- verifies: [DVS-20](#dvs-20), [DVS-24](#dvs-24), [SPEC-246](#spec-246), [SPEC-248](#spec-248), [SPEC-253](#spec-253), [SPEC-663](#spec-663), [SPEC-664](#spec-664), [SPEC-665](#spec-665), [SPEC-666](#spec-666)

<a id="tstfunc-8"></a>
## TSTFUNC-8 — Core: independent zone selection and recovery

Type: test | State: approved | Revision: 3

Suite: Core. Definition for implementation; no execution result.

Exercise Off/Off, On/Off, Off/On, On/On with disagreeing device/custom fixtures. Check absent device profiles and older-API absence do not block valid custom classification. Invalid selected custom profiles never fall back; valid edits recover. Missing/malformed switch reads Off. Switch Off then On retains edited limits. Verify device mode retains native bounds and indices, including 10.

**Relations**

- verifies: [FR-16431](#fr-16431), [FR-16438](#fr-16438), [SPEC-663](#spec-663), [SPEC-664](#spec-664), [SPEC-666](#spec-666), [SPEC-668](#spec-668)

<a id="tstfunc-7"></a>
## TSTFUNC-7 — Core: custom power boundaries and names

Type: test | State: approved | Revision: 3

Suite: Core. Definition for implementation; no execution result.

Use limits 100/150/200/250/300/350 W. Check each boundary minus/at/plus one and half-unit rounding carries; zero ->1 and 351/3001 ->7. Reject negative/missing/non-finite raw input. Verify all seven exact names and open final zone. Cover valid limit edges 1/3000, repeated/descending/missing/zero/fractional/string/non-finite/out-of-range cutoffs.

**Relations**

- verifies: [SPEC-662](#spec-662), [SPEC-666](#spec-666)

<a id="tstfunc-6"></a>
## TSTFUNC-6 — Core: custom HR boundaries and validation

Type: test | State: approved | Revision: 3

Suite: Core. Definition for implementation; no execution result.

Use limits 100/120/140/160 bpm. Assert 99/100 ->1, 101/120 ->2, 121/140 ->3, 141/160 ->4, 161/251 ->5; include half-unit rounding carries. Reject raw zero, negative, missing and non-finite readings. Cover valid edge limits 30 and 250, repeated/descending/missing/zero/fractional/string/non-finite/out-of-range cutoffs; invalid tuples expose no zone. Positive raw values rounding to zero remain zone 1.

**Relations**

- verifies: [SPEC-661](#spec-661), [SPEC-666](#spec-666)

<a id="trgr-1"></a>
## TRGR-1 — Core

Type: test_suite | State: approved | Revision: 15

Default fast UI correctness, values/calculations, formatting, settings, acquisition/lifecycle and cache/draw regressions under [SPEC-157](#spec-157). Contains all 37 named Core Monkey C cases plus four separately identified host build/resource/publication prerequisites; these host checks are not extra Monkey C cases. Run Core after app changes. Never run Memory or Placement implicitly. Repository authority: tests/suites.json, tests.jungle and tests/service-cases.json. Linked definitions assert scope, not current execution or hardware qualification.

**Relations**

- includes_test: [SPEC-167](#spec-167), [SPEC-168](#spec-168), [SPEC-226](#spec-226), [SPEC-227](#spec-227), [SPEC-228](#spec-228), [SPEC-229](#spec-229), [SPEC-230](#spec-230), [SPEC-267](#spec-267), [SPEC-268](#spec-268), [SPEC-269](#spec-269), [SPEC-270](#spec-270), [SPEC-271](#spec-271), [SPEC-272](#spec-272), [SPEC-273](#spec-273), [SPEC-274](#spec-274), [SPEC-275](#spec-275), [SPEC-276](#spec-276), [SPEC-277](#spec-277), [SPEC-278](#spec-278), [SPEC-279](#spec-279), [SPEC-280](#spec-280), [SPEC-281](#spec-281), [SPEC-282](#spec-282), [SPEC-283](#spec-283), [SPEC-284](#spec-284), [SPEC-285](#spec-285), [SPEC-286](#spec-286), [SPEC-287](#spec-287), [SPEC-288](#spec-288), [SPEC-289](#spec-289), [SPEC-290](#spec-290), [SPEC-291](#spec-291), [SPEC-292](#spec-292), [SPEC-293](#spec-293), [SPEC-294](#spec-294), [SPEC-297](#spec-297), [SPEC-298](#spec-298), [SPEC-299](#spec-299), [TCOM-1](#tcom-1), [TFNC-1](#tfnc-1), [TFNC-10](#tfnc-10), [TFNC-11](#tfnc-11), [TFNC-12](#tfnc-12), [TFNC-13](#tfnc-13), [TFNC-14](#tfnc-14), [TFNC-15](#tfnc-15), [TFNC-16](#tfnc-16), [TFNC-17](#tfnc-17), [TFNC-18](#tfnc-18), [TFNC-19](#tfnc-19), [TFNC-2](#tfnc-2), [TFNC-20](#tfnc-20), [TFNC-22](#tfnc-22), [TFNC-23](#tfnc-23), [TFNC-24](#tfnc-24), [TFNC-25](#tfnc-25), [TFNC-26](#tfnc-26), [TFNC-3](#tfnc-3), [TFNC-4](#tfnc-4), [TFNC-5](#tfnc-5), [TFNC-6](#tfnc-6), [TFNC-8](#tfnc-8), [TFNC-9](#tfnc-9), [TINT-1](#tint-1), [TPRF-4](#tprf-4), [TPRF-5](#tprf-5), [TPRF-6](#tprf-6), [TSEC-1](#tsec-1), [TSTFUNC-1](#tstfunc-1), [TSTFUNC-10](#tstfunc-10), [TSTFUNC-11](#tstfunc-11), [TSTFUNC-2](#tstfunc-2), [TSTFUNC-3](#tstfunc-3), [TSTFUNC-4](#tstfunc-4), [TSTFUNC-5](#tstfunc-5), [TSTFUNC-6](#tstfunc-6), [TSTFUNC-7](#tstfunc-7), [TSTFUNC-8](#tstfunc-8), [TSTFUNC-9](#tstfunc-9), [TUI-1](#tui-1), [TUI-10](#tui-10), [TUI-11](#tui-11), [TUI-2](#tui-2), [TUI-3](#tui-3), [TUI-4](#tui-4), [TUI-5](#tui-5), [TUI-6](#tui-6), [TUI-7](#tui-7), [TUI-8](#tui-8), [TUI-9](#tui-9)

<a id="spec-279"></a>
## SPEC-279 — Verify exact seven-zone colors

Type: test | State: approved | Revision: 11

Suite: Core. Definition; execution evidence is separate.

Assert exact shared RGB values for HR/cadence zones 1..5 and power zones 1..7 plus native zone 10 across both themes, inversion and coverage modes. Include white foreground on dark magenta and unchanged value foreground for Label coverage. Verify grade dark-red/black and temperature cyan/white remain available and are not training zones.

**Relations**

- verifies: [DVS-45](#dvs-45), [SPEC-246](#spec-246)

<a id="tfnc-21"></a>
## TFNC-21 — Verify current-lap fields, averages and boundary lifecycle

Type: test | State: approved | Revision: 24

Planned acceptance definition; no execution or implementation is asserted. Verify all six lap fields and the exact labels from their field definitions, codes 26..31, units and full/regular/enlarged/duplicate/hidden layouts. Prove existing 0..25 mappings, saved assignments, ten-slot defaults in both banks and the active catalogue in [SPEC-155](#spec-155) are exposed and the retired use_units_as_labels key is ignored. A full lap of 1000 m over 120000 active ms gives 1.00 km / 02.00 / 30.0 km/h; verify statute conversion, .SS preservation, zero distance and zero-duration unavailability. Use irregular-spacing/zero/missing-channel fixtures against [FUNC-10](#func-10). Verify all channel and time values at confirmed boundaries, including unavailable means until positive covered time.

Exercise fresh activity, late loading while running/paused, recovery at the next confirmed boundary independently of an unknown completed-lap total, manual/Auto Lap, optional lap2 once-only fallback, workout-step-only notifications, pause/stop/resume, save/discard/reset, old events, identity/counter regressions and lost callback continuity under [FUNC-9](#func-9). Verify per-channel availability/coverage, first-sample seeding, gaps, duplicate/out-of-order samples, overflow and long-duration bounded memory. A missing boundary baseline remains unavailable rather than using a cached counter or activity-wide average. Changing settings/layout/visibility does not reset acquisition; drawing adds no samples.

On all ten profiles, separately record compiler capability, callback order/capture freshness, sensor/zero behavior, FIT comparison and observed boundary error with product, SDK, firmware, source revision and captured requirement baseline. Simulator fixtures are not physical evidence. Hardware portions remain blocked until devices/evidence exist. Record unexecuted portions as unrun and missing hardware evidence as blocked. Link this test to its current-lap acquisition and field definitions; approval of the test definition is not a passing result.


**Relations**

- verifies: [FUNC-10](#func-10), [FUNC-3](#func-3), [FUNC-4](#func-4), [FUNC-5](#func-5), [FUNC-6](#func-6), [FUNC-7](#func-7), [FUNC-8](#func-8), [FUNC-9](#func-9), [SPEC-155](#spec-155)

<a id="spec-296"></a>
## SPEC-296 — Verify Team and coloring runtime memory

Type: test | State: approved | Revision: 10

Suite: Memory. Definition; execution evidence is separate.

Explicit-request Memory: run the normal Data Field runtime on all ten profiles with maximum valid Team strings, all three bundled fonts, native text, all colored families/modes and repeated edits/switches. Record peak/steady memory, device limit, source/binary hashes and failures; synthetic test-application memory is insufficient.

**Relations**

- verifies: [APP-48](#app-48)

<a id="tstfunc-1"></a>
## TSTFUNC-1 — Verify battery percentage validity before rounding

Type: test | State: approved | Revision: 9

Suite: Core. Definition; execution evidence is separate.

Through the production formatter verify [DVS-35](#dvs-35): 0, 50 and 100 remain valid; 50.4 displays 50 and 50.6 displays 51 under [DVS-7](#dvs-7). Inputs -0.01, 100.01, missing, NaN and infinities display --; do not clamp or round an out-of-range input into validity. Check battery header/unit visibility separately under [DVS-50](#dvs-50) and preserve a valid zero. No memory sampling is part of this test.

**Relations**

- verifies: [DVS-35](#dvs-35)

<a id="spec-295"></a>
## SPEC-295 — Verify Team insufficient-area handling

Type: test | State: approved | Revision: 7

Suite: Placement. On explicit request, test Team values with overlong words, oversized fonts and insufficient value area: expect !, then no value when ! cannot fit, while retaining the team header and other cells. When the fixed header itself cannot fit, use the shared grid fallback under [APP-34](#app-34). Repeat regular/enlarged cells, both alignments/themes and sets.

**Relations**

- verifies: [SPEC-253](#spec-253)

<a id="spec-294"></a>
## SPEC-294 — Verify Team coloring regions

Type: test | State: approved | Revision: 8

Suite: Core. Render None, Label and Whole cell with semantic/neutral colors in both themes, alignments, sets and regular/enlarged slots. Assert Label fills only the common full-width team header band, Whole fills the cell, and None keeps ordinary backgrounds. Check header/value contrast independently and unchanged wrap/positions across color-only edits.

**Relations**

- verifies: [SPEC-253](#spec-253)

<a id="spec-290"></a>
## SPEC-290 — Verify Team settings isolation

Type: test | State: approved | Revision: 11

Suite: Core. Set one shared Team text and color source. Hide/reassign duplicate slots, disable the second set, switch banks and reload: all Team slots retain the shared values. Exactly two Team properties exist. Slot assignments and coverage remain independent.

**Relations**

- verifies: [SPEC-208](#spec-208), [SPEC-253](#spec-253)

<a id="spec-289"></a>
## SPEC-289 — Verify Team literal rendering

Type: test | State: approved | Revision: 12

Suite: Core. Render TEAM, mixed case, digits, punctuation, repeated spaces and empty text in both sets with units shown/hidden. Assert the exact lowercase team header, unchanged user value and no physical unit or numeric conversion. Empty text retains the header. Render duplicate Team assignments in both sets, including regular/enlarged cells: assert the shared text updates every visible Team value and previous snapshots remain unchanged.

**Relations**

- verifies: [DVS-12](#dvs-12), [DVS-50](#dvs-50), [SPEC-156](#spec-156), [SPEC-253](#spec-253)

<a id="spec-288"></a>
## SPEC-288 — Verify Team binding options

Type: test | State: approved | Revision: 7

Suite: Core. Definition; execution evidence is separate.

Check keys/types/captions/defaults for all 20 slots, each valid code and invalid Boolean/fraction/unknown values. Verify binding and coverage remain independent through reload and bank switching.

**Relations**

- verifies: [SPEC-253](#spec-253)

<a id="spec-287"></a>
## SPEC-287 — Verify Team text options

Type: test | State: approved | Revision: 11

Suite: Core. Check exactly two shared Team controls before every slot control: Team name and Team color source, with no font selector, hidden font property or per-slot/second-set copies. Verify Slot N captions and text default/empty/32/33 characters/spaces/case/wrong types/non-ASCII validation. All duplicate, hidden and reassigned Team slots use the shared text and source after reload/switches; coverage remains independent.

**Relations**

- verifies: [SPEC-253](#spec-253)

<a id="spec-286"></a>
## SPEC-286 — Verify Team catalogue compatibility

Type: test | State: approved | Revision: 8

Suite: Core. Definition; execution evidence is separate.

Check generated/runtime choices 0..32, exact team identifier/caption and all old mappings. Upgrade saved assignments in both banks and verify their layout, presets and switching remain unchanged.

**Relations**

- verifies: [APP-46](#app-46), [SPEC-155](#spec-155), [SPEC-210](#spec-210), [SPEC-253](#spec-253)

<a id="spec-285"></a>
## SPEC-285 — Verify cadence option validation

Type: test | State: approved | Revision: 5

Suite: Core. Definition; execution evidence is separate.

Check types/keys/defaults, all boundary limits, Boolean/fractional/negative/>300 values, equal/reversed bounds and partially absent settings. Assert shared profile across both sets and unchanged stored invalid data.

**Relations**

- verifies: [SPEC-252](#spec-252)

<a id="spec-283"></a>
## SPEC-283 — Verify classification cache isolation

Type: test | State: approved | Revision: 7

Suite: Core. Definition; execution evidence is separate.

Instrument source/classifier calls across duplicates, zone fields and Team bindings. Change one reading/profile/coverage and assert only dependent records change; old snapshots and other channels remain unchanged.

**Relations**

- verifies: [APP-26](#app-26)

<a id="spec-282"></a>
## SPEC-282 — Verify zone fallback and recovery

Type: test | State: approved | Revision: 5

Suite: Core. Definition; execution evidence is separate.

Inject invalid readings/profiles separately and together, including malformed cadence bounds and unsupported native power metadata. Verify neutral fill, preserved valid readings, None suppression and recovery without a restart.

**Relations**

- verifies: [SPEC-249](#spec-249)

<a id="spec-281"></a>
## SPEC-281 — Verify all metric family colors

Type: test | State: approved | Revision: 12

Suite: Core. Definition; execution evidence is separate.

Provide simultaneous current, 3s, activity-average and lap values in different zones; verify each family and numeric-zone field. Include measured zero watts/rpm, missing lap coverage and duplicate slots with different modes.

**Relations**

- verifies: [SPEC-155](#spec-155), [SPEC-248](#spec-248)

<a id="spec-280"></a>
## SPEC-280 — Verify cadence boundary table

Type: test | State: approved | Revision: 5

Suite: Core. Definition; execution evidence is separate.

For defaults and edited thresholds test below/equal/above every bound, rounding across a bound, zero and invalid readings. Assert exactly one zone for every valid nonnegative displayed value.

**Relations**

- verifies: [SPEC-247](#spec-247)

<a id="spec-278"></a>
## SPEC-278 — Verify serialized property budget

Type: test | State: approved | Revision: 6

Suite: Core build checks. Invoke scripts/check-properties.ps1 with the installed Garmin SDK serializer. Serialize all current keys/defaults and maximum allowed Team text; both sizes must be <=8000 bytes, including overhead. Require nonzero exit for an oversized dictionary or serializer failure. Verify invalid keys and duplicate declarations are rejected. Preserve exact measured counts in artifacts/property-budget.json. This host check is not runtime Memory qualification.

**Relations**

- verifies: [SPEC-245](#spec-245)

<a id="spec-275"></a>
## SPEC-275 — Verify color-only packet invalidation

Type: test | State: approved | Revision: 6

Suite: Core. Executable regression: tests/PresentationTests.mc, normalPresentationDrawAndAlignment with EnlargedLabelScenario. Execution evidence is recorded separately.

Hold displayed text/bounds constant while changing thresholds, source validity, theme and coverage. Verify replacement packets and complete erasure; earlier snapshots remain byte-for-byte unchanged.

**Relations**

- verifies: [APP-26](#app-26)

<a id="spec-274"></a>
## SPEC-274 — Verify enlarged color bounds and contrast

Type: test | State: approved | Revision: 8

Suite: Core. Executable regression: tests/PresentationTests.mc, normalPresentationDrawAndAlignment with EnlargedLabelScenario. Execution evidence is recorded separately.

Compare cell commands/pixels before/after effects for zero/one/two enlarged layouts, all grid modes and both alignments. Check complete glyphs/halos, shared band bounds and neighboring cells.

**Relations**

- verifies: [APP-34](#app-34), [DVS-12](#dvs-12), [DVS-6](#dvs-6)

<a id="spec-273"></a>
## SPEC-273 — Verify enlarged neutral fallback

Type: test | State: approved | Revision: 7

Suite: Core. Executable regression: tests/PresentationTests.mc, normalPresentationDrawAndAlignment with EnlargedLabelScenario. Execution evidence is recorded separately.

Exercise no custom source, missing/invalid/unsupported/expired/unqualified sources and recovery, including valid zero. Verify both gray shades, each mode, both sets and inversion without hiding valid values.

**Relations**

- verifies: [DVS-51](#dvs-51), [SPEC-249](#spec-249)

<a id="spec-271"></a>
## SPEC-271 — Verify mode-only invalidation

Type: test | State: approved | Revision: 9

Suite: Core. Definition; execution evidence is separate.

Change one mode with unchanged text, readings and bounds. Assert new production packets/fills on next update, unchanged geometry, other slots and lap/rolling/grade/trigger state. Fitting counters remain unchanged when clearance is unchanged; otherwise only the affected cell may refit to keep complete glyphs/halos inside its bounds.

**Relations**

- verifies: [APP-26](#app-26), [APP-32](#app-32)

<a id="spec-270"></a>
## SPEC-270 — Verify isolated mode validation

Type: test | State: approved | Revision: 9

Suite: Core. Definition; execution evidence is separate.

Inject missing/null/Boolean/fractional/negative/unknown values in one slot. Verify its bank-specific fallback and unchanged other slots/settings; valid explicit 0 survives reload.

**Relations**

- verifies: [APP-31](#app-31), [APP-49](#app-49)

<a id="spec-269"></a>
## SPEC-269 — Verify whole-cell text contrast

Type: test | State: approved | Revision: 9

Suite: Core. Definition; execution evidence is separate.

Render all palette colors, including magenta #FF00FF with black text and an opposite white one-pixel halo, both neutral grays and all coverage modes. Assert foreground/halo colors and transparency for header, primary and secondary glyphs, including enlarged inversion. Changing coverage leaves no obsolete fill/halo.

**Relations**

- verifies: [APP-36](#app-36), [DVS-6](#dvs-6)

<a id="spec-227"></a>
## SPEC-227 — Core: verify threshold hysteresis and source validity

Type: test | State: approved | Revision: 9

Verification definition; implementation and execution evidence are recorded separately. Use production transition logic with deterministic acquisition fixtures. With power A=250,R=220, fresh outputs 249,250,235,220,219 shall select default,second,second,second,default. Raw 249.6 must not activate despite displayed whole-watt 250; 219.6 returns despite displayed 220. Repeat for HR A=160,R=150 using 159,160,155,150,149. Equal A=R activates at equality and returns only below it. Test startup within hysteresis band, exact boundaries, finite zero power, null/negative/NaN/Infinity, HR zero, power before its first valid sample, partial power windows, missing/gapped samples, dropout and recovery inside the band: unavailable returns default, and recovery below activation stays default. Prove current HR and shared 3s power are used with neither selected in either bank, with duplicate slots, and while instantaneous power or HR3s disagrees. Unrelated-channel loss changes nothing. Verify no extra dwell delay beyond the producer and one decision per delivered sample. This is Core and uses no runtime Memory or deliberate overflow cases.
Power startup and recovery follow [DVS-22](#dvs-22): a first 300 W sample activates immediately at A=250; subsequent decisions use two- and three-sample means. Verify this through the real Data Field pipeline with no visible power fields; the trigger must reuse the shared producer.

**Relations**

- verifies: [DVS-22](#dvs-22), [SPEC-211](#spec-211), [SPEC-212](#spec-212), [SPEC-213](#spec-213), [SPEC-214](#spec-214), [SPEC-215](#spec-215), [SPEC-216](#spec-216)

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

- verifies: [SPEC-176](#spec-176)

<a id="spec-166"></a>
## SPEC-166 — Verify: reproduce Garmin-compatible Roboto Condensed resources within the memory budget

Type: test | State: approved | Revision: 20

Regenerate or verify each checked-in resource from declared inputs; compile it on all candidate profiles. Render required glyphs, five-character numeric boundaries and largest regular/enlarged fields. Verify no missing glyph, clipping or unintended substitute typeface, and record resource/loaded-memory costs against existing ceilings. Capture actual generator configuration and asset hashes. This is a planned verification case; no passing execution is asserted.

Check the three font roles under [APP-25](#app-25) against [APP-24](#app-24) references and [SPEC-154](#spec-154) fixed role sizes, including complete current-lap labels after implementation.

Run resource/loaded-memory measurements only when Memory is explicitly requested. Verify unsupported/reduced-area behavior only when Placement is explicitly requested. Core normal-value guarantees follow each field's [APP-34](#app-34) table; fixed font sizes do not guarantee every format in every role.

**Relations**

- verifies: [APP-25](#app-25), [SPEC-154](#spec-154)

<a id="app-4"></a>
## APP-4 — Data drawer

Type: component | State: approved | Revision: 46

Consume the complete snapshot and drawing commands prepared by [APP-3](#app-3) through onUpdate(dc). [APP-26](#app-26) owns the draw-only lifecycle rule, [APP-34](#app-34) owns fitting/fallback, and the shared coverage/contrast requirements own painting. This component does not independently define field formats or geometry.

**Relations**

- uses: [APP-2](#app-2), [APP-3](#app-3), [SWINT-1](#swint-1)

<a id="app-3"></a>
## APP-3 — Drawing params provider

Type: component | State: approved | Revision: 35

Prepare the drawing parameters consumed by [APP-4](#app-4): resolved settings, assigned bounds, font metrics and prepared presentation commands. [APP-26](#app-26) owns preparation/cache lifetime; [APP-34](#app-34) owns fitting; [APP-21](#app-21) owns the value inset and alignment; [APP-25](#app-25) owns font roles. Field-specific formats remain in the field catalogue.

**Relations**

- uses: [APP-2](#app-2), [SWINT-1](#swint-1)

<a id="app-2"></a>
## APP-2 — Initialization handler

Type: component | State: approved | Revision: 14

Initialize settings, capability inputs and a safe snapshot for the drawing-parameter provider [APP-3](#app-3). [APP-31](#app-31) owns validation/defaults, [APP-33](#app-33) owns safe initial presentation, and [APP-38](#app-38) owns device qualification. Bounds-dependent preparation belongs to [APP-3](#app-3).

**Relations**

- uses: [SWINT-1](#swint-1)

<a id="app-44"></a>
## APP-44 — Toybox.Graphics.Dc.fillPolygon(...)

Type: data_item | State: approved | Revision: 11

Graphics.Dc.fillPolygon(points) paints a polygon using the selected color; this contract limits the input to the API's 64-point maximum. Supply prepared, cell-clipped points. [DVS-29](#dvs-29) owns slope geometry; [APP-26](#app-26) owns preparation before drawing.

<a id="app-43"></a>
## APP-43 — Toybox.UserProfile.getPowerZones(...)

Type: data_item | State: approved | Revision: 11

UserProfile.getPowerZones(Activity.SPORT_CYCLING) supplies cycling power thresholds when Connect IQ 5.2.2 and the method are supported. Guard optional availability. The API supplies thresholds, not colors; [DVS-42](#dvs-42) owns metadata interpretation/classification and [SPEC-249](#spec-249) owns unavailable-color fallback.

<a id="app-12"></a>
## APP-12 — onUpdate(dc)

Type: data_item | State: approved | Revision: 29

Toybox.WatchUi.View.onUpdate(dc), inherited by DataField, is the drawing callback. [APP-26](#app-26) owns prepared-command rendering and the first/changed-bounds preparation exception; [APP-33](#app-33) owns the initial safe snapshot.
API: https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/View.html#onUpdate-instance_function

<a id="app-8"></a>
## APP-8 — compute(info)

Type: data_item | State: approved | Revision: 43

Toybox.WatchUi.DataField.compute(info) delivers Activity.Info once per second. Drawing is scheduled independently, so delivery does not establish drawing order. [APP-26](#app-26) owns sample processing and preparation; field acquisition contracts own source validity and reset rules.
API: https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/DataField.html#compute-instance_function

<a id="app-7"></a>
## APP-7 — onLayout(dc)

Type: data_item | State: approved | Revision: 19

Toybox.WatchUi.View.onLayout(dc), inherited by DataField, supplies the drawing context assigned to the field. dc.getWidth()/getHeight() describe assigned bounds, which can differ from physical screen resolution. Application preparation and reuse rules are owned by [APP-26](#app-26).
API: https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/View.html#onLayout-instance_function

<a id="swint-1"></a>
## SWINT-1 — Garmin SDK

Type: interface | State: approved | Revision: 21

Garmin devices SDK library to use device function APIs.

**Relations**

- contains: [APP-10](#app-10), [APP-11](#app-11), [APP-12](#app-12), [APP-13](#app-13), [APP-14](#app-14), [APP-15](#app-15), [APP-16](#app-16), [APP-17](#app-17), [APP-18](#app-18), [APP-19](#app-19), [APP-39](#app-39), [APP-40](#app-40), [APP-41](#app-41), [APP-42](#app-42), [APP-43](#app-43), [APP-44](#app-44), [APP-5](#app-5), [APP-6](#app-6), [APP-7](#app-7), [APP-8](#app-8), [APP-9](#app-9)

<a id="app-42"></a>
## APP-42 — Toybox.UserProfile.getHeartRateZones(...)

Type: data_item | State: approved | Revision: 7

Retrieve cycling heart-rate thresholds with `UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_BIKING)` when available. The app needs UserProfile permission and shall validate the returned boundaries before assigning a zone; the API supplies thresholds, not display colors.

<a id="app-41"></a>
## APP-41 — Toybox.WatchUi.requestUpdate()

Type: data_item | State: approved | Revision: 9

Request a redraw of the active data-field View after a Garmin Connect setting or supported night-mode change. The next [APP-12](#app-12) shall render one consistent settings and palette snapshot.

<a id="app-15"></a>
## APP-15 — Toybox.Application.Properties.getValue(key)

Type: data_item | State: approved | Revision: 10

Toybox.Application.Properties.getValue(key) retrieves an application property declared in the settings/properties resources. Read the keys/types/list mappings from [SPEC-155](#spec-155), validate each read independently under [APP-31](#app-31), and catch missing/unsupported/invalid reads to use that property's documented default. Load/cache values during initialization or [APP-6](#app-6), not each draw. Numeric list values map to stable internal identifiers; valid saved Center and hidden-slot selections/effects are preserved. Do not treat this settings API as a sensor source or as evidence of Garmin Connect transport qualification.

<a id="app-5"></a>
## APP-5 — initialize()

Type: data_item | State: approved | Revision: 12

Constructor/initialization entry. The application class initializes its Toybox.Application.AppBase superclass; the Data Field class initializes Toybox.WatchUi.DataField. Establish validated default configuration, bounded sample state and a complete unavailable-safe display snapshot before the system can call drawing under [APP-33](#app-33). A constructor has no assigned Graphics.Dc; select fitted cell geometry/resources after [APP-7](#app-7), not from an assumed full-screen size. Preserve the separation of constructor, AppBase.onStart and DataField.compute responsibilities.

Initialize the bounded descriptor/presentation caches and resolved static modes required by [APP-26](#app-26). Bounds-dependent preparation remains in [APP-7](#app-7).

<a id="app-11"></a>
## APP-11 — onStop(state)

Type: data_item | State: approved | Revision: 8

Toybox.Application.AppBase.onStop(state) handles application termination and bounded resource cleanup. Preserve settings as required by [APP-31](#app-31)/[APP-46](#app-46), avoid rewriting valid persisted settings with temporary defaults, and release application-owned transient state as applicable. App termination does not authorize changing or deleting the host activity's recorded data. state may be null. Source: https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/AppBase.html#onStop-instance_function

<a id="app-16"></a>
## APP-16 — Toybox.Activity.getActivityInfo()

Type: data_item | State: approved | Revision: 9

Provides a snapshot of the current `Activity.Info` state outside `DataField.compute(info)` when needed, including during data-field initialization. Use `Toybox.Activity.getActivityInfo()`; `Activity.getInfo()` is not a Connect IQ method.

<a id="app-6"></a>
## APP-6 — onSettingsChanged()

Type: data_item | State: approved | Revision: 10

Toybox.Application.AppBase.onSettingsChanged() is the running-application callback for delivered application setting changes, documented for Garmin Connect Mobile. Re-read each property through [APP-15](#app-15), validate independently under [APP-31](#app-31), apply one consistent configuration without clearing unrelated activity/rolling state under [APP-32](#app-32), invalidate affected presentation/layout caches and request [APP-41](#app-41). A later startup also loads saved properties; do not infer that every settings transport has an identical live-callback guarantee. Source: https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/AppBase.html#onSettingsChanged-instance_function

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

<a id="spec-173"></a>
## SPEC-173 — Verify: record unresolved product decisions before closing dependent development tasks

Type: test | State: approved | Revision: 3

Inspect all listed decisions and their affected requirements/tasks. Verify open entries prevent only dependent acceptance, and independently implemented features remain assessable. For resolved entries, confirm reviewer/decision provenance and matching contract/fixture updates; no fabricated temperature source, grade method or arbitrary visual goldens may close an unresolved entry. This is a planned verification case; no passing execution is asserted.

**Relations**

- verifies: [SPEC-161](#spec-161)

<a id="spec-172"></a>
## SPEC-172 — Verify: gate changes on repeatable compilation and explicit test evidence

Type: test | State: approved | Revision: 3

Run a clean CI job and a cached job with declared inputs; change the SDK/device/resource inputs and verify cache invalidation. Inject a compiler error, failing test and unavailable simulator and verify honest failures or unrun classifications. Check per-product artifacts, raw logs and separate hardware/visual-review gates. This is a planned verification case; no passing execution is asserted.

**Relations**

- verifies: [SPEC-160](#spec-160)

<a id="app-40"></a>
## APP-40 — Toybox.Application.AppBase.onNightModeChanged()

Type: data_item | State: approved | Revision: 5

The AppBase callback for a device switch between day and night mode on supported devices. Re-read `System.getDeviceSettings().isNightModeEnabled`, update the active palette and request a redraw without altering the configured fields or numeric values.

<a id="app-39"></a>
## APP-39 — Toybox.System.getDeviceSettings().isNightModeEnabled

Type: data_item | State: approved | Revision: 5

Read the current device night-color state through `System.getDeviceSettings().isNightModeEnabled` when this member is present. It is available on newer supported Edge devices but not every target in [APP-24](#app-24); use a capability check and the explicit theme fallback instead of assuming this property exists.

<a id="app-19"></a>
## APP-19 — Toybox.WatchUi.DataField.createField(...)

Type: data_item | State: approved | Revision: 5

A DataField may call `Toybox.WatchUi.DataField.createField(...)` to create a `FitContributor.Field` for optional custom FIT recording. The returned field is updated with `setData(...)` when the data is valid. This is not required to display values on screen. Garmin API: https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/DataField.html

<a id="app-18"></a>
## APP-18 — Toybox.UserProfile.getProfile()

Type: data_item | State: approved | Revision: 6

Retrieves the user's general profile data, such as body metrics, when the UserProfile permission is granted. Training-zone thresholds are retrieved separately through `Toybox.UserProfile.getHeartRateZones(...)` and, on supported devices, `getPowerZones(...)`; `getProfile()` alone is not a source of zone boundaries.

<a id="app-17"></a>
## APP-17 — Toybox.System.getSystemStats()

Type: data_item | State: approved | Revision: 5

Toybox.System.getSystemStats() returns System.Stats, including battery percentage and application-runtime totalMemory, usedMemory and freeMemory in bytes. Validate battery under [DVS-35](#dvs-35); use the named memory members for the separate qualification measurements under [APP-48](#app-48). These are not device physical RAM or filesystem-free-storage values, and no free-storage member is documented by this contract. Label foreground/background/simulator/hardware measurement provenance separately; published limits alone are not measured free memory. Source: https://developer.garmin.com/connect-iq/api-docs/Toybox/System/Stats.html

<a id="app-14"></a>
## APP-14 — onHide()

Type: data_item | State: approved | Revision: 4

Toybox.WatchUi.View.onHide() is the inherited View hide callback when delivered by the system. It may suspend display-only work, but shall not stop required activity sample processing, clear rolling samples solely because the field is hidden or reset timer/settings state. Do not depend on an onHide callback for every Data Field visibility transition; the documented Data Field lifecycle primarily lists onLayout/onShow/onUpdate. Restore current rendering under [APP-13](#app-13) without inventing samples. Source: https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/View.html

<a id="app-13"></a>
## APP-13 — onShow()

Type: data_item | State: approved | Revision: 4

Toybox.WatchUi.View.onShow(), inherited by DataField, is a visibility callback. When the view becomes visible, render/request the current complete snapshot using the current validated settings and rebuilt layout as needed. Becoming visible shall not reset activity timers, rolling samples, hidden assignments or saved settings. Do not assume visibility callbacks supply Activity.Info or replace [APP-8](#app-8) acquisition. Source: https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/View.html#onShow-instance_function

<a id="app-10"></a>
## APP-10 — onStart(state)

Type: data_item | State: approved | Revision: 4

Toybox.Application.AppBase.onStart(state) is called at application startup before getInitialView(). Handle application startup and load/validate saved configuration without assuming state is non-null, an activity sample is already available or a final drawing area has been assigned. Layout preparation follows [APP-7](#app-7) and safe snapshot initialization follows [APP-33](#app-33). App startup is not an instruction to reset the host Garmin activity. Source: https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/AppBase.html#onStart-instance_function

<a id="app-9"></a>
## APP-9 — getInitialView()

Type: data_item | State: approved | Revision: 4

Toybox.Application.AppBase.getInitialView() returns the initial view array, containing this application's WatchUi.DataField instance. That view receives layout/update and activity-compute callbacks. An input delegate is optional when supported/needed; do not require an on-device settings editor under [APP-46](#app-46). Initialize a complete safe display state under [APP-33](#app-33) before returning the view. Source: https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/AppBase.html#getInitialView-instance_function
