# Roadmap

Near-term ideas for party-on-your-dock. None of these require editing app bundles.

## Next

- [ ] `poyd missing <theme>` — list Dock apps without a theme PNG
- [ ] Theme pack validation script (PNG names vs Dock / Applications)
- [ ] Optional dry-run for apply/revert
- [ ] Keep `make` targets in sync with new CLI commands

## Later

- [ ] Per-theme coverage report (`themes/<slug>` vs Dock)
- [ ] Safer Dock refresh helpers that never touch `.app/Contents`
- [ ] Example logo-only theme pack (small, documented)

## Non-goals

- Replacing `.icns` / `Assets.car` / `Info.plist`
- Ad-hoc `codesign --sign`
- Fighting SIP / root-owned apps
