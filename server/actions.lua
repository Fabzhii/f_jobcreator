
local ox_inventory = exports.ox_inventory
local locales = Locales.Locales[Locales.Language]
playercuffed = {}
zones = {}

ESX.RegisterServerCallback('fjob:getJobActions', function(source, cb)
    local xJob = ESX.GetPlayerFromId(source).getJob().name
    MySQL.Async.fetchAll('SELECT * FROM jobs WHERE name = @name', {
        ['name'] = xJob, 
    }, function(data)
        cb(json.decode(data[1].actions))
    end)
end)

ESX.RegisterServerCallback('fjob:getCuffState', function(source, cb, id)
    found = false 
    for k,v in pairs(playercuffed) do 
        if v.id == id then 
            found = true  
            cb(v.toggle, v.state)
        end 
    end 
    if not found then 
        cb(nil, nil)
    end 
end)

RegisterServerEvent('fjob:requestcuff')
AddEventHandler('fjob:requestcuff', function(cuffid, playerheading, playerCoords,  playerlocation, cuffstate)
    TriggerClientEvent('fjob:getcuffed', cuffid, playerheading, playerCoords, playerlocation, cuffstate)
    TriggerClientEvent('fjob:docuff', source)
    TriggerClientEvent('fjob:playsound', -1, playerCoords, cuffstate)
    table.insert(playercuffed, {id = cuffid, toggle = true, state = cuffstate})
end)

RegisterServerEvent('fjob:requestuncuff')
AddEventHandler('fjob:requestuncuff', function(cuffid, playerheading, playerCoords,  playerlocation)
    TriggerClientEvent('fjob:getuncuff', cuffid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('fjob:douncuff', source)
    for k,v in pairs(playercuffed) do 
        if v.id == cuffid then 
            table.remove(playercuffed, k)
        end 
    end 
end)

RegisterServerEvent('fjob:setPlayerIntoVehicle')
AddEventHandler('fjob:setPlayerIntoVehicle', function(id, seat)
    TriggerClientEvent('fjob:enterVehicle', id, seat)
end)

RegisterServerEvent('fjob:setPlayerOutOfVehicle')
AddEventHandler('fjob:setPlayerOutOfVehicle', function(id)
    TriggerClientEvent('fjob:exitVehicle', id)
end)


RegisterServerEvent('fjob:dragId')
AddEventHandler('fjob:dragId', function(target)
    TriggerClientEvent('fjob:dragIdClient', target, source)
end)

ESX.RegisterServerCallback('fjob:getZones', function(source, cb)
    cb(zones)
end)

RegisterServerEvent('fjob:updateZones')
AddEventHandler('fjob:updateZones', function(xZones, jobLabel, createMsg)
    zones = xZones
    TriggerClientEvent('jobUpdateZonesForAll', -1, zones, jobLabel, createMsg)
end)

RegisterServerEvent('fjob:addHealth')
AddEventHandler('fjob:addHealth', function(id, health)
    TriggerClientEvent('fjob:addHealthClient', -1, id, health)
end)

ESX.RegisterServerCallback('fjob:getLicenses', function(source, cb, id)
    TriggerEvent('esx_license:getLicenses', id, function(licenses)
        cb(licenses)
    end)
end)

RegisterServerEvent('fjob:addLicense')
AddEventHandler('fjob:addLicense', function(id, license)
    TriggerEvent('esx_license:addLicense', id, license)
    TriggerClientEvent('fjob:Notity', id, locales['got_license'])
end)

RegisterServerEvent('fjob:removeLicense')
AddEventHandler('fjob:removeLicense', function(id, license)
    TriggerEvent('esx_license:removeLicense', id, license)
    TriggerClientEvent('fjob:Notity', id, locales['removed_license'])
end)

exports('isBoss', function(job, grade)
    isBoss = false 
    for k,v in pairs(Jobs.Jobs) do 
        if v.job_id == job then 
            for o,i in pairs(v.grades) do 
                if (type(grade) == 'number' and grade == i.stage) or (type(grade) == 'string' and grade == i.name) then 
                    if i.boss ~= nil and i.boss == true then 
                        isBoss = true 
                    end 
                end 
            end 
        end 
    end 
    return(isBoss)
end)