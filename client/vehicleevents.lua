--[[ 
	tnj-events
 _________  ________           ___
|\___   ___\\   __  \         |\  \
\|___ \  \_\ \  \|\  \  /\    \ \  \
     \ \  \ \ \__     \/  \ __ \ \  \
      \ \  \ \|_/  __     /|\  \\_\  \
       \ \__\  /  /_|\   / | \________\
        \|__| /_______   \/ \|________|
              |_______|\__\
                      \|__|


    Credits:
    - CFX Network for the "baseevents" resource


]] -- Do not edit this file unless you know what you are doing

local isInVehicle = false
local isEnteringVehicle = false
local currentVehicle = 0
local currentSeat = 0
local engineState = 0

CreateThread(function()
	while true do
		Wait(0)

		local ped = PlayerPedId()

		if not isInVehicle and not IsPlayerDead(PlayerId()) then
			if DoesEntityExist(GetVehiclePedIsTryingToEnter(ped)) and not isEnteringVehicle then
				-- trying to enter a vehicle!
				local vehicle = GetVehiclePedIsTryingToEnter(ped)
				local seat = GetSeatPedIsTryingToEnter(ped)
				local netId = VehToNet(vehicle)
				isEnteringVehicle = true
				TriggerServerEvent('tnj-events:enteringVehicle', vehicle, seat, GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)), netId)
                TriggerEvent('tnj-events:enteringVehicle', vehicle, seat, GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)), netId)
			elseif not DoesEntityExist(GetVehiclePedIsTryingToEnter(ped)) and not IsPedInAnyVehicle(ped, true) and isEnteringVehicle then
				-- vehicle entering aborted
				engineState = false
				TriggerServerEvent('tnj-events:enteringAborted')
                TriggerEvent('tnj-events:enteringAborted')
				isEnteringVehicle = false
			elseif IsPedInAnyVehicle(ped, false) then
				-- suddenly appeared in a vehicle, possible teleport
				isEnteringVehicle = false
				isInVehicle = true
				currentVehicle = GetVehiclePedIsUsing(ped)
				currentSeat = GetPedVehicleSeat(ped)
				local model = GetEntityModel(currentVehicle)
				local name = GetDisplayNameFromVehicleModel()
				local netId = VehToNet(currentVehicle)
				TriggerServerEvent('tnj-events:enteredVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle)), netId)
                TriggerEvent('tnj-events:enteredVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle)), netId)
			end
		elseif isInVehicle then
			if not IsPedInAnyVehicle(ped, false) or IsPlayerDead(PlayerId()) then
				-- bye, vehicle
				local model = GetEntityModel(currentVehicle)
				local name = GetDisplayNameFromVehicleModel()
				local netId = VehToNet(currentVehicle)
				TriggerServerEvent('tnj-events:leftVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle)), netId)
                TriggerEvent('tnj-events:leftVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle)), netId)
				isInVehicle = false
				currentVehicle = 0
				currentSeat = 0
			elseif GetIsVehicleEngineRunning(currentVehicle) ~= engineState then
				engineState = GetIsVehicleEngineRunning(currentVehicle)
				local netId = VehToNet(currentVehicle)
				TriggerServerEvent('tnj-events:engineChange', engineState, currentVehicle, GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle)), netId)
                TriggerEvent('tnj-events:engineChange', engineState, currentVehicle, GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle)), netId)
			end
		end
		Wait(50)
	end
end)
