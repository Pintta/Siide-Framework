rg = nil
TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)



rg.toiminnot.CreateCallback('occasions:server:getVehicles', function(source, cb)
    rg.toiminnot.datasilta(false, 'SELECT * FROM `occasion_vehicles`', function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

rg.toiminnot.CreateCallback("garage:server:checkVehicleOwner", function(source, cb, plate)
    local src = source
    local pData = rg.toiminnot.GetPlayer(src)

    exports['datasilta']:execute('SELECT * FROM player_vehicles WHERE plate = @plate AND citizenid = @citizenid', {['@plate'] = plate, ['@citizenid'] = pData.PlayerData.citizenid}, function(result)
        if result[1] ~= nil then
            cb(true)
        else
            cb(false)
        end
    end)
end)

rg.toiminnot.CreateCallback("occasions:server:getSellerInformation", function(source, cb, citizenid)
    local src = source

    exports['datasilta']:execute('SELECT * FROM players WHERE citizenid = @citizenid', {['@citizenid'] = citizenid}, function(result)
        if result[1] ~= nil then
            cb(result[1])
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('occasions:server:ReturnVehicle')
AddEventHandler('occasions:server:ReturnVehicle', function(vehicleData)
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)
    rg.toiminnot.datasilta(false, "SELECT * FROM `occasion_vehicles` WHERE `plate` = '"..vehicleData['plate'].."' AND `occasionid` = '"..vehicleData["oid"].."'", function(result)
        if result[1] ~= nil then 
            if result[1].seller == Player.PlayerData.citizenid then
                rg.toiminnot.datasilta(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..vehicleData["model"].."', '"..GetHashKey(vehicleData["model"]).."', '"..vehicleData["mods"].."', '"..vehicleData["plate"].."', '0')")
                rg.toiminnot.datasilta(false, "DELETE FROM `occasion_vehicles` WHERE `occasionid` = '"..vehicleData["oid"].."' and `plate` = '"..vehicleData['plate'].."'")
                TriggerClientEvent("occasions:client:ReturnOwnedVehicle", src, result[1])
                TriggerClientEvent('occasion:client:refreshVehicles', -1)
            else
                TriggerClientEvent('rg:Ilmoitus', src, 'This is not your vehicle...', 'error', 3500)
            end
        else
            TriggerClientEvent('rg:Ilmoitus', src, 'Vehicle does not exist...', 'error', 3500)
        end
    end)
end)

RegisterServerEvent('occasions:server:sellVehicle')
AddEventHandler('occasions:server:sellVehicle', function(vehiclePrice, vehicleData)
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)
    rg.toiminnot.datasilta(true, "DELETE FROM `player_vehicles` WHERE `plate` = '"..vehicleData.plate.."' AND `vehicle` = '"..vehicleData.model.."'")
    rg.toiminnot.datasilta(true, "INSERT INTO `occasion_vehicles` (`seller`, `price`, `description`, `plate`, `model`, `mods`, `occasionid`) VALUES ('"..Player.PlayerData.citizenid.."', '"..vehiclePrice.."', '"..escapeSqli(vehicleData.desc).."', '"..vehicleData.plate.."', '"..vehicleData.model.."', '"..json.encode(vehicleData.mods).."', '"..generateOID().."')")
    
    TriggerEvent("logs:server:sendLog", Player.PlayerData.citizenid, "vehiclesold", {model=vehicleData.model, vehiclePrice=vehiclePrice})
    TriggerEvent("logs:server:CreateLog", "vehicleshop", "For sale", "red", "**"..GetPlayerName(src) .. "** Selling a " .. vehicleData.model .. " For "..vehiclePrice)

    TriggerClientEvent('occasion:client:refreshVehicles', -1)
end)

RegisterServerEvent('occasions:server:buyVehicle')
AddEventHandler('occasions:server:buyVehicle', function(vehicleData)
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)

    rg.toiminnot.datasilta(false, "SELECT * FROM `occasion_vehicles` WHERE `plate` = '"..vehicleData['plate'].."' AND `occasionid` = '"..vehicleData["oid"].."'", function(result)
        if result[1] ~= nil and next(result[1]) ~= nil then
            if Player.PlayerData.money.cash >= result[1].price then
                local SellerCitizenId = result[1].seller
                local SellerData = rg.toiminnot.GetPlayerByCitizenId(SellerCitizenId)
                -- New price calculation minus tax
                local NewPrice = math.ceil((result[1].price / 100) * 77)

                Player.Functions.RemoveMoney('cash', result[1].price)

                -- Insert vehicle for buyer
                rg.toiminnot.datasilta(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..result[1].model.."', '"..GetHashKey(result[1].model).."', '"..result[1].mods.."', '"..result[1].plate.."', '0')")
                
                -- Handle money transfer
                if SellerData ~= nil then
                    -- Add money for online
                    SellerData.Functions.AddMoney('bank', NewPrice)
                else
                    -- Add money for offline
                    rg.toiminnot.datasilta(true, "SELECT * FROM `players` WHERE `citizenid` = '"..SellerCitizenId.."'", function(BuyerData)
                        if BuyerData[1] ~= nil then
                            local BuyerMoney = json.decode(BuyerData[1].money)
                            BuyerMoney.bank = BuyerMoney.bank + NewPrice
                            rg.toiminnot.datasilta(false, "UPDATE `players` SET `money` = '"..json.encode(BuyerMoney).."' WHERE `citizenid` = '"..SellerCitizenId.."'")
                        end
                    end)
                end

                TriggerEvent("logs:server:sendLog", Player.PlayerData.citizenid, "vehiclebought", {model = result[1].model, from = SellerCitizenId, moneyType = "cash", vehiclePrice = result[1].price, plate = result[1].plate})
                TriggerEvent("logs:server:CreateLog", "vehicleshop", "Occasion bought", "green", "**"..GetPlayerName(src) .. "** Bought a occasion for "..result[1].price .. " (" .. result[1].plate .. ") of **"..SellerCitizenId.."**")
                TriggerClientEvent('occasion:client:refreshVehicles', -1)
            
                -- Delete vehicle from Occasion
                rg.toiminnot.datasilta(false, "DELETE FROM `occasion_vehicles` WHERE `plate` = '"..result[1].plate.."' and `occasionid` = '"..result[1].occasionid.."'")

                -- Send selling mail to seller
                TriggerEvent('phone:server:sendNewMailToOffline', SellerCitizenId, {
                    sender = "Stand",
                    subject = "Your car has been bought!",
                    message = "Hey Im Mike, I came here to say that your car "..rg.datapankki.Vehicles[result[1].model].name.." was sold for $"..result[1].price.."!"
                })
            elseif Player.PlayerData.money.bank >= result[1].price then
                local SellerCitizenId = result[1].seller
                local SellerData = rg.toiminnot.GetPlayerByCitizenId(SellerCitizenId)
                -- New price calculation minus tax
                local NewPrice = math.ceil((result[1].price / 100) * 77)

                Player.Functions.RemoveMoney('bank', result[1].price)

                -- Insert vehicle for buyer
                rg.toiminnot.datasilta(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..result[1].model.."', '"..GetHashKey(result[1].model).."', '"..result[1].mods.."', '"..result[1].plate.."', '0')")
                
                -- Handle money transfer
                if SellerData ~= nil then
                    -- Add money for online
                    SellerData.Functions.AddMoney('bank', NewPrice)
                else
                    -- Add money for offline
                    rg.toiminnot.datasilta(true, "SELECT * FROM `players` WHERE `citizenid` = '"..SellerCitizenId.."'", function(BuyerData)
                        if BuyerData[1] ~= nil then
                            local BuyerMoney = json.decode(BuyerData[1].money)
                            BuyerMoney.bank = BuyerMoney.bank + NewPrice
                            rg.toiminnot.datasilta(false, "UPDATE `players` SET `money` = '"..json.encode(BuyerMoney).."' WHERE `citizenid` = '"..SellerCitizenId.."'")
                        end
                    end)
                end

                TriggerEvent("logs:server:sendLog", Player.PlayerData.citizenid, "vehiclebought", {model = result[1].model, from = SellerCitizenId, moneyType = "cash", vehiclePrice = result[1].price, plate = result[1].plate})
                TriggerEvent("logs:server:CreateLog", "vehicleshop", "Occasion bought", "green", "**"..GetPlayerName(src) .. "** Bought a occasion for "..result[1].price .. " (" .. result[1].plate .. ") of **"..SellerCitizenId.."**")
                TriggerClientEvent('occasion:client:refreshVehicles', -1)
            
                -- Delete vehicle from Occasion
                rg.toiminnot.datasilta(false, "DELETE FROM `occasion_vehicles` WHERE `plate` = '"..result[1].plate.."' and `occasionid` = '"..result[1].occasionid.."'")

                -- Send selling mail to seller
                TriggerEvent('phone:server:sendNewMailToOffline', SellerCitizenId, {
                    sender = "Used Car Stand",
                    subject = "Your car was sold!!",
                    message = "Hi, your car "..rg.datapankki.Vehicles[result[1].model].name.." was sold for $"..result[1].price..",-!"
                })
            else
                TriggerClientEvent('rg:Ilmoitus', src, 'You do not have enough money...', 'error', 3500)
            end
        end
    end)
end)

function generateOID()
    local num = math.random(1, 10)..math.random(111, 999)

    return "OC"..num
end

function round(number)
    return number - (number % 1)
end

function escapeSqli(str)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return str:gsub("['\"]", replacements) -- or string.gsub(source, "['\"]", replacements)
end