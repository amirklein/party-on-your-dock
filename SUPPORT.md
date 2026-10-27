# Support

## Self-serve

1. [`FAQ.md`](./FAQ.md) — Dock refresh, Gatekeeper, revert
2. [`SAFETY.md`](./SAFETY.md) — what is never allowed
3. [`AGENTS.md`](./AGENTS.md) — agent workflow for theme prompts
4. [`themes/example/`](./themes/example/) — documented theme pack scaffold
5. [`CONTRIBUTING.md`](./CONTRIBUTING.md#make-workflow) — Make workflow for theme packs (`make themes` lists packs)
6. `./scripts/install-deps.sh` or `make install-deps` — Homebrew fileicon + script permissions
7. `./scripts/poyd doctor` or `make doctor` — local setup checks
8. `make list` / `make dock` — list apps before theming
9. [`RELEASING.md`](./RELEASING.md) — release smoke checklist
10. `./scripts/refresh-dock.sh` or `make refresh` — safe Dock refresh (no bundle edits)
11. `make revert` — clear custom icons (Dock)

## Bugs / features

Use the GitHub issue templates:

- Bug report — include the exact `./scripts/poyd …` command and output
- Feature request — must remain possible without editing `.app/Contents`

## Security

See [`SECURITY.md`](./SECURITY.md). Do not post signing-break repro steps that require bundle surgery in public issues if a private report is more appropriate.
