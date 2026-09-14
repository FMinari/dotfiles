-- ╔══════════════════════════════════════════╗
-- ║  Visual das janelas: borda, gaps, blur…  ║
-- ╚══════════════════════════════════════════╝
-- Salvou? O Hyprland recarrega sozinho. Deu erro? Aparece uma faixa vermelha
-- no topo da tela, ou rode:  hyprctl configerrors
-- Todas as opções: https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
    general = {
        gaps_in = 4,              -- espaço entre janelas
        gaps_out = 10,            -- espaço entre janela e borda da tela
        border_size = 2,
        extend_border_grab_area = 10,
        resize_on_border = true,
        col = {
            -- Gradiente de 3 cores do tema (gira com a animação "borderangle")
            active_border = {
                colors = { BORDA_1, BORDA_2, BORDA_3 },
                angle = BORDA_ANGULO,
            },
            inactive_border = BORDA_INATIVA,
        },
    },
    group = {
        col = {
            border_active = GRUPO_ATIVO,
            border_inactive = FUNDO_ALTO,
            border_locked_active = GRUPO_TRAVADO,
            border_locked_inactive = FUNDO_ALTO,
        },
        groupbar = {
            col = {
                active = GRUPO_ATIVO,
                inactive = FUNDO_ALTO,
                locked_active = GRUPO_TRAVADO,
                locked_inactive = FUNDO_ALTO,
            },
        },
    },
    decoration = {
        rounding = 12,
        rounding_power = 2.5,     -- 2 = círculo, maior = "squircle" estilo iOS
        dim_special = 0.4,        -- escurece o fundo quando abre o scratchpad (SUPER+S)
        active_opacity = 1.0,
        inactive_opacity = 0.93,  -- janela sem foco levemente transparente
        fullscreen_opacity = 1,
        blur = {
            enabled = true,
            size = 6,
            passes = 2,           -- mais passes = mais borrado e mais pesado
            vibrancy = 0.25,
            noise = 0.02,
            special = true,
            popups = true,
        },
        shadow = {
            enabled = true,
            range = 18,
            render_power = 3,
            color = BRILHO,                 -- brilho em volta da janela ativa
            color_inactive = SOMBRA_INATIVA,
        },
    },
})
