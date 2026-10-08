# Roadmap

Near-term ideas for party-on-your-dock. None of these require editing app bundles.

## Next

- [ ] CI smoke: \`make version\`
- [ ] RELEASING / README: \`make themes\` in smoke docs
- [ ] AGENTS: Make shortcuts table (\`make themes\`, \`make version\`)
- [ ] PR template: \`make themes\` check

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

## Non-goals

- Replacing `.icns` / `Assets.car` / `Info.plist`
- Ad-hoc `codesign --sign`
- Fighting SIP / root-owned apps
