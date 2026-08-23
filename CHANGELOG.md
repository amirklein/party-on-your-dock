# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- CLI: `list`, `dock`, `extract`, `apply`, `apply-one`, `revert`, `verify`, `status`, `doctor`, `themes`, `init-theme`
- Safety docs: `SAFETY.md`, `SECURITY.md`, hard rules in `AGENTS.md`
- Repo hygiene: CONTRIBUTING, CODE_OF_CONDUCT, PR/issue templates, Dependabot, EditorConfig, Makefile shortcuts

### Security
- Custom-icon-only apply path; never edit `.app/Contents` or ad-hoc resign apps
