-- ╔══════════════════════════════════════════════════════════════╗
-- ║  Gavetas: apps que aparecem por cima de tudo e somem de novo  ║
-- ╚══════════════════════════════════════════════════════════════╝
-- Na 1ª vez o atalho abre o app já dentro da gaveta; depois só mostra/esconde.
-- Pra criar outra gaveta: adicione uma linha em GAVETAS (nome, tecla, class, comando).
-- Descobrir a "class" de um app aberto: hyprctl clients | grep class

local script = os.getenv("HOME") .. "/.config/hypr/scripts/gaveta.sh"

local GAVETAS = {
    { nome = "whatsapp", tecla = "M",      classe_re = "^chrome-web\\.whatsapp\\.com__.*$",
      cmd = "google-chrome-stable --app=https://web.whatsapp.com" },
    { nome = "teams",    tecla = "N",      classe_re = "^chrome-teams\\.cloud\\.microsoft__.*$",
      cmd = "google-chrome-stable --app=https://teams.cloud.microsoft" },
    { nome = "terminal", tecla = "code:49", -- tecla ' (do lado do 1)
      classe_re = "^gaveta-terminal$",
      cmd = "kitty --class gaveta-terminal" },
}

for _, g in ipairs(GAVETAS) do
    hl.window_rule({
        match     = { class = g.classe_re },
        workspace = "special:" .. g.nome .. " silent",
        float     = true,
        size      = { "monitor_w*0.80", "monitor_h*0.82" },
        center    = true,
    })

    hl.bind("SUPER + " .. g.tecla, hl.dsp.exec_cmd(
        string.format("%s %s '%s' '%s'", script, g.nome, g.classe_re, g.cmd)
    ))
end
