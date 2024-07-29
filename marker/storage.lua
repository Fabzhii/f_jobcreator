
local ox_inventory = exports.ox_inventory
local locales = Locales.Locales[Locales.Language]

function openStorage(marker, grade, positionIndex)
    if marker.storage.use then 
        local position = marker.position[positionIndex].position
        local identifier = ('storage_'..marker.identifier..'-'..math.floor(position.x)..'-'..math.floor(position.y)..'-'..math.floor(position.z))
        exports.ox_inventory:openInventory('stash', identifier)
    end 
end 