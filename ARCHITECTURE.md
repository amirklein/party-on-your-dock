# Architecture

party-on-your-dock is an **agent-operated CLI**, not a GUI app.

## Components

| Piece | Role |
|-------|------|
| `scripts/poyd.swift` | macOS CLI: list/extract/apply/revert/verify/status/doctor |
| `scripts/validate-theme.sh` | Check theme PNG filenames vs `/Applications` |
| `scripts/theme-coverage.sh` | Dock coverage report for a theme pack |
| `scripts/refresh-dock.sh` | Safe Dock/Finder refresh (no bundle edits) |
| `AGENTS.md` | Agent playbook for theme prompts |
| `themes/<slug>/` | Generated logo-only PNG packs |
| `originals/` | Local art references (gitignored) |

## Apply path (safe)

```
themes/<slug>/App.png
        ↓
  fileicon set / NSWorkspace.setIcon
        ↓
  custom icon on Foo.app wrapper
        ↓
  codesign verify (must stay valid)
```

Never write inside `Foo.app/Contents/`.

## Scope

Default target set = **Dock apps** (`poyd dock`, `--dock`). Full `/Applications` is optional.

## Revert path

`poyd revert` clears custom icons via `fileicon rm` — stock bundle icons return. No bundle restore.

## Dock refresh (safe)

After apply, quit themed apps if needed, then:

```bash
./scripts/refresh-dock.sh
```

Clears icon caches and restarts Dock/Finder only — never writes inside `.app/Contents/`.
