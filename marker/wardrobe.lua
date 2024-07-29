
local ox_inventory = exports.ox_inventory
local locales = Locales.Locales[Locales.Language]

function openWardrobe(marker, grade)
    ESX.TriggerServerCallback('fjob:getJob', function(xJob, xJobGrade)
        local options = {
            {
                title = Menus.Wardrobe.default_outfit,
                description = Menus.Wardrobe.wear_desc,
                icon = 'shirt',
                onSelect = function()
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                        TriggerEvent('skinchanger:loadSkin', skin)
                    end)
                    Config.Notifcation(locales['changed_outfit'])
                end,
            },
        }

        for k,v in pairs(marker.outfits) do 
            if grade >= v.grade then 
                table.insert(options, {
                    title = v.label,
                    description = Menus.Wardrobe.wear_desc,
                    icon = 'vest',
                    onSelect = function()

                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadClothes', skin, v.male)
                            else
                                TriggerEvent('skinchanger:loadClothes', skin, v.female)
                            end
                        end)

                        Config.Notifcation(locales['changed_outfit'])
                    end,
                })
            end 
        end

        lib.registerContext({
            id = 'f_wardrobe_main',
            title = Menus.MainMenus[5],
            options = options,
        })
        lib.showContext('f_wardrobe_main')


    end)
end 