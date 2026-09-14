#!/usr/bin/env bash
# Mostra ~/.config/hypr/atalhos.txt no launcher do Noctalia (SUPER+F1).
# Pra adicionar/editar um atalho da colinha: rice keys edit
noctalia dmenu -p "Atalhos" < "$HOME/.config/hypr/atalhos.txt" >/dev/null
