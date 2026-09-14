function rice --description "Atalhos pra customizar o desktop (Hyprland + Noctalia)"
    set -l hypr ~/.config/hypr
    set -l editor micro
    set -q EDITOR_RICE; and set editor $EDITOR_RICE

    switch "$argv[1]"
        case hypr
            $editor $hypr/hyprland.lua $hypr/config/*.lua
        case cores colors
            $editor $hypr/config/colors.lua
        case visual look
            $editor $hypr/config/decorations.lua
        case anim
            $editor $hypr/config/animations.lua
        case binds
            $editor $hypr/config/binds.lua
        case regras rules
            $editor $hypr/config/windowrules.lua
        case barra bar noctalia
            $editor ~/.config/noctalia/config.toml
        case prompt
            $editor ~/.config/starship.toml
        case keys atalhos
            if test "$argv[2]" = edit
                $editor $hypr/atalhos.txt
            else
                cat $hypr/atalhos.txt
            end
        case reload
            hyprctl reload >/dev/null
            noctalia msg config-reload >/dev/null
            noctalia msg templates-apply >/dev/null
            rice check
        case check
            set -l errs (hyprctl configerrors | string trim | string match -rv '^$')
            if test -z "$errs"
                set_color green; echo "✓ Hyprland sem erros"; set_color normal
            else
                set_color red; echo "✗ Hyprland:"; set_color normal
                printf '  %s\n' $errs
            end
            noctalia config validate
        case tema theme
            if test -z "$argv[2]"
                echo "Tema atual: "(string match -r '"[^"]*"' < $hypr/config/colors.lua | head -1)" · paleta: "(noctalia msg color-scheme-get)
                ~/.config/hypr/scripts/tema.sh
                echo "Uso: rice tema <nome>   ·   só a paleta: rice paleta <Catppuccin|Dracula|Nord…>"
            else
                ~/.config/hypr/scripts/tema.sh $argv[2]
            end
        case paleta
            # Só troca as cores do Noctalia, sem mexer em borda/wallpaper
            if test "$argv[2]" = wallpaper
                noctalia msg color-scheme-set wallpaper m3-tonal-spot
            else
                noctalia msg color-scheme-set builtin $argv[2]
            end
        case wall wallpaper
            if test -z "$argv[2]"; or test "$argv[2]" = random
                noctalia msg wallpaper-random
            else
                noctalia msg wallpaper-set (realpath $argv[2])
            end
        case backup
            set -l dest ~/.config-backup-rice-(date +%Y%m%d-%H%M)
            mkdir -p $dest
            cp -a $hypr ~/.config/noctalia ~/.config/fish ~/.config/starship.toml $dest/
            echo "Backup salvo em $dest"
        case '' help ajuda
            set_color magenta; echo "rice — mexer no visual sem decorar caminho"; set_color normal
            echo "
  Abrir config no editor:
    rice hypr      todos os arquivos do Hyprland
    rice cores     paleta de cores (colors.lua)
    rice visual    bordas, gaps, blur, sombra (decorations.lua)
    rice anim      animações
    rice binds     atalhos de teclado
    rice regras    regras de janela (flutuar, workspace fixo…)
    rice barra     barra / lockscreen / wallpaper (Noctalia)
    rice prompt    prompt do terminal (starship)

  Ações:
    rice reload            recarrega tudo e checa erros
    rice check             só checa erros
    rice tema [nome]       troca o tema inteiro (kurenai, vaporwave, tokyo-night, proximo)
    rice paleta <nome>     só as cores do Noctalia (Catppuccin, Dracula…)
    rice wall [arquivo]    troca wallpaper (sem arquivo = aleatório)
    rice keys [edit]       mostra (ou edita) a colinha de atalhos
    rice backup            copia as configs pra ~/.config-backup-rice-*
"
        case '*'
            echo "Não conheço '$argv[1]'. Veja: rice help"
            return 1
    end
end
