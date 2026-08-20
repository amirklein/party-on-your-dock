.PHONY: help dock list themes status verify extract

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
