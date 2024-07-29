
local ox_inventory = exports.ox_inventory
local locales = Locales.Locales[Locales.Language]
local cuff_state = nil 
local iscuffed = false 
local dragged = false 
local draggerId = 0 

exports('search', function()
    local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
        TriggerServerEvent('fjob:notifyId', GetPlayerServerId(closestPlayer), locales['get_searched'])
        exports.ox_inventory:openInventory('player', GetPlayerServerId(closestPlayer))
    else
        Config.Notifcation(locales['no_players'])
    end
end)

exports('ziptie', function()
    if GetCount('ziptie') > 0 then 
        local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
            local cuffid = GetPlayerServerId(closestPlayer)
            playerheading = GetEntityHeading(GetPlayerPed(-1))
            playerlocation = GetEntityForwardVector(PlayerPedId())
            playerCoords = GetEntityCoords(PlayerPedId())
            TriggerServerEvent('fjob:requestcuff', cuffid, playerheading, playerCoords, playerlocation, false)
            TriggerServerEvent('fjob:removeItem', 'ziptie', 1, nil)
        else
            Config.Notifcation(locales['no_players'])
        end
    else 
        Config.Notifcation(locales['no_ziptie'])
    end 
end)


exports('handcuff', function(data, slot)
    if type(slot) == 'table' then 
        if GetCount('handcuff') > 0 then 
            local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
                local cuffid = GetPlayerServerId(closestPlayer)
                playerheading = GetEntityHeading(GetPlayerPed(-1))
                playerlocation = GetEntityForwardVector(PlayerPedId())
                playerCoords = GetEntityCoords(PlayerPedId())
                TriggerServerEvent('fjob:requestcuff', cuffid, playerheading, playerCoords, playerlocation, true)
                TriggerServerEvent('fjob:removeItem', 'handcuff', 1, nil)
            else
                Config.Notifcation(locales['no_players'])
            end  
        end 
    else 
        local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
            local cuffid = GetPlayerServerId(closestPlayer)
            playerheading = GetEntityHeading(GetPlayerPed(-1))
            playerlocation = GetEntityForwardVector(PlayerPedId())
            playerCoords = GetEntityCoords(PlayerPedId())
            TriggerServerEvent('fjob:requestcuff', cuffid, playerheading, playerCoords, playerlocation, true)
        else
            Config.Notifcation(locales['no_players'])
        end    
    end 
end)

RegisterNetEvent('fjob:getcuffed')
AddEventHandler('fjob:getcuffed', function(playerheading, playercoords, playerlocation, cuffstate)
	playerPed = PlayerPedId()
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(playerPed, x, y, z)
	SetEntityHeading(playerPed, playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Citizen.Wait(3760)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
    Config.Notifcation(locales['get_cuffed'])
    LocalPlayer.state.invBusy = true
    LocalPlayer.state.invHotkeys = false
    cuff_state = cuffstate
    iscuffed = true 
end)

RegisterNetEvent('fjob:docuff')
AddEventHandler('fjob:docuff', function()
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	Citizen.Wait(3000)
end) 

RegisterNetEvent('fjob:playsound')
AddEventHandler('fjob:playsound', function(coords, cuffstate)
    if #(coords - GetEntityCoords(PlayerPedId())) < 5 then 
        Citizen.Wait(500)
        if cuffstate then 
            SendNUIMessage({
                transactionType = 'playSound',
                transactionFile  = 'cuff',
                transactionVolume = 0.6
            })
        else 
            SendNUIMessage({
                transactionType = 'playSound',
                transactionFile  = 'ziptie',
                transactionVolume = 0.6
            })
        end 
    end 
end)

Citizen.CreateThread(function()
    while true do 
        if iscuffed then 
            if cuff_state ~= nil and cuff_state == false then 
                for k,v in pairs(Config.ZipTiesDisable) do 
                    DisableControlAction(0, v, true)
                end 
            end 
            if cuff_state ~= nil and cuff_state == true then 
                for k,v in pairs(Config.HandCuffsDisable) do 
                    DisableControlAction(0, v, true)
                end 
            end 
            if IsPedInAnyVehicle(PlayerPedId(), false) then 
                DisableControlAction(0, 30, true)
                DisableControlAction(0, 31, true)
                DisableControlAction(0, 32, true)
                DisableControlAction(0, 33, true)
                DisableControlAction(0, 34, true)
                DisableControlAction(0, 35, true)
                DisableControlAction(0, 38, true)
                DisableControlAction(0, 71, true)
                DisableControlAction(0, 72, true)
            else 
                if IsEntityPlayingAnim(PlayerPedId(), 'mp_arresting', 'idle', 3) ~= 1 then
                    ESX.Streaming.RequestAnimDict('mp_arresting', function()
                        TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
                        RemoveAnimDict('mp_arresting')
                    end)
                end
            end 
            Citizen.Wait(1)
        else 

            Citizen.Wait(200)
        end 
    end 
end)


exports('release', function(data, slot)
    local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
        ESX.TriggerServerCallback('fjob:getCuffState', function(toggle, state)
            if toggle == nil or toggle == false then 
                Config.Notifcation(locales['not_cuffed'])
            else 
                if state == true then 
                    if type(slot) == 'table' then 
                        if data.name == 'handcuff_key' then 
                            uncuff(GetPlayerServerId(closestPlayer), true, 'handcuff_key')
                        else 
                            Config.Notifcation(locales['no_fitting_item'])
                        end 
                    else 
                        uncuff(GetPlayerServerId(closestPlayer), true, nil)
                    end 
                end 
                if state == false then 
                    if type(slot) == 'table' then 
                        if data.name == 'ziptie_key' then 
                            uncuff(GetPlayerServerId(closestPlayer), false, 'ziptie_key')
                        else 
                            Config.Notifcation(locales['no_fitting_item'])
                        end 
                    else 
                        if GetCount('ziptie_key') > 0 then 
                            uncuff(GetPlayerServerId(closestPlayer), false, 'ziptie_key')
                        else 
                            Config.Notifcation(locales['no_ziptie_key'])
                        end 
                    end 
                end 
            end 
        end, GetPlayerServerId(closestPlayer))
    else
        Config.Notifcation(locales['no_players'])
    end  
end)

function uncuff(cuffid, state, item)

    if state then 
        if lib.skillCheck('easy') then 
            Citizen.Wait(100)
            if lib.skillCheck('easy') then 
                Citizen.Wait(100)
                if lib.skillCheck('easy') then 
                    Citizen.Wait(100)
                    if item ~= nil then 
                        TriggerServerEvent('fjob:removeItem', item, 1, nil)
                    end 
                    playerheading = GetEntityHeading(PlayerPedId())
                    playerlocation = GetEntityForwardVector(PlayerPedId())
                    playerCoords = GetEntityCoords(PlayerPedId())
                    TriggerServerEvent('fjob:requestuncuff', cuffid, playerheading, playerCoords, playerlocation)
                else 
                    Config.Notifcation(locales['cound_not_crack'])
                end 
            else 
                Config.Notifcation(locales['cound_not_crack'])
            end 
        else 
            Config.Notifcation(locales['cound_not_crack'])
        end 
    else 
        Citizen.CreateThread(function()
            Citizen.Wait(250)
            lib.progressCircle({
                duration = 4000,
                position = 'bottom',
                canCancel = false,
            })
        end)
        TriggerServerEvent('fjob:removeItem', item, 1, nil)
        playerheading = GetEntityHeading(PlayerPedId())
        playerlocation = GetEntityForwardVector(PlayerPedId())
        playerCoords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent('fjob:requestuncuff', cuffid, playerheading, playerCoords, playerlocation)
    end 

end 

RegisterNetEvent('fjob:douncuff')
AddEventHandler('fjob:douncuff', function()
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('fjob:getuncuff')
AddEventHandler('fjob:getuncuff', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(GetPlayerPed(-1))
    LocalPlayer.state.invBusy = false
    LocalPlayer.state.invHotkeys = true
    cuff_state = nil 
    iscuffed = false 
    Config.Notifcation(locales['get_released'])
end)

exports('vehicle_in', function()
    local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
        local vehicle = ESX.Game.GetClosestVehicle(coords, modelFilter)
        if vehicle ~= -1 and #(GetEntityCoords(vehicle) - GetEntityCoords(PlayerPedId())) < 3 then 

            seats = {}
            for i = -1, 6 do
                if IsVehicleSeatFree(vehicle, i) then 
                    table.insert(seats, {
                        title = (Menus.Player.seat):format(i+2),
                        description = Menus.Player.seat_desc,
                        icon = 'chair',
                        onSelect = function()
                            TriggerServerEvent('fjob:setPlayerIntoVehicle', GetPlayerServerId(closestPlayer), i)
                        end, 
                    })
                end 
            end 

            lib.registerContext({
                id = 'f_select_seat',
                title = Menus.Player.seat_header,
                options = seats 
            })
            lib.showContext('f_select_seat')
        else 
            Config.Notifcation(locales['no_vehicle'])
        end 
    else 
        Config.Notifcation(locales['no_players'])
    end 
end)

RegisterNetEvent('fjob:enterVehicle')
AddEventHandler('fjob:enterVehicle', function(seat)
    local vehicle = ESX.Game.GetClosestVehicle(coords, modelFilter)
    Config.Notifcation(locales['get_in_vehicle'])
    SetPedIntoVehicle(PlayerPedId(), vehicle, seat)
end)

RegisterNetEvent('fjob:exitVehicle')
AddEventHandler('fjob:exitVehicle', function()
    TaskLeaveVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), 0)
    Config.Notifcation(locales['get_out_of_vehicle'])
end)


exports('vehicle_out', function()
    local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
        local vehicle = ESX.Game.GetClosestVehicle(coords, modelFilter)
        if vehicle ~= -1 and #(GetEntityCoords(vehicle) - GetEntityCoords(PlayerPedId())) < 3 then 

            seats = {}
            for i = -1, 6 do
                if GetPedInVehicleSeat(vehicle, i) ~= 0 then 
                    table.insert(seats, {
                        title = (Menus.Player.seat):format(i+2),
                        description = Menus.Player.seat2_desc,
                        icon = 'chair',
                        onSelect = function()
                            TriggerServerEvent('fjob:setPlayerOutOfVehicle', GetPlayerServerId(closestPlayer))
                        end, 
                    })
                end 
            end 

            lib.registerContext({
                id = 'f_select_seat',
                title = Menus.Player.seat2_header,
                options = seats 
            })
            lib.showContext('f_select_seat')
        else 
            Config.Notifcation(locales['no_vehicle'])
        end 
    else 
        Config.Notifcation(locales['no_players'])
    end 
end)

exports('carry', function()
    local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
        ESX.TriggerServerCallback('fjob:getCuffState', function(toggle, state)
            if toggle == nil or toggle == false then 
                Config.Notifcation(locales['not_cuffed'])
            else 
                TriggerServerEvent('fjob:dragId', GetPlayerServerId(closestPlayer))
            end 
        end, GetPlayerServerId(closestPlayer))
    else
        Config.Notifcation(locales['no_players'])
    end 
end)


RegisterNetEvent('fjob:dragIdClient')
AddEventHandler('fjob:dragIdClient', function(senderId)
    if not dragged then 
        local targetPed = GetPlayerPed(GetPlayerFromServerId(senderId))
        AttachEntityToEntity(PlayerPedId(), targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
        Config.Notifcation(locales['get_carried'])
        dragged = true  
        draggerId = senderId 
    else 
        DetachEntity(PlayerPedId(), true, false)
        dragged = false 
        draggerId = 0 
    end 
end)

Citizen.CreateThread(function()
    while true do 
        if dragged then 
            local targetPed = GetPlayerPed(GetPlayerFromServerId(draggerId))
            if IsPedDeadOrDying(targetPed, true) or IsPedDeadOrDying(PlayerPedId(), true) then 
                DetachEntity(PlayerPedId(), true, false)
                dragged = false 
                draggerId = 0 
            end 
            if IsPedInAnyVehicle(targetPed, false) or IsPedInAnyVehicle(PlayerPedId(), false) then 
                DetachEntity(PlayerPedId(), true, false)
                dragged = false 
                draggerId = 0 
            end 
            Citizen.Wait(300)
        else 
            Citizen.Wait(1500)
        end 
    end 
end)
