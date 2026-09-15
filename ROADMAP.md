# Roadmap

Near-term ideas for party-on-your-dock. None of these require editing app bundles.

## Next

- [ ] CONTRIBUTING Make workflow section
- [ ] FAQ `make preview` mention
- [ ] README shell completion note
- [ ] CI `make help` smoke step
- [ ] CHANGELOG doc batch entry
- [ ] SUPPORT link to `themes/example/`

## Shipped

- [x] `poyd missing <theme>` — list Dock apps without a theme PNG
- [x] Theme pack validation script (`scripts/validate-theme.sh`)
- [x] Optional dry-run for apply/revert (`--dry-run`)
- [x] Keep `make` targets in sync with new CLI commands
- [x] Per-theme coverage report (`scripts/theme-coverage.sh`)
- [x] Safer Dock refresh helpers (`scripts/refresh-dock.sh`)
- [x] Example logo-only theme pack (`themes/example/`)
- [x] `make refresh` / `make preview` targets
- [x] CI smoke (refresh-dock, make preview)
- [x] Fish/bash/zsh shell completion
- [x] AGENTS.md Make shortcuts table
- [x] Shell completion in ARCHITECTURE.md

## Non-goals

- Replacing `.icns` / `Assets.car` / `Info.plist`
- Ad-hoc `codesign --sign`
- Fighting SIP / root-owned apps
