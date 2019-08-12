local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local IsDead                    = false
ESX                             = nil

local timer = 1
local showOutlaw = true 
local blipTime = 5 
local showcopsmisbehave = true 
local tabletGerekli = false
local timing = timer * 60000 

Citizen.CreateThread(function()
    while true do
        Wait(100)
        if NetworkIsSessionStarted() then
            DecorRegister("IsOutlaw",  3)
            DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 1)
            return
        end
    end
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

Citizen.CreateThread( function()
    while true do
        Wait(100)
        local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
        local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)
        if pedIsTryingToChopVehicle then
            DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 2)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'police' and 0 > 1 then
            elseif ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'police' then
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                    local sex = nil
                    if skin.sex == 0 then
                        sex = "Erkek"
                    else
                        sex = "Kadın"
                    end
                    
                    if s2 == 0 then
                        TriggerServerEvent('esx_hackerjob:ChopInProgressS1', street1, sex)
                    elseif s2 ~= 0 then
                        TriggerServerEvent('esx_hackerjob:ChopInProgress', street1, street2, sex)
                    end
					
					plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
					
					TriggerServerEvent('esx_hackerjob:ChoppingInProgressPos', plyPos.x, plyPos.y, plyPos.z)
					
					
					Citizen.Wait(Config.BeklemeSuresi * 1000)
					
					
                end)
                Wait(3000)
                pedIsTryingToChopVehicle = false
            else
                --[[ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                    local sex = nil
                    if skin.sex == 0 then
                        sex = "male"
                    else
                        sex = "female"
                    end
                    TriggerServerEvent('esx_hackerjob:ChoppingInProgressPos', plyPos.x, plyPos.y, plyPos.z)
                    if s2 == 0 then
                        TriggerServerEvent('esx_hackerjob:ChopInProgressS1', street1, sex)
                    elseif s2 ~= 0 then
                        TriggerServerEvent('esx_hackerjob:ChopInProgress', street1, street2, sex)
                    end
                end)--]]
                
            end
        end
    end
end)


RegisterNetEvent('esx_hackerjob:Choplocation')
AddEventHandler('esx_hackerjob:Choplocation', function(tx, ty, tz)
    if ESX.PlayerData.job.name == 'police' then
        local transT = 250
        local Blip = AddBlipForCoord(tx, ty, tz)
        SetBlipSprite(Blip,  10)
        SetBlipColour(Blip,  1)
        SetBlipAlpha(Blip,  transT)
        SetBlipAsShortRange(Blip,  false)
        while transT ~= 0 do
            Wait(blipTime * 4)
            transT = transT - 1
            SetBlipAlpha(Blip,  transT)
            if transT == 0 then
                SetBlipSprite(Blip,  2)
                return
            end
        end
    end
end)


GetPlayerName()
RegisterNetEvent('esx_hackerjob:outlawNotify')
AddEventHandler('esx_hackerjob:outlawNotify', function(alert)
		if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'police' then
			TriggerEvent('esx_hackerjob:notify2')
			PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
    end
end)

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

RegisterNetEvent("esx_hackerjob:notify2")
AddEventHandler("esx_hackerjob:notify2", function(msg, target)
		ESX.ShowAdvancedNotification(_U('911'), _U('chop'), _U('call'), 'CHAR_CALL911', 7)
end)


AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
    isDead = false
end)

function CreateBlipCircle(coords, text, radius, color, sprite)

	local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, sprite)
	SetBlipColour(blip, color)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)

end

Citizen.CreateThread(function()
	if Config.EnableBlips == true then
	  for k,zone in pairs(Config.Zones) do
        CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
	  end
   end
end)

RegisterNetEvent('esx_hackerjob:chopEnable')
AddEventHandler('esx_hackerjob:chopEnable', function()
	pedIsTryingToChopVehicle = true
end)

----------------------------------------------------
----------------------------------------------------
----------------------------------------------------

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

function DrawSub(msg, time)
	ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(msg)
	DrawSubtitleTimed(time, 1)
end

function ShowLoadingPromt(msg, time, type)
	Citizen.CreateThread(function()
		Citizen.Wait(0)
		BeginTextCommandBusyString("STRING")
		AddTextComponentString(msg)
		EndTextCommandBusyString(type)
		Citizen.Wait(time)

		RemoveLoadingPrompt()
	end)
end

----------------------------------------------------
----------------------------------------------------
----------------------------------------------------

local sonTest = 0

function hackerActionMenu()

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_ambulance_actions', {
		title    = _U('hacker_baslik'),
		align    = 'top-left',
		elements = {
			{label = _U('kredi_hack'), value = 'kredihack_menu'},
			{label = _U('kapi_hack'), value = 'kapihack'},
			{label =  'Aktif Polis Sayısını Gör - <span style="color:green;">$15000</span>', value = 'aktifPolice'}
		}
	}, function(data, menu)
		ESX.UI.Menu.CloseAll()
		if data.current.value == 'kredihack_menu' then
		
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'kredihack_menu', {
				title    = _U('kredihack_menu_title'),
				align    = 'top-left',
				elements = {
					{label = _U('kolay_kredi'), value = 'kolay'},
					{label = _U('orta_kredi'), value = 'orta'},
					{label = _U('zor_kredi'), value = 'zor'},
					{label = _U('enzor_kredi'), value = 'enzor'}				
				}
			}, function(data, menu)
				ESX.UI.Menu.CloseAll()
				
					if data.current.value == 'kolay' and GetGameTimer() - sonTest > Config.HackSure * 60000 then
					if Config.HackerTablet then	
						tabletGerekli = true
					end
					if tabletGerekli then
						ESX.TriggerServerCallback('esx_hackerjob:getItemAmount', function(qtty)
						if qtty > 0 then
							kolayHack()
						else
								exports.pNotify:SendNotification(
									{
									text = ("Hacker Tabletin YOK"),
									type = "error",
									theme = "metroui",
									timeout = 3000,
									layout = "topRight"
									}
								)
						end
					end, 'hackertablet')
					else	
					kolayHack()
					end				
					elseif data.current.value == 'orta' and GetGameTimer() - sonTest > Config.HackSure * 60000 then		
					if Config.HackerTablet then	
						tabletGerekli = true
					end
					if tabletGerekli then
						ESX.TriggerServerCallback('esx_hackerjob:getItemAmount', function(qtty)
						if qtty > 0 then
							ortaHack()
						else
								exports.pNotify:SendNotification(
									{
									text = ("Hacker Tabletin YOK"),
									type = "error",
									theme = "metroui",
									timeout = 3000,
									layout = "topRight"
									}
								)
							end
						end, 'hackertablet')
						else
						ortaHack()					
						end							
					elseif data.current.value == 'zor' and GetGameTimer() - sonTest > Config.HackSure * 60000 then
					if Config.HackerTablet then	
						tabletGerekli = true
					end		
					if tabletGerekli then				
						ESX.TriggerServerCallback('esx_hackerjob:getItemAmount', function(qtty)
						if qtty > 0 then
							zorHack()
						else
								exports.pNotify:SendNotification(
									{
									text = ("Hacker Tabletin YOK"),
									type = "error",
									theme = "metroui",
									timeout = 3000,
									layout = "topRight"
									}
								)
							end
						end, 'hackertablet')
						else
						zorHack()
						end
					elseif data.current.value == 'enzor' and GetGameTimer() - sonTest > Config.HackSure * 60000 then
					if Config.HackerTablet then	
						tabletGerekli = true
					end
					if tabletGerekli then
						ESX.TriggerServerCallback('esx_hackerjob:getItemAmount', function(qtty)
						if qtty > 0 then
							enZorHack()
						else
								exports.pNotify:SendNotification(
									{
									text = ("Hacker Tabletin YOK"),
									type = "error",
									theme = "metroui",
									timeout = 3000,
									layout = "topRight"
									}
								)
							end
						end, 'hackertablet')
						else
						enZorHack()
						end
					else 
						 local zamanYeniHack = Config.HackSure * 60000 - (GetGameTimer() - sonTest)
						   exports.pNotify:SendNotification({
							text = ""..math.floor(zamanYeniHack / 60000 + 1).. " dakika sonra tekrar dene.",
							type = "error", 
							timeout = 1000, 
							layout = "centerRight", 
							queue = "right", 
							killer = true, 
							animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}
						})
					end
				end, function(data, menu)
				menu.close()
				end)		
					elseif data.current.value == 'kapihack' then
					if Config.HackerTablet then	
						tabletGerekli = true
					end	
					if tabletGerekli then
						ESX.TriggerServerCallback('esx_hackerjob:getItemAmount', function(qtty)
						if qtty > 0 then
							kapiHack()
						else
								exports.pNotify:SendNotification(
									{
									text = ("Hacker Tabletin YOK"),
									type = "error",
									theme = "metroui",
									timeout = 3000,
									layout = "topRight"
									}
								)
							end
						end, 'hackertablet')
						else
						kapiHack()
					end
					elseif data.current.value == 'aktifPolice' then
					if Config.HackerTablet then	
						tabletGerekli = true
					end
					if tabletGerekli then
						ESX.TriggerServerCallback('esx_hackerjob:getItemAmount', function(qtty)
						if qtty > 0 then
							TriggerServerEvent('esx_hackerjob:hackparasiAl')
						else
								exports.pNotify:SendNotification(
									{
									text = ("Hacker Tabletin YOK"),
									type = "error",
									theme = "metroui",
									timeout = 3000,
									layout = "topRight"
									}
								)
							end
						end, 'hackertablet')
						else
							TriggerServerEvent('esx_hackerjob:hackparasiAl')				
					end		
			end
	end, function(data, menu)
		menu.close()
	end)
end

----------------------------------------------------

function kapiHack()
                	TriggerServerEvent('esx_doorlock:hack', mycb)
                	
                	exports.pNotify:SendNotification(
                		{
                		text = ("W, A, S, D tuşlarını kullanarak seçim yapabilir ve BOŞLUK tuşuyla sol kod bloğundan seçim yapabilirsin."),
                		type = "alert",
                		theme = "metroui",
                		timeout = 3000,
                		layout = "bottomRight"
                		}
                	)
                	
                	exports.pNotify:SendNotification(
                		{
                		text = ("Yön tuşlarını kullanarak seçim yapabilir ve ENTER tuşuyla sağ kod bloğundan seçim yapabilirsin."),
                		type = "alert",
                		theme = "metroui",
                		timeout = 3000,
                		layout = "bottomRight"
                		}
                	)
end
	
function kolayHack()
                	sonTest = GetGameTimer()
                	
                	TriggerEvent("mhacking:show")
                	TriggerEvent("mhacking:start",7,30,mycbkolay)
                	
                	exports.pNotify:SendNotification(
                		{
                		text = ("W, A, S, D tuşlarını kullanarak seçim yapabilir ve BOŞLUK tuşuyla sol kod bloğundan seçim yapabilirsin."),
                		type = "alert",
                		theme = "metroui",
                		timeout = 3000,
                		layout = "bottomRight"
                		}
                	)
                		
                	exports.pNotify:SendNotification(
                		{
                		text = ("Yön tuşlarını kullanarak seçim yapabilir ve ENTER tuşuyla sağ kod bloğundan seçim yapabilirsin."),
                		type = "alert",
                		theme = "metroui",
                		timeout = 3000,
                		layout = "bottomRight"
                		}
                	)
end

function ortaHack()
					sonTest = GetGameTimer()
						
					TriggerEvent("mhacking:show")
					TriggerEvent("mhacking:start",5,30,mycborta)
					
					exports.pNotify:SendNotification(
						{
						text = ("W, A, S, D tuşlarını kullanarak seçim yapabilir ve BOŞLUK tuşuyla sol kod bloğundan seçim yapabilirsin."),
						type = "alert",
						theme = "metroui",
						timeout = 3000,
						layout = "bottomRight"
						}
					)
					
					exports.pNotify:SendNotification(
						{
						text = ("Yön tuşlarını kullanarak seçim yapabilir ve ENTER tuşuyla sağ kod bloğundan seçim yapabilirsin."),
						type = "alert",
						theme = "metroui",
						timeout = 3000,
						layout = "bottomRight"
						}
					)
end

function zorHack()
					sonTest = GetGameTimer()
						
					TriggerEvent("mhacking:show")
					TriggerEvent("mhacking:start",4,30,mycbzor)
					
					exports.pNotify:SendNotification(
						{
						text = ("W, A, S, D tuşlarını kullanarak seçim yapabilir ve BOŞLUK tuşuyla sol kod bloğundan seçim yapabilirsin."),
						type = "alert",
						theme = "metroui",
						timeout = 3000,
						layout = "bottomRight"
						}
					)
					
					exports.pNotify:SendNotification(
						{
						text = ("Yön tuşlarını kullanarak seçim yapabilir ve ENTER tuşuyla sağ kod bloğundan seçim yapabilirsin."),
						type = "alert",
						theme = "metroui",
						timeout = 3000,
						layout = "bottomRight"
						}
					)
end

function enZorHack()
					sonTest = GetGameTimer()
						
					TriggerEvent("mhacking:show")
					TriggerEvent("mhacking:start",2,25,mycbenzor)

					exports.pNotify:SendNotification(
						{
						text = ("W, A, S, D tuşlarını kullanarak seçim yapabilir ve BOŞLUK tuşuyla sol kod bloğundan seçim yapabilirsin."),
						type = "alert",
						theme = "metroui",
						timeout = 3000,
						layout = "bottomRight"
						}
					)
					
					exports.pNotify:SendNotification(
						{
						text = ("Yön tuşlarını kullanarak seçim yapabilir ve ENTER tuşuyla sağ kod bloğundan seçim yapabilirsin."),
						type = "alert",
						theme = "metroui",
						timeout = 3000,
						layout = "bottomRight"
						}
					)
end
		
function mycbkolay(success, timeremaining)
    if success then
	
        if Config.PolisiAra then
        	local randomReport = math.random(1, Config.PolisiAramaYuzdesi)
        
        	if randomReport == Config.PolisiAramaYuzdesi then
        		TriggerServerEvent('esx_hackerjob:chopNotify')
        	end
        end				
			TriggerServerEvent('esx_hackerjob:hackparasi', 758)
			print('Success with '..timeremaining..'s remaining.')
		
		
					exports.pNotify:SendNotification(
						{
						text = ("Tebrikler! Hesabınıza 758$ yatırıldı 15 dakika sonra tekrar deneyebilirsiniz."),
						type = "alert",
						theme = "metroui",
						timeout = 3000,
						layout = "topRight"
						}
					)
				
			TriggerEvent('mhacking:hide')
    else
	
	if Config.PolisiAra then
    	local randomReport = math.random(1, Config.PolisiAramaYuzdesi)
    
    	if randomReport == Config.PolisiAramaYuzdesi then
    		TriggerServerEvent('esx_hackerjob:chopNotify')
    	end
    end					
        print('Failure')
        TriggerEvent('mhacking:hide')
				
				exports.pNotify:SendNotification(
					{
                    text = ("Başaramadın!"),
                    type = "error",
					theme = "metroui",
                    timeout = 3000,
                    layout = "topRight"
                }
            )	
    end
end

function mycborta(success, timeremaining)
    if success then
	
	if Config.PolisiAra then
   		local randomReport = math.random(1, Config.PolisiAramaYuzdesi)
   
   		if randomReport == Config.PolisiAramaYuzdesi then
   			TriggerServerEvent('esx_hackerjob:chopNotify')
   		end
   	end											
		TriggerServerEvent('esx_hackerjob:hackparasi', 1758)
        print('Success with '..timeremaining..'s remaining.')
		
				exports.pNotify:SendNotification(
					{
                    text = ("Tebrikler! Hesabınıza 1758$ yatırıldı 15 dakika sonra tekrar deneyebilirsiniz."),
                    type = "alert",
					theme = "metroui",
                    timeout = 3000,
                    layout = "topRight"
					}
				)
		
        TriggerEvent('mhacking:hide')
    else
	
	if Config.PolisiAra then
    	local randomReport = math.random(1, Config.PolisiAramaYuzdesi)
    
    	if randomReport == Config.PolisiAramaYuzdesi then
    		TriggerServerEvent('esx_hackerjob:chopNotify')
    	end
    end											
        print('Failure')
        TriggerEvent('mhacking:hide')
		
				exports.pNotify:SendNotification(
					{
                    text = ("Başaramadın!"),
                    type = "error",
					theme = "metroui",
                    timeout = 3000,
                    layout = "topRight"
					}
				)
    end
end

function mycbzor(success, timeremaining)
    if success then
	
	if Config.PolisiAra then
    	local randomReport = math.random(1, Config.PolisiAramaYuzdesi)
    
    	if randomReport == Config.PolisiAramaYuzdesi then
    		TriggerServerEvent('esx_hackerjob:chopNotify')
    	end
    end										
		TriggerServerEvent('esx_hackerjob:hackparasi', 2671)
        print('Success with '..timeremaining..'s remaining.')
		
				exports.pNotify:SendNotification(
					{
                    text = ("Tebrikler! Hesabınıza 2671$ yatırıldı 15 dakika sonra tekrar deneyebilirsiniz."),
                    type = "alert",
					theme = "metroui",
                    timeout = 3000,
                    layout = "topRight"
					}
				)
		
        TriggerEvent('mhacking:hide')
    else
	
	if Config.PolisiAra then
    	local randomReport = math.random(1, Config.PolisiAramaYuzdesi)
    
    	if randomReport == Config.PolisiAramaYuzdesi then
    		TriggerServerEvent('esx_hackerjob:chopNotify')
    	end
    end												
        print('Failure')
        TriggerEvent('mhacking:hide')
		
				exports.pNotify:SendNotification(
					{
                    text = ("Başaramadın!"),
                    type = "error",
					theme = "metroui",
                    timeout = 3000,
                    layout = "topRight"
					}
				)		
    end
end

function mycbenzor(success, timeremaining)
    if success then
	
	if Config.PolisiAra then
    	local randomReport = math.random(1, Config.PolisiAramaYuzdesi)
    
    	if randomReport == Config.PolisiAramaYuzdesi then
    		TriggerServerEvent('esx_hackerjob:chopNotify')
    	end
    end											
		TriggerServerEvent('esx_hackerjob:hackparasi', 4827)
        print('Success with '..timeremaining..'s remaining.')
		
				exports.pNotify:SendNotification(
					{
                    text = ("Tebrikler! Hesabınıza 4827$ yatırıldı 15 dakika sonra tekrar deneyebilirsiniz."),
                    type = "alert",
					theme = "metroui",
                    timeout = 3000,
                    layout = "topRight"
					}
				)

        TriggerEvent('mhacking:hide')
    else
	
	if Config.PolisiAra then
    	local randomReport = math.random(1, Config.PolisiAramaYuzdesi)
    
    	if randomReport == Config.PolisiAramaYuzdesi then
    		TriggerServerEvent('esx_hackerjob:chopNotify')
    	end
    end											
        print('Failure')
        TriggerEvent('mhacking:hide')
		
				exports.pNotify:SendNotification(
					{
                    text = ("Başaramadın!"),
                    type = "error",
					theme = "metroui",
                    timeout = 3000,
                    layout = "topRight"
					}
				)		
    end
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(0, Keys['F6']) and not IsDead and ESX.PlayerData.job and ESX.PlayerData.job.name == 'hackerjob' then
			hackerActionMenu()
			
		end
	end
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	IsDead = false
end)