.PHONY: help dock list themes status verify extract doctor version install-deps missing validate init-theme revert apply coverage

POYD := ./scripts/poyd

help:
	@echo "Make targets: dock list themes status verify extract doctor version install-deps missing validate coverage init-theme apply revert"
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

missing:
	@$(POYD) missing $(THEME) --dock

validate:
	@./scripts/validate-theme.sh $(THEME)

init-theme:
	@$(POYD) init-theme "$(NAME)"

revert:
	@$(POYD) revert --dock

apply:
	@$(POYD) apply $(THEME) --dock

coverage:
	@./scripts/theme-coverage.sh $(THEME) --dock
