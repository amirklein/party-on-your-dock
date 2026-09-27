# Roadmap

Near-term ideas for party-on-your-dock. None of these require editing app bundles.

## Next

- [ ] CI smoke for `make validate`
- [ ] Makefile require `NAME` for `init-theme`
- [ ] RELEASING.md: `make coverage` in smoke checklist
- [ ] CHANGELOG entry for coverage/THEME-guard batch
- [ ] ARCHITECTURE: document fish/zsh flag completion
- [ ] PR template: `make help` smoke check

## Shipped

- [x] `poyd missing <theme>` — list Dock apps without a theme PNG
- [x] Theme pack validation script (`scripts/validate-theme.sh`)
- [x] Optional dry-run for apply/revert (`--dry-run`)
- [x] Keep `make` targets in sync with new CLI commands
- [x] Per-theme coverage report (`scripts/theme-coverage.sh`)
- [x] Safer Dock refresh helpers (`scripts/refresh-dock.sh`)
- [x] Example logo-only theme pack (`themes/example/`)
- [x] `make refresh` / `make preview` / `make preview-revert` targets
- [x] CI smoke (preview, preview-revert, help, install-deps, coverage)
- [x] Fish/bash/zsh shell completion (flag hints on all three)
- [x] AGENTS / themes README / example preview-revert workflow
- [x] ARCHITECTURE Make shortcuts section
- [x] `install-deps` chmod bash/zsh/fish completion scripts
- [x] Makefile `THEME` required for theme-scoped targets
- [x] README / SUPPORT install-deps and Make workflow links

## Non-goals

- Replacing `.icns` / `Assets.car` / `Info.plist`
- Ad-hoc `codesign --sign`
- Fighting SIP / root-owned apps
