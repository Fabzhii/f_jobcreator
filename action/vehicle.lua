
local ox_inventory = exports.ox_inventory
local locales = Locales.Locales[Locales.Language]

exports('open_vehicle', function()
    local vehicle = ESX.Game.GetClosestVehicle(coords, modelFilter)
    if vehicle ~= -1 and #(GetEntityCoords(vehicle) - GetEntityCoords(PlayerPedId())) < 3 then 

        if GetCount('dietrich') > 0 then 

            ESX.Streaming.RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", function()
                TaskPlayAnim(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8.0, -1, 0, 0.0, false, false, false)
            end)


            if lib.skillCheck('easy') then 
                Citizen.Wait(100)
                if lib.skillCheck('easy') then 
                    Citizen.Wait(100)
                    if lib.skillCheck('easy') then 
                        Citizen.Wait(100)
                        lib.progressCircle({
                            duration = 5000,
                            position = 'bottom',
                        })
                        TriggerServerEvent('fjob:removeItem', 'dietrich', 1, nil)
                        ClearPedTasksImmediately(PlayerPedId())
                        SetVehicleDoorsLocked(vehicle, 1)
                        Config.Notifcation(locales['opened_vehicle'])
                    else 
                        Config.Notifcation(locales['cound_not_crack'])
                        ClearPedTasksImmediately(PlayerPedId())
                    end 
                else 
                    Config.Notifcation(locales['cound_not_crack'])
                    ClearPedTasksImmediately(PlayerPedId())
                end 
            else 
                Config.Notifcation(locales['cound_not_crack'])
                ClearPedTasksImmediately(PlayerPedId())
            end 
        else 
            Config.Notification('no_lockpick')
        end 
    else 
        Config.Notifcation(locales['no_vehicle'])
    end 
end)

exports('delete_vehicle', function()
    local vehicle = ESX.Game.GetClosestVehicle(coords, modelFilter)
    if vehicle ~= -1 and #(GetEntityCoords(vehicle) - GetEntityCoords(PlayerPedId())) < 3 then 

        ESX.Streaming.RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", function()
            TaskPlayAnim(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8.0, -1, 0, 0.0, false, false, false)
        end)

        lib.progressCircle({
            duration = 15000,
            position = 'bottom',
        })

        exports["AdvancedParking"]:DeleteVehicle(vehicle)
        ClearPedTasksImmediately(PlayerPedId())
        Config.Notifcation(locales['deleted_vehicle'])
    else 
        Config.Notifcation(locales['no_vehicle'])
    end 
end)

exports('repair_vehicle_body', function()
    local vehicle = ESX.Game.GetClosestVehicle(coords, modelFilter)
    if vehicle ~= -1 and #(GetEntityCoords(vehicle) - GetEntityCoords(PlayerPedId())) < 3 then 
        if GetCount('body_kit') > 0 then 

            enginehealth = GetVehicleEngineHealth(vehicle)

            ESX.Streaming.RequestAnimDict("mini@repair", function()
                TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped", 8.0, -8.0, -1, 0, 0.0, false, false, false)
            end)
            lib.progressCircle({
                duration = 10000,
                position = 'bottom',
            })
            SetVehicleBodyHealth(vehicle, 1000.0)
            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            Config.Notifcation(locales['repaired_body'])
            ClearPedTasksImmediately(PlayerPedId())
            TriggerServerEvent('fjob:removeItem', 'body_kit', 1, nil)
            Citizen.Wait(50)
            SetVehicleEngineHealth(vehicle, enginehealth)
        else 
            Config.Notifcation(locales['no_body_kit'])
        end 
    else 
        Config.Notifcation(locales['no_vehicle'])
    end 
end)


exports('repair_vehicle_engine', function()
    local vehicle = ESX.Game.GetClosestVehicle(coords, modelFilter)
    if vehicle ~= -1 and #(GetEntityCoords(vehicle) - GetEntityCoords(PlayerPedId())) < 3 then 
        if GetCount('engine_kit') > 0 then 
            SetVehicleDoorOpen(vehicle, 4, false, true)
            ESX.Streaming.RequestAnimDict("mini@repair", function()
                TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped", 8.0, -8.0, -1, 0, 0.0, false, false, false)
            end)
            lib.progressCircle({
                duration = 10000,
                position = 'bottom',
            })
            SetVehicleEngineHealth(vehicle, 1000.0)
            Config.Notifcation(locales['repaired_engine'])
            ClearPedTasksImmediately(PlayerPedId())
            SetVehicleDoorShut(vehicle, 4, true) 
            TriggerServerEvent('fjob:removeItem', 'engine_kit', 1, nil)
        else 
            Config.Notifcation(locales['no_engine_kit'])
        end 
    else 
        Config.Notifcation(locales['no_vehicle'])
    end 
end)

exports('repair_vehicle_wheels', function()
    local vehicle = ESX.Game.GetClosestVehicle(coords, modelFilter)
    if vehicle ~= -1 and #(GetEntityCoords(vehicle) - GetEntityCoords(PlayerPedId())) < 3 then 
        if GetCount('tire_kit') > 0 then 
        
            repaired_lf = false
            repaired_rf = false
            repaired_lr = false
            repaired_rr = false

            red = {r = 255, g = 0, b = 0}
            green = {r = 0, g = 255, b = 0}

            local lf = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "wheel_lf"))
            local rf = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "wheel_rf"))
            local lr = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "wheel_lr"))
            local rr = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "wheel_rr"))

            repairing = true 
            while repairing do 

                local lf_dist = #(GetEntityCoords(PlayerPedId()) - lf)
                local rf_dist = #(GetEntityCoords(PlayerPedId()) - rf)
                local lr_dist = #(GetEntityCoords(PlayerPedId()) - lr)
                local rr_dist = #(GetEntityCoords(PlayerPedId()) - rr)

                if not repaired_lf then 
                    CreateWheelMarker(lf, red)
                else 
                    CreateWheelMarker(lf, green)
                end 

                if not repaired_rf then 
                    CreateWheelMarker(rf, red)
                else 
                    CreateWheelMarker(rf, green)
                end 

                if not repaired_lr then 
                    CreateWheelMarker(lr, red)
                else 
                    CreateWheelMarker(lr, green)
                end 

                if not repaired_rr then 
                    CreateWheelMarker(rr, red)
                else 
                    CreateWheelMarker(rr, green)
                end 

                lib.showTextUI(Menus.Vehicle.repair_wheels_text, {
                    position = 'left-center',
                })

                if IsControlJustReleased(0, 38) then 

                    if lf_dist < 1.5 and not repaired_lf then 
                        if skillcheck() then 
                            repaired_lf = true 
                        else 
                            Config.Notifcation(locales['could_not_repair_wheel'])
                        end 
                    elseif rf_dist < 1.5 and not repaired_rf then 
                        if skillcheck() then 
                            repaired_rf = true 
                        else 
                            Config.Notifcation(locales['could_not_repair_wheel'])
                        end 
                    elseif lr_dist < 1.5 and not repaired_lr then 
                        if skillcheck() then 
                            repaired_lr = true 
                        else 
                            Config.Notifcation(locales['could_not_repair_wheel'])
                        end 
                    elseif rr_dist < 1.5 and not repaired_rr then 
                        if skillcheck() then 
                            repaired_rr = true 
                        else 
                            Config.Notifcation(locales['could_not_repair_wheel'])
                        end 
                    else 
                        Config.Notifcation(locales['not_at_wheel'])
                    end 
                end 

                if repaired_rr and repaired_lr and repaired_rf and repaired_lf then 
                    repairing = false 
                end 

                if IsControlJustReleased(0, 177) then 
                    repairing = false 
                end 

                Citizen.Wait(1)
            end 
            lib.hideTextUI()
            if repaired_rr and repaired_lr and repaired_rf and repaired_lf then 
                SetVehicleWheelHealth(vehicle, -1, 1000)
                SetVehicleWheelHealth(vehicle, 0, 1000)
                SetVehicleWheelHealth(vehicle, 1, 1000)
                SetVehicleWheelHealth(vehicle, 2, 1000)
                SetVehicleWheelHealth(vehicle, 3, 1000)
                SetVehicleWheelHealth(vehicle, 6, 1000)
                Config.Notifcation(locales['repaired_wheels'])
                TriggerServerEvent('fjob:removeItem', 'tire_kit', 1, nil)
            end 
        else 
            Config.Notifcation(locales['no_wheel_kit'])
        end 
    else 
        Config.Notifcation(locales['no_vehicle'])
    end 
end)

function skillcheck()
    done = false 
    ESX.Streaming.RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", function()
        TaskPlayAnim(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8.0, -1, 0, 0.0, false, false, false)
    end)
    Citizen.Wait(300)
    if lib.skillCheck('easy') then 
        Citizen.Wait(100)
        if lib.skillCheck('easy') then 
            Citizen.Wait(100)
            if lib.skillCheck('easy') then 
                Citizen.Wait(100)
                done = true 
                lib.progressCircle({
                    duration = 5000,
                    position = 'bottom',
                })
            end 
        end 
    end 

    Citizen.Wait(500)
    ClearPedTasksImmediately(PlayerPedId())
    return(done)
end 

function CreateWheelMarker(pos, color)
    DrawMarker(
        28, pos, 0.0, 0.0, 0.0, 0.0, 180, 0.0, 0.4, 0.4, 0.4, 
        color.r, color.g, color.b, 100, false, true, 2, nil, nil, false
    )
end 