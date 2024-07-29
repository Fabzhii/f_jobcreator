
local ox_inventory = exports.ox_inventory
local locales = Locales.Locales[Locales.Language]

isLoaded = false 
Citizen.CreateThread(function()
    while isLoaded == false do 
        Citizen.Wait(1000)
        local playerData = ESX.GetPlayerData()
        if ESX.IsPlayerLoaded(PlayerId) then 
            isLoaded = true
            setUpBlips()
        end
    end 
end)

RegisterNetEvent('fjob:updateAll')
AddEventHandler('fjob:updateAll', function()
    setUpBlips()
end)

RegisterNetEvent('esx:setJob', function(job, lastJob)
    setUpBlips()
end)

local small = {}
local large = {}

function setUpBlips()
    ESX.TriggerServerCallback('fjob:getJob', function(xJob, xJobGrade)
        ESX.TriggerServerCallback('fjob:getJobMarker', function(xMarker)
            for k,v in pairs(small) do
                local zone = v[1]
                zone:remove()
            end 
            for k,v in pairs(large) do 
                local zone = v[1]
                zone:remove()
            end 
            small = {}
            large = {}
            TriggerServerEvent('fjob:upadeStrage')
            CreateBlips(xJob, xJobGrade, xMarker)
            setupActions(xJob, xJobGrade)
        end)
    end)
end 

function CreateBlips(job, grade, marker)



    for k,v in pairs(marker) do 

        -- if isOffDuty(job) and v.id ~= 5 then 
        --     return
        -- end 

        if v.id ~= 3 then 
            if not isOffDuty(job) or v.id == 6 then 
                local marker = json.decode(v.marker)
                marker.size = (math.floor(marker.size) * 10) / 10
                for o,i in pairs(json.decode(v.position)) do 
                    local position = vector3(i.position.x, i.position.y, i.position.z)
                    table.insert(large, {
                        lib.zones.sphere({
                            coords = position,
                            radius = Config.RenderDistance,
                            debug = false,
                            inside = function()
                                DrawMarker(
                                    marker.id, position, 0.0, 0.0, 0.0, 0.0, 180, 0.0, marker.size, marker.size, marker.size, 
                                    marker.color.r, marker.color.g, marker.color.b, 
                                    100, false, true, 2, nil, nil, false
                                )
                            end,
                        })
                    })
                    table.insert(small, {
                        lib.zones.sphere({
                            coords = position,
                            radius = Config.InteractDistance,
                            debug = false,
                            inside = function()
                                if IsControlJustReleased(0, 38) then 
                                    interact(job, v, grade, o)
                                end 
                            end,
                            onEnter = function()
                                Config.InfoBar({(locales['interact'][1]):format(Menus.MainMenus[v.id]), locales['interact'][2]}, true)
                            end,
                            onExit = function()
                                Config.InfoBar(locales['interact'], false)
                            end,
                        })
                    })
                end 
            end 
        else 
            if not isOffDuty(job) then 
                local marker = json.decode(v.marker)
                marker.size = (math.floor(marker.size) * 10) / 10
                local storemarker = json.decode(v.storemarker)
                storemarker.size = (math.floor(storemarker.size) * 10) / 10
                for o,i in pairs(json.decode(v.position)) do 
                    local menu = vector3(i.menu.x, i.menu.y, i.menu.z)
                    local park = vector3(i.park.x, i.park.y, i.park.z - 0.99)
                    table.insert(large, {
                        lib.zones.sphere({
                            coords = menu,
                            radius = Config.RenderDistance,
                            debug = false,
                            inside = function()
                                DrawMarker(
                                    marker.id, menu, 0.0, 0.0, 0.0, 0.0, 180, 0.0, marker.size, marker.size, marker.size, 
                                    marker.color.r, marker.color.g, marker.color.b, 
                                    100, false, true, 2, nil, nil, false
                                )
                            end,
                        })
                    })
                    table.insert(large, {
                        lib.zones.sphere({
                            coords = park,
                            radius = Config.RenderDistance,
                            debug = false,
                            inside = function()
                                if IsPedInAnyVehicle(PlayerPedId(), false) then 
                                    DrawMarker(
                                        storemarker.id, park, 0.0, 0.0, 0.0, 0.0, 180, 0.0, storemarker.size, storemarker.size, storemarker.size, 
                                        storemarker.color.r, storemarker.color.g, storemarker.color.b, 
                                        100, false, true, 2, nil, nil, false
                                    )
                                end
                            end,
                        })
                    })


                    table.insert(small, {
                        lib.zones.sphere({
                            coords = menu,
                            radius = Config.InteractDistance,
                            debug = false,
                            inside = function()
                                if IsControlJustReleased(0, 38) then 
                                    interact(job, v, grade, o)
                                end 
                            end,
                            onEnter = function()
                                Config.InfoBar({(locales['interact'][1]):format(Menus.MainMenus[v.id]), locales['interact'][2]}, true)
                            end,
                            onExit = function()
                                Config.InfoBar(locales['interact'], false)
                            end,
                        })
                    })

                    table.insert(small, {
                        lib.zones.sphere({
                            coords = park,
                            radius = Config.InteractDistance * 2,
                            debug = false,
                            inside = function()
                                if IsControlJustReleased(0, 38) then 
                                    if IsPedInAnyVehicle(PlayerPedId(), false) then 
                                        parkIn(o, k, grade)
                                    end 
                                end 
                            end,
                            onEnter = function()
                                if IsPedInAnyVehicle(PlayerPedId(), false) then 
                                    Config.InfoBar(locales['interact_store_vehicle'], true)
                                end 
                            end,
                            onExit = function()
                                Config.InfoBar(locales['interact'], false)
                            end,
                        })
                    })
                end
            end 
        end 

    end 
end 



function interact(job, rawMarker, grade, positionIndex)
    if grade >= rawMarker.mingrade then 
        local marker = {}
        marker.job = rawMarker.job
        marker.id = rawMarker.id
        marker.identifier = rawMarker.identifier
        marker.mingrade = rawMarker.mingrade
        marker.garage_type = rawMarker.garage_type
        marker.position = json.decode(rawMarker.position)
        marker.weapons = json.decode(rawMarker.weapons)
        marker.items = json.decode(rawMarker.items)
        marker.storage = json.decode(rawMarker.storage)
        marker.armor = json.decode(rawMarker.armor)
        marker.vehicles = json.decode(rawMarker.vehicles)
        marker.bosssettings = json.decode(rawMarker.bosssettings)
        marker.outfits = json.decode(rawMarker.outfits)

        if marker.id == 1 then 
            openArmory(marker, grade, positionIndex)
        end 
        if marker.id == 2 then 
            openStorage(marker, grade, positionIndex)
        end 
        if marker.id == 3 then 
            openGarage(marker, grade, positionIndex)
        end 
        if marker.id == 4 then 
            openBoss(marker, grade, positionIndex)
        end 
        if marker.id == 5 then 
            openWardrobe(marker, grade, positionIndex)
        end 
        if marker.id == 6 then 
            openDuty(marker, grade, positionIndex)
        end 
    else 
        Config.Notifcation(locales['no_access'])
    end 
end 

RegisterNetEvent('fjob:Notity')
AddEventHandler('fjob:Notity', function(notity)
    Config.Notifcation(notity)
end)

function isOffDuty(job)
    local isOfDuty = false 
    local prefix = 'off_'
    if job:find(prefix) ~= nil then 
        isOfDuty = true 
    end 
    return(isOfDuty)
end 