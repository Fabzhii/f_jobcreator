
local ox_inventory = exports.ox_inventory
local locales = Locales.Locales[Locales.Language]

function openDuty(marker, grade)
    ESX.TriggerServerCallback('fjob:getJob', function(xJob, xJobGrade)
        local options = {}
        local prefix = 'off_'
        if xJob:find(prefix) ~= nil then 
            table.insert(options, {
                title = Menus.Duty.on,
                description = Menus.Duty.on_desc,
                icon = 'user-plus',
                onSelect = function()
                    local job = string.gsub(xJob, "off_", '')
                    TriggerServerEvent('fjob:changeJob', GetPlayerServerId(PlayerId()), nil, job, xJobGrade)
                    Config.Notifcation(locales['on_duty'])
                end,
            })
        else 
            table.insert(options, {
                title = Menus.Duty.off,
                description = Menus.Duty.off_desc,
                icon = 'user-plus',
                onSelect = function()
                    local job = 'off_'..xJob
                    TriggerServerEvent('fjob:changeJob', GetPlayerServerId(PlayerId()), nil, job, xJobGrade)
                    Config.Notifcation(locales['off_duty'])
                end,
            })
        end 

        lib.registerContext({
            id = 'f_duty_main',
            title = Menus.MainMenus[6],
            options = options,
        })
        lib.showContext('f_duty_main')

    end)
end 