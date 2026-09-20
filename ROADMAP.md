# Roadmap

Near-term ideas for party-on-your-dock. None of these require editing app bundles.

## Next

- [ ] `make preview-revert` target
- [ ] CI smoke for `install-deps.sh`
- [ ] SUPPORT link to `themes/example/`
- [ ] RELEASING.md Make smoke steps
- [ ] Bash completion for `--dock` / `--dry-run` flags
- [ ] PR template `make doctor` check

## Shipped

- [x] `poyd missing <theme>` — list Dock apps without a theme PNG
- [x] Theme pack validation script (`scripts/validate-theme.sh`)
- [x] Optional dry-run for apply/revert (`--dry-run`)
- [x] Keep `make` targets in sync with new CLI commands
- [x] Per-theme coverage report (`scripts/theme-coverage.sh`)
- [x] Safer Dock refresh helpers (`scripts/refresh-dock.sh`)
- [x] Example logo-only theme pack (`themes/example/`)
- [x] `make refresh` / `make preview` targets
- [x] CI smoke (refresh-dock, make preview, make help)
- [x] Fish/bash/zsh shell completion
- [x] AGENTS.md Make shortcuts table
- [x] Shell completion in ARCHITECTURE.md
- [x] CONTRIBUTING Make workflow section
- [x] FAQ `make preview` mention
- [x] README shell completion note
- [x] CHANGELOG doc batch entry

## Non-goals

- Replacing `.icns` / `Assets.car` / `Info.plist`
- Ad-hoc `codesign --sign`
- Fighting SIP / root-owned apps
