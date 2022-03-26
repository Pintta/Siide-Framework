rg.toiminnot.CreateCallback('drugs:server:cornerselling:getAvailableDrugs', function(source, cb)
    local AvailableDrugs = {}
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)

    for i = 1, #Config.CornerSellingDrugsList, 1 do
        local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

        if item ~= nil then
            table.insert(AvailableDrugs, {
                item = item.name,
                amount = item.amount,
                label = rg.datapankki.Items[item.name]["label"]
            })
        end
    end

    if next(AvailableDrugs) ~= nil then
        cb(AvailableDrugs)
    else
        cb(nil)
    end
end)

RegisterServerEvent('drugs:server:sellCornerDrugs')
AddEventHandler('drugs:server:sellCornerDrugs', function(item, amount, price)
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)
    local AvailableDrugs = {}

    Player.Functions.RemoveItem(item, amount)
    Player.Functions.AddMoney('cash', price, "sold-cornerdrugs")

    TriggerClientEvent('inventory:client:ItemBox', src, rg.datapankki.Items[item], "remove")

    for i = 1, #Config.CornerSellingDrugsList, 1 do
        local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

        if item ~= nil then
            table.insert(AvailableDrugs, {
                item = item.name,
                amount = item.amount,
                label = rg.datapankki.Items[item.name]["label"]
            })
        end
    end

    TriggerClientEvent('drugs:client:refreshAvailableDrugs', src, AvailableDrugs)
end)

RegisterServerEvent('drugs:server:robCornerDrugs')
AddEventHandler('drugs:server:robCornerDrugs', function(item, amount, price)
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)
    local AvailableDrugs = {}

    Player.Functions.RemoveItem(item, amount)

    TriggerClientEvent('inventory:client:ItemBox', src, rg.datapankki.Items[item], "remove")

    for i = 1, #Config.CornerSellingDrugsList, 1 do
        local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

        if item ~= nil then
            table.insert(AvailableDrugs, {
                item = item.name,
                amount = item.amount,
                label = rg.datapankki.Items[item.name]["label"]
            })
        end
    end

    TriggerClientEvent('drugs:client:refreshAvailableDrugs', src, AvailableDrugs)
end)