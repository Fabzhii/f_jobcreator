
local ox_inventory = exports.ox_inventory
local locales = Locales.Locales[Locales.Language]

function setupActions(xJob, xJobGrade)
    ESX.TriggerServerCallback('fjob:getJobActions', function(actions)

        if Config.Actionsmenu.type == 'radial' then 

            items = {}

            if actions.check_identity or actions.give_license or actions.get_license or actions.billing then 
                table.insert(items, {
                    label =  Menus.MainActions.personal,
                    icon = 'file-invoice-dollar',
                    menu = 'personal',
                })
            end 
            if actions.zone then 
                table.insert(items, {
                    label =  Menus.MainActions.zone,
                    icon = 'crosshairs',
                    menu = 'zone',
                })
            end 
            if actions.search or actions.handcuff or actions.carry or actions.ziptie or actions.release or actions.vehicle then 
                table.insert(items, {
                    label =  Menus.MainActions.player,
                    icon = 'handcuffs',
                    menu = 'player',
                })
            end 
            if actions.open_vehicle or actions.delete_vehicle or actions.repair_vehicle then 
                table.insert(items, {
                    label =  Menus.MainActions.vehicle,
                    icon = 'car',
                    menu = 'job_vehicle',
                })
            end 
            if actions.heal_big or actions.heal_small or actions.revive then 
                table.insert(items, {
                    label =  Menus.MainActions.medical,
                    icon = 'suitcase-medical',
                    menu = 'medical',
                })
            end 
            if lib.getCurrentRadialId() ~= 'job' then 
                lib.registerRadial({
                    id = 'job',
                    items = items,
                })
            end 

            local personal_items = {}
            if actions.check_identity then 
                table.insert(personal_items, {
                    label =  Menus.Personal.check_identity,
                    icon = 'id-card',
                    onSelect = 'check_identity'
                })
            end 
            if actions.give_license then 
                table.insert(personal_items, {
                    label =  Menus.Personal.give_license,
                    icon = 'plus',
                    onSelect = 'give_license'
                })
            end 
            if actions.get_license then 
                table.insert(personal_items, {
                    label =  Menus.Personal.get_license,
                    icon = 'minus',
                    onSelect = 'get_license'
                })
            end 
            if actions.billing then 
                table.insert(personal_items, {
                    label =  Menus.Personal.billing,
                    icon = 'wallet',
                    onSelect = function()
                        ExecuteCommand('rechnungen')
                    end,
                })
            end 
            if lib.getCurrentRadialId() ~= 'personal' then 
                lib.registerRadial({
                    id = 'personal',
                    items = personal_items,
                })
            end 

            local zone_items = {}
            if actions.zone then 
                table.insert(zone_items, {
                    label =  Menus.Zone.add,
                    icon = 'plus',
                    onSelect = 'zone_add'
                })
                table.insert(zone_items, {
                    label =  Menus.Zone.remove,
                    icon = 'minus',
                    onSelect = 'zone_remove'
                })
                table.insert(zone_items, {
                    label =  Menus.Zone.edit,
                    icon = 'pen-to-square',
                    onSelect = 'zone_edit'
                })
            end 
            if lib.getCurrentRadialId() ~= 'zone' then 
                lib.registerRadial({
                    id = 'zone',
                    items = zone_items,
                })
            end 

            local player_items = {}
            if actions.search then 
                table.insert(player_items, {
                    label =  Menus.Player.search,
                    icon = 'magnifying-glass',
                    onSelect = 'search'
                })
            end 
            if actions.carry then 
                table.insert(player_items, {
                    label =  Menus.Player.carry,
                    icon = 'hand-holding',
                    onSelect = 'carry'
                })
            end 
            if actions.ziptie then 
                table.insert(player_items, {
                    label =  Menus.Player.ziptie,
                    icon = 'hands-bound',
                    onSelect = 'ziptie'
                })
            end 
            if actions.handcuff then 
                table.insert(player_items, {
                    label =  Menus.Player.handcuff,
                    icon = 'handcuffs',
                    onSelect = 'handcuff'
                })
            end 
            if actions.vehicle then 
                table.insert(player_items, {
                    label =  Menus.Player.vehicle_out,
                    icon = 'car',
                    onSelect = 'vehicle_out'
                })
                table.insert(player_items, {
                    label =  Menus.Player.vehicle_in,
                    icon = 'car',
                    onSelect = 'vehicle_in'
                })
            end 
            if actions.release then 
                table.insert(player_items, {
                    label =  Menus.Player.release,
                    icon = 'handshake-simple',
                    onSelect = 'release'
                })
            end 
            if lib.getCurrentRadialId() ~= 'player' then 
                lib.registerRadial({
                    id = 'player',
                    items = player_items,
                })
            end 

            local vehicle_items = {}
            if actions.open_vehicle then 
                table.insert(vehicle_items, {
                    label =  Menus.Vehicle.open_vehicle,
                    icon = 'unlock',
                    onSelect = 'open_vehicle'
                })
            end 
            if actions.delete_vehicle then 
                table.insert(vehicle_items, {
                    label =  Menus.Vehicle.delete_vehicle,
                    icon = 'trash',
                    onSelect = 'delete_vehicle'
                })
            end 
            if actions.repair_vehicle then 
                table.insert(vehicle_items, {
                    label =  Menus.Vehicle.repair_vehicle_body,
                    icon = 'toolbox',
                    onSelect = 'repair_vehicle_body'
                })
                table.insert(vehicle_items, {
                    label =  Menus.Vehicle.repair_vehicle_engine,
                    icon = 'toolbox',
                    onSelect = 'repair_vehicle_engine'
                })
                table.insert(vehicle_items, {
                    label =  Menus.Vehicle.repair_vehicle_wheels,
                    icon = 'toolbox',
                    onSelect = 'repair_vehicle_wheels'
                })
            end 
            if lib.getCurrentRadialId() ~= 'job_vehicle' then 
                lib.registerRadial({
                    id = 'job_vehicle',
                    items = vehicle_items,
                })
            end 

            local medical_items = {}
            if actions.heal_small then 
                table.insert(medical_items, {
                    label =  Menus.Medical.heal_small,
                    icon = 'briefcase-medical',
                    onSelect = 'heal_small'
                })
            end 
            if actions.heal_big then 
                table.insert(medical_items, {
                    label =  Menus.Medical.heal_big,
                    icon = 'suitcase-medical',
                    onSelect = 'heal_big'
                })
            end 
            if actions.revive then 
                table.insert(medical_items, {
                    label =  Menus.Medical.revive,
                    icon = 'user-doctor',
                    onSelect = 'revive'
                })
            end 
            if lib.getCurrentRadialId() ~= 'medical' then 
                lib.registerRadial({
                    id = 'medical',
                    items = medical_items,
                })
            end 

        else 

            print('registering Menu')

            local keybind = lib.addKeybind({
                name = 'jobactions',
                description = 'Öffne Job Aktionen',
                defaultKey = Config.Actionsmenu.keybind,
                onPressed = function(self)
                    openMainMenu()
                end,
            })
        end 
    end)
end 

function removeString(string)
    return string.gsub(string, "  \n  ", " ")
end 

function openMainMenu()
    ESX.TriggerServerCallback('fjob:getJobActions', function(actions)
        local options = {}

        if actions.check_identity or actions.give_license or actions.get_license or actions.billing then 
            table.insert(options, {
                label =  removeString(Menus.MainActions.personal),
                icon = 'file-invoice-dollar',
                args = 'personal',
            })
        end 
        if actions.zone then 
            table.insert(options, {
                label =  removeString(Menus.MainActions.zone),
                icon = 'crosshairs',
                args = 'zone',
            })
        end 
        if actions.search or actions.handcuff or actions.carry or actions.ziptie or actions.release or actions.vehicle then 
            table.insert(options, {
                label =  removeString(Menus.MainActions.player),
                icon = 'handcuffs',
                args = 'player',
            })
        end 
        if actions.open_vehicle or actions.delete_vehicle or actions.repair_vehicle then 
            table.insert(options, {
                label =  removeString(Menus.MainActions.vehicle),
                icon = 'car',
                args = 'job_vehicle',
            })
        end 
        if actions.heal_big or actions.heal_small or actions.revive then 
            table.insert(options, {
                label =  removeString(Menus.MainActions.medical),
                icon = 'suitcase-medical',
                args = 'medical',
            })
        end 

        lib.registerMenu({
            id = 'f_jobmaker_actions_main',
            title = removeString(Menus.MainActions.main),
            position = 'top-left',
            options = options,
        }, function(selected, scrollIndex, args)
            if args == 'personal' then 
                openPersonalMenu()
            end 
            if args == 'zone' then 
                openZoneMenu()
            end 
            if args == 'player' then 
                openPlayerMenu()
            end 
            if args == 'job_vehicle' then 
                openVehicleMenu()
            end 
            if args == 'medical' then 
                openMedicalMenu()
            end 
        end)

        lib.showMenu('f_jobmaker_actions_main')

    end)
end 

function openPersonalMenu()
    ESX.TriggerServerCallback('fjob:getJobActions', function(actions)
        local personal_items = {}
        if actions.check_identity then 
            table.insert(personal_items, {
                label =  Menus.Personal.check_identity,
                icon = 'id-card',
                args = 'check_identity'
            })
        end 
        if actions.give_license then 
            table.insert(personal_items, {
                label =  Menus.Personal.give_license,
                icon = 'plus',
                args = 'give_license'
            })
        end 
        if actions.get_license then 
            table.insert(personal_items, {
                label =  Menus.Personal.get_license,
                icon = 'minus',
                args = 'get_license'
            })
        end 
        if actions.billing then 
            table.insert(personal_items, {
                label =  Menus.Personal.billing,
                icon = 'wallet',
                args = 'billing'
            })
        end 

        lib.registerMenu({
            id = 'f_jobmaker_actions_main',
            title = removeString(Menus.MainActions.personal),
            position = 'top-left',
            options = personal_items,
            onClose = function(keyPressed)
                openMainMenu()
            end,
        }, function(selected, scrollIndex, args)
            exports[GetCurrentResourceName()][args]()
        end)
        lib.showMenu('f_jobmaker_actions_main')

    end)
end

function openZoneMenu()
    ESX.TriggerServerCallback('fjob:getJobActions', function(actions)
        local zone_items = {}
        if actions.zone then 
            table.insert(zone_items, {
                label =  Menus.Zone.add,
                icon = 'plus',
                args = 'zone_add'
            })
            table.insert(zone_items, {
                label =  Menus.Zone.remove,
                icon = 'minus',
                args = 'zone_remove'
            })
            table.insert(zone_items, {
                label =  Menus.Zone.edit,
                icon = 'pen-to-square',
                args = 'zone_edit'
            })
        end 

        lib.registerMenu({
            id = 'f_jobmaker_actions_main',
            title = removeString(Menus.MainActions.zone),
            position = 'top-left',
            options = zone_items,
            onClose = function(keyPressed)
                openMainMenu()
            end,
        }, function(selected, scrollIndex, args)
            exports[GetCurrentResourceName()][args]()
        end)
        lib.showMenu('f_jobmaker_actions_main')

    end)
end

function openPlayerMenu()
    ESX.TriggerServerCallback('fjob:getJobActions', function(actions)
        local player_items = {}
        if actions.search then 
            table.insert(player_items, {
                label =  Menus.Player.search,
                icon = 'magnifying-glass',
                args = 'search'
            })
        end 
        if actions.carry then 
            table.insert(player_items, {
                label =  Menus.Player.carry,
                icon = 'hand-holding',
                args = 'carry'
            })
        end 
        if actions.ziptie then 
            table.insert(player_items, {
                label =  Menus.Player.ziptie,
                icon = 'hands-bound',
                args = 'ziptie'
            })
        end 
        if actions.handcuff then 
            table.insert(player_items, {
                label =  Menus.Player.handcuff,
                icon = 'handcuffs',
                args = 'handcuff'
            })
        end 
        if actions.vehicle then 
            table.insert(player_items, {
                label =  Menus.Player.vehicle_out,
                icon = 'car',
                args = 'vehicle_out'
            })
            table.insert(player_items, {
                label =  Menus.Player.vehicle_in,
                icon = 'car',
                args = 'vehicle_in'
            })
        end 
        if actions.release then 
            table.insert(player_items, {
                label =  Menus.Player.release,
                icon = 'handshake-simple',
                args = 'release'
            })
        end 

        lib.registerMenu({
            id = 'f_jobmaker_actions_main',
            title = removeString(Menus.MainActions.player),
            position = 'top-left',
            options = player_items,
            onClose = function(keyPressed)
                openMainMenu()
            end,
        }, function(selected, scrollIndex, args)
            exports[GetCurrentResourceName()][args]()
        end)
        lib.showMenu('f_jobmaker_actions_main')

    end)
end

function openVehicleMenu()
    ESX.TriggerServerCallback('fjob:getJobActions', function(actions)
        local vehicle_items = {}
        if actions.open_vehicle then 
            table.insert(vehicle_items, {
                label =  Menus.Vehicle.open_vehicle,
                icon = 'unlock',
                onSelect = 'open_vehicle'
            })
        end 
        if actions.delete_vehicle then 
            table.insert(vehicle_items, {
                label =  Menus.Vehicle.delete_vehicle,
                icon = 'trash',
                args = 'delete_vehicle'
            })
        end 
        if actions.repair_vehicle then 
            table.insert(vehicle_items, {
                label =  Menus.Vehicle.repair_vehicle_body,
                icon = 'toolbox',
                args = 'repair_vehicle_body'
            })
            table.insert(vehicle_items, {
                label =  Menus.Vehicle.repair_vehicle_engine,
                icon = 'toolbox',
                args = 'repair_vehicle_engine'
            })
            table.insert(vehicle_items, {
                label =  Menus.Vehicle.repair_vehicle_wheels,
                icon = 'toolbox',
                args = 'repair_vehicle_wheels'
            })
        end 

        lib.registerMenu({
            id = 'f_jobmaker_actions_main',
            title = removeString(Menus.MainActions.vehicle),
            position = 'top-left',
            options = vehicle_items,
            onClose = function(keyPressed)
                openMainMenu()
            end,
        }, function(selected, scrollIndex, args)
            exports[GetCurrentResourceName()][args]()
        end)
        lib.showMenu('f_jobmaker_actions_main')

    end)
end

function openMedicalMenu()
    ESX.TriggerServerCallback('fjob:getJobActions', function(actions)
        local medical_items = {}
        if actions.heal_small then 
            table.insert(medical_items, {
                label =  Menus.Medical.heal_small,
                icon = 'briefcase-medical',
                args = 'heal_small'
            })
        end 
        if actions.heal_big then 
            table.insert(medical_items, {
                label =  Menus.Medical.heal_big,
                icon = 'suitcase-medical',
                args = 'heal_big'
            })
        end 
        if actions.revive then 
            table.insert(medical_items, {
                label =  Menus.Medical.revive,
                icon = 'user-doctor',
                args = 'revive'
            })
        end 
            
        lib.registerMenu({
            id = 'f_jobmaker_actions_main',
            title = removeString(Menus.MainActions.medical),
            position = 'top-left',
            options = medical_items,
            onClose = function(keyPressed)
                openMainMenu()
            end,
        }, function(selected, scrollIndex, args)
            exports[GetCurrentResourceName()][args]()
        end)
        lib.showMenu('f_jobmaker_actions_main')
    end)
end
