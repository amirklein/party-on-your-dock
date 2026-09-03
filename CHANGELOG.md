# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- CLI: `list`, `dock`, `extract`, `apply`, `apply-one`, `revert`, `verify`, `status`, `doctor`, `version`, `missing`, `themes`, `init-theme`
- Scripts: `install-deps.sh`, `validate-theme.sh`
- Safety docs: `SAFETY.md`, `SECURITY.md`, hard rules in `AGENTS.md`
- Docs: FAQ, SUPPORT, ROADMAP, RELEASING, CONTRIBUTING, CODE_OF_CONDUCT
- CI: macOS smoke workflow (help, themes, doctor, status, version)
- Repo hygiene: Makefile shortcuts, Dependabot, EditorConfig, issue/PR templates

### Security
- Custom-icon-only apply path; never edit `.app/Contents` or ad-hoc resign apps
