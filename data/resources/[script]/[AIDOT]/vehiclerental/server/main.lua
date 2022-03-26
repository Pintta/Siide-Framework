rg = nil
TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)



local RentedVehicles = {}

RegisterServerEvent('vehiclerental:server:SetVehicleRented')
AddEventHandler('vehiclerental:server:SetVehicleRented', function(plate, bool, vehicleData)
    local src = source
    local ply = rg.toiminnot.GetPlayer(src)
    local plyCid = ply.PlayerData.citizenid

    if bool then
        if ply.PlayerData.money.cash >= vehicleData.price then
            ply.Functions.RemoveMoney('cash', vehicleData.price, "vehicle-rentail-bail") 
            RentedVehicles[plyCid] = plate
            TriggerClientEvent('rg:Ilmoitus', src, 'Je hebt de borg van $'..vehicleData.price..' cash betaald.', 'success', 3500)
            TriggerClientEvent('vehiclerental:server:SpawnRentedVehicle', src, plate, vehicleData) 
        elseif ply.PlayerData.money.bank >= vehicleData.price then 
            ply.Functions.RemoveMoney('bank', vehicleData.price, "vehicle-rentail-bail") 
            RentedVehicles[plyCid] = plate
            TriggerClientEvent('rg:Ilmoitus', src, 'Je hebt de borg van $'..vehicleData.price..' via de bank betaald.', 'success', 3500)
            TriggerClientEvent('vehiclerental:server:SpawnRentedVehicle', src, plate, vehicleData) 
        else
            TriggerClientEvent('rg:Ilmoitus', src, 'Je hebt niet genoeg geld.', 'error', 3500)
        end
        return
    end
    TriggerClientEvent('rg:Ilmoitus', src, 'Je hebt je borg van $'..vehicleData.price..' terug gekregen.', 'success', 3500)
    ply.Functions.AddMoney('cash', vehicleData.price, "vehicle-rentail-bail")
    RentedVehicles[plyCid] = nil
end)




