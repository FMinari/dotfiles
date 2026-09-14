-- ╔═════════════════════════════════════╗
-- ║  Animações                          ║
-- ╚═════════════════════════════════════╝
-- speed: menor = mais rápido (unidade = 100ms). enabled = false desliga.
-- Wiki: https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
-- Brincar com curvas: https://cubic-bezier.com

-- Curvas bezier
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("overshoot",      { type = "bezier", points = { {0.5, 0.9},   {0.1, 1.1}   } })

-- Molas (spring)
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 500, dampening = 35 })
hl.curve("rubber",         { type = "spring", mass = 1, stiffness = 200, dampening = 15 })

-- Animações
hl.animation({ leaf = "global",              enabled = true, speed = 3,  bezier = "quick" })
hl.animation({ leaf = "windowsIn",           enabled = true, speed = 4,  spring = "easy",        style = "popin 85%" })
hl.animation({ leaf = "windowsOut",          enabled = true, speed = 3,  bezier = "easeOutQuint", style = "popin 85%" })
hl.animation({ leaf = "windowsMove",         enabled = true, speed = 3,  spring = "easy",        style = "slide" })
hl.animation({ leaf = "fade",                enabled = true, speed = 3,  bezier = "quick" })
hl.animation({ leaf = "border",              enabled = true, speed = 5,  bezier = "easeOutQuint" })
-- A borda neon girando sem parar (speed alto = giro lento). Pesa pouco, mas dá pra desligar.
hl.animation({ leaf = "borderangle",         enabled = true, speed = 60, bezier = "linear",      style = "loop" })
hl.animation({ leaf = "workspaces",          enabled = true, speed = 4,  bezier = "easeOutQuint", style = "slidefadevert 15%" }) -- vert = de cima pra baixo; tira o "vert" pra voltar pro lado
hl.animation({ leaf = "specialWorkspaceIn",  enabled = true, speed = 2,  bezier = "quick",       style = "slide top" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 2,  bezier = "quick",       style = "slide bottom" })
hl.animation({ leaf = "layers",              enabled = true, speed = 3,  bezier = "easeOutQuint", style = "popin 90%" })
