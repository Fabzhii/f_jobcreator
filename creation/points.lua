
local ox_inventory = exports.ox_inventory
local locales = Locales.Locales[Locales.Language]

function editPoints(id)
    ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
        lib.registerContext({
            id = 'f_job_creation',
            title = Menus.Creation.job_add_marker,
            options = {
                {
                    title = Menus.CreatePoints.armory,
                    description = Menus.CreatePoints.edit,
                    icon = 'pen-to-square',
                    onSelect = function()
                        openEditArmory(id)
                    end,
                },
                {
                    title = Menus.CreatePoints.storage,
                    description = Menus.CreatePoints.edit,
                    icon = 'pen-to-square',
                    onSelect = function()
                        openEditStorage(id)
                    end,
                },
                {
                    title = Menus.CreatePoints.garage,
                    description = Menus.CreatePoints.edit,
                    icon = 'pen-to-square',
                    onSelect = function()
                        openEditGarage(id)
                    end,
                },
                {
                    title = Menus.CreatePoints.boss,
                    description = Menus.CreatePoints.edit,
                    icon = 'pen-to-square',
                    onSelect = function()
                        openEditBoss(id)
                    end,
                },
                {
                    title = Menus.CreatePoints.outfit,
                    description = Menus.CreatePoints.edit,
                    icon = 'pen-to-square',
                    onSelect = function()
                        openEditOutfit(id)
                    end,
                },
                {
                    title = Menus.CreatePoints.duty,
                    description = Menus.CreatePoints.edit,
                    icon = 'pen-to-square',
                    onSelect = function()
                        openEditDuty(id)
                    end,
                },
            },
            onExit = function()
                openJob(id)
            end,
        })
        lib.showContext('f_job_creation')
    end, id)
end 

function openEditArmory(id)
    ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
        local options = {
            {
                title = Menus.CreatePoints.add_point,
                description = Menus.CreatePoints.add_point_desc,
                icon = 'plus',
                onSelect = function()
                    createPoint(id, 1)
                end,
            },
        }
        for k,v in pairs(xPoints) do 
            if v.id == 1 then
                table.insert(options, {
                    title = v.name,
                    description = Menus.CreatePoints.edit_this_point,
                    onSelect = function()
                        editThisArmory(id, v.identifier)
                    end,
                })
            end
        end 
        lib.registerContext({
            id = 'f_job_point',
            title = Menus.CreatePoints.armory,
            options = options,
            onExit = function()
                editPoints(id)
            end,
        })
        lib.showContext('f_job_point')
    end, id)
end 

function openEditStorage(id)
    ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
        local options = {
            {
                title = Menus.CreatePoints.add_point,
                description = Menus.CreatePoints.add_point_desc,
                icon = 'plus',
                onSelect = function()
                    createPoint(id, 2)
                end,
            },
        }
        for k,v in pairs(xPoints) do 
            if v.id == 2 then
                table.insert(options, {
                    title = v.name,
                    description = Menus.CreatePoints.edit_this_point,
                    onSelect = function()
                        editThisStorage(id, v.identifier)
                    end,
                })
            end
        end 
        lib.registerContext({
            id = 'f_job_point',
            title = Menus.CreatePoints.storage,
            options = options,
            onExit = function()
                editPoints(id)
            end,
        })
        lib.showContext('f_job_point')
    end, id)
end 

function openEditGarage(id)
    ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
        local options = {
            {
                title = Menus.CreatePoints.add_point,
                description = Menus.CreatePoints.add_point_desc,
                icon = 'plus',
                onSelect = function()
                    createPoint(id, 3)
                end,
            },
        }
        for k,v in pairs(xPoints) do 
            if v.id == 3 then
                table.insert(options, {
                    title = v.name,
                    description = Menus.CreatePoints.edit_this_point,
                    onSelect = function()
                        editThisGarage(id, v.identifier)
                    end,
                })
            end
        end 
        lib.registerContext({
            id = 'f_job_point',
            title = Menus.CreatePoints.garage,
            options = options,
            onExit = function()
                editPoints(id)
            end,
        })
        lib.showContext('f_job_point')
    end, id)
end 

function openEditBoss(id)
    ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
        local options = {
            {
                title = Menus.CreatePoints.add_point,
                description = Menus.CreatePoints.add_point_desc,
                icon = 'plus',
                onSelect = function()
                    createPoint(id, 4)
                end,
            },
        }
        for k,v in pairs(xPoints) do 
            if v.id == 4 then
                table.insert(options, {
                    title = v.name,
                    description = Menus.CreatePoints.edit_this_point,
                    onSelect = function()
                        editThisBoss(id, v.identifier)
                    end,
                })
            end
        end 
        lib.registerContext({
            id = 'f_job_point',
            title = Menus.CreatePoints.boss,
            options = options,
            onExit = function()
                editPoints(id)
            end,
        })
        lib.showContext('f_job_point')
    end, id)
end 

function openEditOutfit(id)
    ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
        local options = {
            {
                title = Menus.CreatePoints.add_point,
                description = Menus.CreatePoints.add_point_desc,
                icon = 'plus',
                onSelect = function()
                    createPoint(id, 5)
                end,
            },
        }
        for k,v in pairs(xPoints) do 
            if v.id == 5 then
                table.insert(options, {
                    title = v.name,
                    description = Menus.CreatePoints.edit_this_point,
                    onSelect = function()
                        editThisOutfit(id, v.identifier)
                    end,
                })
            end
        end 
        lib.registerContext({
            id = 'f_job_point',
            title = Menus.CreatePoints.outfit,
            options = options,
            onExit = function()
                editPoints(id)
            end,
        })
        lib.showContext('f_job_point')
    end, id)
end 

function openEditDuty(id)
    ESX.TriggerServerCallback('fjob:getPoints', function(xPoints)
        local options = {
            {
                title = Menus.CreatePoints.add_point,
                description = Menus.CreatePoints.add_point_desc,
                icon = 'plus',
                onSelect = function()
                    createPoint(id, 6)
                end,
            },
        }
        for k,v in pairs(xPoints) do 
            if v.id == 6 then
                table.insert(options, {
                    title = v.name,
                    description = Menus.CreatePoints.edit_this_point,
                    onSelect = function()
                        editThisDuty(id, v.identifier)
                    end,
                })
            end
        end 
        lib.registerContext({
            id = 'f_job_point',
            title = Menus.CreatePoints.duty,
            options = options,
            onExit = function()
                editPoints(id)
            end,
        })
        lib.showContext('f_job_point')
    end, id)
end 


