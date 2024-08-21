if GetResourceState('es_extended') ~= 'started' then return end

local ESX = exports['es_extended']:getSharedObject()

function GetPlayer(id)
    return ESX.GetPlayerFromId(id)
end

function DoNotification(src, text, nType)
    TriggerClientEvent('ox_lib:notify', src, { type = nType, description = text })
end

function GetPlyIdentifier(xPlayer)
    return xPlayer.identifier
end

function GetByIdentifier(cid)
    return ESX.GetPlayerFromIdentifier(cid)
end

function GetSourceFromIdentifier(cid)
    local xPlayer = ESX.GetPlayerFromIdentifier(cid)
    return xPlayer and xPlayer.source or false
end

function GetPlayerSource(xPlayer)
    return xPlayer.source
end

function GetCharacterName(xPlayer)
    return xPlayer.getName()
end

function AddMoney(xPlayer, moneyType, amount)
    local account = moneyType == 'cash' and 'money' or moneyType
    xPlayer.addAccountMoney(account, amount)
end

function AddItem(src, item, amount)
    if not exports.ox_inventory:CanCarryItem(src, item, amount) then return error(("Player %s tried to carry an item (%s) but couldn't!"):format(src, item) end
    exports.ox_inventory:AddItem(src, item, amount)
end

function itemLabel(item)
    return exports.ox_inventory:Items(item) and exports.ox_inventory:Items(item).label or lib.print.error(('UNREGISTERED REWARD ITEM: %s'):format(item))
end
