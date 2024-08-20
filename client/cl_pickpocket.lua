local Config = lib.load('config')
local cooldownActive = false

local function canPickpocket(ped)
    return not IsPedAPlayer(ped)
    and not IsPedInAnyVehicle(ped, false)
    and GetPedType(ped) ~= 28 
    and NetworkGetEntityIsNetworked(ped)
    and not Entity(ped).state.pickPocketed
    and not IsPedFacingPed(ped, cache.ped, 90.0)
    and IsPedFacingPed(cache.ped, ped, 90.0)
    and not cooldownActive
    and not Config.BlacklistedJobs[GetPlayerJob()]
end

local function checkWhilePickpocketing(ped)
    CreateThread(function()
        while lib.progressActive() do
            local coords = GetEntityCoords(ped)
            local pos = GetEntityCoords(cache.ped)
            local distance = #(coords - pos)
            
            if distance > 6.0 or IsPedRunning(ped) or IsPedSprinting(ped) or IsPedFleeing(ped) then
                lib.cancelProgress()
            end
            
            Wait(100)
        end
    end)
end

local function pickPocket(data)
    if Config.Cooldown.enable and cooldownActive then return end
    
    checkWhilePickpocketing(data.entity)
    Config.AlertPolice(GetEntityCoords(cache.ped))

    if lib.progressCircle({
        duration = Config.ProgressTime,
        position = 'bottom',
        label = 'Pickpocketing..',
        useWhileDead = false,
        canCancel = true,
        disable = { move = false, car = true, mouse = false, combat = true, },
        anim = { dict = 'anim@heists@prison_heiststation@heels', clip = 'pickup_bus_schedule', flag = 49},
    })
    then
        TriggerServerEvent('randol_pickpocket:server:pickPocketNpc', NetworkGetNetworkIdFromEntity(data.entity))
        if Config.Cooldown.enable then
            cooldownActive = true
            SetTimeout(Config.Cooldown.time * 1000, function()
                cooldownActive = false
            end)
        end
    end

    ClearPedTasks(cache.ped)
end

exports.ox_target:addGlobalPed({
    icon = 'fa-solid fa-hand-holding-dollar',
    label = 'Pickpocket',
    onSelect = pickPocket,
    canInteract = canPickpocket,
    distance = 1.5,
})

lib.callback.register('randol_pickpocket:client:getZoneName', function(coords)
    return GetNameOfZone(coords.x, coords.y, coords.z)
end)

RegisterNetEvent('randol_pickpocket:client:failedPickpocket', function(netId)
    if GetInvokingResource() then return end
    local entity = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(entity) or IsEntityDead(entity) then return end
    ClearPedTasksImmediately(entity)
    GiveWeaponToPed(entity, `WEAPON_STUNGUN`, 255, false, false)
    SetPedDropsWeaponsWhenDead(entity, false)
    TaskCombatPed(entity, cache.ped, 0, 16)
    DoNotification('I think they caught you!', 'error')
end)
