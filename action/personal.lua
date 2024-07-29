
local ox_inventory = exports.ox_inventory
local locales = Locales.Locales[Locales.Language]

exports('check_identity', function()
    local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
        openId(GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
    else
        Config.Notifcation(locales['no_players'])
    end
end)

exports('give_license', function()
    local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
        ESX.TriggerServerCallback('fjob:getLicenses', function(xLicenses)

            local has_dmv = false
            local has_drive = false 
            local has_boat = false 
            local has_drive_bike = false 
            local has_drive_truck = false
            local has_plane = false 
            local has_heli = false
            local has_weapon = false 

            for k,v in pairs(xLicenses) do 
                if v.type == 'dmv' then 
                    has_dmv = true 
                end 
                if v.type == 'drive' then 
                    has_drive = true 
                end 
                if v.type == 'boat' then 
                    has_boat = true 
                end 
                if v.type == 'drive_bike' then 
                    has_drive_bike = true 
                end 
                if v.type == 'drive_truck' then 
                    has_drive_truck = true 
                end 
                if v.type == 'plane' then 
                    has_plane = true 
                end 
                if v.type == 'heli' then 
                    has_heli = true 
                end 
                if v.type == 'weapon' then 
                    has_weapon = true 
                end 
            end 

            local options = {
                {
                    title = Menus.Licenses.dmv,
                    icon = 'id-card',
                    disabled = has_dmv,
                    onSelect = function()
                        TriggerServerEvent('fjob:addLicense', GetPlayerServerId(closestPlayer), 'dmv')
                    end, 
                },
                {
                    title = Menus.Licenses.drive,
                    icon = 'id-card',
                    disabled = has_drive,
                    onSelect = function()
                        TriggerServerEvent('fjob:addLicense', GetPlayerServerId(closestPlayer), 'drive')
                    end, 
                },
                {
                    title = Menus.Licenses.drive_bike,
                    icon = 'id-card',
                    disabled = has_drive_bike,
                    onSelect = function()
                        TriggerServerEvent('fjob:addLicense', GetPlayerServerId(closestPlayer), 'drive_bike')
                    end, 
                },
                {
                    title = Menus.Licenses.drive_truck,
                    icon = 'id-card',
                    disabled = has_drive_truck,
                    onSelect = function()
                        TriggerServerEvent('fjob:addLicense', GetPlayerServerId(closestPlayer), 'drive_truck')
                    end, 
                },

                {
                    title = Menus.Licenses.boat,
                    icon = 'id-card',
                    disabled = has_boat,
                    onSelect = function()
                        TriggerServerEvent('fjob:addLicense', GetPlayerServerId(closestPlayer), 'boat')
                    end, 
                },
                {
                    title = Menus.Licenses.heli,
                    icon = 'id-card',
                    disabled = has_heli,
                    onSelect = function()
                        TriggerServerEvent('fjob:addLicense', GetPlayerServerId(closestPlayer), 'heli')
                    end, 
                },
                {
                    title = Menus.Licenses.plane,
                    icon = 'id-card',
                    disabled = has_plane,
                    onSelect = function()
                        TriggerServerEvent('fjob:addLicense', GetPlayerServerId(closestPlayer), 'plane')
                    end, 
                },

                {
                    title = Menus.Licenses.weapon,
                    icon = 'id-card',
                    disabled = has_weapon,
                    onSelect = function()
                        TriggerServerEvent('fjob:addLicense', GetPlayerServerId(closestPlayer), 'weapon')
                    end, 
                },
            }

            lib.registerContext({
                id = 'fjob_add_license',
                title = Menus.Licenses.header_add,
                options = options
            })
            lib.showContext('fjob_add_license')


        end, GetPlayerServerId(closestPlayer))
    else 
        Config.Notifcation(locales['no_players'])
    end 
end)

exports('get_license', function()
    local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
        ESX.TriggerServerCallback('fjob:getLicenses', function(xLicenses)

            local has_dmv = false
            local has_drive = false 
            local has_boat = false 
            local has_drive_bike = false 
            local has_drive_truck = false
            local has_plane = false 
            local has_heli = false
            local has_weapon = false 

            for k,v in pairs(xLicenses) do 
                if v.type == 'dmv' then 
                    has_dmv = true 
                end 
                if v.type == 'drive' then 
                    has_drive = true 
                end 
                if v.type == 'boat' then 
                    has_boat = true 
                end 
                if v.type == 'drive_bike' then 
                    has_drive_bike = true 
                end 
                if v.type == 'drive_truck' then 
                    has_drive_truck = true 
                end 
                if v.type == 'plane' then 
                    has_plane = true 
                end 
                if v.type == 'heli' then 
                    has_heli = true 
                end 
                if v.type == 'weapon' then 
                    has_weapon = true 
                end 
            end 

            local options = {
                {
                    title = Menus.Licenses.dmv,
                    icon = 'id-card',
                    disabled = not has_dmv,
                    onSelect = function()
                        TriggerServerEvent('fjob:removeLicense', GetPlayerServerId(closestPlayer), 'dmv')
                    end, 
                },
                {
                    title = Menus.Licenses.drive,
                    icon = 'id-card',
                    disabled = not has_drive,
                    onSelect = function()
                        TriggerServerEvent('fjob:removeLicense', GetPlayerServerId(closestPlayer), 'drive')
                    end, 
                },
                {
                    title = Menus.Licenses.drive_bike,
                    icon = 'id-card',
                    disabled = not has_drive_bike,
                    onSelect = function()
                        TriggerServerEvent('fjob:removeLicense', GetPlayerServerId(closestPlayer), 'drive_bike')
                    end, 
                },
                {
                    title = Menus.Licenses.drive_truck,
                    icon = 'id-card',
                    disabled = not has_drive_truck,
                    onSelect = function()
                        TriggerServerEvent('fjob:removeLicense', GetPlayerServerId(closestPlayer), 'drive_truck')
                    end, 
                },

                {
                    title = Menus.Licenses.boat,
                    icon = 'id-card',
                    disabled = not has_boat,
                    onSelect = function()
                        TriggerServerEvent('fjob:removeLicense', GetPlayerServerId(closestPlayer), 'boat')
                    end, 
                },
                {
                    title = Menus.Licenses.heli,
                    icon = 'id-card',
                    disabled = not has_heli,
                    onSelect = function()
                        TriggerServerEvent('fjob:removeLicense', GetPlayerServerId(closestPlayer), 'heli')
                    end, 
                },
                {
                    title = Menus.Licenses.plane,
                    icon = 'id-card',
                    disabled = not has_plane,
                    onSelect = function()
                        TriggerServerEvent('fjob:removeLicense', GetPlayerServerId(closestPlayer), 'plane')
                    end, 
                },

                {
                    title = Menus.Licenses.weapon,
                    icon = 'id-card',
                    disabled = not has_weapon,
                    onSelect = function()
                        TriggerServerEvent('fjob:removeLicense', GetPlayerServerId(closestPlayer), 'weapon')
                    end, 
                },
            }

            lib.registerContext({
                id = 'fjob_add_license',
                title = Menus.Licenses.header_remove,
                options = options
            })
            lib.showContext('fjob_add_license')


        end, GetPlayerServerId(closestPlayer))
    else 
        Config.Notifcation(locales['no_players'])
    end 
end)


exports('billing', function()
    local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
        openBilling(GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
    else
        Config.Notifcation(locales['no_players'])
    end
end)
