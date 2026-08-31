# Releasing

party-on-your-dock is currently versioned lightly via `./scripts/poyd version`.

## Checklist

1. Update `poydVersion` in `scripts/poyd.swift` if needed
2. Update [`CHANGELOG.md`](./CHANGELOG.md) under `[Unreleased]` → a dated section
3. Run local smoke:
   ```bash
   ./scripts/poyd doctor
   ./scripts/poyd version
   ./scripts/poyd themes
   ./scripts/poyd status --dock
   ```
4. Open a PR; confirm CI smoke is green
5. Merge to `main`

## Safety reminder

Releases must never introduce bundle edits (`.icns` / `Assets.car` / resign). See [`SAFETY.md`](./SAFETY.md).
