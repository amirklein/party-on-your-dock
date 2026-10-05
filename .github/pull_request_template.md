## Summary
- 

## Why
- 

## Safety Checklist
- [ ] I did **not** edit anything inside any `.app/Contents/` path
- [ ] I did **not** replace `.icns`, `Assets.car`, or `Info.plist`
- [ ] I did **not** use `codesign --sign` / ad-hoc re-signing
- [ ] I only used safe custom-icon paths (`fileicon` / `NSWorkspace.setIcon`)
- [ ] I tested `./scripts/poyd help`
- [ ] I tested `make doctor` (or `./scripts/poyd doctor`)
- [ ] I tested `make help`
- [ ] I tested `make themes` (if CLI/Make changed)
- [ ] I tested `make validate THEME=example` (if theme PNGs changed) || true
- [ ] I tested `make preview THEME=example` (or `--dry-run`) when touching apply flow

## Test Plan
- [ ] 

## Scope
- [ ] This PR is intentionally small and focused
