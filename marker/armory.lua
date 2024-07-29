
local ox_inventory = exports.ox_inventory
local locales = Locales.Locales[Locales.Language]

function openArmory(marker, grade, positionIndex)
    ESX.TriggerServerCallback('fjob:getJob', function(xJob, xJobGrade)
        local options = {
            {
                title = Menus.Armory.take_weapons,
                description = Menus.Armory.take_weapons_desc,
                icon = 'gun',
                onSelect = function()
                    local shopid = ('weapons_'..marker.identifier)
                    exports.ox_inventory:openInventory('shop', {type = shopid, id = 1})
                end,
            },
            {
                title = Menus.Armory.take_objects,
                description = Menus.Armory.take_objects_desc,
                icon = 'toolbox',
                onSelect = function()
                    local shopid = ('items_'..marker.identifier)
                    exports.ox_inventory:openInventory('shop', {type = shopid, id = 1})
                end,
            },
        }
        if marker.storage.use then 
            table.insert(options, {
                title = Menus.Armory.storage,
                description = Menus.Armory.storage_desc,
                icon = 'box-open',
                onSelect = function()
                    local position = marker.position[positionIndex].position
                    local identifier = ('storage_'..marker.identifier..'-'..math.floor(position.x)..'-'..math.floor(position.y)..'-'..math.floor(position.z))
                    exports.ox_inventory:openInventory('stash', identifier)
                end,
            })
        end 
        if marker.armor.use then 
            table.insert(options, {
                title = Menus.Armory.get_armor,
                description = (Menus.Armory.get_armor_desc):format(marker.armor.price),
                icon = 'shield-halved',
                onSelect = function()
                    if GetCount('money') >= marker.armor.price then 
                        TriggerServerEvent('fjob:removeItem', 'money', marker.armor[2], nil)
                        SetPedArmour(PlayerPedId(), marker.armor.fill)
                    else 
                        Config.Notifcation(locales['no_money'])
                    end 
                end,
            })
        end 

        lib.registerContext({
            id = 'fmain',
            title = Menus.MainMenus[1],
            options = options,
        })
        lib.showContext('fmain')
    end)
end 

function GetLabel(item)
    label = ''
    for k,v in pairs(exports.ox_inventory:Items()) do 
        if string.lower(v.name) == string.lower(item) then 
            label = v.label
        end 
    end 
    return(label)
end  

function GetCount(item)
    count = 0
    for k,v in pairs(exports.ox_inventory:GetPlayerItems()) do 
        if v.name == item then 
            count = v.count
        end 
    end 
    return(count)
end 
