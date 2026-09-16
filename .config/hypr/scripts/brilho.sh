#!/usr/bin/env bash
# Brilho da tela: brilho.sh up|down [passo%]
# O Noctalia não enxerga o intel_backlight do eDP-1, então muda via brightnessctl e só usa o OSD dele.
dev=intel_backlight
passo=${2:-5}
case "$1" in
  up)   brightnessctl -q -d "$dev" set "${passo}%+" ;;
  down) brightnessctl -q -d "$dev" --min-value=1 set "${passo}%-" ;;  # -n 1: nunca apaga a tela de vez
  *)    echo "uso: $0 up|down [passo]"; exit 1 ;;
esac
atual=$(brightnessctl -d "$dev" get)
max=$(brightnessctl -d "$dev" max)
noctalia msg brightness-osd "$(awk -v a="$atual" -v m="$max" 'BEGIN{printf "%.2f", a/m}')" >/dev/null 2>&1
