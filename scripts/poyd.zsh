# Zsh completion for poyd. Add to ~/.zshrc:
#   source /path/to/party-on-your-dock/scripts/poyd.zsh

_poyd() {
  local -a commands
  commands=(
    list dock extract apply apply-one revert verify status doctor version missing themes init-theme help
  )

  if (( CURRENT == 2 )); then
    _describe 'command' commands
    return
  fi

  case "${words[2]}" in
    apply|missing|init-theme)
      if (( CURRENT == 3 )); then
        local -a themes
        themes=(${${(f)"$(find themes -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null)"}:#})
        _describe 'theme' themes
      fi
      ;;
    apply-one)
      if (( CURRENT == 3 )); then
        local -a apps
        apps=(${${(f)"$(./scripts/poyd list 2>/dev/null)"}:#})
        _describe 'app' apps
      fi
      ;;
  esac
}

compdef _poyd poyd ./scripts/poyd
