return {
    ["shield"] = {
        label = "Escudo policial",
        weight = 8000,
        stack = false,
        consume = 0,
        client = {
            export = "ND_Police.useShield",
            add = function(total)
                if total > 0 then
                        pcall(function() return exports["ND_Police"]:hasShield(true) end)
                    end
                end,
            remove = function(total)
                if total < 1 then
                    pcall(function() return exports["ND_Police"]:hasShield(false) end)
                end
            end
        }
    },
    ["spikestrip"] = {
        label = "Faixa de pregos",
        weight = 500,
        client = {
            export = "ND_Police.deploySpikestrip"
        }
    },
    ["cuffs"] = {
        label = "Algemas",
        weight = 150,
        client = {
            export = "ND_Police.cuff"
        }
    },
    ["zipties"] = {
        label = "Abraçadeiras",
        weight = 10,
        client = {
            export = "ND_Police.ziptie"
        }
    },
    ["tools"] = {
	label = "Ferramentas",
        description = "Podem ser usadas para ligar veículos à chupeta.",
	weight = 800,
	consume = 1,
        stack = true,
        close = true,
		client = {
            export = "ND_Core.hotwire",
            event = "ND_Police:unziptie"
		}
	},
    ["handcuffkey"] = {
        label = "Chave das algemas",
        weight = 10,
        client = {
            export = "ND_Police.uncuff"
        }
    },
    ["casing"] = {
        label = "Invólucro de bala"
    },
    ["projectile"] = {
        label = "Projétil"
    },
}
