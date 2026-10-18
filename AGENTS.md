# Struktur

Struktur is a Monkey C cycling Data Field developed with the [AI Architect requirement service](https://ai-architect.link). It offers 33 selectable fields, a two-column grid and up to two enlarged fields.

- `source/` contains acquisition, formatting and rendering; `profiles/` and `config/` define devices and settings.
- `resources/` contains UI assets and generated font sprites. Use `tools/` generators; include only glyphs used by the app and retain font licensing.
- `requirements/` holds versioned specifications and traceability; `tests/` and `validation/` contain separate verification workflows.
- For every change, keep code and requirements aligned: update affected requirements in the authoritative requirement service, local exports and traceability when behavior changes, and implement requirement changes in code. Keep affected tests and documentation consistent, preserve requested requirement states, and report any synchronization blockers.
- `architecture/` contains the sanitized public documentation release. Keep service identifiers, private links, author identities and raw execution history out of publication files.
- Nine candidate Edge profiles are listed in `config/devices.json`. Compile them with `powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/build.ps1 -Mode all`.
- `-Mode candidate` exports a signed `.iq`; guarded `release`/`package` modes require approved decisions and matching qualification evidence. Compilation alone is not qualification.
- Team uses native text fonts; AUX choices require target-specific qualification. Use the current compact property schema; no legacy keys or settings migration are required.
- Keep the signing key external. Machine paths and credentials belong in ignored local configuration; outputs belong in `bin/`, `artifacts/` or `dist/`.
- Run the fast Core suite after app changes. Memory and Placement suites require an explicit user request; do not run either automatically, through CI or after a Core run. Build-resource checks remain part of compilation. Use `scripts/run-tests.ps1` (Core by default), `-Suite Memory`, or `-Suite Placement`.
- Follow the current requirements for behavior. Temperature uses guarded native background reads; physical source qualification remains separate. Background effects stay independent per slot.
- See `publishing/` for submission preparation. Do not upload or submit without user authorization.
