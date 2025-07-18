Ox_inventory = exports.ox_inventory
local QBCore = exports["qb-core"]:GetCoreObject()
local glm = require 'glm'
local config = lib.load("data.config")

local function hasJobs(src, groups)
    if not groups then return end

    local player = QBCore.Functions.GetPlayer(src)
    local job = player.PlayerData.job.name

    for i=1, #groups do
        if job == groups[i] then
            return true
        end
    end
end

RegisterServerEvent('ND_Police:deploySpikestrip', function(data)
    local count = Ox_inventory:Search(source, 'count', 'spikestrip')

    if count < data.size then return end

    Ox_inventory:RemoveItem(source, 'spikestrip', data.size)

    local dir = glm.direction(data.segment[1], data.segment[2])

    for i = data.size, 1, -1 do
        local coords = glm.segment.getPoint(data.segment[1], data.segment[2], (i * 2 - 1) / (data.size * 2))
        local object = CreateObject(`p_ld_stinger_s`, coords.x, coords.y, coords.z, true, true, true)

        while not DoesEntityExist(object) do
            Wait(0)
        end

        SetEntityRotation(object, math.deg(-math.sin(dir.z)), 0.0, math.deg(math.atan(dir.y, dir.x)) + 90, 2, false)
        Entity(object).state:set('inScope', true, true)
        Wait(800)
    end
end)

RegisterServerEvent('ND_Police:retrieveSpikestrip', function(netId)
    local ped = GetPlayerPed(source)

    if GetVehiclePedIsIn(ped, false) ~= 0 then return end

    local pedPos = GetEntityCoords(ped)
    local spike = NetworkGetEntityFromNetworkId(netId)
    local spikePos = GetEntityCoords(spike)

    if #(pedPos - spikePos) > 5 then return end

    if not Ox_inventory:CanCarryItem(source, 'spikestrip', 1) then return end

    DeleteEntity(spike)

    Ox_inventory:AddItem(source, 'spikestrip', 1)
end)

RegisterServerEvent('ND_Police:setPlayerEscort', function(target, state, setIntoVeh, setIntoSeat)
    local src = source
    target = tonumber(target)
    if not target then return end

    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    local targetPed = GetPlayerPed(target)
    local targetCoords = GetEntityCoords(targetPed)
    if not playerCoords or not targetCoords or #(playerCoords-targetCoords) > 5 then return end

    target = Player(target)?.state
    
    if not target then return end
    target:set('isEscorted', state and src, true)

    if not setIntoVeh or not setIntoSeat then return end
    Wait(500)

    local veh = NetworkGetEntityFromNetworkId(setIntoVeh)
    if not DoesEntityExist(veh) then return end

    SetPedIntoVehicle(targetPed, veh, setIntoSeat)
end)

RegisterNetEvent('ND_Police:gsrTest', function(target)
	local src = source
	local state = Player(target).state

    if state.shot then
        return TriggerClientEvent("ox_lib:notify", src, {
            type = 'success',
            description = 'Teste positivo (disparou arma)'
        })
         
    end

    TriggerClientEvent("ox_lib:notify", src, {
        type = 'error',
        description = 'Teste negativo (não disparou arma)'
    })
    
end)

RegisterNetEvent("ND_Police:shotspotter", function(location, coords)
    local src = source
    -- note: add integration for dispatch resources
end)

RegisterNetEvent("ND_Police:impoundVehicle", function(netId, impoundReclaimPrice)
    local src = source

    if not impoundReclaimPrice or impoundReclaimPrice > config.maxImpoundPrice or impoundReclaimPrice < config.minImpoundPrice then
        return TriggerClientEvent("ox_lib:notify", src, {
            type = "error",
            description = "Preço de resgate do reboque inválido."
        }) 
    end

    if not hasJobs(src, config.policeGroups) then
        return TriggerClientEvent("ox_lib:notify", src, {
            type = "error",
            description = "Não tem permissão para fazer isto."
        }) 
    end

    local vehicle = NetworkGetEntityFromNetworkId(netId)

    if not DoesEntityExist(vehicle) then
        return TriggerClientEvent("ox_lib:notify", src, {
            type = "error",
            description = "Veículo não encontrado, tente novamente mais tarde."
        }) 
    end

    local vehCoords = GetEntityCoords(vehicle)
    local pedCoords = GetEntityCoords(GetPlayerPed(src))

    if #(vehCoords-pedCoords) > 5 then
        return TriggerClientEvent("ox_lib:notify", src, {
            type = "error",
            description = "Está muito longe do veículo."
        }) 
    end
    
    --add fuction of cd_garage to impound the vehicle
    --impoundVehicle(netId, vehicle, impoundReclaimPrice)
    
    
    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
    end
end)
