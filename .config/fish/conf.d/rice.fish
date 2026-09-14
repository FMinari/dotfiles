# Visual do terminal (cores seguem o tema do Noctalia). Comandos de customização: `rice help`

# Prompt estiloso — só ativa se o starship estiver instalado
if status is-interactive; and command -q starship
    starship init fish | source
end

complete -c rice -f -n __fish_use_subcommand -a "hypr cores visual anim binds regras barra prompt reload check tema paleta wall keys backup help"
complete -c rice -f -n "__fish_seen_subcommand_from tema" -a "menu proximo (path basename -E ~/.config/rice/temas/*.conf)"
complete -c rice -f -n "__fish_seen_subcommand_from paleta" -a "Tokyo-Night Catppuccin Dracula Nord Gruvbox Kanagawa wallpaper"
complete -c rice -n "__fish_seen_subcommand_from wall" -a "random" -F
