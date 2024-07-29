
function openId(selfID, targetID)
    TriggerServerEvent('jsfour-idcard:open', targetID, selfID)
end

function openBilling(selfID, targetID)
    ExecuteCommand('rechnungen')
end

RegisterNetEvent('fjob:addHealthClient')
AddEventHandler('fjob:addHealthClient', function(add)
    SetEntityHealth(PlayerPedId(), (GetEntityHealth(PlayerPedId()) + add))
    Config.Notifcation(locales['got_healed'])
end)