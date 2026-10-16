#!/usr/bin/env bash
# SUPER+B: alterna a barra entre
#   escondida → aparece ao encostar o mouse no topo, por cima das janelas (padrão)
#   fixa      → sempre visível e empurra as janelas pra baixo
# O padrão vem de auto_hide/reserve_space em [bar.default] no ~/.config/noctalia/config.toml.
#
# O estado é lido do próprio Hyprland (espaço reservado no topo dos monitores), não de
# arquivo de estado: bar-reserve-toggle só inverte, então um arquivo dessincronizado
# deixava a barra visível mas sem reservar espaço — por cima das abas do Chrome.
# `barra.sh esconder` / `barra.sh fixar` forçam um dos dois estados.

reservado() { hyprctl monitors -j | jq '[.[].reserved[1]] | max'; }

esconder() {
    noctalia msg bar-auto-hide-set on
    (( $(reservado) > 0 )) && noctalia msg bar-reserve-toggle
}

fixar() {
    noctalia msg bar-auto-hide-set off
    (( $(reservado) == 0 )) && noctalia msg bar-reserve-toggle
}

case "$1" in
    esconder) esconder ;;
    fixar)    fixar ;;
    *)        if (( $(reservado) > 0 )); then esconder; else fixar; fi ;;
esac
rm -f "${XDG_RUNTIME_DIR:-/tmp}/barra-fixa"   # arquivo de estado antigo, não é mais usado
true
