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



local PlayerData              = {}
local JobBlips = {}
local inservizio = false
local vestiti = false
local CurrentTask             = {}
ESX                           = nil


Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
	refreshBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	refreshBlips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	deleteBlips()
	refreshBlips()
	Citizen.Wait(5000)
end)

function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Vestiti.male ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Vestiti.male)
			else
				ESX.ShowNotification("Non puoi indossare alcun vestito")
			end

			if job == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		else
			if Config.Vestiti.female ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Vestiti.female)
			else
				ESX.ShowNotification("Non puoi indossare alcun vestito")
			end
		end
	end)
end


RegisterNetEvent('esx:setOrg')

AddEventHandler('esx:setOrg', function(org)
	PlayerData.org = org
	deleteBlips()
	refreshBlips()
	Citizen.Wait(5000)
end)

function deleteBlips()
	if JobBlips[1] ~= nil then
		for i=1, #JobBlips, 1 do
			RemoveBlip(JobBlips[i])
			JobBlips[i] = nil
		end
	end
end



Citizen.CreateThread(function()
if inservizio == false then
	while true do

		Citizen.Wait(10)
            local coords = GetEntityCoords(PlayerPedId())
			local playerPed = GetPlayerPed()
	        for k,v in pairs(Config.Zones) do	
		    for i = 1, #v.Pos, 1 do			
			if  GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < 3 and PlayerData.job ~= nil and (PlayerData.job.name == 'unemployed') then
			if inservizio == false then
			DrawMarker(1,v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 0.4, 255, 255, 50, 100, false, true, 2, false, false, false, false)
            DrawText3Ds(vector3(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z+0.5), "~w~Premi ~w~[~g~E~w~]~w~ per iniziare a chiedere elemosina", 0.45)
						if IsControlJustPressed(0, Keys['E']) then
				Aprimenu()

			end	
			else
			DrawMarker(1,v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 0.4, 255, 255, 50, 100, false, true, 2, false, false, false, false)
		    DrawText3Ds(vector3(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z+0.5), "~w~Premi ~w~[~g~E~w~]~w~ per smettere di chiedere elemosina", 0.45)
			if IsControlJustPressed(0, Keys['E']) then
				Aprimenu()

			end		
			end
			end
			end
			end
			end
			end
end)

function Aprimenu()
    ESX.UI.Menu.CloseAll()
 if inservizio == false then
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pawn_menu',
        {
            title    = 'Elemosina',
            elements = {
				{label = 'Inizia a chiedere elemosina', value = 'elemosina'},
				{label = 'Cambiati i vestiti', value = 'vestiti'}
            }
        },
        function(data, menu)
            if data.current.value == 'elemosina' then
			    inservizio = true
			    ESX.ShowNotification("~w~Hai iniziato a chiedere ~y~elemosina")
				Elemosina()
				 menu.close()   
		 
            elseif data.current.value == 'vestiti' then
			vestiti = true
		   ESX.ShowNotification("~w~Ti sei cambiato i ~y~vestiti")
		   setUniform(data.current.value, PlayerPedId())
            end
        end,
        function(data, menu)
            menu.close()
        end
    )

	else 

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pawn_menu',
        {
            title    = 'Elemosina',
            elements = {
				{label = 'Smetti di chiedere elemosina', value = 'smettere'},
				{label = 'Cambiati i vestiti', value = 'togli'}
            }
        },
        function(data, menu)
            if data.current.value == 'smettere' then
			inservizio = false
			    ESX.ShowNotification("~w~Hai smesso di chiedere ~y~elemosina")
				Smettere()
				 menu.close()   

			elseif data.current.value == 'togli' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			local isMale = skin.sex == 0

			TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
		    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
			end)
			end)

		
        end,
        function(data, menu)
            menu.close()      
                end
		)
end
end)
end
end


Citizen.CreateThread(function()
function Elemosina()

	while true do

		Citizen.Wait(10)
            local coords = GetEntityCoords(PlayerPedId())
			local playerPed = GetPlayerPed()
			local soldi = Config.Guadagno

	        for k,v in pairs(Config.Elemosina) do	
		    for i = 1, #v.Pos, 1 do			

			if  PlayerData.job ~= nil and (PlayerData.job.name == 'unemployed') and inservizio == true then
			DrawMarker(21,v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.0, 1.0, 75, 255, 255, 100, false, true, 2, false, false, false, false)

			if IsControlJustPressed(0, 38) and (GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < 1.0) then
			TaskGoToCoordAnyMeans(GetPlayerPed(-1), v.Pos[i].x+2, v.Pos[i].y+2, v.Pos[i].z, 1.0, 0, 0, 786603, 1.0)
			Citizen.Wait(1*1000)
            TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_BUM_FREEWAY", 0, true)
			Citizen.Wait(15*1000)
			TriggerServerEvent("esx_elemosina:soldi")
		    ESX.ShowNotification("~w~Hai guadagnato ~g~".. soldi .. "~g~$~w~ chiedendo elemosina")
			ClearPedTasks(PlayerPedId())
			end	
end
end
end
end
end
end)

AddEventHandler('esx_elemosina:uscitodalblip', function (zone)
	if not Aprimenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil
		 for k,v in pairs(Config.Elemosina) do	
		  for i = 1, #v.Pos, 1 do	

			if(GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < 1.5) then
				isInMarker  = true
				currentZone = k
			end

		if inservizio and (isInMarker and not HasAlreadyEnteredMarker)  then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
      	ESX.ShowHelpNotification("~w~Premi ~w~[~g~E~w~]~w~ per chiedere elemosina")
		end


		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_elemosina:uscitodalblip', LastZone)
		end
	end
end
end
end)


function Smettere()

end

function refreshBlips()
	if PlayerData.job ~= nil and (PlayerData.job.name == 'unemployed' or PlayerData.org.name == 'unemployed') then

        for k,v in pairs(Config.Zones) do	
		    for i = 1, #v.Pos, 1 do	
			local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)		
			SetBlipSprite (blip, 409)
			SetBlipDisplay(blip, 4)
		    SetBlipScale  (blip, 1.0)
		    SetBlipColour (blip, 0)
		    SetBlipAsShortRange(blip, true)
		    BeginTextCommandSetBlipName("STRING")
		    AddTextComponentString("Elemosina")
			EndTextCommandSetBlipName(blip)
			table.insert(JobBlips, blip)
		    end
			end
			end
end

-- 3d Text Function
DrawText3Ds = function(coords, text, scale)
    local x,y,z = coords.x, coords.y, coords.z
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 215)

    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 500

    DrawRect(_x, _y + 0.0130, 0.052 + factor, 0.030, 14, 14, 14, 150)
end