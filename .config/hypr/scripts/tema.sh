#!/usr/bin/env bash
# Troca o tema do sistema todo: bordas do Hyprland, paleta do Noctalia (barra,
# GTK, Qt, kitty, btop, prompt), wallpaper e tela de bloqueio.
# Uso:
#   tema.sh <nome>    aplica um tema (nomes = arquivos em ~/.config/rice/temas/*.conf)
#   tema.sh menu      escolhe num menu (SUPER+SHIFT+T)
#   tema.sh proximo   pula pro próximo tema da lista
#   tema.sh           lista os temas
set -euo pipefail

temas="$HOME/.config/rice/temas"
hypr_colors="$HOME/.config/hypr/config/colors.lua"
nome="${1:-}"

lista() { for f in "$temas"/*.conf; do basename "$f" .conf; done; }
atual() { sed -n 's/^RICE_THEME = "\([^"]*\)".*/\1/p' "$hypr_colors"; }
descricao() { sed -n '1s/^# *//p' "$temas/$1.conf"; }

case "$nome" in
    menu)
        escolha=$(for t in $(lista); do
                      marca="  "; [[ "$t" == "$(atual)" ]] && marca="● "
                      printf '%s%s  —  %s\n' "$marca" "$t" "$(descricao "$t")"
                  done | noctalia dmenu -p "Tema" || true)
        nome=$(awk '{print $1 == "●" ? $2 : $1}' <<<"$escolha")
        [[ -z "$nome" ]] && exit 0
        ;;
    proximo)
        mapfile -t todos < <(lista)
        for i in "${!todos[@]}"; do
            [[ "${todos[$i]}" == "$(atual)" ]] && nome="${todos[$(( (i + 1) % ${#todos[@]} ))]}"
        done
        [[ "$nome" == proximo ]] && nome="${todos[0]}"
        ;;
esac

conf="$temas/$nome.conf"
if [[ -z "$nome" || ! -f "$conf" ]]; then
    echo "Temas disponíveis:"
    for t in $(lista); do
        marca="  "; [[ "$t" == "$(atual)" ]] && marca="● "
        printf '  %s%-12s %s\n' "$marca" "$t" "$(descricao "$t")"
    done
    [[ -z "$nome" ]] && exit 0 || { echo "Não achei o tema '$nome'"; exit 1; }
fi

# shellcheck source=/dev/null
source <(sed "s|~|$HOME|g" "$conf")

noct="$HOME/.config/noctalia/config.toml"
[[ -f "$HOME/.config/hypr/config/themes/$HYPR_TEMA.lua" ]] || { echo "Falta themes/$HYPR_TEMA.lua"; exit 1; }

# 1. Hyprland
sed -i "s|^RICE_THEME = \"[^\"]*\"|RICE_THEME = \"$HYPR_TEMA\"|" "$hypr_colors"
hyprctl reload >/dev/null

# 2. Noctalia: config.toml (fonte da verdade) + comando ao vivo
sed -i \
    -e "/^\[theme\]/,/^\[/ s|^source = .*|source = \"$NOCTALIA_FONTE\"|" \
    -e "/^\[wallpaper\]/,/^\[/ s|^directory = .*|directory = \"$PASTA_WALL\"|" \
    -e "/^\[lockscreen\]/,/^\[/ s|^wallpaper = .*|wallpaper = \"$PASTA_WALL/$LOCK\"|" \
    "$noct"
case "$NOCTALIA_FONTE" in
    builtin)   sed -i "/^\[theme\]/,/^\[/ s|^builtin = .*|builtin = \"$NOCTALIA_PALETA\"|" "$noct" ;;
    custom)    sed -i "/^\[theme\]/,/^\[/ s|^custom_palette = .*|custom_palette = \"$NOCTALIA_PALETA\"|" "$noct" ;;
    community) sed -i "/^\[theme\]/,/^\[/ s|^community_palette = .*|community_palette = \"$NOCTALIA_PALETA\"|" "$noct" ;;
esac
# cursor do mouse: Hyprland agora, apps GTK e próximo login
if [[ -n "${CURSOR:-}" && -d "$HOME/.local/share/icons/$CURSOR" ]]; then
    hyprctl setcursor "$CURSOR" 24 >/dev/null
    gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR" 2>/dev/null || true
    sed -i "s|^gtk-cursor-theme-name=.*|gtk-cursor-theme-name=$CURSOR|" "$HOME/.config/gtk-3.0/settings.ini" 2>/dev/null || true
    sed -i -E "s|^export (HYPRCURSOR_THEME\|XCURSOR_THEME)=.*|export \1=\"$CURSOR\"|" "$HOME/.config/uwsm/env"
fi

# fonte do relógio grande (widgets do desktop e da tela de bloqueio)
if [[ -n "${FONTE_RELOGIO:-}" ]]; then
    sed -i -E "s|^(\s*)font_family = \".*\"|\1font_family = \"$FONTE_RELOGIO\"|" "$HOME/.local/state/noctalia/settings.toml"
fi
noctalia msg config-reload >/dev/null
noctalia msg color-scheme-set "$NOCTALIA_FONTE" "$NOCTALIA_PALETA" >/dev/null
noctalia msg wallpaper-set "$PASTA_WALL/$WALL" >/dev/null

echo "Tema '$nome' aplicado. (Warp: troque o tema em Settings → Appearance)"
