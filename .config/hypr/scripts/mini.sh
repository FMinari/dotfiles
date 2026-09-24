#!/usr/bin/env bash
# Mini-janela (picture-in-picture caseiro): pega a janela focada, deixa ela
# pequena, flutuante, fixa em cima de tudo e no canto de baixo à direita.
# Aperta de novo pra devolver a janela ao que ela era.
# Uso: mini.sh   (atalho SUPER+SHIFT+P)

LARGURA=480; ALTURA=270      # 16:9
MARGEM=16

win=$(hyprctl activewindow -j)
addr=$(jq -r '.address' <<<"$win")
[[ -z $addr || $addr == null ]] && exit 0

estado="${XDG_RUNTIME_DIR:-/tmp}/hypr-mini-${addr//0x/}"

# Já está em modo mini? Então restaura.
if [[ -f $estado ]]; then
    source "$estado"
    hyprctl dispatch "hl.dsp.window.pin({ window = \"address:$addr\" })" >/dev/null
    if [[ $ERA_FLUTUANTE == true ]]; then
        hyprctl dispatch "hl.dsp.window.resize({ x = $ERA_W, y = $ERA_H, relative = false, window = \"address:$addr\" })" >/dev/null
        sleep 0.1
        hyprctl dispatch "hl.dsp.window.move({ x = $ERA_X, y = $ERA_Y, relative = false, window = \"address:$addr\" })" >/dev/null
    else
        hyprctl dispatch "hl.dsp.window.float({ action = \"off\", window = \"address:$addr\" })" >/dev/null
    fi
    rm -f "$estado"
    exit 0
fi

# Guarda como a janela estava, pra conseguir desfazer depois.
{
    echo "ERA_FLUTUANTE=$(jq -r '.floating' <<<"$win")"
    echo "ERA_W=$(jq -r '.size[0]' <<<"$win")"
    echo "ERA_H=$(jq -r '.size[1]' <<<"$win")"
    echo "ERA_X=$(jq -r '.at[0]' <<<"$win")"
    echo "ERA_Y=$(jq -r '.at[1]' <<<"$win")"
} > "$estado"

# Canto de baixo à direita do monitor focado (respeita posição do monitor no
# layout, escala e rotação — igual o gaveta.sh faz).
read -r x y < <(hyprctl monitors -j | jq -r --argjson w "$LARGURA" --argjson h "$ALTURA" --argjson m "$MARGEM" '
    .[] | select(.focused)
    | (if .transform % 2 == 1 then [.height, .width] else [.width, .height] end) as [$W, $H]
    | "\(.x + ($W / .scale) - $w - $m | floor) \(.y + ($H / .scale) - $h - $m | floor)"')

hyprctl dispatch "hl.dsp.window.float({ action = \"on\", window = \"address:$addr\" })" >/dev/null
sleep 0.1
hyprctl dispatch "hl.dsp.window.resize({ x = $LARGURA, y = $ALTURA, relative = false, window = \"address:$addr\" })" >/dev/null
sleep 0.1
hyprctl dispatch "hl.dsp.window.move({ x = $x, y = $y, relative = false, window = \"address:$addr\" })" >/dev/null
hyprctl dispatch "hl.dsp.window.pin({ window = \"address:$addr\" })" >/dev/null
