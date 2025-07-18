Config = lib.load("data.config")
local activeLoop = false

AddEventHandler("ox_inventory:currentWeapon", function(weaponData)
    local ammo = weaponData?.ammo
    
    if not ammo or activeLoop then
        activeLoop = false
        return
    end
    
    activeLoop = true

    while ammo and activeLoop do
        Wait(0)

        if IsPedShooting(cache.ped) then
            TriggerEvent("ND_Police:playerJustShot", weaponData)
        end
    end
end)

AddEventHandler("ND_Police:playerUnloaded", function()
    LocalPlayer.state:set('isCuffed', false, true)
    LocalPlayer.state:set('isEscorted', false, true)
end)

exports.ox_target:addGlobalVehicle({
    {
        icon = "fa-solid fa-car-side",
        label = "Rebocar veículo",
        groups = Config.policeGroups,
	    distance = 1.5,
        onSelect = function(data)
            local input = lib.inputDialog("Rebocar veículo", {
                {
                    type = "number",
                    label = "Preço de resgate do reboque",
                    description = "Quanto é que o proprietário tem de pagar para resgatar o veículo do depósito?",
                    icon = "dollar-sign",
                    min = Config.minImpoundPrice,
                    max = Config.maxImpoundPrice,
                    default = Config.defaultImpoundPrice
                }
            })
            
            local impoundReclaimPrice = input and input[1]
            if not impoundReclaimPrice then return end

            local alert = lib.alertDialog({
                header = "Rebocar veículo",
                content = ("O veículo será eliminado e se pertencer a um jogador, poderá levantá-lo no depósito por $%s."):format(impoundReclaimPrice),
                centered = true,
                cancel = true
            })
 
            if alert ~= "confirm" then return end
            TriggerServerEvent("ND_Police:impoundVehicle", VehToNet(data.entity), impoundReclaimPrice)
        end
    }
})
