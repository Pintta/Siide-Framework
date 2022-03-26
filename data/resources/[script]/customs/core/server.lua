rg = nil

CreateThread(function()
    while (rg == nil) do
        TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)
        Wait(100)
    end
end)

RegisterServerEvent('customs:removeCash')
AddEventHandler('customs:removeCash', function(amount)
    local src = source
    removePlayerCashMoney(src, amount)
end)

function IsVehicleOwned(plate)
    local retval = false
    rg.toiminnot.datasilta(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = true
        end
    end)
    return retval
end

RegisterServerEvent('customs:server:SaveVehicleProps')
AddEventHandler('customs:server:SaveVehicleProps', function(vehicleProps)
    local src = source
    if IsVehicleOwned(vehicleProps.plate) then
        rg.toiminnot.datasilta(false, "UPDATE `player_vehicles` SET `mods` = '"..json.encode(vehicleProps).."' WHERE `plate` = '"..vehicleProps.plate.."'")
    else
        TriggerClientEvent('rg:Ilmoitus', src, 'No Owner - Mods Not Saved', 'error')
    end
end)
