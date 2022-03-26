function getPlayerCashMoney()
    return rg.toiminnot.GetPlayerData().money['cash']
end

function saveVehicleData(vehicle)
    TriggerServerEvent("customs:server:SaveVehicleProps", rg.toiminnot.GetVehicleProperties(vehicle))
end