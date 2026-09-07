# example

Documented **example theme pack** — no bundled PNGs. Copy this folder as a starting point:

```bash
cp -R themes/example themes/my-theme
# generate logo-only transparent PNGs named like ./scripts/poyd dock apps
```

Workflow:

```bash
./scripts/poyd missing my-theme --dock
./scripts/validate-theme.sh my-theme
./scripts/theme-coverage.sh my-theme --dock
./scripts/poyd apply my-theme --dock --dry-run
./scripts/poyd apply my-theme --dock
```

Art rules: [`ART.md`](../../ART.md) — logo only, transparent background.
