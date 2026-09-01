# Bash completion for poyd. Source with:
#   source /path/to/party-on-your-dock/scripts/poyd.bash

_poyd_completions() {
  local cur prev
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  local commands="list dock extract apply apply-one revert verify status doctor version missing themes init-theme help"

  if [[ ${COMP_CWORD} -eq 1 ]]; then
    COMPREPLY=( $(compgen -W "${commands}" -- "${cur}") )
    return
  fi

  case "${COMP_WORDS[1]}" in
    apply|missing|init-theme)
      if [[ ${COMP_CWORD} -eq 2 ]]; then
        if [[ -d themes ]]; then
          COMPREPLY=( $(compgen -W "$(find themes -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)" -- "${cur}") )
        fi
      fi
      ;;
    apply-one)
      if [[ ${COMP_CWORD} -eq 2 ]]; then
        COMPREPLY=( $(compgen -W "$(./scripts/poyd list 2>/dev/null)" -- "${cur}") )
      fi
      ;;
  esac
}

complete -F _poyd_completions poyd ./scripts/poyd
