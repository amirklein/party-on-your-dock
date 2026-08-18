# Security policy

## Supported versions

This project is currently maintained on `main`.

## Reporting a vulnerability

Please open a private report instead of a public issue when possible.

Include:
- What command you ran
- macOS version
- Expected vs actual behavior
- Any evidence that app signing / Gatekeeper behavior changed

## Security boundaries

`party-on-your-dock` intentionally treats these as hard boundaries:

- Never write inside any `.app/Contents/` path
- Never replace `.icns`, `Assets.car`, or `Info.plist`
- Never ad-hoc re-sign apps (`codesign --sign -`)

If you find a path in the CLI or docs that suggests violating these constraints, please report it.
