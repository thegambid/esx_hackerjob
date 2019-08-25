ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_hackerjob:hackparasi')
AddEventHandler('esx_hackerjob:hackparasi', function(verilenPara)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addAccountMoney('bank', verilenPara)
end)

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
    ESX.RegisterServerCallback('esx_hackerjob:getItemAmount', function(source, cb, item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local items = xPlayer.getInventoryItem(item)
        if items == nil then
            cb(0)
        else
            cb(items.count)
        end
    end)
end)

ESX.RegisterServerCallback('esx_taxijob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory
	cb( { items = items } )
end)

RegisterServerEvent('hackNotify')
AddEventHandler('hackNotify', function()
    TriggerClientEvent("hackEnable", source)
end)


RegisterServerEvent('hackInProgress')
AddEventHandler('hackInProgress', function(street1, street2, sex)
    TriggerClientEvent("outlawNotify", -1, "~r~Hack. Cinsiyet: ~w~"..sex.."~r~ Konum:~w~"..street1.."~r~ ve ~w~"..street2)
end)

RegisterServerEvent('hackInProgressS1')
AddEventHandler('hackInProgressS1', function()
    TriggerClientEvent("outlawNotify", -1, "~r~Hack. Cinsiyet: ~w~"..sex.."~r~ Konum:~w~"..street1)
end)

RegisterServerEvent('hackInProgressPos')
AddEventHandler('hackInProgressPos', function(gx, gy, gz)
    TriggerClientEvent('hacklocation', -1, gx, gy, gz)
end)
