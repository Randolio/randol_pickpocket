if GetResourceState('ND_Core') ~= 'started' then return end

local NDCore = exports.ND_Core
local PlayerData = {}

AddEventHandler("ND:characterLoaded", function(character)
    PlayerData = character
end)

AddEventHandler("ND:characterUnloaded", function(character)
    table.wipe(PlayerData)
end)

function hasPlyLoaded()
    return LocalPlayer.state.isLoggedIn
end

function DoNotification(text, nType)
    lib.notify({description = text, type = nType})
end

function GetPlayerJob()
    return PlayerData.job
end

AddEventHandler("ND:updateCharacter", function(character)
    PlayerData = character
end)

AddEventHandler('onResourceStart', function(res)
    if GetCurrentResourceName() ~= res or not hasPlyLoaded() then return end
    PlayerData = NDCore:getPlayer()
end)
