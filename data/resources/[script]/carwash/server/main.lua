rg = nil
TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)



RegisterServerEvent('carwash:server:washCar')
AddEventHandler('carwash:server:washCar', function()
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)

    if Player.Functions.RemoveMoney('cash', Config.DefaultPrice, "car-washed") then
        TriggerClientEvent('carwash:client:washCar', src)
    elseif Player.Functions.RemoveMoney('bank', Config.DefaultPrice, "car-washed") then
        TriggerClientEvent('carwash:client:washCar', src)
    else
        TriggerClientEvent('rg:Ilmoitus', src, 'You have no money to wash the car..', 'error')
    end
end)