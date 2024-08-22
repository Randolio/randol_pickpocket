if GetResourceState('qb-core') ~= 'started' then return end

local QBCore = exports['qb-core']:GetCoreObject()

function GetPlayer(id)
    return QBCore.Functions.GetPlayer(id)
end

function DoNotification(src, text, nType)
    TriggerClientEvent('QBCore:Notify', src, text, nType)
end

function GetPlyIdentifier(Player)
    return Player.PlayerData.citizenid
end

function GetByIdentifier(cid)
    return QBCore.Functions.GetPlayerByCitizenId(cid)
end

function GetSourceFromIdentifier(cid)
    local Player = QBCore.Functions.GetPlayerByCitizenId(cid)
    return Player and Player.PlayerData.source or false
end

function GetPlayerSource(Player)
    return Player.PlayerData.source
end

function GetCharacterName(Player)
    return Player.PlayerData.charinfo.firstname.. ' ' ..Player.PlayerData.charinfo.lastname
end

function AddMoney(player, acc, amount)
    player.Functions.AddMoney(acc, amount)
end

function AddItem(src, item, amount)
    exports.ox_inventory:AddItem(src, item, amount)
end

function itemLabel(item)
    return exports.ox_inventory:Items(item) and exports.ox_inventory:Items(item).label or ('UNREGISTERED REWARD ITEM: %s'):format(item)
end
