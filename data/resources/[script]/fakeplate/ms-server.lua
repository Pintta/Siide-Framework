rg = nil
TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)

rg.toiminnot.CreateUseableItem("advancedlockpick", function(source, item)
    local Player = rg.toiminnot.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("fakeplate:removeplate", -1, source)
    end
end)

rg.toiminnot.CreateUseableItem("license_plate", function(source, item)
    local Player = rg.toiminnot.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("fakeplate:placeplate", -1, source)
    end
end)
