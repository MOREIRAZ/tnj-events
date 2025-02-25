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

CreateThread(function()
    while true do
        Wait(0)
        local player = PlayerId()

        if NetworkIsPlayerActive(player) then
            local ped = PlayerPedId()

            if IsPedShooting(ped) then
                local isShooting = IsPedShooting(ped)
                local isShootingEntity, entityShot = GetEntityPlayerIsFreeAimingAt(player)
                local entityType = GetEntityType(entityShot)
                local shotFromVehicle = IsPedDoingDriveby(ped)
                TriggerEvent('tnj-events:onPlayerShoot', isShooting, isShootingEntity, entityShot, entityType, shotFromVehicle)
                TriggerServerEvent('tnj-events:onPlayerShoot', isShooting, isShootingEntity, entityShot, entityType, shotFromVehicle)
            end

        end
    end
end)
