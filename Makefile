.PHONY: help dock list themes status verify extract doctor version install-deps

POYD := ./scripts/poyd

help:
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
