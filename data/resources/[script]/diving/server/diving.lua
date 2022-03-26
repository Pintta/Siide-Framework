local CurrentDivingArea = math.random(1, #rgDiving.Locations)

rg.toiminnot.CreateCallback('diving:server:GetDivingConfig', function(source, cb)
    cb(rgDiving.Locations, CurrentDivingArea)
end)

RegisterServerEvent('diving:server:TakeCoral')
AddEventHandler('diving:server:TakeCoral', function(Area, Coral, Bool)
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)
    local CoralType = math.random(1, #rgDiving.CoralTypes)
    local Amount = math.random(1, rgDiving.CoralTypes[CoralType].maxAmount)
    local ItemData = rg.datapankki.Items[rgDiving.CoralTypes[CoralType].item]

    if Amount > 1 then
        for i = 1, Amount, 1 do
            Player.Functions.AddItem(ItemData["name"], 1)
            TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "add")
            Citizen.Wait(250)
        end
    else
        Player.Functions.AddItem(ItemData["name"], Amount)
        TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "add")
    end

    if (rgDiving.Locations[Area].TotalCoral - 1) == 0 then
        for k, v in pairs(rgDiving.Locations[CurrentDivingArea].coords.Coral) do
            v.PickedUp = false
        end
        rgDiving.Locations[CurrentDivingArea].TotalCoral = rgDiving.Locations[CurrentDivingArea].DefaultCoral

        local newLocation = math.random(1, #rgDiving.Locations)
        while (newLocation == CurrentDivingArea) do
            Citizen.Wait(3)
            newLocation = math.random(1, #rgDiving.Locations)
        end
        CurrentDivingArea = newLocation
        
        TriggerClientEvent('diving:client:NewLocations', -1)
    else
        rgDiving.Locations[Area].coords.Coral[Coral].PickedUp = Bool
        rgDiving.Locations[Area].TotalCoral = rgDiving.Locations[Area].TotalCoral - 1
    end

    TriggerClientEvent('diving:server:UpdateCoral', -1, Area, Coral, Bool)
end)

RegisterServerEvent('diving:server:RemoveGear')
AddEventHandler('diving:server:RemoveGear', function()
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)

    Player.Functions.RemoveItem("diving_gear", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, rg.datapankki.Items["diving_gear"], "remove")
end)

RegisterServerEvent('diving:server:GiveBackGear')
AddEventHandler('diving:server:GiveBackGear', function()
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)
    
    Player.Functions.AddItem("diving_gear", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, rg.datapankki.Items["diving_gear"], "add")
end)