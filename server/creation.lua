
local ox_inventory = exports.ox_inventory
local locales = Locales.Locales[Locales.Language]

ESX.RegisterCommand(Config.Command.commands, Config.Command.group, function(xPlayer, args, showError)
    TriggerClientEvent('fjob:openCreator', xPlayer.source)
end, false, {help = Config.Command.help})

ESX.RegisterServerCallback('fjob:getJobs', function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM jobs', {
    }, function(data)
        cb(data)
    end)
end)

RegisterServerEvent('fjob:createJob')
AddEventHandler('fjob:createJob', function(name, label, whitelist, money, offduty)
    local insertWhitelist, insertDuty = 0, 0
    if whitelist then 
        insertWhitelist = 1
    end 
    if offduty then 
        insertDuty = 1
    end 
    MySQL.insert('INSERT INTO jobs (name, label, whitelisted, money, offduty) VALUES (?, ?, ?, ?, ?)', {name, label, insertWhitelist, money, insertDuty},
    function() end)
end)

ESX.RegisterServerCallback('fjob:getJobsRanks', function(source, cb, id)
    MySQL.Async.fetchAll('SELECT * FROM job_grades WHERE job_name = @job_name', {
        ['job_name'] = id, 
    }, function(data)
        cb(data)
    end)
end)

ESX.RegisterServerCallback('fjob:getPoints', function(source, cb, id)
    MySQL.Async.fetchAll('SELECT * FROM f_job_marker WHERE job = @job', {
        ['job'] = id, 
    }, function(data)
        cb(data)
    end)
end)

RegisterServerEvent('fjob:createRank')
AddEventHandler('fjob:createRank', function(name, label, grade, salary, job)
    MySQL.Async.fetchAll('SELECT * FROM job_grades', {
    }, function(data)
        local id = data[#data].id + 1
        MySQL.insert('INSERT INTO job_grades (id, job_name, grade, name, label, salary) VALUES (?, ?, ?, ?, ?, ?)', {id, job, grade, name, label, salary},
        function() end)
    end)
end)

RegisterServerEvent('fjob:deleteRank')
AddEventHandler('fjob:deleteRank', function(job, name, grade)
    MySQL.Async. execute('DELETE FROM job_grades WHERE job_name = @job_name AND grade = @grade AND name = @name ', {
        ['@job_name'] = job,
        ['@grade'] = grade,
        ['@name'] = name,
    },
    function()end)
end)

RegisterServerEvent('fjob:deleteJob')
AddEventHandler('fjob:deleteJob', function(job)
    MySQL.Async. execute('DELETE FROM jobs WHERE name = @name', {
        ['@name'] = job,
    },
    function()end)
end)

RegisterServerEvent('fjob:editRank')
AddEventHandler('fjob:editRank', function(name, label, grade, salary, job, oldname, oldgrade)
    MySQL.Async.fetchAll('SELECT * FROM job_grades WHERE job_name = @job_name AND grade = @grade AND name = @name', {
        ['@job_name'] = job,
        ['@grade'] = tonumber(oldgrade),
        ['@name'] = oldname,
    }, function(data)
        local id = data[1].id
        MySQL.Async.execute('UPDATE job_grades SET name = @name WHERE id = @id', {
            ['@name'] = name,
            ['@id']  = id,
        })
        MySQL.Async.execute('UPDATE job_grades SET label = @label WHERE id = @id', {
            ['@label'] = label,
            ['@id']  = id,
        })
        MySQL.Async.execute('UPDATE job_grades SET grade = @grade WHERE id = @id', {
            ['@grade'] = grade,
            ['@id']  = id,
        })
        MySQL.Async.execute('UPDATE job_grades SET salary = @salary WHERE id = @id', {
            ['@salary'] = salary,
            ['@id']  = id,
        })
    end)
end)


RegisterServerEvent('fjob:editJob')
AddEventHandler('fjob:editJob', function(name, label, whitelist, offduty)
    MySQL.Async.execute('UPDATE jobs SET label = @label WHERE name = @name', {
        ['@name'] = name,
        ['@label']  = label,
    })
    MySQL.Async.execute('UPDATE jobs SET whitelisted = @whitelisted WHERE name = @name', {
        ['@name'] = name,
        ['@whitelisted']  = whitelist,
    })
    MySQL.Async.execute('UPDATE jobs SET offduty = @offduty WHERE name = @name', {
        ['@name'] = name,
        ['@offduty']  = offduty,
    })
end)

RegisterServerEvent('fjob:updateActions')
AddEventHandler('fjob:updateActions', function(job, action)
    MySQL.Async.execute('UPDATE jobs SET actions = @actions WHERE name = @name', {
        ['@name'] = job,
        ['@actions']  = json.encode(action),
    })
    TriggerClientEvent('fjob:updateAll', -1)
end)

ESX.RegisterServerCallback('fjob:createPoint', function(source, cb, job, id, name)
    local identifier = math.floor(math.random(10000000000, 99999999999) / math.floor(os.clock()))
    MySQL.insert('INSERT INTO f_job_marker (job, id, name, identifier) VALUES (?, ?, ?, ?)', {job, id, name, identifier},
    function(data) 
        cb(identifier)
    end)
    TriggerClientEvent('fjob:updateAll', -1)
end)

RegisterServerEvent('fjob:updateMarker')
AddEventHandler('fjob:updateMarker', function(identifier, point)
    MySQL.Async.execute('UPDATE f_job_marker SET name = @name WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@name']  = point.name,
    })
    MySQL.Async.execute('UPDATE f_job_marker SET mingrade = @mingrade WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@mingrade']  = tonumber(point.mingrade),
    })
    MySQL.Async.execute('UPDATE f_job_marker SET position = @position WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@position']  = point.position,
    })
    MySQL.Async.execute('UPDATE f_job_marker SET marker = @marker WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@marker']  = point.marker,
    })
    MySQL.Async.execute('UPDATE f_job_marker SET storemarker = @storemarker WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@storemarker']  = point.storemarker,
    })
    MySQL.Async.execute('UPDATE f_job_marker SET weapons = @weapons WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@weapons']  = point.weapons,
    })
    MySQL.Async.execute('UPDATE f_job_marker SET items = @items WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@items']  = point.items,
    })
    MySQL.Async.execute('UPDATE f_job_marker SET storage = @storage WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@storage']  = point.storage,
    })
    MySQL.Async.execute('UPDATE f_job_marker SET armor = @armor WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@armor']  = point.armor,
    })
    MySQL.Async.execute('UPDATE f_job_marker SET vehicles = @vehicles WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@vehicles']  = point.vehicles,
    })
    MySQL.Async.execute('UPDATE f_job_marker SET garage_type = @garage_type WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@garage_type']  = point.garage_type,
    })
    MySQL.Async.execute('UPDATE f_job_marker SET bosssettings = @bosssettings WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@bosssettings']  = point.bosssettings,
    })
    MySQL.Async.execute('UPDATE f_job_marker SET outfits = @outfits WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@outfits']  = point.outfits,
    })
    TriggerClientEvent('fjob:updateAll', -1)
end)

RegisterServerEvent('fjob:deleteMarker')
AddEventHandler('fjob:deleteMarker', function(identifier)
    MySQL.Async. execute('DELETE FROM f_job_marker WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
    },
    function()end)
    TriggerClientEvent('fjob:updateAll', -1)
end)