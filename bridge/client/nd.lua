if not lib.checkDependency('ND_Core', '2.0.0') then return end

NDCore = {}

lib.load('@ND_Core.init')

local PlayerData = {}

RegisterNetEvent('ND:characterUnloaded', function()
    LocalPlayer.state.isLoggedIn = false
    table.wipe(PlayerData)
end)

RegisterNetEvent('ND:characterLoaded', function(character)
    LocalPlayer.state.isLoggedIn = true
    PlayerData = character
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
    PlayerData = NDCore.getPlayer()
end)
