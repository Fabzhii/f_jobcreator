
local ox_inventory = exports.ox_inventory
local locales = Locales.Locales[Locales.Language]

Citizen.CreateThread(function()
    updateShopStorage()
end)

RegisterServerEvent('fjob:upadeStrage')
AddEventHandler('fjob:upadeStrage', function()
    updateShopStorage()
end)

function updateShopStorage()
    MySQL.Async.fetchAll('SELECT * FROM f_job_marker', {
    }, function(marker)
        for k,v in pairs(marker) do 
            exports.ox_inventory:RegisterShop(('weapons_'..v.identifier), {
                name = Menus.Armory.take_weapons,
                inventory = json.decode(v.weapons),
            })
            exports.ox_inventory:RegisterShop(('items_'..v.identifier), {
                name = Menus.Armory.take_objects,
                inventory = json.decode(v.items),
            })

            local storage = json.decode(v.storage)
            if storage.use then 
                for o,i in pairs(json.decode(v.position)) do 
                    local position = vector3(i.position.x, i.position.y, i.position.z)
                    local identifier = ('storage_'..v.identifier..'-'..math.floor(position.x)..'-'..math.floor(position.y)..'-'..math.floor(position.z))
                    exports.ox_inventory:RegisterStash(identifier, Menus.Armory.storage_title, storage.slots, storage.weight, nil)
                end 
            end 

        end 
    end)
end 

ESX.RegisterServerCallback('fjob:getJob', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.getJob().name, xPlayer.getJob().grade)
end)

ESX.RegisterServerCallback('fjob:getJobMarker', function(source, cb)
    local xJob = ESX.GetPlayerFromId(source).getJob().name
    MySQL.Async.fetchAll('SELECT * FROM f_job_marker WHERE job = @job', {
        ['job'] = string.gsub(xJob, "off_", ''), 
    }, function(data)
        cb(data)
    end)
end)

ESX.RegisterServerCallback('fjob:getInv', function(source, cb)
    cb(exports.ox_inventory:GetInventoryItems(source))
end)

RegisterServerEvent('fjob:addItem')
AddEventHandler('fjob:addItem', function(item, count, metadata)
    exports.ox_inventory:AddItem(source, item, count, metadata)
end)

RegisterServerEvent('fjob:removeItem')
AddEventHandler('fjob:removeItem', function(item, count, metadata)
    exports.ox_inventory:RemoveItem(source, item, count, metadata)
end)

ESX.RegisterServerCallback('fjob:canCarryItem', function(source, cb, item, count, metadata)
    cb(exports.ox_inventory:CanCarryItem(source, item, count, metadata))
end)


RegisterServerEvent('fjob:setPlayerBucket')
AddEventHandler('fjob:setPlayerBucket', function(bucket)
    SetPlayerRoutingBucket(source, bucket)
end)

RegisterServerEvent('fjob:setEntityBucket')
AddEventHandler('fjob:setEntityBucket', function(entity, bucket)
    SetEntityRoutingBucket(NetworkGetEntityFromNetworkId(entity), bucket)
end)

ESX.RegisterServerCallback('fjob:isPlateTaken', function(source, cb, plate)
	MySQL.scalar('SELECT plate FROM owned_vehicles WHERE plate = ?', {plate},
	function(result)
		cb(result ~= nil)
	end)
end)

RegisterServerEvent('fjob:writesqlcar')
AddEventHandler('fjob:writesqlcar', function(vehicleProps, platetext, job, carType)
    print(carType)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.insert('INSERT INTO owned_vehicles (owner, plate, vehicle, type, job, stored) VALUES (?, ?, ?, ?, ?, ?)', {xPlayer.identifier, platetext, json.encode(vehicleProps), carType, job, 1},
    function() end)
end)

ESX.RegisterServerCallback('fjob:getOwnedCars', function(source, cb)
    local identifier = ESX.GetPlayerFromId(source).identifier
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
        ['owner'] = identifier, 
    }, function(data)
        cb(data)
    end)
end)

RegisterServerEvent('fjob:setVehicleParkingState')
AddEventHandler('fjob:setVehicleParkingState', function(plate, state)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute('UPDATE owned_vehicles SET stored = @stored WHERE plate = @plate AND owner = @owner', {
        ['@stored']  = state,
        ['@plate'] = plate,
        ['@owner'] = xPlayer.identifier,
    })
end)

RegisterServerEvent('fjob:changeJob')
AddEventHandler('fjob:changeJob', function(id, s_identifier, job, grade)
    print(id, s_identifier, job, grade)
    changeJob(id, s_identifier, job, grade)
end)

function changeJob(id, s_identifier, job, grade)
    local identifier = s_identifier
    if id ~= nil then 
        identifier = ESX.GetPlayerFromId(id).identifier
    end 

    if json.encode(ESX.GetPlayerFromIdentifier(identifier)) ~= 'null' then 
        local id = ESX.GetPlayerFromIdentifier(identifier).source
        local xPlayer = ESX.GetPlayerFromId(id)

        if job ~= nil then 
            MySQL.Async.execute('UPDATE users SET job = @job WHERE identifier = @identifier', {
                ['@identifier']  = identifier,
                ['@job'] = job,
            })
        end 
        if grade ~= nil then 
            MySQL.Async.execute('UPDATE users SET job_grade = @job_grade WHERE identifier = @identifier', {
                ['@identifier']  = identifier,
                ['@job_grade'] = tonumber(grade),
            })
        end 

        xPlayer.setJob(job, grade)
        Citizen.Wait(50)
        TriggerClientEvent('fjob:updateAll', ESX.GetPlayerFromIdentifier(identifier).source)
    else 
        if job ~= nil then 
            MySQL.Async.execute('UPDATE users SET job = @job WHERE identifier = @identifier', {
                ['@identifier']  = identifier,
                ['@job'] = job,
            })
        end 
        if grade ~= nil then 
            MySQL.Async.execute('UPDATE users SET job_grade = @job_grade WHERE identifier = @identifier', {
                ['@identifier']  = identifier,
                ['@job_grade'] = tonumber(grade),
            })
        end 
    end 
end 

function doesJobExist(job)
    exist = false 
    for k,v in pairs(Jobs.Jobs) do 
        if v.job_id == job then 
            exist = true 
        end 
    end 
    if job == 'unemployed' then 
        exist = true 
    end 
    return(exist)
end 

function doesGradeExist(job, grade)
    exist = false 
    for k,v in pairs(Jobs.Jobs) do 
        if v.job_id == job then 
            local maxgrade = v.grades[#v.grades].stage
            if grade <= maxgrade then 
                exist = true 
            end 
        end 
    end 
    if job == 'unemployed' and grade == 0 then 
        exist = true 
    end 
    return(exist)
end

ESX.RegisterServerCallback("fjob:getPlayers", function(source, cb, job) 
    MySQL.Async.fetchAll("SELECT * FROM users WHERE job = @job", {
        ['@job'] = job,
    }, function(result)
        local return_value = {}
        for k,v in pairs(result) do 
            local id = nil 
            if json.encode(ESX.GetPlayerFromIdentifier(v.identifier)) ~= 'null' then 
                id = ESX.GetPlayerFromIdentifier(v.identifier).source
            end 
            table.insert(return_value, {name = (v.firstname .. ' ' .. v.lastname), grade = v.job_grade, id = id, identifier = v.identifier})
        end 
        cb(return_value, source)
    end)
end) 

ESX.RegisterServerCallback("fjob:getJobLabel", function(source, cb, job, grade) 
    local job_label = ''
    local job_grade_label = ''

    for k,v in pairs(Jobs.Jobs) do 
        if v.job_id == job then 
            job_label = v.job_label
            for o,i in pairs(v.grades) do 
                if i.stage == grade then 
                    job_grade_label = i.label 
                end 
            end 
        end 
    end 
    cb(job_label, job_grade_label)
end) 

exports('getJobLabel', function(job, grade)
    local job_label = ''
    local job_grade_label = ''

    for k,v in pairs(Jobs.Jobs) do 
        if v.job_id == job then 
            job_label = v.job_label
            for o,i in pairs(v.grades) do 
                if i.stage == grade then 
                    job_grade_label = i.label 
                end 
            end 
        end 
    end 

    cbtable = {job = job_label, grade = job_grade_label}
    return(cbtable)
end)

RegisterServerEvent('fjob:hireRequestServer')
AddEventHandler('fjob:hireRequestServer', function(id, job)
    TriggerClientEvent('fjob:hireRequestClient', id, job, id)
end)

RegisterServerEvent('fjob:notifyId')
AddEventHandler('fjob:notifyId', function(id, notify)
    TriggerClientEvent('fjob:Notity', id, notify)
end)

