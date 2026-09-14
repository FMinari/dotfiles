-- ╔══════════════════════════════════════════════════════════════╗
-- ║  Cores do Hyprland                                           ║
-- ╚══════════════════════════════════════════════════════════════╝
-- Cada tema é um arquivo em config/themes/. Trocar tema (sistema todo):
--     rice tema kurenai      |  rice tema tokyo-night
-- Criar um tema novo: copia um arquivo de themes/ e muda as cores.
-- Pegar cor da tela: SUPER+P (hyprpicker, copia o hex).

RICE_THEME = "vaporwave" -- <- o comando `rice tema` edita esta linha

require("config.themes." .. RICE_THEME)

-- Aliases antigos do CachyOS (outros arquivos ainda usam esses nomes)
CACHYLGREEN = BORDA_1
CACHYMGREEN = BORDA_2
CACHYDGREEN = BORDA_3
CACHYLBLUE  = GRUPO_ATIVO
CACHYMBLUE  = FUNDO_ALTO
CACHYDBLUE  = FUNDO_ALTO
CACHYWHITE  = TEXTO
CACHYGREY   = TEXTO
CACHYGRAY   = BORDA_INATIVA
