# Roadmap

Near-term ideas for party-on-your-dock. None of these require editing app bundles.

## Next

- [ ] SAFETY / SUPPORT: `make preview` and `make preview-revert` in safety docs
- [ ] ROADMAP / CHANGELOG: keep batch notes in sync after merges
- [ ] Makefile: document `make init-theme` NAME guard in help text
- [ ] FAQ: link AGENTS playbook for theme prompts

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
- [x] Batch #235-245: apply/coverage docs, SAFETY refresh/doctor, themes/README extract, RELEASING/PR template apply
- [x] Batch #246-258: missing/validate README, CONTRIBUTING validation/setup, coverage PR template/SUPPORT, SECURITY verify, CI completion chmod
- [x] Batch #259-273: FAQ missing, PR template missing, CONTRIBUTING make help, SUPPORT/ARCHITECTURE completion, validate AGENTS, CI completion test
- [x] Batch #274-279: preview-revert PR template, FAQ scaffold validate, ARCHITECTURE CI completion, README completion hint
- [x] Batch #280-287: RELEASING/CONTRIBUTING/AGENTS/ART preview-revert, themes/example Make, install-deps completion echo

## Non-goals

- Replacing `.icns` / `Assets.car` / `Info.plist`
- Ad-hoc `codesign --sign`
- Fighting SIP / root-owned apps
