
local ox_inventory = exports.ox_inventory
local locales = Locales.Locales[Locales.Language]


function editThisGarage(id, identifier)
    ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
        for k,v in pairs(xPoints) do 
            if v.identifier == identifier then 
                lib.registerContext({
                    id = 'f_job_point',
                    title = v.name,
                    options = {
                        {
                            title = Menus.CreatePoints.edit_name ..': '.. v.name,
                            description = Menus.CreatePoints.edit_name_desc,
                            icon = 'pen-to-square',
                            onSelect = function()
                                setName(id, identifier, v.id, v.name)
                            end,
                        },
                        {
                            title = Menus.CreatePoints.edit_mingrade ..': '.. v.mingrade,
                            description = Menus.CreatePoints.edit_mingrade_desc,
                            icon = 'pen-to-square',
                            onSelect = function()
                                setMinGrade(id, identifier, v.id, v.mingrade)
                            end,
                        },
                        {
                            title = Menus.CreatePoints.edit_position,
                            description = Menus.CreatePoints.edit_position_desc,
                            icon = 'pen-to-square',
                            onSelect = function()
                                setGaragePosition(id, identifier, v.id)
                            end,
                        },
                        {
                            title = Menus.CreatePoints.edit_marker,
                            description = Menus.CreatePoints.edit_marker_desc,
                            icon = 'pen-to-square',
                            onSelect = function()
                                setMarker(id, identifier, v.id, v.marker)
                            end,
                        },
                        {
                            title = Menus.CreatePoints.edit_store_marker,
                            description = Menus.CreatePoints.edit_store_marker_desc,
                            icon = 'pen-to-square',
                            onSelect = function()
                                setStoreMarker(id, identifier, v.id, v.storemarker)
                            end,
                        },
                        {
                            title = Menus.CreatePoints.edit_vehicles,
                            description = Menus.CreatePoints.edit_vehicles_desc,
                            icon = 'pen-to-square',
                            onSelect = function()
                                setVehicles(id, identifier, v.id)
                            end,
                        },
                        {
                            title = Menus.CreatePoints.edit_vehicles_type .. ': ' .. v.garage_type,
                            description = Menus.CreatePoints.edit_vehicles_type_desc,
                            icon = 'pen-to-square',
                            onSelect = function()
                                setVehicleType(id, identifier, v.id, v.garage_type)
                            end,
                        },
                        {
                            title = Menus.CreatePoints.edit_delete,
                            description = Menus.CreatePoints.edit_delete_desc,
                            icon = 'trash',
                            onSelect = function()
                                TriggerServerEvent('fjob:deleteMarker', v.identifier)
                                openEditGarage(id)
                            end,
                        },
                    },
                    onExit = function()
                        openEditGarage(id)
                    end,
                })
                lib.showContext('f_job_point')
            end 
        end 
    end, id)
end