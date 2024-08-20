local Config = lib.load('config')
local Server = lib.load('server/sv_config')
local tempCd = {}

AddEventHandler('entityRemoved', function(ent)
    if GetEntityType(ent) ~= 1 or not Entity(ent).state.pickPocketed then return end
    Entity(ent).state:set('pickPocketed', nil, true) -- Do I need to do this or do statebags get set to nil when the entity is removed? idk.
end)

local function generateReward(zoneId)
    local data = Server.RewardZones[zoneId]
    if data and data.tier and Server.Tiers[data.tier] then
        local items = Server.Tiers[data.tier]
        local index = items[math.random(1, #items)]
        return index.name, math.random(index.amount.min, index.amount.max)
    end
    return false
end

RegisterNetEvent('randol_pickpocket:server:pickPocketNpc', function(netId)
    local src = source
    local player = GetPlayer(src)
    if not player or not netId or (Config.Cooldown.enable and tempCd[src]) then return end

    local target = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(target) or GetEntityType(target) ~= 1 then return end

    local pos = GetEntityCoords(GetPlayerPed(src))
    local coords = GetEntityCoords(target)

    if #(pos - coords) > 6.0 then
        return DoNotification(src, 'Target is too far away from you to pickpocket.', 'error')
    end

    if Entity(target).state.pickPocketed then
        return DoNotification(src, 'This person doesnt appear to have anything.', 'error')
    end

    local zoneId = lib.callback.await('randol_pickpocket:client:getZoneName', src, pos)
    if not zoneId or not Server.RewardZones[zoneId] then return end
    
    if math.random() > Server.Luck then
        if math.random(2) == 1 then
            local item, amount = generateReward(zoneId)
            if not item then return end
            AddItem(src, item, amount)
            DoNotification(src, ('You stole %sx %s.'):format(amount, itemLabel(item)), 'success')
        else
            local amount = math.random(Server.RewardZones[zoneId].cash.min, Server.RewardZones[zoneId].cash.max)
            AddMoney(player, 'cash', amount)
            DoNotification(src, ('You stole $%s.'):format(amount), 'success')
        end
    else
        DoNotification(src, 'This person doesnt appear to have anything.', 'error')
    end

    Entity(target).state:set('pickPocketed', true, true)
    if Config.Cooldown.enable then
        tempCd[src] = true
        SetTimeout(Config.Cooldown.time * 1000, function()
            tempCd[src] = false
        end)
    end
end)