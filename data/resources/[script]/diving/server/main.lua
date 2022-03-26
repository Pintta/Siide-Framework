rg = nil
TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)



RegisterServerEvent('diving:server:SetBerthVehicle')
AddEventHandler('diving:server:SetBerthVehicle', function(BerthId, vehicleModel)
    TriggerClientEvent('diving:client:SetBerthVehicle', -1, BerthId, vehicleModel)
    
    rgBoatshop.Locations["berths"][BerthId]["boatModel"] = boatModel
end)

RegisterServerEvent('diving:server:SetDockInUse')
AddEventHandler('diving:server:SetDockInUse', function(BerthId, InUse)
    rgBoatshop.Locations["berths"][BerthId]["inUse"] = InUse
    TriggerClientEvent('diving:client:SetDockInUse', -1, BerthId, InUse)
end)

rg.toiminnot.CreateCallback('diving:server:GetBusyDocks', function(source, cb)
    cb(rgBoatshop.Locations["berths"])
end)

RegisterServerEvent('diving:server:BuyBoat')
AddEventHandler('diving:server:BuyBoat', function(boatModel, BerthId)
    local BoatPrice = rgBoatshop.ShopBoats[boatModel]["price"]
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)
    local PlayerMoney = {
        cash = Player.PlayerData.money.cash,
        bank = Player.PlayerData.money.bank,
    }
    local missingMoney = 0
    local plate = "IDEK"..math.random(1111, 9999)

    if PlayerMoney.cash >= BoatPrice then
        Player.Functions.RemoveMoney('cash', BoatPrice, "bought-boat")
        TriggerClientEvent('diving:client:BuyBoat', src, boatModel, plate)
        InsertBoat(boatModel, Player, plate)
    elseif PlayerMoney.bank >= BoatPrice then
        Player.Functions.RemoveMoney('bank', BoatPrice, "bought-boat")
        TriggerClientEvent('diving:client:BuyBoat', src, boatModel, plate)
        InsertBoat(boatModel, Player, plate)
    else
        if PlayerMoney.bank > PlayerMoney.cash then
            missingMoney = (BoatPrice - PlayerMoney.bank)
        else
            missingMoney = (BoatPrice - PlayerMoney.cash)
        end
        TriggerClientEvent('rg:Ilmoitus', src, 'You do not have enough money, you are missing $'..missingMoney, 'error', 4000)
    end
end)

function InsertBoat(boatModel, Player, plate)
    rg.toiminnot.datasilta(false, "INSERT INTO `player_boats` (`citizenid`, `model`, `plate`) VALUES ('"..Player.PlayerData.citizenid.."', '"..boatModel.."', '"..plate.."')")
end

rg.toiminnot.CreateUseableItem("jerry_can", function(source, item)
    local Player = rg.toiminnot.GetPlayer(source)

    TriggerClientEvent("diving:client:UseJerrycan", source)
end)

rg.toiminnot.CreateUseableItem("diving_gear", function(source, item)
    local Player = rg.toiminnot.GetPlayer(source)

    TriggerClientEvent("diving:client:UseGear", source, true)
end)

RegisterServerEvent('diving:server:RemoveItem')
AddEventHandler('diving:server:RemoveItem', function(item, amount)
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)

    Player.Functions.RemoveItem(item, amount)
end)

rg.toiminnot.CreateCallback('diving:server:GetMyBoats', function(source, cb, dock)
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)

    rg.toiminnot.datasilta(false, "SELECT * FROM `player_boats` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `boathouse` = '"..dock.."'", function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

rg.toiminnot.CreateCallback('diving:server:GetDepotBoats', function(source, cb, dock)
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)

    rg.toiminnot.datasilta(false, "SELECT * FROM `player_boats` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `state` = '0'", function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('diving:server:SetBoatState')
AddEventHandler('diving:server:SetBoatState', function(plate, state, boathouse)
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)
    rg.toiminnot.datasiltav(false, "SELECT * FROM `player_boats` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            rg.toiminnot.datasilta(false, "UPDATE `player_boats` SET `state` = '"..state.."' WHERE `plate` = '"..plate.."' AND `citizenid` = '"..Player.PlayerData.citizenid.."'")
    
            if state == 1 then
                rg.toiminnot.datasilta(false, "UPDATE `player_boats` SET `boathouse` = '"..boathouse.."' WHERE `plate` = '"..plate.."' AND `citizenid` = '"..Player.PlayerData.citizenid.."'")
            end
        end
    end)
end)

RegisterServerEvent('diving:server:CallCops')
AddEventHandler('diving:server:CallCops', function(Coords)
    local src = source
    for k, v in pairs(rg.toiminnot.GetPlayers()) do
        local Player = rg.toiminnot.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                local msg = "Coral may be stolen!"
                TriggerClientEvent('diving:client:CallCops', Player.PlayerData.source, Coords, msg)
                local alertData = {
                    title = "illegal diving",
                    coords = {x = Coords.x, y = Coords.y, z = Coords.z},
                    description = msg,
                }
                TriggerClientEvent("phone:client:addPoliceAlert", -1, alertData)
            end
        end
	end
end)

local AvailableCoral = {}

rg.komennot.Add("wetsuit", "take or put on wetsuit", {}, false, function(source, args)
    local Player = rg.toiminnot.GetPlayer(source)
    TriggerClientEvent("diving:client:UseGear", source, false)
end)

RegisterServerEvent('diving:server:SellCoral')
AddEventHandler('diving:server:SellCoral', function()
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)

    if HasCoral(src) then
        for k, v in pairs(AvailableCoral) do
            local Item = Player.Functions.GetItemByName(v.item)
            local price = (Item.amount * v.price)
            local Reward = math.ceil(GetItemPrice(Item, price))

            if Item.amount > 1 then
                for i = 1, Item.amount, 1 do
                    Player.Functions.RemoveItem(Item.name, 1)
                    TriggerClientEvent('inventory:client:ItemBox', src, rg.datapankki.Items[Item.name], "remove")
                    Player.Functions.AddMoney('cash', math.ceil((Reward / Item.amount)), "sold-coral")
                    Citizen.Wait(250)
                end
            else
                Player.Functions.RemoveItem(Item.name, 1)
                Player.Functions.AddMoney('cash', Reward, "sold-coral")
                TriggerClientEvent('inventory:client:ItemBox', src, rg.datapankki.Items[Item.name], "remove")
            end
        end
    else
        TriggerClientEvent('rg:Ilmoitus', src, 'You dont have coral to sell..', 'error')
    end
end)

function GetItemPrice(Item, price)
    if Item.amount > 5 then
        price = price / 100 * 80
    elseif Item.amount > 10 then
        price = price / 100 * 70
    elseif Item.amount > 15 then
        price = price / 100 * 50
    end
    return price
end

function HasCoral(src)
    local Player = rg.toiminnot.GetPlayer(src)
    local retval = false
    AvailableCoral = {}

    for k, v in pairs(rgDiving.CoralTypes) do
        local Item = Player.Functions.GetItemByName(v.item)
        if Item ~= nil then
            table.insert(AvailableCoral, v)
            retval = true
        end
    end
    return retval
end