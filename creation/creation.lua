
local ox_inventory = exports.ox_inventory
local locales = Locales.Locales[Locales.Language]

RegisterNetEvent('fjob:openCreator')
AddEventHandler('fjob:openCreator', function()
    ESX.TriggerServerCallback('fjob:getJobs', function(xJobs)
        local options = {
            {
                title = Menus.Creation.add_job,
                description = Menus.Creation.add_job_desc,
                icon = 'plus',
                onSelect = function()
                    createJob()
                end,
            },
        }

        for k,v in pairs(xJobs) do 
            local prefix = 'off_'
            if (v.name):find(prefix) == nil then 
                table.insert(options, {
                    title = v.label,
                    description = Menus.Creation.edit_job_desc,
                    onSelect = function()
                        openJob(v.name)
                    end,
                })
            end
        end 

        lib.registerContext({
            id = 'f_job_creation',
            title = Menus.Creation.jobs_header,
            options = options
        })
        lib.showContext('f_job_creation')
    end)
end)

function createJob()
    local input = lib.inputDialog(Menus.Creation.add_job, {
        {type = 'input', label = Menus.Creation.create_name, required = true, min = 3, max = 30},
        {type = 'input', label = Menus.Creation.create_label, required = true, min = 3, max = 30},
        {type = 'checkbox', label = Menus.Creation.create_whitelist},
        {type = 'number', label = Menus.Creation.create_defaultmoney, default = 0},
        {type = 'checkbox', label = Menus.Creation.create_offDuty},
    })
    if input ~= nil then 
        local id = string.lower(input[1])
        id = id:gsub(" ", "_")
        TriggerServerEvent('fjob:createJob', id, input[2], input[3], input[4], input[5])
        if input[5] == true then 
            TriggerServerEvent('fjob:createJob', ('off_'..id), (input[2]..Config.OffDutySuffix), 1, 0, 1)
        end 
        Citizen.Wait(100)
        openJob(id)
    end  
end 

function openJob(id)
    ESX.TriggerServerCallback('fjob:getJobs', function(xJobs)
        for o,i in pairs(xJobs) do 
            if i.name == id then 
                lib.registerContext({
                    id = 'f_job_creation',
                    title = i.label,
                    onExit = function()
                        TriggerEvent('fjob:openCreator')
                    end,
                    options = {
                        {
                            title = Menus.Creation.job_edit,
                            description = Menus.Creation.job_edit_desc,
                            icon = 'pen-to-square',
                            onSelect = function()
                                editJob(id)
                            end,
                        },
                        {
                            title = Menus.Creation.job_add_grades,
                            description = Menus.Creation.job_add_grades_desc,
                            icon = 'plus',
                            onSelect = function()
                                editRanks(id, i.offduty)
                            end,
                        },
                        {
                            title = Menus.Creation.job_add_marker,
                            description = Menus.Creation.job_add_marker_desc,
                            icon = 'plus',
                            onSelect = function()
                                editPoints(id)
                            end,
                        },
                        {
                            title = Menus.Creation.job_settings,
                            description = Menus.Creation.job_settings_desc,
                            icon = 'pen-to-square',
                            onSelect = function()
                                editSettings(id)
                            end,
                        },
                        {
                            title = Menus.Creation.job_delete,
                            description = Menus.Creation.job_delete_desc,
                            icon = 'trash',
                            onSelect = function()
                                deleteJob(id)
                            end,
                        },
                    }
                })
                lib.showContext('f_job_creation')
            end 
        end 
    end)
end

function editRanks(id, offduty)
    ESX.TriggerServerCallback('fjob:getJobsRanks', function(xRanks)
        local options = {
            {
                title = Menus.Creation.add_rank,
                description = Menus.Creation.add_rank_desc,
                icon = 'plus',
                onSelect = function()
                    createRank(id, offduty)
                end,
            },
        }

        for k,v in pairs(xRanks) do 
            table.insert(options, {
                title = (v.grade .. ' - ' .. v.label),
                description = Menus.Creation.edit_rank_desc,
                onSelect = function()
                    lib.registerContext({
                        id = 'f_rank_creation',
                        title = v.label,
                        options = {
                            {
                                title = Menus.Creation.rank_edit,
                                description = Menus.Creation.rank_edit_desc,
                                icon = 'pen-to-square',
                                onSelect = function()
                                    editRank(id, offduty, v.name, v.label, v.grade, v.salary)
                                end,
                            },
                            {
                                title = Menus.Creation.rank_delete,
                                description = Menus.Creation.rank_delete_desc,
                                icon = 'trash',
                                onSelect = function()
                                    TriggerServerEvent('fjob:deleteRank', id, v.name, v.grade)
                                    TriggerServerEvent('fjob:deleteRank', ('off_'..id), v.name, v.grade)
                                    Citizen.Wait(100)
                                    editRanks(id, offduty)
                                end,
                            },
                        },
                        onExit = function()
                            editRanks(id, offduty)
                        end,
                    })
                    lib.showContext('f_rank_creation')
                end,
            })
        end 

        lib.registerContext({
            id = 'f_rank_creation',
            title = Menus.Creation.ranks_header,
            options = options,
            onExit = function()
                openJob(id)
            end,
        })
        lib.showContext('f_rank_creation')

    end, id)
end 

function createRank(job, offduty)
    local input = lib.inputDialog(Menus.Creation.add_job, {
        {type = 'input', label = Menus.Creation.create_rank_name, required = true, min = 3, max = 30},
        {type = 'input', label = Menus.Creation.create_rank_label, required = true, min = 3, max = 30},
        {type = 'number', label = Menus.Creation.create_rank_grade, required = true, min = 0},
        {type = 'number', label = Menus.Creation.create_rank_salary, required = true, min = 0},

    })
    if input ~= nil then 
        local id = string.lower(input[1])
        id = id:gsub(" ", "_")
        TriggerServerEvent('fjob:createRank', id, input[2], input[3], input[4], job)
        Citizen.Wait(100)
        if offduty then 
            TriggerServerEvent('fjob:createRank', id, input[2], input[3], Config.OffDutyPay, ('off_'..job))
            Citizen.Wait(100)
        end 
    end 
    editRanks(job, offduty) 
end

function editRank(job, offduty, name, label, grade, salary)
    local input = lib.inputDialog(Menus.Creation.add_job, {
        {type = 'input', label = Menus.Creation.create_rank_name, default = name, required = true, min = 3, max = 30},
        {type = 'input', label = Menus.Creation.create_rank_name, default = label, required = true, min = 3, max = 30},
        {type = 'number', label = Menus.Creation.create_rank_grade, default = grade, required = true, min = 0},
        {type = 'number', label = Menus.Creation.create_rank_salary, default = salary, required = true, min = 0},
    })
    if input ~= nil then 
        local id = string.lower(input[1])
        id = id:gsub(" ", "_")
        TriggerServerEvent('fjob:editRank', id, input[2], input[3], input[4], job, name, grade)
        Citizen.Wait(100)
        if offduty then 
            TriggerServerEvent('fjob:editRank', id, input[2], input[3], input[4], ('off_'..job), name, grade)
            Citizen.Wait(100)
        end 
    end 
    editRanks(job, offduty) 
end

function editJob(id)
    ESX.TriggerServerCallback('fjob:getJobs', function(xJobs)
        for o,i in pairs(xJobs) do 
            if i.name == id then 

                local input = lib.inputDialog(Menus.Creation.add_job, {
                    {type = 'input', label = Menus.Creation.create_label, default = i.label, required = true, min = 3, max = 30},
                    {type = 'checkbox', label = Menus.Creation.create_whitelist, checked = i.whitelisted},
                    {type = 'checkbox', label = Menus.Creation.create_offDuty, checked = i.offduty},
                })
                if input ~= nil then 
                    TriggerServerEvent('fjob:editJob', i.name, input[1], input[2], input[3])
                    if i.offduty == 1 and input[3] == false then 
                        TriggerServerEvent('fjob:deleteJob', ('off_'..id))
                        ESX.TriggerServerCallback('fjob:getJobsRanks', function(xRanks)
                            for k,v in pairs(xRanks) do 
                                TriggerServerEvent('fjob:deleteRank', ('off_'..id), v.name, v.grade)
                            end 
                        end, ('off_'..id))
                    end 
                    if i.offduty == 0 and input[3] == true then 
                        TriggerServerEvent('fjob:createJob', ('off_'..id), (i.label..Config.OffDutySuffix), 1, 0, 1)
                        ESX.TriggerServerCallback('fjob:getJobsRanks', function(xRanks)
                            for k,v in pairs(xRanks) do 
                                TriggerServerEvent('fjob:createRank', v.name, v.label, v.grade, Config.OffDutyPay, ('off_'..id))
                                Citizen.Wait(50)
                            end 
                        end, id)
                    end 
                    Citizen.Wait(100)
                end  
                openJob(id)
            end
        end 
    end)
end 

function deleteJob(id)
    TriggerServerEvent('fjob:deleteJob', id)
    TriggerServerEvent('fjob:deleteJob', ('off_'..id))
    ESX.TriggerServerCallback('fjob:getJobsRanks', function(xRanks)
        for k,v in pairs(xRanks) do 
            TriggerServerEvent('fjob:deleteRank', id, v.name, v.grade)
        end 
    end, id)
    ESX.TriggerServerCallback('fjob:getJobsRanks', function(xRanks)
        for k,v in pairs(xRanks) do 
            TriggerServerEvent('fjob:deleteRank', ('off_'..id), v.name, v.grade)
        end 
    end, ('off_'..id))
    Citizen.Wait(100)
    TriggerEvent('fjob:openCreator')
end 

function editSettings(id)
    ESX.TriggerServerCallback('fjob:getJobs', function(xJobs)
        for o,i in pairs(xJobs) do 
            if i.name == id then 
                local actions = json.decode(i.actions)
                local input = lib.inputDialog(Menus.Creation.edit_actions, {
                    {type = 'checkbox', label = Menus.Creation.action_check_identity, checked = actions.check_identity},
                    {type = 'checkbox', label = Menus.Creation.action_search, checked = actions.search},
                    {type = 'checkbox', label = Menus.Creation.action_handcuff, checked = actions.handcuff},
                    {type = 'checkbox', label = Menus.Creation.action_ziptie, checked = actions.ziptie},
                    {type = 'checkbox', label = Menus.Creation.action_carry, checked = actions.carry},
                    {type = 'checkbox', label = Menus.Creation.action_release, checked = actions.release},
                    {type = 'checkbox', label = Menus.Creation.action_vehicle, checked = actions.vehicle},
                    {type = 'checkbox', label = Menus.Creation.action_billing, checked = actions.billing},
                    {type = 'checkbox', label = Menus.Creation.action_give_license, checked = actions.give_license},
                    {type = 'checkbox', label = Menus.Creation.action_get_license, checked = actions.get_license},
                    {type = 'checkbox', label = Menus.Creation.action_zone, checked = actions.zone},
                    {type = 'checkbox', label = Menus.Creation.action_open_vehicle, checked = actions.open_vehicle},
                    {type = 'checkbox', label = Menus.Creation.action_delete_vehicle, checked = actions.delete_vehicle},
                    {type = 'checkbox', label = Menus.Creation.action_repair_vehicle, checked = actions.repair_vehicle},
                    {type = 'checkbox', label = Menus.Creation.action_heal_small, checked = actions.heal_small},
                    {type = 'checkbox', label = Menus.Creation.action_heal_big, checked = actions.heal_big},
                    {type = 'checkbox', label = Menus.Creation.action_revive, checked = actions.revive},
                })
                if input ~= nil then 
                    local insertActions = { 
                        check_identity = input[1],
                        search = input[2],
                        handcuff = input[3], 
                        ziptie = input[4],
                        carry = input[5],
                        release = input[6],
                        vehicle = input[7],
                        billing = input[8],
                        give_license = input[9],
                        get_license = input[10],
                        zone = input[11],
                        open_vehicle = input[12],
                        delete_vehicle = input[13],
                        repair_vehicle = input[14],
                        heal_small = input[15],
                        heal_big = input[16],
                        revive = input[17],
                    }
                    TriggerServerEvent('fjob:updateActions', id, insertActions)
                    Citizen.Wait(100)
                end 
                openJob(id)
            end 
        end 
    end)
end 
