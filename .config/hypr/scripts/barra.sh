#!/usr/bin/env bash
# SUPER+B: alterna a barra entre
#   escondida → aparece ao encostar o mouse no topo, por cima das janelas (padrão)
#   fixa      → sempre visível e empurra as janelas pra baixo
# O padrão vem de auto_hide/reserve_space em [bar.default] no ~/.config/noctalia/config.toml.
estado="${XDG_RUNTIME_DIR:-/tmp}/barra-fixa"
if [[ -f "$estado" ]]; then
    rm -f "$estado"
    noctalia msg bar-auto-hide-set on
else
    touch "$estado"
    noctalia msg bar-auto-hide-set off
fi
noctalia msg bar-reserve-toggle
