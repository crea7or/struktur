# Runtime memory validation

Run `scripts/run-tests.ps1 -Product edge1030 -Suite Memory` for isolated font probes, host reporting regressions and three sequential normal Data Field runs:

- **Native observer:** unchanged production callbacks/default settings, without synthetic fixtures or RuntimeMetrics sampling. The small observer remains included in reported usage.
- **Matrix:** all 648 layout/resource cases, three fonts, 33 fields, complete grids and lifecycle checks.
- **Switching:** 1000 field-set transitions and 200 settings changes.

The matrix uses the native full-bounds Dc directly and releases its reference settings while synthetic cases run; it does not retain a third bank. Production geometry caches retain only the winning plan, reuse valid unchanged geometry and release obsolete plans before replacement.

The sampler retains fixed counters and existing stage identifiers. It performs no console I/O or diagnostic formatting while sampling; output is deferred until fixture temporaries have returned. Native observation retires its measured presentation before printing the final record. All observed allocations, including instrumentation, must remain within the actual runtime allocation and published ceiling. Never subtract estimated overhead to obtain a pass.

The aggregate report compares initialization and first-draw checkpoints. The initialization delta includes driver code and retained fixture state; differences between unrelated scenario peaks are not an exact app-only measurement. Native/default observation does not replace maximum-resource matrix qualification. Sparse observations do not prove absence of transient peaks; simulator results do not qualify physical devices.

For diagnosis, `scripts/validate-memory.ps1 -Product edge1030 -Scenario native` (or `matrix` / `switching`) runs one scenario and marks the report `diagnostic_passed`, with `qualification_complete=false`. Only the default `all` run can qualify the complete runtime procedure. Failed attempts are archived under `artifacts/history/memory/`.
