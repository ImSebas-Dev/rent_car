if Config.esx then
    ESX = exports["es_extended"]:getSharedObject()
else
    QBCore = exports['qb-core']:GetCoreObject()
end
discordWebhook = "WEBHOOK" -- Change this to your own discord webhook

RegisterNetEvent('rental:pay', function()
    local src = source
    local price = Config.Price

    if Config.esx then
        local xPlayer = ESX.GetPlayerFromId(src)
        local bankBalance = xPlayer.getAccount('bank').money

        if bankBalance >= price then
            xPlayer.removeAccountMoney('bank', price)
            TriggerClientEvent("esx:showNotification", src, "Se te han cobrado $" ..price.. " por el servicio de entrega")
            if Config.DiscordLogs == true then
                steam = GetPlayerName(source)
                msg = "ID: " .. source .. " con el nombre de Steam: " .. steam .. " pagó " .. Config.Price .. "$ de su " .. Config.PriceType .. " cuenta para rentar un coche."
                SendDiscordLog(msg)
            end
        else
            TriggerClientEvent("esx:showNotification", src, "No tienes suficiente dinero.")
        end

    else
        local Player = QBCore.Functions.GetPlayer(src)
        local bankBalance = Player.Functions.GetMoney("bank")

        if  bankBalance >= price then
            Player.Functions.RemoveMoney("bank", price)
            TriggerClientEvent("qb-phone:client:RentNotification", src, "Servicio de entrega", "Se te han cobrado $" ..price.. " por el servicio de entrega", "fas fa-car")
            if Config.DiscordLogs == true then
                steam = GetPlayerName(source)
                msg = "ID: " .. source .. " con el nombre de Steam: " .. steam .. " pagó " .. Config.Price .. "$ de su " .. Config.PriceType .. " cuenta para rentar un coche."
                SendDiscordLog(msg)
            end
        else 
            TriggerClientEvent("qb-phone:client:RentNotification", src, "Servicio de entrega", "No tienes suficiente dinero.", "fas fa-car")
        end

        TriggerClientEvent('rental:isok', source)
    end
end)

function SendDiscordLog(message)

    local logData = {
        ["content"] = message
    }

    PerformHttpRequest(discordWebhook, function(err, text, headers)
    end, 'POST', json.encode(logData), {
        ['Content-Type'] = 'application/json'
    })
end
