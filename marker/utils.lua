function spawncar(car, pos, bucket)
    local ModelHash = car
	if not IsModelInCdimage(ModelHash) then return end
	RequestModel(ModelHash)
	while not HasModelLoaded(ModelHash) do Wait(0) end
	vehicle = CreateVehicle(ModelHash, pos, pos.w, true, false)
    
	SetModelAsNoLongerNeeded(ModelHash)
    FreezeEntityPosition(vehicle, true)
    SetVehicleNumberPlateText(vehicle, GenPlate())
	Citizen.Wait(30)
	TriggerServerEvent('fjob:setEntityBucket', NetworkGetNetworkIdFromEntity(vehicle), bucket)
	return(vehicle)
end 

local NumberCharset = {}
local Charset = {}
for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end
function GenPlate()
	math.randomseed(GetGameTimer())
	local generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. (Config.PlateUseSpace and ' ' or '') .. GetRandomNumber(Config.PlateNumbers))
	local isTaken = IsPlateTaken(generatedPlate)
	if isTaken then 
		return GenPlate()
	end
	return generatedPlate
end
function IsPlateTaken(plate)
	local p = promise.new()
	ESX.TriggerServerCallback('fjob:isPlateTaken', function(isPlateTaken)
		p:resolve(isPlateTaken)
	end, plate)
	return Citizen.Await(p)
end
function GetRandomNumber(length)
	Wait(0)
	return length > 0 and GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)] or ''
end
function GetRandomLetter(length)
	Wait(0)
	return length > 0 and GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)] or ''
end

incar = false 
Citizen.CreateThread(function()
    while true do 
        if incar then 
            Citizen.Wait(1)
            DisableControlAction(2, 75, true)
        else 
            Citizen.Wait(200)
        end 
    end 
end)

function toggleExit(bool)
	incar = bool 
end 

function youSure(header, text)
    local alert = lib.alertDialog({
        header = header,
        content = text,
        centered = true,
        cancel = true,
        labels = {
            confirm = Menus.Boss.yes,
            cancel = Menus.Boss.no,
        }
    })
    local back = false 
    if alert == 'confirm' then 
        back = true 
    end 
    return(back)
end 

function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
	end
end