# Roadmap

Near-term ideas for party-on-your-dock. None of these require editing app bundles.

## Next

- [ ] FAQ: document `make init-theme NAME=...`
- [ ] README: mention `make init-theme` in Make block
- [ ] CHANGELOG: note Makefile NAME guard + PR template batch

## Shipped

- [x] `poyd missing <theme>` — list Dock apps without a theme PNG
- [x] Theme pack validation script (`scripts/validate-theme.sh`)
- [x] Optional dry-run for apply/revert (`--dry-run`)
- [x] Keep `make` targets in sync with new CLI commands
- [x] Per-theme coverage report (`scripts/theme-coverage.sh`)
- [x] Safer Dock refresh helpers (`scripts/refresh-dock.sh`)
- [x] Example logo-only theme pack (`themes/example/`)
- [x] `make refresh` / `make preview` / `make preview-revert` targets
- [x] CI smoke (validate, coverage, preview, preview-revert, help, install-deps, init-theme)
- [x] Fish/bash/zsh shell completion (flag hints)
- [x] Makefile `THEME` / `NAME` guards for scoped targets
- [x] ARCHITECTURE completion flags + Make shortcuts docs
- [x] RELEASING make coverage / preview-revert smoke
- [x] PR template `make help` check
- [x] CONTRIBUTING THEME/NAME Make requirements

## Non-goals

- Replacing `.icns` / `Assets.car` / `Info.plist`
- Ad-hoc `codesign --sign`
- Fighting SIP / root-owned apps
