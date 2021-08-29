ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent("devcore_panicbutton:server:Panic")
AddEventHandler("devcore_panicbutton:server:Panic", function(player, s1)
	local src = source
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == Config.PoliceName then
            TriggerClientEvent('devcore_panicbutton:client:Panic', xPlayer.source, src, s1)
        end
    end
end)

RegisterServerEvent("devcore_panicbutton:server:Blip")
AddEventHandler("devcore_panicbutton:server:Blip", function(gx, gy, gz)
	local src = source
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == Config.PoliceName then
            TriggerClientEvent('devcore_panicbutton:client:Blip', -1, gx, gy, gz)
        end
    end
end)
