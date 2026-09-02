# Architecture

party-on-your-dock is an **agent-operated CLI**, not a GUI app.

## Components

| Piece | Role |
|-------|------|
| `scripts/poyd.swift` | macOS CLI: list/extract/apply/revert/verify/status/doctor |
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
