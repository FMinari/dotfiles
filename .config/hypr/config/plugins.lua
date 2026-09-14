-- ╔══════════════════════════════════════════════════════════════╗
-- ║  Plugins (instalados com hyprpm)                              ║
-- ╚══════════════════════════════════════════════════════════════╝
-- Ver/ligar/desligar:  hyprpm list  |  hyprpm enable <nome>  |  hyprpm disable <nome>
-- Depois de atualizar o Hyprland (pacman): rode `hyprpm update` pra recompilar.
-- Cada bloco só roda se o plugin estiver carregado, então nada quebra sem eles.

local function carregado(nome)
    return hl.plugin ~= nil and hl.plugin[nome] ~= nil
end

---------------------------------------------------------------
-- hyprexpo: visão geral das áreas de trabalho (SUPER+G)
-- https://github.com/sandwichfarm/hyprexpo
---------------------------------------------------------------
if carregado("hyprexpo") then
    local gradiente = string.format("%s %s %s 45deg", BORDA_1, BORDA_2, BORDA_3)

    hl.config({
        plugin = {
            hyprexpo = {
                columns = 3,
                rows = 1,                   -- 1 fileira: tuas 3 áreas de trabalho, quadros grandes
                skip_empty = 1,             -- só mostra áreas de trabalho que existem
                gaps_in = 12,
                gaps_out = 28,
                bg_col = FUNDO_ALTO,        -- fundo com a cor do tema
                wallpaper_bg = 0,           -- 1 mostraria o wallpaper interno do Hyprland, não o do Noctalia
                workspace_method = "center current",
                show_cursor = 1,
                cancel_key = "escape",
                tile_rounding = 14,
                border_width = 2,
                border_color = BORDA_INATIVA,
                border_color_current = gradiente,
                border_color_hover = BORDA_1,
                border_color_focus = BORDA_3,
                label_enable = 1,
                label_text_mode = "id",
                label_position = "top-left",
                label_offset_x = 10,
                label_offset_y = 8,
                keynav_enable = 1,          -- setas + Enter dentro da visão geral
            },
        },
    })

    hl.define_submap("hyprexpo", function()
        hl.bind("left",   function() hl.plugin.hyprexpo.kb_focus("left") end)
        hl.bind("right",  function() hl.plugin.hyprexpo.kb_focus("right") end)
        hl.bind("up",     function() hl.plugin.hyprexpo.kb_focus("up") end)
        hl.bind("down",   function() hl.plugin.hyprexpo.kb_focus("down") end)
        hl.bind("return", function() hl.plugin.hyprexpo.kb_confirm() end)
        hl.bind("escape", function() hl.plugin.hyprexpo.expo("cancel") end)
    end)
end

-- O atalho existe sempre; só age se o plugin estiver carregado
hl.bind("SUPER + G", function()
    if carregado("hyprexpo") then hl.plugin.hyprexpo.expo("toggle") end
end)

---------------------------------------------------------------
-- hyprfocus: efeito rápido na janela que ganha foco
-- animações: flash | shrink | slide | none
---------------------------------------------------------------
hl.config({
    plugin = {
        hyprfocus = {
            keyboard_focus_animation = "shrink",
            mouse_focus_animation = "none",
            shrink_percentage = 0.97,
            animate_floating = true,
        },
    },
})
