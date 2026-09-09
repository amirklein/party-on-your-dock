# Fish completion for poyd. Add to ~/.config/fish/config.fish:
#   source /path/to/party-on-your-dock/scripts/poyd.fish

function __poyd_themes
    find themes -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null
end

function __poyd_apps
    ./scripts/poyd list 2>/dev/null
end

complete -c poyd -f
complete -c poyd -n "not __fish_seen_subcommand_from list dock extract apply apply-one revert verify status doctor version missing themes init-theme help" -a "list dock extract apply apply-one revert verify status doctor version missing themes init-theme help"
complete -c poyd -n "__fish_seen_subcommand_from apply missing init-theme" -a "(__poyd_themes)"
complete -c poyd -n "__fish_seen_subcommand_from apply-one" -a "(__poyd_apps)"
complete -c ./scripts/poyd -f
complete -c ./scripts/poyd -n "not __fish_seen_subcommand_from list dock extract apply apply-one revert verify status doctor version missing themes init-theme help" -a "list dock extract apply apply-one revert verify status doctor version missing themes init-theme help"
complete -c ./scripts/poyd -n "__fish_seen_subcommand_from apply missing init-theme" -a "(__poyd_themes)"
complete -c ./scripts/poyd -n "__fish_seen_subcommand_from apply-one" -a "(__poyd_apps)"
