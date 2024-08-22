if not lib.checkDependency('ND_Core', '2.0.0') then return end

NDCore = {}

lib.load('@ND_Core.init')

function GetPlayer(id)
    return NDCore.getPlayer(id)
end

function DoNotification(src, text, nType)
    TriggerClientEvent('ox_lib:notify', src, {description = text, type = nType})
end

function GetPlyIdentifier(Player)
    return Player.id
end

function GetByIdentifier(cid)
    return false
end

function GetSourceFromIdentifier(cid)
    return false
end

function GetPlayerSource(Player)
    return Player.source
end

function GetCharacterName(Player)
    return Player.firstname.. ' ' ..Player.lastname
end

function AddMoney(player, acc, amount)
    player.addMoney(acc, amount)
end

function AddItem(src, item, amount)
    exports.ox_inventory:AddItem(src, item, amount)
end

function itemLabel(item)
    return exports.ox_inventory:Items(item).label
end

