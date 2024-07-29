
local ox_inventory = exports.ox_inventory
local locales = Locales.Locales[Locales.Language]
local createZones = {}

exports('zone_add', function()
    local input = lib.inputDialog(Menus.Zone.zone_create, {
        {type = 'input', label = Menus.Zone.name, required = true, min = 3, max = 22},
        {type = 'select', label = Menus.Zone.color, options = Menus.BlipColors},
        {type = 'slider', label = Menus.Zone.size, required = true, min = 1, max = 5},
        {type = 'input', label = Menus.Zone.create_msg, required = true, max = 110},
    })
    if json.encode(input) ~= 'null' then 
        ESX.TriggerServerCallback('fjob:getJob', function(xJob, xJobGrade)
            ESX.TriggerServerCallback('fjob:getJobLabel', function(xJobLabel, xJobGradeLabel)
                ESX.TriggerServerCallback('fjob:getZones', function(xZones)
                    table.insert(xZones, {job = xJob, jobLabel = xJobLabel, zoneLabel = input[1], zoneColor = input[2], zoneSize = input[3], createMsg = input[4], pos = GetEntityCoords(PlayerPedId())})
                    TriggerServerEvent('fjob:updateZones', xZones, xJobLabel, input[4])
                end)
            end, xJob)
        end)
    end 
end)

RegisterNetEvent('jobUpdateZonesForAll')
AddEventHandler('jobUpdateZonesForAll', function(xZones, jobLabel, createMsg)
    for k,v in pairs(createZones) do 
        RemoveBlip(v)
    end 
    if jobLabel ~= nil and createMsg ~= nil then 
        lib.notify({
            title = 'Das ' .. jobLabel .. ' hat eine Zone erstellt:',
            description = createMsg,
            type = 'info',
            position = 'top',
        })
    end 
    for k,v in pairs(xZones) do 
        local size = tonumber(v.zoneSize..'.0')
        blip = AddBlipForCoord(v.pos)
        SetBlipSprite(blip, 161)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, size)
        SetBlipColour(blip, v.zoneColor)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.zoneLabel)
        EndTextCommandSetBlipName(blip)
        table.insert(createZones, blip)
    end 
end)

exports('zone_remove', function()
    ESX.TriggerServerCallback('fjob:getJob', function(xJob, xJobGrade)
        ESX.TriggerServerCallback('fjob:getZones', function(xZones)

            local options = {}

            for k,v in pairs(xZones) do 
                if v.job == xJob then 
                    table.insert(options, {
                        title = v.zoneLabel,
                        description = Menus.Zone.delete_zone,
                        icon = 'bullseye',
                        onSelect = function()
                            table.remove(xZones, k)
                            TriggerServerEvent('fjob:updateZones', xZones, nil, nil)
                        end, 
                    })
                end 
            end 

            lib.registerContext({
                id = 'f_zone_delete',
                title = Menus.Zone.zone_delete,
                options = options
            })
            lib.showContext('f_zone_delete')

        end)
    end)
end)

exports('zone_edit', function()
    ESX.TriggerServerCallback('fjob:getJob', function(xJob, xJobGrade)
        ESX.TriggerServerCallback('fjob:getZones', function(xZones)

            local options = {}

            for k,v in pairs(xZones) do 
                if v.job == xJob then 
                    table.insert(options, {
                        title = v.zoneLabel,
                        description = Menus.Zone.edit_zone,
                        icon = 'bullseye',
                        onSelect = function()
                            local input = lib.inputDialog(Menus.Zone.zone_create, {
                                {type = 'input', label = Menus.Zone.name, required = true, min = 3, max = 22},
                                {type = 'select', label = Menus.Zone.color, options = Menus.BlipColors},
                                {type = 'slider', label = Menus.Zone.size, required = true, min = 1, max = 5},
                            })
                            if json.encode(input) ~= 'null' then 
                                xZones[k].zoneLabel = input[1]
                                xZones[k].zoneColor = input[2]
                                xZones[k].zoneSize = input[3]
                                TriggerServerEvent('fjob:updateZones', xZones, nil, nil)
                            end 
                        end, 
                    })
                end 
            end 

            lib.registerContext({
                id = 'f_zone_delete',
                title = Menus.Zone.zone_edit,
                options = options
            })
            lib.showContext('f_zone_delete')

        end)
    end)
end)