# Roadmap

Near-term ideas for party-on-your-dock. None of these require editing app bundles.

## Next

- [ ] RELEASING / PR template: `make apply` smoke
- [ ] Makefile / ART: `make coverage` in examples and art docs
- [ ] themes/README: `make extract` in scaffold block
- [ ] SAFETY: `make refresh` / `make doctor` in contract

## Shipped

- [x] `poyd missing <theme>` — list Dock apps without a theme PNG
- [x] Theme pack validation script (`scripts/validate-theme.sh`)
- [x] Optional dry-run for apply/revert (`--dry-run`)
- [x] Keep `make` targets in sync with new CLI commands
- [x] Per-theme coverage report (`scripts/theme-coverage.sh`)
- [x] Safer Dock refresh helpers (`scripts/refresh-dock.sh`)
- [x] Example logo-only theme pack (`themes/example/`)
- [x] Full Make workflow (preview, apply, coverage, init-theme, guards)
- [x] CI smoke (doctor, missing, init-theme, validate, coverage, preview)
- [x] Fish/bash/zsh shell completion (flag hints)
- [x] Docs batch: FAQ/AGENTS/ART/themes init-theme, CHANGELOG NAME guard, RELEASING missing
- [x] README / CONTRIBUTING / SUPPORT links to RELEASING and Make workflow
- [x] PR template `make help` / `make preview` checks
- [x] Makefile help examples for THEME/NAME
- [x] Batch #137-145: ROADMAP/CHANGELOG batch, CI chmod helpers + make themes, RELEASING/FAQ validate, install-deps make help, ARCHITECTURE CI note, PR template validate
- [x] Batch #146-155: make themes/version docs, CI make version, AGENTS/ARCHITECTURE/CONTRIBUTING/SUPPORT/PR template
- [x] Batch #156-159: ROADMAP/CHANGELOG batch, RELEASING make version, FAQ make themes
- [x] Batch #160-169: CI make install-deps, Makefile help themes/version, PR template make version, README/CONTRIBUTING/AGENTS/ARCHITECTURE/RELEASING
- [x] Batch #179-188: make status/verify CI, list/dock docs, CONTRIBUTING/SUPPORT/RELEASING, themes/example Make workflow
- [x] Batch #189-196: make refresh CI, RELEASING status/verify/refresh, FAQ/themes README/Makefile/PR template
- [x] Batch #197-204: make revert CI, README/FAQ revert, Makefile refresh/revert, ARCHITECTURE/CHANGELOG/PR template
- [x] Batch #205-218: make extract CI, extract/revert docs, CONTRIBUTING status/verify, FAQ list/dock, themes READMEs
- [x] Batch #219-234: make apply CI, extract/apply docs, SAFETY/AGENTS/Makefile/FAQ/install-deps

## Non-goals

- Replacing `.icns` / `Assets.car` / `Info.plist`
- Ad-hoc `codesign --sign`
- Fighting SIP / root-owned apps
