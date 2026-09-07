# Roadmap

Near-term ideas for party-on-your-dock. None of these require editing app bundles.

## Next

- [x] `poyd missing <theme>` — list Dock apps without a theme PNG
- [x] Theme pack validation script (`scripts/validate-theme.sh`) (PNG names vs Dock / Applications)
- [x] Optional dry-run for apply/revert (`--dry-run` on apply/revert)
- [x] Keep `make` targets in sync with new CLI commands

## Later

<<<<<<< HEAD
- [x] Per-theme coverage report (`scripts/theme-coverage.sh`)
- [ ] Safer Dock refresh helpers that never touch `.app/Contents`
- [x] Example logo-only theme pack (`themes/example/` README scaffold)
=======
- [ ] Per-theme coverage report (`themes/<slug>` vs Dock)
- [x] Safer Dock refresh helpers (`scripts/refresh-dock.sh`; never touches `.app/Contents`)
- [ ] Example logo-only theme pack (small, documented)
>>>>>>> 7725992 (Add refresh-dock.sh for safe Dock icon refresh.)

## Non-goals

- Replacing `.icns` / `Assets.car` / `Info.plist`
- Ad-hoc `codesign --sign`
- Fighting SIP / root-owned apps
