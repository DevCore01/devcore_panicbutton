local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168,["F11"] = 344, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }


ESX = nil
local panic = false

Citizen.CreateThread(function()
	while ESX == nil do
	  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	  Citizen.Wait(250)
	end

	while ESX.GetPlayerData().job == nil do
	  Citizen.Wait(250)
  end
  
  ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if ESX.PlayerData.job.name == Config.PoliceName then
			if not panic and IsControlJustPressed(1, Config.PanicButton) then
				panic = true
				local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
				local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
				local street1 = GetStreetNameFromHashKey(s1)
				local player = GetPlayerPed(PlayerId())
				TriggerServerEvent('devcore_panicbutton:server:Panic', player, street1)
				TriggerServerEvent('devcore_panicbutton:server:Blip', plyPos.x, plyPos.y, plyPos.z)
			end
		else
			Citizen.Wait(500)
		end
	end
end)


RegisterNetEvent('devcore_panicbutton:client:Panic')
AddEventHandler('devcore_panicbutton:client:Panic', function(player, s1, s2)
	if ESX.PlayerData.job.name == Config.PoliceName then
			local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(GetPlayerFromServerId(player)))
			ESX.ShowAdvancedNotification('PANIC BUTTON', 'Officer', ' Officer in danger. ' ..s1, mugshotStr, 4)
			UnregisterPedheadshot(mugshot)
	end
end)

RegisterNetEvent('devcore_panicbutton:client:Blip')
AddEventHandler('devcore_panicbutton:client:Blip', function(tx, ty, tz)
	if ESX.PlayerData.job.name == Config.PoliceName then
	local transT = 250
	local Blip = AddBlipForCoord(tx, ty, tz)
	SetBlipSprite(Blip,  161)
	SetBlipColour(Blip,  1)
	SetBlipScale(Blip , 2.0)
	SetBlipAlpha(Blip,  transT)
	SetBlipAsShortRange(Blip,  false)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('panicbuttonblip'))
	EndTextCommandSetBlipName(Blip)
	PulseBlip(Blip)
	while transT ~= 0 do
		Wait(Config.blipTime * 4)
		transT = transT - 1
		SetBlipAlpha(Blip,  transT)
			if transT == 0 then
				SetBlipSprite(Blip,  2)
				panic = false
				return
			end
		end
	end
end)