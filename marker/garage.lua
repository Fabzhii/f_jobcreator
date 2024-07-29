
local ox_inventory = exports.ox_inventory
local locales = Locales.Locales[Locales.Language]

function openGarage(marker, grade, positionIndex)
    ESX.TriggerServerCallback('fjob:getJob', function(xJob, xJobGrade)

        local options = {
            {
                title = Menus.Garage.park_out,
                description = Menus.Garage.park_out_desc,
                icon = 'car',
                onSelect = function()
                    openStoredVehicles(marker, grade, positionIndex)
                end,
            },
        }
        if marker.vehicles ~= {} then 
            table.insert(options, {
                title = Menus.Garage.buy_vehicle,
                description = Menus.Garage.buy_vehicle_desc,
                icon = 'warehouse',
                onSelect = function()
                    buyVehicles(marker, grade, positionIndex)
                end,
            })
        end 

        lib.registerContext({
            id = 'f_garage_main',
            title = Menus.MainMenus[3],
            options = options,
        })
        lib.showContext('f_garage_main')
    end)
end 

function buyVehicles(marker, grade, positionIndex)

    ESX.TriggerServerCallback('fjob:getJob', function(xJob, xJobGrade)
        local options = {}
        local bucket = GetRandomIntInRange(1, 99)
        TriggerServerEvent('fjob:setPlayerBucket', bucket)

        SetEntityCoords(PlayerPedId(), vector3(marker.position[positionIndex].inside.x, marker.position[positionIndex].inside.y, marker.position[positionIndex].inside.z))
        exports["AdvancedParking"]:DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
        toggleExit(true)
        SetPlayerInvincible(PlayerId(), true)
        SetEntityAlpha(PlayerPedId(), 0, true)

        for k,v in pairs(marker.vehicles) do 
            local values = {}
            local args = {}
            for o, i in pairs(v.cars) do 
                if grade >= i.grade then 
                    table.insert(args, {i.spawn, i.price})
                    table.insert(values, (GetLabelText(i.spawn) ..' - ' .. i.price .. '$'))
                end 
            end 

            table.insert(options, {
                label = v.cathegorie, 
                values = values, 
                args = args,
            })
        end

        lib.registerMenu({
            id = 'buy_veh',
            title = Menus.Garage.header,
            position = Menus.Garage.position,

            onSelected = function(selected, secondary, args)
                Citizen.Wait(10)
                exports["AdvancedParking"]:DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                Citizen.Wait(10)
                local vehicle = spawncar(options[selected].args[secondary][1], vector3(marker.position[positionIndex].inside.x, marker.position[positionIndex].inside.y, marker.position[positionIndex].inside.z), bucket)
                Citizen.Wait(10)
                SetPedIntoVehicle(PlayerPedId(), vehicle, -1) 
            end,

            onSideScroll = function(selected, scrollIndex, args)
                Citizen.Wait(10)
                exports["AdvancedParking"]:DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                Citizen.Wait(10)
                local vehicle = spawncar(args[scrollIndex][1], vector3(marker.position[positionIndex].inside.x, marker.position[positionIndex].inside.y, marker.position[positionIndex].inside.z), bucket)
                Citizen.Wait(10)
                SetPedIntoVehicle(PlayerPedId(), vehicle, -1) 
            end,
            onClose = function(keyPressed)
                TriggerServerEvent('fjob:setPlayerBucket', 0)
                openGarage(marker, grade, positionIndex)

                SetEntityCoords(PlayerPedId(), vector3(marker.position[positionIndex].menu.x, marker.position[positionIndex].menu.y, marker.position[positionIndex].menu.z))
                exports["AdvancedParking"]:DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                toggleExit(false)
                SetPlayerInvincible(PlayerId(), false)
                SetEntityAlpha(PlayerPedId(), 255, false)

            end,
            options = options,
        }, function(selected, scrollIndex, args)
            if GetCount('money') > args[scrollIndex][2] then 
                local alert = lib.alertDialog({
                    header = GetLabelText(args[scrollIndex][1]),
                    content = (Menus.Garage.buy_menu):format(args[scrollIndex][2]),
                    centered = true,
                    cancel = true,
                    labels = {
                        cancel = Menus.Garage.cancel,
                        confirm = Menus.Garage.confirm,
                    }
                })
                if alert == 'confirm' then 
                    local vehicleProps = ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId(), false))
                    local platetext = vehicleProps.plate
                    TriggerServerEvent('fjob:writesqlcar', vehicleProps, platetext, xJob, GetType(args[scrollIndex][1], marker.vehicles))
                    TriggerServerEvent('fjob:removeItem', 'money', args[scrollIndex][2], nil)
                    exports["AdvancedParking"]:DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                    SetEntityCoords(PlayerPedId(), vector3(marker.position[positionIndex].menu.x, marker.position[positionIndex].menu.y, marker.position[positionIndex].menu.z))
                    SetPlayerInvincible(PlayerId(), false)
                    SetEntityAlpha(PlayerPedId(), 255, false)
                    TriggerServerEvent('fjob:setPlayerBucket', 0)
                    toggleExit(false)
                else 
                    lib.hideMenu(false)
                    exports["AdvancedParking"]:DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                    buyVehicles(marker, grade, positionIndex)
                end 
            else 
                lib.hideMenu(false)
                exports["AdvancedParking"]:DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                buyVehicles(marker, grade, positionIndex)
                Config.Notifcation(locales['no_money'])
            end 
        end)
        lib.showMenu('buy_veh')
        
    end)
end 


function openStoredVehicles(marker, grade, positionIndex)
    ESX.TriggerServerCallback('fjob:getJob', function(xJob, xJobGrade)
        ESX.TriggerServerCallback('fjob:getOwnedCars', function(xCars)
            local options = {}
            for k,v in pairs(xCars) do 
                if v.job == xJob and v.type == marker.garage_type then 
                    local vehicle = json.decode(v.vehicle).model
                    local vehicle = GetDisplayNameFromVehicleModel(vehicle)
                    table.insert(options, {
                        title = GetLabelText(vehicle),
                        description = (v.plate),
                        icon = Config.Symbols[v.stored + 1],
                        onSelect = function()
                            if tonumber(v.stored) == 1 then 
                                local avaible = false 
                                for o,i in pairs(marker.position[positionIndex].spawn) do 
                                    local pos = vector4(i.x, i.y, i.z, i.w)
                                    local closest_veh = ESX.Game.GetClosestVehicle(pos)
                                    if closest_veh == -1 or #(GetEntityCoords(closest_veh) - vector3(pos.x, pos.y, pos.z)) > 2.0 then 
                                        avaible = true  
                                        SetEntityCoords(PlayerPedId(), pos)
                                        Citizen.Wait(100)
                                        ESX.Game.SpawnVehicle(json.decode(v.vehicle).model, GetEntityCoords(PlayerPedId()), pos.w, function(vehicle)
                                            ESX.Game.SetVehicleProperties(vehicle, json.decode(v.vehicle))
                                            Config.Notifcation(locales['parked_vehicle_out'])
                                            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                        end)
                                        TriggerServerEvent('fjob:setVehicleParkingState', json.decode(v.vehicle).plate, 0)
                                        break 
                                    end 
                                end 

                                if avaible == false then 
                                    Config.Notifcation(locales['no_free_parking_spot'])
                                end 

                            else 
                                Config.Notifcation(locales['not_parked'])
                            end 
                        end 
                    })
                end
            end 

            lib.registerContext({
                id = 'f_garage_owned',
                title = Menus.Garage.your_vehicles,
                onExit = function()
                    openGarage(marker, grade, positionIndex)
                end,
                options = options,
            })
            lib.showContext('f_garage_owned')

        end)
    end)
end 

function parkIn(o, k, grade)
    ESX.TriggerServerCallback('fjob:getJob', function(xJob, xJobGrade)
        ESX.TriggerServerCallback('fjob:getOwnedCars', function(xCars)
            local current_vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local vehicleProps = ESX.Game.GetVehicleProperties(current_vehicle)
            local platetext = vehicleProps.plate
            local exist = false 
            for k,v in pairs(xCars) do 
                if v.job == xJob then 
                    if v.plate == platetext then 
                        exist = true 
                        if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() then 
                            exports["AdvancedParking"]:DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                            TriggerServerEvent('fjob:setVehicleParkingState', platetext, 1)
                            Config.Notifcation(locales['parked_vehicle_in'])
                        end 
                    end 
                end 
            end 
            if exist == false then 
                Config.Notifcation(locales['cant_park'])
            end 
        end)
    end)
end 

function GetType(spawn, vehicles)
    local returnValue = 'car'
    for k,v in pairs(vehicles) do 
        for o,i in pairs(v.cars) do 
            if string.lower(i.spawn) == string.lower(spawn) then 
                returnValue = i.type
            end 
        end 
    end 
    return(returnValue)
end 