# Roadmap

Near-term ideas for party-on-your-dock. None of these require editing app bundles.

## Next

- [ ] Zsh/fish completion for `--dock` / `--dry-run` flags
- [ ] `install-deps` chmod bash/zsh completion scripts
- [ ] ARCHITECTURE.md Make shortcuts section
- [ ] themes/README preview-revert in workflow
- [ ] AGENTS apply workflow: preview-revert before apply

## Shipped

- [x] `poyd missing <theme>` — list Dock apps without a theme PNG
- [x] Theme pack validation script (`scripts/validate-theme.sh`)
- [x] Optional dry-run for apply/revert (`--dry-run`)
- [x] Keep `make` targets in sync with new CLI commands
- [x] Per-theme coverage report (`scripts/theme-coverage.sh`)
- [x] Safer Dock refresh helpers (`scripts/refresh-dock.sh`)
- [x] Example logo-only theme pack (`themes/example/`)
- [x] `make refresh` / `make preview` / `make preview-revert` targets
- [x] CI smoke (refresh-dock, make preview, make preview-revert, make help, install-deps)
- [x] Fish/bash/zsh shell completion (bash flag hints)
- [x] AGENTS.md Make shortcuts table
- [x] Shell completion in ARCHITECTURE.md
- [x] CONTRIBUTING Make workflow section
- [x] SUPPORT / ART / CONTRIBUTING links to `themes/example/`
- [x] RELEASING Make smoke steps
- [x] PR template `make doctor` check

## Non-goals

- Replacing `.icns` / `Assets.car` / `Info.plist`
- Ad-hoc `codesign --sign`
- Fighting SIP / root-owned apps
