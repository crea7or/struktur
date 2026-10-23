# Struktur

Struktur is a Monkey C cycling Data Field developed with the [AI Architect requirement service](https://ai-architect.link). It offers 33 selectable fields, a two-column grid and up to two enlarged fields.

- `source/` contains acquisition, formatting and rendering; `profiles/` and `config/` define devices and settings.
- `resources/` contains UI assets and generated font sprites. Use `tools/` generators; include only glyphs used by the app and retain font licensing.
- `requirements/` holds versioned specifications and traceability; `tests/` and `validation/` contain separate verification workflows.
- For every change, keep code and requirements aligned: update affected requirements in the authoritative requirement service, local exports and traceability when behavior changes, and implement requirement changes in code. Keep affected tests and documentation consistent, preserve requested requirement states, and report any synchronization blockers.
- The public architecture export is limited to `architecture/specification.md` and its referenced files in `architecture/attachments/`. Update these files in place; do not generate ZIP archives, JSON snapshots, checksums, release metadata or a separate `architecture/current/` export. Keep service identifiers, private links, author identities and raw execution history out of publication files.
- Ten candidate Edge profiles are listed in `config/devices.json`. Compile them with `powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/build.ps1 -Mode all`.
- `-Mode candidate` exports a signed `.iq`; guarded `release`/`package` modes require approved decisions and matching qualification evidence. Compilation alone is not qualification.
- Team automatically fits native text fonts; no font selector is exposed. Use the current compact property schema; no legacy keys or settings migration are required.
- Keep the signing key external. Machine paths and credentials belong in ignored local configuration. Validation evidence belongs in `artifacts/`.
- Put final Connect IQ publishing packages and sideloadable PRG files in `dist/`, and link those files when fulfilling publishing or sideloading requests. Reserve `bin/` for internal builds only.
- Run the fast Core suite after app changes. Memory and Placement suites require an explicit user request; do not run either automatically, through CI or after a Core run. Build-resource checks remain part of compilation. Use `scripts/run-tests.ps1` (Core by default), `-Suite Memory`, or `-Suite Placement`.
- Follow the current requirements for behavior. Temperature uses guarded native background reads; physical source qualification remains separate. Background effects stay independent per slot.
- For every publication request, refresh the sanitized requirements export in `architecture/`, then update the root `VERSION` file to the next Semantic Version (`MAJOR.MINOR.PATCH`). The current version is `0.1.7`; use `0.1.8` for the next publication unless a different version is requested. After that publication, use `VERSION` as the current version and increment it for each subsequent publication.
- Build both a Connect IQ store `.iq` package and an Edge 1040 sideloadable `.prg` for every publication request, and place both final artifacts in `dist/`.
- See `publishing/` for submission preparation. Do not upload or submit without user authorization.
