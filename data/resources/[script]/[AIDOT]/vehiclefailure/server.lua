rg = nil
TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)

rg.komennot.Add("fix", "Reparar o carro", {}, false, function(source, args)
    TriggerClientEvent('iens:repaira', source)
    TriggerClientEvent('vehiclemod:client:fixEverything', source)
end, "admin")

rg.toiminnot.CreateUseableItem("repairkit", function(source, item)
    local Player = rg.toiminnot.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("vehiclefailure:client:RepairVehicle", source)
    end
end)

rg.toiminnot.CreateUseableItem("cleaningkit", function(source, item)
    local Player = rg.toiminnot.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("vehiclefailure:client:CleanVehicle", source)
    end
end)

rg.toiminnot.CreateUseableItem("advancedrepairkit", function(source, item)
    local Player = rg.toiminnot.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("vehiclefailure:client:RepairVehicleFull", source)
    end
end)

RegisterServerEvent('vehiclefailure:removeItem')
AddEventHandler('vehiclefailure:removeItem', function(item)
    local src = source
    local ply = rg.toiminnot.GetPlayer(src)
    ply.Functions.RemoveItem(item, 1)
end)

RegisterServerEvent('vehiclefailure:server:removewashingkit')
AddEventHandler('vehiclefailure:server:removewashingkit', function(veh)
    local src = source
    local ply = rg.toiminnot.GetPlayer(src)
    ply.Functions.RemoveItem("cleaningkit", 1)
    TriggerClientEvent('vehiclefailure:client:SyncWash', -1, veh)
end)

