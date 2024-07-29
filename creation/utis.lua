
function getBack(job, identifier, id)
    if id == 1 then 
        editThisArmory(job, identifier)
    end 
    if id == 2 then 
        editThisStorage(job, identifier)
    end 
    if id == 3 then 
        editThisGarage(job, identifier)
    end 
    if id == 4 then 
        editThisBoss(job, identifier)
    end 
    if id == 5 then 
        editThisOutfit(job, identifier)
    end 
    if id == 6 then 
        editThisDuty(job, identifier)
    end 
end 

function createPoint(job, id)
    local input = lib.inputDialog(Menus.CreatePoints.create_new_point_header, {
        {type = 'input', label = Menus.CreatePoints.create_new_point, min = 3, max = 20, required = true},
    })
    if input ~= nil then 
        ESX.TriggerServerCallback('fjob:createPoint', function(xIdentifier)
            Citizen.Wait(100)
            getBack(job, xIdentifier, id) 
        end, job, id, input[1])
    end 
end 

function updatePoint(identifier, point)
    TriggerServerEvent('fjob:updateMarker', identifier, point)
end 

function setName(job, identifier, id, name)
    local input = lib.inputDialog(Menus.CreatePoints.edit_name, {
        {type = 'input', label = Menus.CreatePoints.edit_name_desc, min = 3, max = 20, required = true, default = name},
    })
    if input ~= nil then 
        ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
            for k,v in pairs(xPoints) do 
                if v.identifier == identifier then 
                    local point = v
                    point.name = input[1]
                    updatePoint(identifier, point)
                end 
            end 
        end, job)
        Citizen.Wait(100)
    end 
    getBack(job, identifier, id)
end 

function setMinGrade(job, identifier, id, mingrade)
    local input = lib.inputDialog(Menus.CreatePoints.edit_mingrade, {
        {type = 'number', label = Menus.CreatePoints.edit_mingrade_desc, min = 0, required = true, default = mingrade},
    })
    if input ~= nil then 
        ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
            for k,v in pairs(xPoints) do 
                if v.identifier == identifier then 
                    local point = v
                    point.mingrade = tonumber(input[1])
                    updatePoint(identifier, point)
                end 
            end 
        end, job)
        Citizen.Wait(100)
    end 
    getBack(job, identifier, id)
end 

function setPosition(job, identifier, id)
    ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
        for k,v in pairs(xPoints) do 
            if v.identifier == identifier then 
                local point = v
                local positions = json.decode(v.position)
                local options = {
                    {
                        title = Menus.CreatePoints.add_position,
                        description = Menus.CreatePoints.add_position_desc,
                        icon = 'plus',
                        onSelect = function()
                            local input = lib.inputDialog(Menus.CreatePoints.add_position, {
                                {type = 'input', label = Menus.CreatePoints.position_name, min = 3, max = 20, required = true},
                                {type = 'checkbox', label = Menus.CreatePoints.position_current, checked = true},
                                {type = 'number', label = 'X', required = false},
                                {type = 'number', label = 'Y', required = false},
                                {type = 'number', label = 'Z', required = false},
                            })
                            if input ~= nil then 
                                local position
                                if input[2] == true then 
                                    position = GetEntityCoords(PlayerPedId())
                                end 
                                if input[2] == false and input[3] ~= nil and input[4] ~= nil and input[5] then
                                    position = vector3(input[3], input[4], input[5])
                                end 
                                local insert = {position = position, label = input[1]}
                                table.insert(positions, insert)
                                point.position = json.encode(positions)
                                updatePoint(identifier, point)
                                Citizen.Wait(150)
                            end 
                            setPosition(job, identifier, id)
                        end,
                    }
                }

                for o,i in pairs(positions) do 
                    table.insert(options, {
                        title = i.label,
                        description = Menus.CreatePoints.edit_this_position,
                        icon = 'pen-to-square',
                        onSelect = function()
                            ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
                                lib.registerContext({
                                    id = 'f_job_point',
                                    title = Menus.CreatePoints.edit_this_position,
                                    options = {
                                        {
                                            title = Menus.CreatePoints.position_goto,
                                            description = Menus.CreatePoints.position_goto_desc,
                                            icon = 'location-dot',
                                            onSelect = function()
                                                SetEntityCoords(PlayerPedId(), i.position.x, i.position.y, i.position.z)
                                                setPosition(job, identifier, id)
                                            end,
                                        },
                                        {
                                            title = Menus.CreatePoints.position_delete,
                                            description = Menus.CreatePoints.position_delete_desc,
                                            icon = 'trash',
                                            onSelect = function()
                                                table.remove(positions, o)
                                                point.position = json.encode(positions)
                                                updatePoint(identifier, point)
                                                Citizen.Wait(150)
                                                setPosition(job, identifier, id)
                                            end,
                                        },
                                    },
                                    onExit = function()
                                        setPosition(job, identifier, id)
                                    end
                                })
                                lib.showContext('f_job_point')
                            end, job)
                        end,
                    })
                end 

                lib.registerContext({
                    id = 'f_job_point',
                    title = v.name,
                    options = options,
                    onExit = function()
                        getBack(job, identifier, id)
                    end
                })
                lib.showContext('f_job_point')
            end 
        end 
    end, job)
end 

function setWeapons(job, identifier, id)
    ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
        for k,v in pairs(xPoints) do 
            if v.identifier == identifier then 
                local point = v
                local weapons = json.decode(v.weapons)

                local options = {
                    {
                        title = Menus.CreatePoints.weapons_add,
                        description = Menus.CreatePoints.weapons_add_desc,
                        icon = 'plus',
                        onSelect = function()
                            local input = lib.inputDialog(Menus.CreatePoints.weapons_add, {
                                {type = 'input', label = Menus.CreatePoints.weapon_name, min = 3, max = 40, required = true},
                                {type = 'number', label = Menus.CreatePoints.weapon_price, min = 0, required = true},
                            })
                            if input ~= nil then 
                                local insert = {name = input[1], price = input[2]}
                                table.insert(weapons, insert)
                                point.weapons = json.encode(weapons)
                                updatePoint(identifier, point)
                                Citizen.Wait(150)
                            end 
                            setWeapons(job, identifier, id)
                        end,
                    }
                }

                for o,i in pairs(weapons) do 
                    table.insert(options, {
                        title = (i.name .. ' - ' .. i.price..'$'),
                        description = Menus.CreatePoints.weapons_delete_desc,
                        icon = 'trash',
                        onSelect = function()
                            table.remove(weapons, o)
                            point.weapons = json.encode(weapons)
                            updatePoint(identifier, point)
                            Citizen.Wait(150)
                            setWeapons(job, identifier, id)
                        end,
                    })
                end 

                lib.registerContext({
                    id = 'f_job_point',
                    title = v.name,
                    options = options,
                    onExit = function()
                        getBack(job, identifier, id)
                    end
                })
                lib.showContext('f_job_point')
            end 
        end 
    end, job)
end 

function setItems(job, identifier, id)
    ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
        for k,v in pairs(xPoints) do 
            if v.identifier == identifier then 
                local point = v
                local items = json.decode(v.items)

                local options = {
                    {
                        title = Menus.CreatePoints.items_add,
                        description = Menus.CreatePoints.items_add_desc,
                        icon = 'plus',
                        onSelect = function()
                            local input = lib.inputDialog(Menus.CreatePoints.items_add, {
                                {type = 'input', label = Menus.CreatePoints.weapon_name, min = 3, max = 40, required = true},
                                {type = 'number', label = Menus.CreatePoints.weapon_price, min = 0, required = true},
                            })
                            if input ~= nil then 
                                local insert = {name = input[1], price = input[2]}
                                table.insert(items, insert)
                                point.items = json.encode(items)
                                updatePoint(identifier, point)
                                Citizen.Wait(150)
                            end 
                            setItems(job, identifier, id)
                        end,
                    }
                }

                for o,i in pairs(items) do 
                    table.insert(options, {
                        title = (i.name .. ' - ' .. i.price..'$'),
                        description = Menus.CreatePoints.items_delete_desc,
                        icon = 'trash',
                        onSelect = function()
                            table.remove(items, o)
                            point.items = json.encode(items)
                            updatePoint(identifier, point)
                            Citizen.Wait(150)
                            setItems(job, identifier, id)
                        end,
                    })
                end 

                lib.registerContext({
                    id = 'f_job_point',
                    title = v.name,
                    options = options,
                    onExit = function()
                        getBack(job, identifier, id)
                    end
                })
                lib.showContext('f_job_point')
            end 
        end 
    end, job)
end 

function setMarker(job, identifier, id, marker)
    local marker = json.decode(marker)
    local input = lib.inputDialog(Menus.CreatePoints.edit_marker, {
        {type = 'number', label = 'ID', min = 0.0, required = true, default = marker.id},
        {type = 'number', label = Menus.CreatePoints.marker_size, min = 0.0, precision = 1, required = true, default = marker.size},
        {type = 'number', label = 'R', min = 0.0, required = true, default = marker.color?.r},
        {type = 'number', label = 'G', min = 0.0, required = true, default = marker.color?.g},
        {type = 'number', label = 'B', min = 0.0, required = true, default = marker.color?.b},
    })
    if input ~= nil then 
        ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
            for k,v in pairs(xPoints) do 
                if v.identifier == identifier then 
                    local point = v

                    marker.id = input[1]
                    marker.size = input[2]
                    marker.color = {r = input[3], g = input[4], b = input[5]}

                    point.marker = json.encode(marker)
                    updatePoint(identifier, point)
                end 
            end 
        end, job)
        Citizen.Wait(100)
    end 
    getBack(job, identifier, id)
end 

function setStoreMarker(job, identifier, id, marker)
    local marker = json.decode(marker)
    local input = lib.inputDialog(Menus.CreatePoints.edit_marker, {
        {type = 'number', label = 'ID', min = 0.0, required = true, default = marker.id},
        {type = 'number', label = Menus.CreatePoints.marker_size, min = 0.0, precision = 1, required = true, default = marker.size},
        {type = 'number', label = 'R', min = 0.0, required = true, default = marker.color?.r},
        {type = 'number', label = 'G', min = 0.0, required = true, default = marker.color?.g},
        {type = 'number', label = 'B', min = 0.0, required = true, default = marker.color?.b},
    })
    if input ~= nil then 
        ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
            for k,v in pairs(xPoints) do 
                if v.identifier == identifier then 
                    local point = v

                    marker.id = input[1]
                    marker.size = input[2]
                    marker.color = {r = input[3], g = input[4], b = input[5]}

                    point.storemarker = json.encode(marker)
                    updatePoint(identifier, point)
                end 
            end 
        end, job)
        Citizen.Wait(100)
    end 
    getBack(job, identifier, id)
end 

function setStorage(job, identifier, id, storage)
    local storage = json.decode(storage)
    local input = lib.inputDialog(Menus.CreatePoints.edit_storage, {
        {type = 'checkbox', label = Menus.CreatePoints.storage_use, checked = storage.use},
        {type = 'number', label = Menus.CreatePoints.storage_slots, min = 0, required = true, default = storage.slots},
        {type = 'number', label = Menus.CreatePoints.storage_weight, min = 0, required = true, default = storage.weight},
    })
    if input ~= nil then 
        ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
            for k,v in pairs(xPoints) do 
                if v.identifier == identifier then 
                    local point = v

                    storage.use = input[1]
                    storage.slots = input[2]
                    storage.weight = input[3]

                    point.storage = json.encode(storage)
                    updatePoint(identifier, point)
                end 
            end 
        end, job)
        Citizen.Wait(100)
    end 
    getBack(job, identifier, id)
end 

function setArmor(job, identifier, id, armor)
    local armor = json.decode(armor)
    local input = lib.inputDialog(Menus.CreatePoints.edit_armor, {
        {type = 'checkbox', label = Menus.CreatePoints.storage_use, checked = armor.use},
        {type = 'number', label = Menus.CreatePoints.weapon_price, min = 0, required = true, default = armor.price},
        {type = 'number', label = Menus.CreatePoints.armor_fill, min = 0, max = 100, required = true, default = armor.fill},
    })
    if input ~= nil then 
        ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
            for k,v in pairs(xPoints) do 
                if v.identifier == identifier then 
                    local point = v

                    armor.use = input[1]
                    armor.price = input[2]
                    armor.fill = input[3]

                    point.armor = json.encode(armor)
                    updatePoint(identifier, point)
                end 
            end 
        end, job)
        Citizen.Wait(100)
    end 
    getBack(job, identifier, id)
end 

function setVehicles(job, identifier, id)
    ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
        for k,v in pairs(xPoints) do 
            if v.identifier == identifier then 
                local point = v
                local vehicles = json.decode(v.vehicles)

                local options = {
                    {
                        title = Menus.CreatePoints.vehicles_create_categorie,
                        description = Menus.CreatePoints.vehicles_create_categorie_desc,
                        icon = 'plus',
                        onSelect = function()
                            local input = lib.inputDialog(Menus.CreatePoints.vehicles_create_categorie, {
                                {type = 'input', label = Menus.CreatePoints.weapon_name, min = 0, max = 30, required = true},
                            })
                            if input ~= nil then 
                                local insert = {cathegorie = input[1], cars = {}}
                                table.insert(vehicles, insert)
                                point.vehicles = json.encode(vehicles)
                                updatePoint(identifier, point)
                                Citizen.Wait(100)
                            end 
                            setVehicles(job, identifier, id)
                        end,
                    }
                }

                for o,i in pairs(vehicles) do 
                    table.insert(options, {
                        title = i.cathegorie,
                        description = Menus.CreatePoints.vehicles_edit_caegorie_desc,
                        icon = 'pen-to-square',
                        onSelect = function()
                            ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
                                local options = {
                                    {
                                        title = Menus.CreatePoints.vehicles_delete_categorie,
                                        description = Menus.CreatePoints.vehicles_delete_categorie_desc,
                                        icon = 'trash',
                                        onSelect = function()
                                            table.remove(vehicles, o)
                                            point.vehicles = json.encode(vehicles)
                                            updatePoint(identifier, point)
                                            Citizen.Wait(100)
                                            setVehicles(job, identifier, id)
                                        end,
                                    },
                                    {
                                        title = Menus.CreatePoints.vehicles_add_vehicle,
                                        description = Menus.CreatePoints.vehicles_add_vehicle_desc,
                                        icon = 'plus',
                                        onSelect = function()
                                            local input = lib.inputDialog(Menus.CreatePoints.vehicles_add_vehicle, {
                                                {type = 'input', label = Menus.CreatePoints.vehicle_spawn, min = 0, max = 30, required = true},
                                                {type = 'number', label = Menus.CreatePoints.weapon_price, min = 0, required = true},
                                                {type = 'number', label = Menus.CreatePoints.vehicle_grade, min = 0, default = 0, required = true},
                                                {type = 'select', label = Menus.CreatePoints.vehicle_type, options = Menus.CreatePoints.vehicle_types, required = true},
                                            })
                                            if input ~= nil then 
                                                table.insert(vehicles[o].cars, {spawn = input[1], price = tonumber(input[2]), grade = tonumber(input[3]), type = input[4]})
                                                point.vehicles = json.encode(vehicles)
                                                updatePoint(identifier, point)
                                                Citizen.Wait(100)
                                                setVehicles(job, identifier, id)
                                            end 
                                        end,
                                    },
                                }

                                for m,n in pairs(i.cars) do 
                                    table.insert(options, {
                                        title = (n.spawn .. ' - ' .. n.price .. '$ - Rang-' .. n.grade),
                                        description = Menus.CreatePoints.vehicles_delete_vehicle_desc,
                                        icon = 'pen-to-square',
                                        onSelect = function()
                                            table.remove(vehicles[o].cars, m)
                                            point.vehicles = json.encode(vehicles)
                                            updatePoint(identifier, point)
                                            Citizen.Wait(100)
                                            setVehicles(job, identifier, id)
                                        end,
                                    })
                                end 

                                lib.registerContext({
                                    id = 'f_job_point',
                                    title = i.cathegorie,
                                    options = options,
                                    onExit = function()
                                        setVehicles(job, identifier, id)
                                    end
                                })
                                lib.showContext('f_job_point')

                            end, job)
                        end,
                    })
                end 

                lib.registerContext({
                    id = 'f_job_point',
                    title = v.name,
                    options = options,
                    onExit = function()
                        getBack(job, identifier, id)
                    end
                })
                lib.showContext('f_job_point')
            end 
        end 
    end, job)
end 

function setGaragePosition(job, identifier, id)
    ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
        for k,v in pairs(xPoints) do 
            if v.identifier == identifier then 
                local point = v
                local positions = json.decode(v.position)

                local options = {
                    {
                        title = Menus.CreatePoints.add_position,
                        description = Menus.CreatePoints.add_position_desc,
                        icon = 'plus',
                        onSelect = function()
                            local input = lib.inputDialog(Menus.CreatePoints.add_position, {
                                {type = 'input', label = Menus.CreatePoints.position_name, min = 3, max = 20, required = true},
                            })
                            if input ~= nil then 
                                table.insert(positions, {name = input[1], menu = vector4(0,0,0,0), inside = Config.DefaultVehicleShopPosition, spawn = {}, park = vector4(0,0,0,0)})
                                point.position = json.encode(positions)
                                updatePoint(identifier, point)
                                Citizen.Wait(100)
                            end 
                            setGaragePosition(job, identifier, id)
                        end,
                    }
                }

                for o,i in pairs(positions) do 
                    table.insert(options, {
                        title = i.name,
                        description = Menus.CreatePoints.position_edit_desc,
                        icon = 'pen-to-square',
                        onSelect = function()
                            ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
                                local options = {
                                    {
                                        title = Menus.CreatePoints.position_delete,
                                        description = Menus.CreatePoints.position_delete_desc,
                                        icon = 'trash',
                                        onSelect = function()
                                            table.remove(positions, o)
                                            point.position = json.encode(positions)
                                            updatePoint(identifier, point)
                                            Citizen.Wait(100)
                                            setGaragePosition(job, identifier, id)
                                        end,
                                    },
                                    {
                                        title = Menus.CreatePoints.position_menu,
                                        description = Menus.CreatePoints.position_create_this_desc,
                                        icon = 'pen-to-square',
                                        onSelect = function()
                                            local coords = getCoords()
                                            if coords ~= nil then 
                                                positions[o].menu = coords
                                                point.position = json.encode(positions)
                                                updatePoint(identifier, point)
                                                Citizen.Wait(100)
                                            end 
                                            setGaragePosition(job, identifier, id)
                                        end,
                                    },
                                    {
                                        title = Menus.CreatePoints.position_inside,
                                        description = Menus.CreatePoints.position_create_this_desc,
                                        icon = 'pen-to-square',
                                        onSelect = function()
                                            local coords = getCoords()
                                            if coords ~= nil then 
                                                positions[o].inside = coords
                                                point.position = json.encode(positions)
                                                updatePoint(identifier, point)
                                                Citizen.Wait(100)
                                            end 
                                            setGaragePosition(job, identifier, id)
                                        end,
                                    },
                                    {
                                        title = Menus.CreatePoints.position_store,
                                        description = Menus.CreatePoints.position_create_this_desc,
                                        icon = 'pen-to-square',
                                        onSelect = function()
                                            local coords = getCoords()
                                            if coords ~= nil then 
                                                positions[o].park = coords
                                                point.position = json.encode(positions)
                                                updatePoint(identifier, point)
                                                Citizen.Wait(100)
                                            end 
                                            setGaragePosition(job, identifier, id)
                                        end,
                                    },
                                    {
                                        title = Menus.CreatePoints.position_spawn,
                                        description = Menus.CreatePoints.position_spawn_desc,
                                        icon = 'plus',
                                        onSelect = function()
                                            local coords = getCoords()
                                            if coords ~= nil then 
                                                table.insert(positions[o].spawn, coords)
                                                point.position = json.encode(positions)
                                                updatePoint(identifier, point)
                                                Citizen.Wait(100)
                                            end 
                                            setGaragePosition(job, identifier, id)
                                        end,
                                    },
                                }

                                
                                for m,n in pairs(i.spawn) do 
                                    table.insert(options, {
                                        title = ('vector3(%d, %d, %d)'):format(math.floor(n.x), math.floor(n.y), math.floor(n.z)),
                                        description = Menus.CreatePoints.position_delete_spawn_desc,
                                        icon = 'trash',
                                        onSelect = function()
                                            table.remove(positions[o].spawn, m)
                                            point.position = json.encode(positions)
                                            updatePoint(identifier, point)
                                            Citizen.Wait(100)
                                            setGaragePosition(job, identifier, id)
                                        end,
                                    })
                                end                                 

                                lib.registerContext({
                                    id = 'f_job_point',
                                    title = i.name,
                                    options = options,
                                    onExit = function()
                                        setGaragePosition(job, identifier, id)
                                    end
                                })
                                lib.showContext('f_job_point')

                            end, job)
                        end,
                    })
                end 

                lib.registerContext({
                    id = 'f_job_point',
                    title = v.name,
                    options = options,
                    onExit = function()
                        getBack(job, identifier, id)
                    end
                })
                lib.showContext('f_job_point')

            end 
        end
    end, job)
end 

function getCoords()
    local returnValue = nil 
    local input = lib.inputDialog(Menus.CreatePoints.add_position, {
        {type = 'checkbox', label = Menus.CreatePoints.position_current, checked = true},
        {type = 'number', label = 'X', required = false},
        {type = 'number', label = 'Y', required = false},
        {type = 'number', label = 'Z', required = false},
        {type = 'number', label = 'Rot', required = false},
    })
    if input ~= nil then 
        local position
        if input[1] == true then 
            position = vector4(GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z, GetEntityHeading(PlayerPedId()))
        end 
        if input[1] == false and input[2] ~= nil and input[3] ~= nil and input[4] ~= nil and input[5] ~= nil then
            position = vector4(input[2], input[3], input[4], input[5])
        end 
        returnValue = position
    end 
    return(returnValue)
end 

function setVehicleType(job, identifier, id, garage_type)
    local input = lib.inputDialog(Menus.CreatePoints.edit_vehicles_type, {
        {type = 'select', label = Menus.CreatePoints.vehicle_type, required = true, default = garage_type, options = Menus.CreatePoints.vehicle_types},
    })
    if input ~= nil then 
        ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
            for k,v in pairs(xPoints) do 
                if v.identifier == identifier then 
                    local point = v
                    point.garage_type = input[1]
                    updatePoint(identifier, point)
                end 
            end 
        end, job)
        Citizen.Wait(100)
    end 
    getBack(job, identifier, id)
end 

function setBossSettings(job, identifier, id, settings)
    local settings = json.decode(settings)
    local input = lib.inputDialog(Menus.CreatePoints.edit_boss_settings, {
        {type = 'checkbox', label = Menus.CreatePoints.boss_fire, checked = settings.fire},
        {type = 'checkbox', label = Menus.CreatePoints.boss_hire, checked = settings.hire},
        {type = 'checkbox', label = Menus.CreatePoints.boss_change_grade, checked = settings.change_grade},
        {type = 'checkbox', label = Menus.CreatePoints.boss_put_money, checked = settings.put_money},
        {type = 'checkbox', label = Menus.CreatePoints.boss_get_money, checked = settings.get_money},
        {type = 'checkbox', label = Menus.CreatePoints.boss_move_money, checked = settings.move_money},
    })
    if input ~= nil then 
        ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
            for k,v in pairs(xPoints) do 
                if v.identifier == identifier then 
                    local point = v

                    settings.fire = input[1]
                    settings.hire = input[2]
                    settings.change_grade = input[3]
                    settings.put_money = input[4]
                    settings.get_money = input[5]
                    settings.move_money = input[6]

                    point.bosssettings = json.encode(settings)
                    updatePoint(identifier, point)
                end 
            end 
        end, job)
        Citizen.Wait(100)
    end 
    getBack(job, identifier, id)
end 

function setOutfits(job, identifier, id)
    ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
        for k,v in pairs(xPoints) do 
            if v.identifier == identifier then 
                local point = v
                local outfits = json.decode(v.outfits)

                local options = {
                    {
                        title = Menus.CreatePoints.outfit_create,
                        description = Menus.CreatePoints.outfit_create_desc,
                        icon = 'plus',
                        onSelect = function()
                            local input = lib.inputDialog(Menus.CreatePoints.outfit_create, {
                                {type = 'input', label = Menus.CreatePoints.edit_name, min = 3, max = 30, required = true},
                                {type = 'number', label = Menus.CreatePoints.vehicle_grade, min = 0, required = true},
                            })
                            if input ~= nil then 
                                local name = input[1]
                                local grade = input[2]
                                local minput = lib.inputDialog(Menus.CreatePoints.outfit_male, {
                                    {type = 'textarea', label = Menus.CreatePoints.outfit_json, autosize = true},
                                    {type = 'number', label = 'tshirt_1'},
                                    {type = 'number', label = 'tshirt_2'},
                                    {type = 'number', label = 'torso_1'},
                                    {type = 'number', label = 'torso_2'},
                                    {type = 'number', label = 'decals_1'},
                                    {type = 'number', label = 'decals_2'},
                                    {type = 'number', label = 'arms'},
                                    {type = 'number', label = 'arms_2'},
                                    {type = 'number', label = 'pants_1'},
                                    {type = 'number', label = 'pants_2'},
                                    {type = 'number', label = 'shoes_1'},
                                    {type = 'number', label = 'shoes_2'},
                                    {type = 'number', label = 'mask_1'},
                                    {type = 'number', label = 'mask_2'},
                                    {type = 'number', label = 'bproof_1'},
                                    {type = 'number', label = 'bproof_2'},
                                    {type = 'number', label = 'chain_1'},
                                    {type = 'number', label = 'chain_2'},
                                    {type = 'number', label = 'helmet_1'},
                                    {type = 'number', label = 'helmet_2'},
                                    {type = 'number', label = 'glasses_1'},
                                    {type = 'number', label = 'glasses_2'},
                                    {type = 'number', label = 'watches_1'},
                                    {type = 'number', label = 'watches_2'},
                                    {type = 'number', label = 'bags_1'},
                                    {type = 'number', label = 'bags_2'},
                                    {type = 'number', label = 'ears_1'},
                                    {type = 'number', label = 'ears_2'},
                                })
                                if minput ~= nil then 
                                    local male = {
                                        tshirt_1 = minput[2], tshirt_2 = minput[3],
                                        torso_1 = minput[4], torso_2 = minput[5],
                                        decals_1 = minput[6], decals_2 = minput[7],
                                        arms = minput[8], arms_2 = minput[9],
                                        pants_1 = minput[10], pants_2 = minput[11],
                                        shoes_1 = minput[12], shoes_2 = minput[13],
                                        mask_1 = minput[14], mask_2 = minput[15],
                                        bproof_1 = minput[16], bproof_2 = minput[17],
                                        chain_1 = minput[18], chain_2 = minput[19],
                                        helmet_1 = minput[20], helmet_2 = minput[21],
                                        glasses_1 = minput[22], glasses_2 = minput[23],
                                        watches_1 = minput[24], watches_2 = minput[25],
                                        bags_1 = minput[26], bags_2 = minput[27],
                                        ears_1 = minput[28], ears_2 = minput[29],
                                    }

                                    if minput[1] ~= '' then 
                                        male = json.decode(minput[1])
                                    end 

                                    local finput = lib.inputDialog(Menus.CreatePoints.outfit_female, {
                                        {type = 'textarea', label = Menus.CreatePoints.outfit_json, autosize = true},
                                        {type = 'number', label = 'tshirt_1'},
                                        {type = 'number', label = 'tshirt_2'},
                                        {type = 'number', label = 'torso_1'},
                                        {type = 'number', label = 'torso_2'},
                                        {type = 'number', label = 'decals_1'},
                                        {type = 'number', label = 'decals_2'},
                                        {type = 'number', label = 'arms'},
                                        {type = 'number', label = 'arms_2'},
                                        {type = 'number', label = 'pants_1'},
                                        {type = 'number', label = 'pants_2'},
                                        {type = 'number', label = 'shoes_1'},
                                        {type = 'number', label = 'shoes_2'},
                                        {type = 'number', label = 'mask_1'},
                                        {type = 'number', label = 'mask_2'},
                                        {type = 'number', label = 'bproof_1'},
                                        {type = 'number', label = 'bproof_2'},
                                        {type = 'number', label = 'chain_1'},
                                        {type = 'number', label = 'chain_2'},
                                        {type = 'number', label = 'helmet_1'},
                                        {type = 'number', label = 'helmet_2'},
                                        {type = 'number', label = 'glasses_1'},
                                        {type = 'number', label = 'glasses_2'},
                                        {type = 'number', label = 'watches_1'},
                                        {type = 'number', label = 'watches_2'},
                                        {type = 'number', label = 'bags_1'},
                                        {type = 'number', label = 'bags_2'},
                                        {type = 'number', label = 'ears_1'},
                                        {type = 'number', label = 'ears_2'},
                                    })
                                    if finput ~= nil then 
                                        local female = {
                                            tshirt_1 = finput[2], tshirt_2 = finput[3],
                                            torso_1 = finput[4], torso_2 = finput[5],
                                            decals_1 = finput[6], decals_2 = finput[7],
                                            arms = finput[8], arms_2 = finput[9],
                                            pants_1 = finput[10], pants_2 = finput[11],
                                            shoes_1 = finput[12], shoes_2 = finput[13],
                                            mask_1 = finput[14], mask_2 = finput[15],
                                            bproof_1 = finput[16], bproof_2 = finput[17],
                                            chain_1 = finput[18], chain_2 = finput[19],
                                            helmet_1 = finput[20], helmet_2 = finput[21],
                                            glasses_1 = finput[22], glasses_2 = finput[23],
                                            watches_1 = finput[24], watches_2 = finput[25],
                                            bags_1 = finput[26], bags_2 = finput[27],
                                            ears_1 = finput[28], ears_2 = finput[29],
                                        }
                                        if finput[1] ~= '' then 
                                            print('nil')
                                            female = json.decode(finput[1])
                                        end 

                                        table.insert(outfits, {label = name, grade = grade, male = male, female = female})

                                        point.outfits = json.encode(outfits)
                                        updatePoint(identifier, point)
                                        Citizen.Wait(150)
                                    end
                                end
                            end
                            setOutfits(job, identifier, id)
                        end,
                    }
                }

                for o,i in pairs(outfits) do 
                    table.insert(options, {
                        title = i.label .. ' - Rang-' .. i.grade,
                        description = Menus.CreatePoints.outfit_delete,
                        icon = 'trash',
                        onSelect = function()
                            table.remove(outfits, o)
                            point.outfits = json.encode(outfits)
                            updatePoint(identifier, point)
                            Citizen.Wait(150)
                            setOutfits(job, identifier, id)
                        end,
                    })
                end 
                
                lib.registerContext({
                    id = 'f_job_point',
                    title = v.name,
                    options = options,
                    onExit = function()
                        getBack(job, identifier, id)
                    end
                })
                lib.showContext('f_job_point')

            end
        end
    end, job)
end
