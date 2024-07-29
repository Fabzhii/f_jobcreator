Config = {}

Config.Command = {
    commands = {'jobs', 'createjob', 'jobcreator', 'jobmaker'},
    group = 'admin',
    help = 'Öffne den Job Creator',
}


Config.DefaultVehicleShopPosition = vector4(228.5, -993.5, -99.9999, 185.0)

Config.RenderDistance = 50
Config.InteractDistance = 1.2 

Config.PlateLetters = 3
Config.PlateNumbers = 3
Config.PlateUseSpace = true 

Config.OffDutyPay = 200
Config.OffDutySuffix = ' - Off Duty'

Config.HandCuffsDisable = {
    20,
    21,
    22,
    23,
    24,
    25,
    257,
    263,
    288,
}

Config.ZipTiesDisable = {
    20,
    22,
    24,
    25,
    257,
    263,
    288,
}


Config.Symbols = {
    'circle-xmark',
    'circle-check',
}

Config.Notifcation = function(notify)
    local message = notify[1]
    local notify_type = notify[2]
    lib.notify({
        position = 'top-right',
        description = message,
        type = notify_type,
    })
end 

Config.InfoBar = function(info, toggle)
    local message = info[1]
    local notify_type = info[2]
    if toggle then 
        lib.showTextUI(message, {position = 'left-center'})
    else 
        lib.hideTextUI()
    end
end 
