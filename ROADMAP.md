# Roadmap

Near-term ideas for party-on-your-dock. None of these require editing app bundles.

## Next

- [ ] CI smoke step for `make preview`
- [ ] Document `make preview` in README
- [ ] SAFETY.md mention `refresh-dock.sh`
- [ ] `install-deps` chmod `poyd.fish`

## Shipped

- [x] `poyd missing <theme>` — list Dock apps without a theme PNG
- [x] Theme pack validation script (`scripts/validate-theme.sh`)
- [x] Optional dry-run for apply/revert (`--dry-run`)
- [x] Keep `make` targets in sync with new CLI commands
- [x] Per-theme coverage report (`scripts/theme-coverage.sh`)
- [x] Safer Dock refresh helpers (`scripts/refresh-dock.sh`)
- [x] Example logo-only theme pack (`themes/example/`)
- [x] `make refresh` target for `scripts/refresh-dock.sh`
- [x] CI smoke step for `refresh-dock.sh`
- [x] Document helper scripts in ARCHITECTURE.md
- [x] `make preview` target wrapping `apply --dry-run`
- [x] Fish shell completion (`scripts/poyd.fish`)
- [x] Link example theme pack from main README

## Non-goals

- Replacing `.icns` / `Assets.car` / `Info.plist`
- Ad-hoc `codesign --sign`
- Fighting SIP / root-owned apps
