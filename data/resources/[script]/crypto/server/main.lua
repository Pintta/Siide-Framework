rg = nil
TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)

rg.komennot.Add("setcryptoworth", "Set crypto worth", {{name="crypto", help="Name of the crypto"}, {name="Worth", help="New worth of the crypto currency"}}, false, function(source, args)
    local src = source
    local crypto = tostring(args[1])

    if crypto ~= nil then
        if Crypto.Worth[crypto] ~= nil then
            local NewWorth = math.ceil(tonumber(args[2]))
            
            if NewWorth ~= nil then
                local PercentageChange = math.ceil(((NewWorth - Crypto.Worth[crypto]) / Crypto.Worth[crypto]) * 100)
                local ChangeLabel = "+"
                if PercentageChange < 0 then
                    ChangeLabel = "-"
                    PercentageChange = (PercentageChange * -1)
                end
                if Crypto.Worth[crypto] == 0 then
                    PercentageChange = 0
                    ChangeLabel = ""
                end

                table.insert(Crypto.History[crypto], {
                    PreviousWorth = Crypto.Worth[crypto],
                    NewWorth = NewWorth
                })

                TriggerClientEvent('rg:Ilmoitus', src, "sinä asetat arvon "..Crypto.Labels[crypto].." from: ($"..Crypto.Worth[crypto].." to: $"..NewWorth..") ("..ChangeLabel.." "..PercentageChange.."%)")
                Crypto.Worth[crypto] = NewWorth
                TriggerClientEvent('crypto:client:UpdateCryptoWorth', -1, crypto, NewWorth)
                rg.toiminnot.datasilta(false, "UPDATE `crypto` SET `worth` = '"..NewWorth.."', `history` = '"..json.encode(Crypto.History[crypto]).."' WHERE `crypto` = '"..crypto.."'")
            else
                TriggerClientEvent('rg:Ilmoitus', src, "et ole antanut arvoa.. nykyinen arvo: "..Crypto.Worth[crypto])
            end
        else
            TriggerClientEvent('rg:Ilmoitus', src, "tämä crypto valuutta ei ole olemassa :(, olemassa oleva crypto: ELLAcoin")
        end
    else
        TriggerClientEvent('rg:Ilmoitus', src, "et valinnut crypto valuuttaa, olemassa oleva crpyto: ELLAcoin")
    end
end, "admin")

rg.komennot.Add("checkcryptoworth", "", {}, false, function(source, args)
    local src = source
    TriggerClientEvent('rg:Ilmoitus', src, "The ELLAcoin has a value of: $"..Crypto.Worth["ELLAcoin"])
end, "admin")

rg.komennot.Add("crypto", "", {}, false, function(source, args)
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)
    local MyPocket = math.ceil(Player.PlayerData.money.crypto * Crypto.Worth["ELLAcoin"])

    TriggerClientEvent('rg:Ilmoitus', src, "You have: "..Player.PlayerData.money.crypto.." ELLAcoin, with a worth of: $"..MyPocket..",-")
end, "admin")

RegisterServerEvent('crypto:server:FetchWorth')
AddEventHandler('crypto:server:FetchWorth', function()
    for name,_ in pairs(Crypto.Worth) do
        rg.toiminnot.datasilta(false, "SELECT * FROM `crypto` WHERE `crypto` = '"..name.."'", function(result)
            if result[1] ~= nil then
                Crypto.Worth[name] = result[1].worth
                if result[1].history ~= nil then
                    Crypto.History[name] = json.decode(result[1].history)
                    TriggerClientEvent('crypto:client:UpdateCryptoWorth', -1, name, result[1].worth, json.decode(result[1].history))
                else
                    TriggerClientEvent('crypto:client:UpdateCryptoWorth', -1, name, result[1].worth, nil)
                end
            end
        end)
    end
end)

RegisterServerEvent('crypto:server:ExchangeFail')
AddEventHandler('crypto:server:ExchangeFail', function()
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)
    local ItemData = Player.Functions.GetItemByName("cryptostick")

    if ItemData ~= nil then
        Player.Functions.RemoveItem("cryptostick", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, rg.datapankki.Items["cryptostick"], "remove")
        TriggerClientEvent('rg:Ilmoitus', src, "Attempt failed, the stick crashed..", 'error', 5000)
    end
end)

RegisterServerEvent('crypto:server:Rebooting')
AddEventHandler('crypto:server:Rebooting', function(state, percentage)
    Crypto.Exchange.RebootInfo.state = state
    Crypto.Exchange.RebootInfo.percentage = percentage
end)

RegisterServerEvent('crypto:server:GetRebootState')
AddEventHandler('crypto:server:GetRebootState', function()
    local src = source
    TriggerClientEvent('crypto:client:GetRebootState', src, Crypto.Exchange.RebootInfo)
end)

RegisterServerEvent('crypto:server:SyncReboot')
AddEventHandler('crypto:server:SyncReboot', function()
    TriggerClientEvent('crypto:client:SyncReboot', -1)
end)

RegisterServerEvent('crypto:server:ExchangeSuccess')
AddEventHandler('crypto:server:ExchangeSuccess', function(LuckChance)
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)
    local ItemData = Player.Functions.GetItemByName("cryptostick")

    if ItemData ~= nil then
        local LuckyNumber = math.random(1, 10)
        local DeelNumber = 1000000
        local Amount = (math.random(611111, 1599999) / DeelNumber)
        if LuckChance == LuckyNumber then
            Amount = (math.random(1599999, 2599999) / DeelNumber)
        end

        Player.Functions.RemoveItem("cryptostick", 1)
        Player.Functions.AddMoney('crypto', Amount)
        TriggerClientEvent('rg:Ilmoitus', src, "olet vaihtanut cryptotikussi: "..Amount.." ELLAcoin(\'s)", "success", 3500)
        TriggerClientEvent('inventory:client:ItemBox', src, rg.datapankki.Items["cryptostick"], "remove")
        TriggerClientEvent('phone:client:AddTransaction', src, Player, {}, "There are "..Amount.." ELLAcoin('s) credited!", "Bijschrijving")
    end
end)

rg.toiminnot.CreateCallback('crypto:server:HasSticky', function(source, cb)
    local Player = rg.toiminnot.GetPlayer(source)
    local Item = Player.Functions.GetItemByName("cryptostick")

    if Item ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

rg.toiminnot.CreateCallback('crypto:server:GetCryptoData', function(source, cb, name)
    local Player = rg.toiminnot.GetPlayer(source)
    local CryptoData = {
        History = Crypto.History[name],
        Worth = Crypto.Worth[name],
        Portfolio = Player.PlayerData.money.crypto,
        WalletId = Player.PlayerData.metadata["walletid"],
    }

    cb(CryptoData)
end)

rg.toiminnot.CreateCallback('crypto:server:BuyCrypto', function(source, cb, data)
    local Player = rg.toiminnot.GetPlayer(source)

    if Player.PlayerData.money.bank >= tonumber(data.Price) then
        local CryptoData = {
            History = Crypto.History["ELLAcoin"],
            Worth = Crypto.Worth["ELLAcoin"],
            Portfolio = Player.PlayerData.money.crypto + tonumber(data.Coins),
            WalletId = Player.PlayerData.metadata["walletid"],
        }
        Player.Functions.RemoveMoney('bank', tonumber(data.Price))
        TriggerClientEvent('phone:client:AddTransaction', source, Player, data, "You bought "..tonumber(data.Coins).." ELLAcoin('s)!", "Bijschrijving")
        Player.Functions.AddMoney('crypto', tonumber(data.Coins))
        cb(CryptoData)
    else
        cb(false)
    end
end)

rg.toiminnot.CreateCallback('crypto:server:SellCrypto', function(source, cb, data)
    local Player = rg.toiminnot.GetPlayer(source)

    if Player.PlayerData.money.crypto >= tonumber(data.Coins) then
        local CryptoData = {
            History = Crypto.History["ELLAcoin"],
            Worth = Crypto.Worth["ELLAcoin"],
            Portfolio = Player.PlayerData.money.crypto - tonumber(data.Coins),
            WalletId = Player.PlayerData.metadata["walletid"],
        }
        Player.Functions.RemoveMoney('crypto', tonumber(data.Coins))
        TriggerClientEvent('phone:client:AddTransaction', source, Player, data, "You sold "..tonumber(data.Coins).." ELLAcoin('s)!", "Afschrijving")
        Player.Functions.AddMoney('bank', tonumber(data.Price))
        cb(CryptoData)
    else
        cb(false)
    end
end)

rg.toiminnot.CreateCallback('crypto:server:TransferCrypto', function(source, cb, data)
    local Player = rg.toiminnot.GetPlayer(source)

    if Player.PlayerData.money.crypto >= tonumber(data.Coins) then
        rg.toiminnot.datasilta(false, "SELECT * FROM `players` WHERE `metadata` LIKE '%"..data.WalletId.."%'", function(result)
            if result[1] ~= nil then
                local CryptoData = {
                    History = Crypto.History["ELLAcoin"],
                    Worth = Crypto.Worth["ELLAcoin"],
                    Portfolio = Player.PlayerData.money.crypto - tonumber(data.Coins),
                    WalletId = Player.PlayerData.metadata["walletid"],
                }
                Player.Functions.RemoveMoney('crypto', tonumber(data.Coins))
                TriggerClientEvent('phone:client:AddTransaction', source, Player, data, "You transfered "..tonumber(data.Coins).." ELLAcoin('s)!", "Afschrijving")
                local Target = rg.toiminnot.GetPlayerByCitizenId(result[1].citizenid)

                if Target ~= nil then
                    Target.Functions.AddMoney('crypto', tonumber(data.Coins))
                    TriggerClientEvent('phone:client:AddTransaction', Target.PlayerData.source, Player, data, "There are "..tonumber(data.Coins).." ELLAcoin('s) credited!", "Bijschrijving")
                else
                    MoneyData = json.decode(result[1].money)
                    MoneyData.crypto = MoneyData.crypto + tonumber(data.Coins)
                    rg.toiminnot.datasilta(false, "UPDATE `players` SET `money` = '"..json.encode(MoneyData).."' WHERE `citizenid` = '"..result[1].citizenid.."'")
                end
                cb(CryptoData)
            else
                cb("notvalid")
            end
        end)
    else
        cb("notenough")
    end
end)