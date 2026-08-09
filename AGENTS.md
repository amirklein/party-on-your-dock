# Agent instructions — party-on-your-dock

You are operating **party-on-your-dock**: a local macOS toolkit that restyles app icons from a theme prompt (e.g. "Nintendo 64", "retro", "vaporwave") and applies them to apps in `/Applications`.

When the user says anything like **"change my theme to X"**, **"party theme: X"**, or **"restyle my dock as X"**, follow this workflow end-to-end. Do not ask whether to proceed unless a step fails or they limited scope (e.g. only Slack and Spotify).

## Workflow

### 1. Normalize the theme slug
- Lowercase, hyphens, ASCII: `Nintendo 64` → `n64`, `Retro Synthwave` → `retro-synthwave`.
- Theme directory: `themes/<slug>/`.

### 2. Ensure originals exist
```bash
./scripts/poyd extract
```
Skip if `originals/` already has the apps you need. Originals are machine-local and gitignored.

### 3. Decide which apps to theme
```bash
./scripts/poyd list
```
Default v1 scope: **user apps in `/Applications`** that have a matching PNG in the theme folder after generation. Prefer apps the user names; otherwise theme a sensible batch of common third-party apps (skip if extract/apply fails for an app).

Do **not** fight system-protected apps. If `setIcon` fails, skip and continue.

### 4. AI-restyle each icon
For each target app:
1. Read the source image from `originals/<AppName>.png` (preferred) or the live app icon.
2. Generate a **restyled** icon with the user's theme. Requirements:
   - Keep the app **recognizable** (same subject/logo silhouette when possible).
   - Square PNG, ideally **1024×1024**, with transparency if it fits the theme.
   - No tiny unreadable text; no watermark; fill the canvas like a real macOS icon.
   - Prompt pattern: *Restyle this macOS app icon in the style of \<theme\>. Preserve the core symbol so the app stays identifiable. Output a single square app icon.*
3. Save as `themes/<slug>/<AppName>.png` where `<AppName>` matches `./scripts/poyd list` exactly (e.g. `Slack.png`, `Google Chrome.png`).

Use whatever image generation / edit capability you have in this environment (Cursor image tools, etc.). Prefer **edit/restyle of the original** over inventing a new logo from scratch.

### 5. Apply the theme
Prefer `fileicon` installed (`brew install fileicon`). `./scripts/poyd apply` uses it when available and flushes Dock/icon caches afterward.
```bash
./scripts/poyd apply <slug>
```
Or limited:
```bash
./scripts/poyd apply <slug> --only Slack Spotify
```

If the user says icons look unchanged, re-apply and ensure caches were flushed (the CLI does this). Do not assume setIcon alone updated the Dock.

### 6. Confirm
- Tell the user the theme slug, how many icons applied, and any skips/failures.
- Mention they can revert with `./scripts/poyd revert` (or you can run it if they ask).

## Revert
```bash
./scripts/poyd revert
./scripts/poyd revert --only Slack
```

## Commands cheat sheet
| Command | Purpose |
|--------|---------|
| `./scripts/poyd list` | List app names in `/Applications` |
| `./scripts/poyd extract` | Backup current icons → `originals/` |
| `./scripts/poyd apply <theme>` | Apply `themes/<theme>/*.png` |
| `./scripts/poyd apply-one AppName path.png` | Apply one icon |
| `./scripts/poyd revert` | Restore originals / clear custom icons |

## Repo layout
```
themes/<slug>/<AppName>.png   # generated theme packs (committable)
originals/<AppName>.png       # local backups (gitignored)
scripts/poyd                  # CLI entrypoint
AGENTS.md                     # this file
```

## Product intent (v1)
- Agent-driven, not a GUI.
- AI restyle from a text theme.
- Fun, reversible Dock makeovers for everyday `/Applications` apps.
