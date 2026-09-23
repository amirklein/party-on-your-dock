.PHONY: help dock list themes status verify extract doctor version install-deps missing validate init-theme revert apply coverage refresh preview preview-revert

POYD := ./scripts/poyd

# Require THEME for theme-scoped targets (init-theme uses NAME)
require-theme = $(if $(THEME),,$(error THEME is required, e.g. make apply THEME=n64))

help:
	@echo "Make targets: dock list themes status verify extract doctor version install-deps missing validate coverage init-theme apply revert refresh preview preview-revert"
	@echo "Theme-scoped targets need THEME=<slug> (init-theme uses NAME=...)"
	@$(POYD) help

dock:
	@$(POYD) dock

list:
	@$(POYD) list

themes:
	@$(POYD) themes

status:
	@$(POYD) status --dock

verify:
	@$(POYD) verify --dock

extract:
	@$(POYD) extract --dock

doctor:
	@$(POYD) doctor

version:
	@$(POYD) version

install-deps:
	@./scripts/install-deps.sh

missing: require-theme
	@$(POYD) missing $(THEME) --dock

validate: require-theme
	@./scripts/validate-theme.sh $(THEME)

init-theme:
	@$(POYD) init-theme "$(NAME)"

revert:
	@$(POYD) revert --dock

apply: require-theme
	@$(POYD) apply $(THEME) --dock

coverage: require-theme
	@./scripts/theme-coverage.sh $(THEME) --dock

refresh:
	@./scripts/refresh-dock.sh

preview: require-theme
	@$(POYD) apply $(THEME) --dock --dry-run

preview-revert:
	@$(POYD) revert --dock --dry-run
