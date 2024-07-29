
local ox_inventory = exports.ox_inventory
local locales = Locales.Locales[Locales.Language]

exports('heal_small', function()
    local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
        ESX.Streaming.RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", function()
            TaskPlayAnim(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8.0, -1, 0, 0.0, false, false, false)
        end)
        lib.progressCircle({
            duration = 5000,
            position = 'bottom',
        })
        TriggerServerEvent('fjob:addHealth', GetPlayerServerId(closestPlayer), 100)
        Config.Notifcation(locales['healed'])
    else
        Config.Notifcation(locales['no_players'])
    end
end)

exports('heal_big', function()
    local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
        ESX.Streaming.RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", function()
            TaskPlayAnim(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8.0, -1, 0, 0.0, false, false, false)
        end)
        lib.progressCircle({
            duration = 5000,
            position = 'bottom',
        })
        TriggerServerEvent('fjob:addHealth', GetPlayerServerId(closestPlayer), 30)
        Config.Notifcation(locales['healed'])
    else
        Config.Notifcation(locales['no_players'])
    end
end)

exports('revive', function()   
    local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then

        local counter = 0
        while counter < 30 do 
            local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
            end)
            Citizen.Wait(900)
            counter = counter + 1
        end 
        TriggerServerEvent('fjob:reviveId', GetPlayerServerId(closestPlayer))
        Config.Notifcation(locales['revived'])
    else
        Config.Notifcation(locales['no_players'])
    end
end)
