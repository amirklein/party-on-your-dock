.PHONY: help dock list themes verify extract

POYD := ./scripts/poyd

help:
	@$(POYD) help

dock:
	@$(POYD) dock

list:
	@$(POYD) list

themes:
	@$(POYD) themes

verify:
	@$(POYD) verify --dock

extract:
	@$(POYD) extract --dock
