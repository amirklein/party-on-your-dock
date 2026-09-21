# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- CLI: `list`, `dock`, `extract`, `apply`, `apply-one`, `revert`, `verify`, `status`, `doctor`, `version`, `missing`, `themes`, `init-theme`; `--dry-run` on `apply`/`revert`
- Scripts: `install-deps.sh`, `validate-theme.sh`, `theme-coverage.sh`, `refresh-dock.sh`
- Shell completion: `scripts/poyd.bash`, `scripts/poyd.zsh`, `scripts/poyd.fish`; bash flag completion for `--dock` / `--dry-run`
- Docs: FAQ, SUPPORT, ROADMAP, RELEASING, CONTRIBUTING, CODE_OF_CONDUCT, ART.md, ARCHITECTURE.md; AGENTS Make shortcuts table; CONTRIBUTING Make workflow
- Example theme scaffold: `themes/example/`
- CI: macOS smoke (help, themes, doctor, status, version, missing, validate, dry-run, coverage, refresh-dock, make preview, make preview-revert, make help, install-deps)
- Repo hygiene: Makefile shortcuts (`apply`, `coverage`, `refresh`, `preview`, `preview-revert`), Dependabot, EditorConfig, issue/PR templates, CODEOWNERS

### Security
- Custom-icon-only apply path; never edit `.app/Contents` or ad-hoc resign apps
