# Safety: never break apps when theming icons

Incident (Aug 2026): replacing `Contents/Resources/*.icns` and running `codesign --sign -` made apps show **“damaged and can’t be opened”** and broke signed features (e.g. ChatGPT connectors).

## Guarantees

| Allowed | Forbidden |
|--------|-----------|
| `fileicon set` / `NSWorkspace.setIcon` custom icons on the `.app` | Writing inside `Foo.app/Contents/` |
| `fileicon rm` / clear custom icon (`poyd revert`) | Replacing `.icns`, `Assets.car`, `Info.plist` |
| PNG theme packs under `themes/` | `codesign --force --sign -` / ad-hoc resign |
| Art-reference PNGs under `originals/` | “Fixing” Dock visibility by patching the bundle |

## Agent / CLI contract

- [`AGENTS.md`](./AGENTS.md) hard rules — agents must refuse bundle surgery.
- [`.cursor/rules/party-on-your-dock.mdc`](./.cursor/rules/party-on-your-dock.mdc) — always-on Cursor rule.
- `./scripts/poyd apply` — custom icons only; rolls back if `codesign --verify` flips from valid → invalid.
- `./scripts/poyd verify` — report apps with broken signatures.
- `./scripts/poyd revert` — clears custom icons only (does **not** re-glue `originals/*.png`).

If the Dock still shows stock icons while apps are running, quit the app / refresh Dock — **do not** escalate to bundle edits.
