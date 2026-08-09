# party-on-your-dock

Theme your Mac Dock like a costume party. Open this repo in **Cursor**, **Codex**, or **Claude Code**, say something like:

> Change my theme to Nintendo 64

…and the agent restyles your app icons and applies them.

## Quick start

```bash
chmod +x scripts/poyd
./scripts/poyd extract          # backup current icons → originals/
# agent generates themes/<slug>/*.png from your prompt
./scripts/poyd apply n64        # apply a theme pack
./scripts/poyd revert           # undo
```

## How it works

1. **Extract** — saves current icons under `originals/` (local only).
2. **Restyle** — an agent AI-edits each icon to match your theme into `themes/<slug>/`.
3. **Apply** — writes custom icons onto apps in `/Applications` via `NSWorkspace`.

Agents: read [`AGENTS.md`](./AGENTS.md).

## Requirements

- macOS
- Swift (ships with Xcode / CLT)
- Permission to modify app icons in `/Applications`

## License

MIT
