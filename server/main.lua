ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)




TriggerEvent('esx_society:registerSociety', 'taxi', 'Taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'public'})



---------------------------------------------------------------------------------------
----------------------------------BAŞARILI HACK ÖDÜLLERİ-------------------------------
---------------------------------------------------------------------------------------

RegisterServerEvent('esx_hackerjob:hackparasi')
AddEventHandler('esx_hackerjob:hackparasi', function(verilenPara)
local source = source
local xPlayer = ESX.GetPlayerFromId(source)
xPlayer.addBank(verilenPara)
end)
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

---------------------------------------------------------

RegisterServerEvent('esx_hackerjob:chopNotify')
AddEventHandler('esx_hackerjob:chopNotify', function()
    TriggerClientEvent("esx_hackerjob:chopEnable", source)
end)


RegisterServerEvent('esx_hackerjob:ChopInProgress')
AddEventHandler('esx_hackerjob:ChopInProgress', function(street1, street2, sex)
    TriggerClientEvent("esx_hackerjob:outlawNotify", -1, "~r~Someone is Chopping a vehicle")

end)


RegisterServerEvent('esx_hackerjob:ChopInProgressS1')
AddEventHandler('esx_hackerjob:ChopInProgressS1', function(street1, sex)
    TriggerClientEvent("esx_hackerjob:outlawNotify", -1, "~r~Someone is Chopping a vehicle")

end)



RegisterServerEvent('esx_hackerjob:ChoppingInProgressPos')
AddEventHandler('esx_hackerjob:ChoppingInProgressPos', function(gx, gy, gz)
    TriggerClientEvent('esx_hackerjob:Choplocation', -1, gx, gy, gz)
end)

---------------------------------------------------------


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



---------------------------------------------------------------------------------------
-----------------------------------POLİS SAYISI ÖĞRENME--------------------------------
---------------------------------------------------------------------------------------

RegisterServerEvent('esx_hackerjob:hackparasiAl')
AddEventHandler('esx_hackerjob:hackparasiAl', function()
local xPlayer = ESX.GetPlayerFromId(source)
local xPlayers = ESX.GetPlayers()
local price = 15000
local _source = source
local PlayerTabletInventory = xPlayer.getInventoryItem('hackertablet').count
PoliceConnected = 0
local tablet = false

if Config.HackerTablet then
 tablet = true
end

for i=1, #xPlayers, 1 do
	local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
	
	if xPlayer.job.name == 'police' then
			PoliceConnected = PoliceConnected + 1
	end	
end
	
	if (xPlayer.getBank() >= price) then
	xPlayer.removeBank(price)	
	
		if tablet then
			if PlayerTabletInventory > 0 then
			
				
						TriggerClientEvent("pNotify:SendNotification", source,{
						text = ("<b style='color:#67f046'>$15000 </b>Ödedin! Aktif polis sayısı: " .. PoliceConnected .. ""),
						type = "alert",
						theme = "metroui",
						timeout = 5000,
						layout = "topRight",
						queue = "lmao"
						}
					)
			
			else
	
	
			TriggerClientEvent("pNotify:SendNotification", source,{
                    text = ("Hacker Tabletin YOK"),
                    type = "error",
					theme = "metroui",
                    timeout = 2500,
                    layout = "topRight",
					queue = "lmao"
                }
            )	
			
			end
		
			
	else
		
					TriggerClientEvent("pNotify:SendNotification", source,{
                    text = ("<b style='color:#67f046'>$15000 </b>Ödedin! Aktif polis sayısı: " .. PoliceConnected .. ""),
                    type = "alert",
					theme = "metroui",
                    timeout = 5000,
                    layout = "topRight",
					queue = "lmao"
                }
            )

					
		
	end
	
	else
	
	
	TriggerClientEvent("pNotify:SendNotification", source,{
                    text = ("Bankanda yeterli para yok"),
                    type = "error",
					theme = "metroui",
                    timeout = 5000,
                    layout = "topRight",
					queue = "lmao"
                }
            )
	
	
end
end)



---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------






ESX.RegisterServerCallback('esx_taxijob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)
