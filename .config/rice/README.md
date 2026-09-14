# Dotfiles do rice (CachyOS + Hyprland + Noctalia)

Configs versionadas com um repositório git "bare" em `~/.dotfiles`, sem symlink:
os arquivos ficam no lugar normal e o comando `dots` é um `git` apontado pra eles.

```fish
dots status                 # o que mudou
dots add ~/.config/hypr     # começar a versionar algo novo
dots commit -am "mudei X"   # salvar
dots log --oneline          # histórico
dots diff                   # ver as mudanças
```

## O que está aqui

| Caminho | O quê |
|---|---|
| `~/.config/hypr/` | Hyprland (Lua): visual, animações, atalhos, gavetas, temas, scripts |
| `~/.config/rice/temas/*.conf` | Temas (Kurenai, Vaporwave, Tokyo Night) |
| `~/.config/noctalia/` | Barra, dock, tela de bloqueio, paletas |
| `~/.local/state/noctalia/settings.toml` | Widgets do desktop e da tela de bloqueio |
| `~/.config/fish/` | `rice`, `dots`, starship |
| `~/.config/starship.toml`, `fastfetch/`, `cava/`, `kitty/kitty.conf` | Terminal |
| `~/.config/uwsm/env` | Variáveis da sessão (cursor, Wayland) |
| `~/.local/share/warp-terminal/themes/` | Temas do Warp |

## O que NÃO está (baixar de novo num PC novo)

- **Wallpapers** (`~/Imagens/Wallpapers/`): tokyo-night/wallpapers (MIT), Wallhaven e dharmx/walls
- **Fontes** (`~/.local/share/fonts/rice/`): Google Fonts: Yuji Syuku, Monoton, Orbitron
- **Cursores** (`~/.local/share/icons/`): catppuccin/cursors v2.0.0, mocha red / pink / lavender
- **Pacotes**: `sudo pacman -S --needed hyprpm cmake meson cava starship`
- **Plugins** (depois dos pacotes):
  `hyprpm update && hyprpm add https://github.com/sandwichfarm/hyprexpo && hyprpm add https://github.com/hyprwm/hyprland-plugins && hyprpm enable hyprexpo && hyprpm enable hyprfocus`

## Restaurar num PC novo

```bash
git clone --bare <url-do-repo> ~/.dotfiles
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout   # se reclamar de arquivo existente, faça backup e repita
git --git-dir=$HOME/.dotfiles --work-tree=$HOME config status.showUntrackedFiles no
```
