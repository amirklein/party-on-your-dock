# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- CLI: `list`, `dock`, `extract`, `apply`, `apply-one`, `revert`, `verify`, `status`, `doctor`, `version`, `missing`, `themes`, `init-theme`; `--dry-run` on `apply`/`revert`
- Scripts: `install-deps.sh`, `validate-theme.sh`, `theme-coverage.sh`, `refresh-dock.sh`
- Shell completion: `scripts/poyd.bash`, `scripts/poyd.zsh`, `scripts/poyd.fish`; flag completion for `--dock` / `--dry-run` (bash, zsh, fish)
- Docs: FAQ, SUPPORT, ROADMAP, RELEASING, CONTRIBUTING, CODE_OF_CONDUCT, ART.md, ARCHITECTURE.md; AGENTS Make shortcuts table; CONTRIBUTING Make workflow
- Example theme scaffold: `themes/example/`
- CI: macOS smoke (help, themes, doctor, status, version, missing, validate, dry-run, coverage, refresh-dock, make preview, make preview-revert, make help, make coverage, make doctor, make missing, make init-theme, install-deps, make version, make themes, make list, make dock, make status, make verify, make refresh, make revert, make extract, make apply)
- Docs/CI batch #235-245: RELEASING/PR apply, Makefile/ART coverage, SAFETY refresh/doctor, SUPPORT apply, themes/README extract, FAQ verify
- Docs/CI batch #219-234: make apply CI, extract/apply FAQ/AGENTS, RELEASING extract, PR template extract, SAFETY Make notes
- Docs/CI batch #205-218: make extract CI, RELEASING/PR template revert, CONTRIBUTING status/verify, FAQ/SUPPORT/ART/themes docs
- Docs/CI batch #197-204: make revert CI, README/FAQ revert, Makefile help, ARCHITECTURE/PR template refresh
- Docs/CI batch #189-196: make refresh CI, RELEASING smoke, FAQ/themes README, Makefile help, PR template verify
- Docs/CI batch #179-188: make status/verify CI, README/RELEASING list, CONTRIBUTING/SUPPORT, PR template status, themes/example
- Docs/CI batch #170 follow-up: make list/dock CI, install-deps across README/SUPPORT/CONTRIBUTING/PR template, FAQ setup, ART make missing
- Docs/CI batch #160-169: CI make install-deps, Makefile help themes/version, PR template/README/CONTRIBUTING/AGENTS/ARCHITECTURE/RELEASING
- Docs/CI batch #156-159: ROADMAP ship, RELEASING make version, FAQ make themes
- Docs/CI batch #146-155: ROADMAP ship, CI make version, RELEASING/README make themes, AGENTS make themes/version, ARCHITECTURE/CONTRIBUTING/SUPPORT/PR template
- Docs/CI batch #137-145: ROADMAP ship, CI chmod helpers + make themes, RELEASING/FAQ validate, install-deps hint, ARCHITECTURE CI, PR template validate
- Repo hygiene: Makefile shortcuts (`apply`, `coverage`, `refresh`, `preview`, `preview-revert`; Makefile requires `THEME=` / `NAME=` (inline guard fix #134) for theme targets; PR template `make help` / `make preview` checks; Makefile help examples; RELEASING make missing), Dependabot, EditorConfig, issue/PR templates, CODEOWNERS

### Security
- Custom-icon-only apply path; never edit `.app/Contents` or ad-hoc resign apps
