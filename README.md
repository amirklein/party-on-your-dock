# party-on-your-dock

Theme your Mac Dock like a costume party. Open this repo in **Cursor**, **Codex**, or **Claude Code**, say something like:

> Change my theme to Nintendo 64

…and the agent restyles your app icons and applies them.

## Quick start

```bash
chmod +x scripts/poyd
./scripts/poyd extract                    # art-reference PNGs → originals/
./scripts/poyd init-theme "Nintendo 64"   # → themes/n64/
# agent generates logo-only themes/<slug>/*.png from your prompt
./scripts/poyd apply n64                  # safe custom icons only
./scripts/poyd themes                     # list packs
./scripts/poyd revert                     # clear custom icons → stock
```

Or via Make:

```bash
make help
make dock
make status
make doctor
make verify
```

## How it works

1. **Extract** — PNG renders under `originals/` (local only, for AI reference).
2. **Restyle** — agent generates **logo-only** transparent PNGs into `themes/<slug>/`.
3. **Apply** — `fileicon` custom icons on the `.app` (never edits files inside the bundle).

Agents: read [`AGENTS.md`](./AGENTS.md) and [`SAFETY.md`](./SAFETY.md) — no bundle surgery, logo-only art, easy revert.

Want to contribute? See [`CONTRIBUTING.md`](./CONTRIBUTING.md).

## Requirements

- macOS
- Swift (ships with Xcode / CLT)
- [`fileicon`](https://github.com/mklement0/fileicon) (`brew install fileicon`)
- **App Management** permission for your agent app (System Settings → Privacy & Security)

## Safety

`./scripts/poyd verify` checks code signatures. Apply/revert never modify files inside `.app/Contents`.

## Changelog

See [`CHANGELOG.md`](./CHANGELOG.md).

## Security

See [`SECURITY.md`](./SECURITY.md) for vulnerability reporting and hard security boundaries.

## Community

See [`CODE_OF_CONDUCT.md`](./CODE_OF_CONDUCT.md).

## License

MIT
