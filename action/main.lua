
local ox_inventory = exports.ox_inventory
local locales = Locales.Locales[Locales.Language]

function setupActions(xJob, xJobGrade)
    ESX.TriggerServerCallback('fjob:getJobActions', function(actions)
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

    end)
end 
