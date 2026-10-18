# Roadmap

Near-term ideas for party-on-your-dock. None of these require editing app bundles.

## Next

- [ ] CI smoke: `make status` and `make verify` (Dock-scoped)
- [ ] RELEASING / README: `make list` and `make dock` smoke
- [ ] CONTRIBUTING / SUPPORT: `make list` in Make workflow
- [ ] themes/example: Make shortcuts for missing/validate

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
- [x] Batch #170 follow-up: make list/dock CI, install-deps docs, FAQ/ART/themes README, PR template (direct to main)

## Non-goals

- Replacing `.icns` / `Assets.car` / `Info.plist`
- Ad-hoc `codesign --sign`
- Fighting SIP / root-owned apps
