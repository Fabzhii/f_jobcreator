
ESX.RegisterServerCallback("fjob:getSocietyMoney", function(source, cb, job) 
    MySQL.Async.fetchAll('SELECT * FROM okokbanking_societies', {
    }, function(data)
        for k,v in pairs(data) do 
            if v.society_name == job then 
                cb(v.value)
            end 
        end 
    end)
end) 

RegisterServerEvent('fjob:updateSocietyMoney')
AddEventHandler('fjob:updateSocietyMoney', function(job, money)
    MySQL.Async.execute('UPDATE okokbanking_societies SET value = @value WHERE society_name = @society_name', {
        ['@society_name']  = job,
        ['@value'] = money,
    })
end)

RegisterServerEvent('fjob:reviveId')
AddEventHandler('fjob:reviveId', function(id)
    local xPlayer = ESX.GetPlayerFromId(id)
    xPlayer.triggerEvent('esx_ambulancejob:revive')
end)