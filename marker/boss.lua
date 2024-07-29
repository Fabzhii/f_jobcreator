
local ox_inventory = exports.ox_inventory
local locales = Locales.Locales[Locales.Language]

function openBoss(marker, grade)
    ESX.TriggerServerCallback('fjob:getJob', function(xJob, xJobGrade)
        ESX.TriggerServerCallback('fjob:getSocietyMoney', function(xMoney)
            local money = xMoney
            local settings = marker.bosssettings

            local options = {
                {
                    title = (Menus.Boss.money):format(money),
                    progress = (money/10000000)*100,
                    colorScheme = 'blue',
                }
            }

            if settings.hire then 
                table.insert(options, {
                    title = Menus.Boss.hire,
                    description = Menus.Boss.hire_desc,
                    icon = 'user-check',
                    onSelect = function()
                        hire(marker, grade)
                    end,
                })
            end 

            if settings.fire then 
                table.insert(options, {
                    title = Menus.Boss.fire,
                    description = Menus.Boss.fire_desc,
                    icon = 'user-xmark',
                    onSelect = function()
                        fire(marker, grade)
                    end,
                })
            end 

            if settings.change_grade then 
                table.insert(options, {
                    title = Menus.Boss.change_grade,
                    description = Menus.Boss.change_grade_desc,
                    icon = 'user-pen',
                    onSelect = function()
                        change_grade(marker, grade)
                    end,
                })
            end 

            if settings.get_money then 
                table.insert(options, {
                    title = Menus.Boss.get_money,
                    description = Menus.Boss.get_money_desc,
                    icon = 'money-bill',
                    onSelect = function()
                        get_money(marker, grade)
                    end,
                })
            end 

            if settings.put_money then 
                table.insert(options, {
                    title = Menus.Boss.put_money,
                    description = Menus.Boss.put_money_desc,
                    icon = 'money-check-dollar',
                    onSelect = function()
                        put_money(marker, grade)
                    end,
                })
            end 

            if settings.move_money then 
                table.insert(options, {
                    title = Menus.Boss.move_money,
                    description = Menus.Boss.move_money_desc,
                    icon = 'cash-register',
                    onSelect = function()
                        move_money(marker, grade)
                    end,
                })
            end 

            lib.registerContext({
                id = 'f_boss_main',
                title = Menus.MainMenus[4],
                options = options,
            })
            lib.showContext('f_boss_main')
        end, xJob)
    end)
end

function hire(marker, grade)
    ESX.TriggerServerCallback('fjob:getJob', function(xJob, xJobGrade)
        ESX.TriggerServerCallback('fjob:getPlayers', function(xPlayers, xSelv)
            local options = {}
            for k,v in pairs(xPlayers) do 
                if v.id ~= nil and v.id ~= xSelv then
                    table.insert(options, {
                        title = v.name,
                        description = (Menus.Boss.grade):format(v.grade),
                        icon = 'user',
                        onSelect = function()
                            ESX.TriggerServerCallback('fjob:getJobLabel', function(xJobLabel, xJobGradeLabel)
                                if youSure(xJobLabel, (Menus.Boss.sure_hire):format(v.name)) then 
                                    TriggerServerEvent('fjob:hireRequestServer', v.id, xJob)
                                else 
                                    hire(marker, grade)
                                end 
                            end, xJob)
                        end,
                    })
                end 
            end 

            lib.registerContext({
                id = 'f_boss_hire',
                title = Menus.Boss.hire,
                options = options,
                onExit = function()
                    openBoss(marker, grade)
                end, 
            })
            lib.showContext('f_boss_hire')

        end, xJob)
    end)
end 

function fire(marker, grade)
    ESX.TriggerServerCallback('fjob:getJob', function(xJob, xJobGrade)
        ESX.TriggerServerCallback('fjob:getPlayers', function(xPlayers, xSelv)
            local options = {}
            for k,v in pairs(xPlayers) do 
                if v.id ~= xSelv then
                    table.insert(options, {
                        title = v.name,
                        description = (Menus.Boss.grade):format(v.grade),
                        icon = 'user',
                        onSelect = function()
                            ESX.TriggerServerCallback('fjob:getJobLabel', function(xJobLabel, xJobGradeLabel)
                                if youSure(xJobLabel, (Menus.Boss.sure_fire):format(v.name)) then 
                                    TriggerServerEvent('fjob:changeJob', nil, v.identifier, 'unemployed', 0)
                                else 
                                    fire(marker, grade)
                                end 
                            end, xJob)
                        end,
                    })
                end 
            end 

            lib.registerContext({
                id = 'f_boss_fire',
                title = Menus.Boss.fire,
                options = options,
                onExit = function()
                    openBoss(marker, grade)
                end, 
            })
            lib.showContext('f_boss_fire')

        end, xJob)
    end)
end 

RegisterNetEvent('fjob:hireRequestClient')
AddEventHandler('fjob:hireRequestClient', function(job, id)
    ESX.TriggerServerCallback('fjob:getJobLabel', function(xJobLabel, xJobGradeLabel)
        if youSure(Menus.Boss.hire_header, (Menus.Boss.hire_text):format(xJobLabel)) then 
            TriggerServerEvent('fjob:changeJob', id, nil, job, 0)
            Config.Notifcation(locales['hire'])
        end 
    end, job)
end)

function change_grade(marker, grade)
    ESX.TriggerServerCallback('fjob:getJob', function(xJob, xJobGrade)
        ESX.TriggerServerCallback('fjob:getPlayers', function(xPlayers, xSelv)
            local options = {}
            for k,v in pairs(xPlayers) do 
                if v.id ~= nil and v.id ~= xSelv then
                    table.insert(options, {
                        title = v.name,
                        description = (Menus.Boss.grade):format(v.grade),
                        icon = 'user',
                        onSelect = function()
                            local max = 0
                            for k,v in pairs(Jobs.Jobs) do 
                                if v.job_id == xJob then 
                                    max = v.grades[#v.grades].stage
                                end 
                            end 
                            local input = lib.inputDialog(Menus.Boss.change_grade_header, {
                                {type = 'number', label = Menus.Boss.change_grade_text, required = true, min = 0, max = max},
                            })
                            if json.encode(input) ~= 'null' then 
                                local new_grade = tonumber(input[1])
                                TriggerServerEvent('fjob:changeJob', v.id, nil, xJob, new_grade)
                                TriggerServerEvent('fjob:notifyId', v.id, locales['changed_grade'])
                            else 
                                change_grade(marker, grade)
                            end 
                        end,
                    })
                end 
            end 

            lib.registerContext({
                id = 'f_boss_change_grade',
                title = Menus.Boss.change_grade,
                options = options,
                onExit = function()
                    openBoss(marker, grade)
                end, 
            })
            lib.showContext('f_boss_change_grade')
        end, xJob)
    end)
end 

function get_money(marker, grade)
    ESX.TriggerServerCallback('fjob:getJob', function(xJob, xJobGrade)
        ESX.TriggerServerCallback('fjob:getSocietyMoney', function(xMoney)
            local money = xMoney

            local input = lib.inputDialog(Menus.Boss.get_money_desc, {
                {type = 'number', required = true, min = 0, max = money},
            })
            if json.encode(input) ~= 'null' then 
                new_society_money = money - tonumber(input[1])
                TriggerServerEvent('fjob:updateSocietyMoney', xJob, new_society_money)
                TriggerServerEvent('fjob:addItem', 'money', tonumber(input[1]), nil)
                Config.Notifcation(locales['get_money'])
            end
            openBoss(marker, grade)
                        
        end, xJob)
    end)
end 

function put_money(marker, grade)
    ESX.TriggerServerCallback('fjob:getJob', function(xJob, xJobGrade)
        ESX.TriggerServerCallback('fjob:getSocietyMoney', function(xMoney)
            local money = xMoney

            local input = lib.inputDialog(Menus.Boss.put_money_desc, {
                {type = 'number', required = true, min = 0, max = GetCount('money')},
            })
            if json.encode(input) ~= 'null' then 
                new_society_money = money + tonumber(input[1])
                TriggerServerEvent('fjob:updateSocietyMoney', xJob, new_society_money)
                TriggerServerEvent('fjob:removeItem', 'money', tonumber(input[1]), nil)
                Config.Notifcation(locales['put_money'])
            end
            openBoss(marker, grade)

        end, xJob)
    end)
end 

function move_money(marker, grade)
    ESX.TriggerServerCallback('fjob:getJob', function(xJob, xJobGrade)
        ESX.TriggerServerCallback('fjob:getSocietyMoney', function(xMoney)
            local money = xMoney

            options = {
                {
                    title = (Menus.Boss.money):format(money),
                    progress = (money / 10000000) * 100,
                    colorScheme = 'blue',
                },
            }

            for k,v in pairs(Jobs.Jobs) do 
                if v.job_id ~= xJob then 
                    table.insert(options, {
                        title = v.job_label,
                        description = Menus.Boss.move_there,
                        icon = 'file-invoice',
                        onSelect = function()
                            local input = lib.inputDialog(Menus.Boss.move_money, {
                                {type = 'number', label = v.job_label, required = true, min = 0, max = money},
                            })
                            if json.encode(input) ~= 'null' then 
                                self_new_society_money = money - tonumber(input[1])

                                local othermoney = 0
                                for o,i in pairs(xMoney) do 
                                    if i.job == v.job_id then 
                                        othermoney = i.money
                                    end 
                                end 
                                other_new_society_money = othermoney + tonumber(input[1])

                                TriggerServerEvent('fjob:updateSocietyMoney', xJob, self_new_society_money)
                                TriggerServerEvent('fjob:updateSocietyMoney', v.job_id, other_new_society_money)
                                Config.Notifcation(locales['move_money'])
                            else 
                                move_money(marker, grade)
                            end
                        end,
                    })
                end 
            end 

            lib.registerContext({
                id = 'f_boss_move_money',
                title = Menus.Boss.move_money,
                options = options,
                onExit = function()
                    openBoss(marker, grade)
                end,
            })
            lib.showContext('f_boss_move_money')
        end, xJob)
    end)
end 