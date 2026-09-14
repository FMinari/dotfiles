#!/usr/bin/env bash
# Mostra/esconde uma gaveta (special workspace). Se o app ainda não estiver
# aberto, abre (a regra em config/gavetas.lua manda ele direto pra gaveta).
# Uso: gaveta.sh <nome> <regex-da-class> <comando>
nome="$1"; classe="$2"; cmd="$3"

if ! hyprctl clients -j | jq -e --arg re "$classe" 'any(.[]; .class | test($re))' >/dev/null; then
    setsid -f uwsm app -- $cmd >/dev/null 2>&1
fi

# se a gaveta já está visível, esconde; senão mostra
hyprctl dispatch "hl.dsp.workspace.toggle_special(\"$nome\")" >/dev/null
