rg = nil

TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)



local Races = {}
RegisterServerEvent('streetraces:NewRace')
AddEventHandler('streetraces:NewRace', function(RaceTable)
    local src = source
    local RaceId = math.random(1000, 9999)
    local pelaaja = rg.toiminnot.GetPlayer(src)
    if pelaaja.Functions.RemoveMoney('cash', RaceTable.amount, "streetrace-created") then
        Races[RaceId] = RaceTable
        Races[RaceId].creator = GetPlayerIdentifiers(src)[1]
        table.insert(Races[RaceId].joined, GetPlayerIdentifiers(src)[1])
        TriggerClientEvent('streetraces:SetRace', -1, Races)
        TriggerClientEvent('streetraces:SetRaceId', src, RaceId)
        TriggerClientEvent('rg:Ilmoitus', src, "You joind the race for $"..Races[RaceId].amount..",-", 'success')
    end
end)

RegisterServerEvent('streetraces:RaceWon')
AddEventHandler('streetraces:RaceWon', function(RaceId)
    local src = source
    local pelaaja = rg.toiminnot.GetPlayer(src)
    pelaaja.Functions.AddMoney('cash', Races[RaceId].pot, "race-won")
    TriggerClientEvent('rg:Ilmoitus', src, "You won the race and $"..Races[RaceId].pot..",- recieved", 'success')
    TriggerClientEvent('streetraces:SetRace', -1, Races)
    TriggerClientEvent('streetraces:RaceDone', -1, RaceId, GetPlayerName(src))
end)

RegisterServerEvent('streetraces:JoinRace')
AddEventHandler('streetraces:JoinRace', function(RaceId)
    local src = source
    local pelaaja = rg.toiminnot.GetPlayer(src)
    local zPlayer = rg.toiminnot.GetPlayer(Races[RaceId].creator)
    if zPlayer ~= nil then
        if pelaaja.PlayerData.money.cash >= Races[RaceId].amount then
            Races[RaceId].pot = Races[RaceId].pot + Races[RaceId].amount
            table.insert(Races[RaceId].joined, GetPlayerIdentifiers(src)[1])
            if pelaaja.Functions.RemoveMoney('cash', Races[RaceId].amount, "streetrace-joined") then
                TriggerClientEvent('streetraces:SetRace', -1, Races)
                TriggerClientEvent('streetraces:SetRaceId', src, RaceId)
                TriggerClientEvent('rg:Ilmoitus', zPlayer.PlayerData.source, GetPlayerName(src).." Joined the race", 'primary')
            end
        else
            TriggerClientEvent('rg:Ilmoitus', src, "You dont have enough cash", 'error')
        end
    else
        TriggerClientEvent('rg:Ilmoitus', src, "The person wo made the race is offline!", 'error')
        Races[RaceId] = {}
    end
end)

rg.komennot.Add("race", "A street race has started.", {{name="bedrag", help="The stake amount for the race."}}, true, function(source, args)
    local src = source
    local pelaaja = rg.toiminnot.GetPlayer(src)
    local amount = tonumber(args[1])
    if GetJoinedRace(GetPlayerIdentifiers(src)[1]) == 0 then
        if pelaaja.PlayerData.money.cash >= amount then
            TriggerClientEvent('streetraces:CreateRace', src, amount)
        else
            TriggerClientEvent('rg:Ilmoitus', src, "You don't have enough cash in your pocket", 'error')
        end
    else
        TriggerClientEvent('rg:Ilmoitus', src, "Your already in a race!", 'error')
    end
end)

rg.komennot.Add("stoprace", "Stop a race as creator.", {}, false, function(source, args)
    local src = source
    CancelRace(src)
end)

rg.komennot.Add("quitrace", "Quiting the race. (You wont get ur money back)", {}, false, function(source, args)
    local src = source
    local pelaaja = rg.toiminnot.GetPlayer(src)
    local RaceId = GetJoinedRace(GetPlayerIdentifiers(src)[1])
    local zPlayer = rg.toiminnot.GetPlayer(Races[RaceId].creator)
    if RaceId ~= 0 then
        if GetCreatedRace(GetPlayerIdentifiers(src)[1]) ~= RaceId then
            RemoveFromRace(GetPlayerIdentifiers(src)[1])
            TriggerClientEvent('rg:Ilmoitus', src, "You quited the race and wont get ur money back", 'error')
            TriggerClientEvent('esx:showNotification', zPlayer.PlayerData.source, GetPlayerName(src) .." has quited the race!", "red")
        else
            TriggerClientEvent('rg:Ilmoitus', src, "/stoprace to stop the race", 'error')
        end
    else
        TriggerClientEvent('rg:Ilmoitus', src, "Your not in a race.", 'error')
    end
end)

rg.komennot.Add("startrace", "Starting race", {}, false, function(source, args)
    local src = source
    local RaceId = GetCreatedRace(GetPlayerIdentifiers(src)[1])
    
    if RaceId ~= 0 then
        Races[RaceId].started = true
        TriggerClientEvent('streetraces:SetRace', -1, Races)
        TriggerClientEvent("streetraces:StartRace", -1, RaceId)
    else
        TriggerClientEvent('rg:Ilmoitus', src, "You did not start a race", 'error')
    end
end)

function CancelRace(source)
    local pelaaja = rg.toiminnot.GetPlayer(source)
    local RaceId = GetCreatedRace(GetPlayerIdentifiers(source)[1])

    if RaceId ~= 0 then
        for key, race in pairs(Races) do
            if Races[key] ~= nil and Races[key].creator == pelaaja.PlayerData.steam then
                if not Races[key].started then
                    for _, iden in pairs(Races[key].joined) do
                        local xdPlayer = rg.toiminnot.GetPlayer(iden)
                        xdPlayer.Functions.AddMoney('cash', Races[key].amount, "race-cancelled")
                        TriggerClientEvent('rg:Ilmoitus', xdPlayer.PlayerData.source, "The race has stopped you recieved $"..Races[key].amount..",-Back", 'error')
                        TriggerClientEvent('streetraces:StopRace', xdPlayer.PlayerData.source)
                        RemoveFromRace(iden)
                    end
                else
                    TriggerClientEvent('rg:Ilmoitus', pelaaja.PlayerData.source, "The race has already started..", 'error')
                end
                TriggerClientEvent('rg:Ilmoitus', source, "Race has been stopped!", 'error')
                Races[key] = nil
            end
        end
        TriggerClientEvent('streetraces:SetRace', -1, Races)
    else
        TriggerClientEvent('rg:Ilmoitus', source, "You did not start a race!", 'error')
    end
end

function RemoveFromRace(identifier)
    for key, race in pairs(Races) do
        if Races[key] ~= nil and not Races[key].started then
            for i, iden in pairs(Races[key].joined) do
                if iden == identifier then
                    table.remove(Races[key].joined, i)
                end
            end
        end
    end
end

function GetJoinedRace(identifier)
    for key, race in pairs(Races) do
        if Races[key] ~= nil and not Races[key].started then
            for _, iden in pairs(Races[key].joined) do
                if iden == identifier then
                    return key
                end
            end
        end
    end
    return 0
end

function GetCreatedRace(identifier)
    for key, race in pairs(Races) do
        if Races[key] ~= nil and Races[key].creator == identifier and not Races[key].started then
            return key
        end
    end
    return 0
end
