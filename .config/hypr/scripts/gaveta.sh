#!/usr/bin/env bash
# Mostra/esconde uma gaveta (special workspace). Se o app ainda não estiver
# aberto, abre (a regra em config/gavetas.lua manda ele direto pra gaveta).
# Uso: gaveta.sh <nome> <regex-da-class> <comando>
nome="$1"; classe="$2"; cmd="$3"

# tamanho da gaveta em relação ao monitor (igual à regra em gavetas.lua)
LARGURA=0.80; ALTURA=0.82

if ! hyprctl clients -j | jq -e --arg re "$classe" 'any(.[]; .class | test($re))' >/dev/null; then
    setsid -f uwsm app -- $cmd >/dev/null 2>&1
fi

# Vai aparecer agora? Antes de mostrar, ajusta o tamanho ao monitor atual.
# A regra da gaveta só calcula o tamanho quando a janela abre: se ela abriu no
# HDMI, fica grande demais na tela do notebook (e vice-versa).
# Redimensiona ainda escondida e só se precisar — mexer com ela visível não pega
# (volta ao tamanho antigo) e ficar redimensionando o Chrome em sequência já o derrubou.
mon=$(hyprctl monitors -j | jq -c '.[] | select(.focused)')
if [[ $(jq -r '.specialWorkspace.name' <<<"$mon") != "special:$nome" ]]; then
    read -r w h < <(jq -r --argjson lw "$LARGURA" --argjson lh "$ALTURA" '
        (if .transform % 2 == 1 then [.height, .width] else [.width, .height] end) as [$W, $H]
        | "\($W / .scale * $lw | floor) \($H / .scale * $lh | floor)"' <<<"$mon")

    hyprctl clients -j | jq -r --arg re "$classe" --argjson w "$w" --argjson h "$h" '
        .[] | select(.class | test($re))
            | select(((.size[0] - $w) | fabs) > 20 or ((.size[1] - $h) | fabs) > 20)
            | .address' |
    while read -r addr; do
        hyprctl dispatch "hl.dsp.window.resize({ x = $w, y = $h, relative = false, window = \"address:$addr\" })" >/dev/null
    done
fi

# se a gaveta já está visível, esconde; senão mostra
hyprctl dispatch "hl.dsp.workspace.toggle_special(\"$nome\")" >/dev/null

# Acabou de aparecer: centraliza no monitor onde ela está agora. Centralizar
# escondida não serve — usa as coordenadas do monitor antigo e a janela aparece
# atravessando as duas telas. O Chrome só aplica o resize depois que a janela
# fica visível (~600ms), então espera o tamanho bater antes de centralizar.
# (O move com x/y absoluto não serve: cai em lugar aleatório.)
if [[ $(jq -r '.specialWorkspace.name' <<<"$mon") != "special:$nome" ]]; then
    for _ in {1..15}; do
        sleep 0.1
        hyprctl clients -j | jq -e --arg re "$classe" --argjson w "$w" --argjson h "$h" '
            all(.[] | select(.class | test($re));
                ((.size[0] - $w) | fabs) <= 20 and ((.size[1] - $h) | fabs) <= 20)' >/dev/null && break
    done
    sleep 0.1
    hyprctl clients -j | jq -r --arg re "$classe" '.[] | select(.class | test($re)) | .address' |
    while read -r addr; do
        hyprctl dispatch "hl.dsp.window.center({ window = \"address:$addr\" })" >/dev/null
    done
fi
