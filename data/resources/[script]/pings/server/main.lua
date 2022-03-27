rg = nil
TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)



local Pings = {}

rg.komennot.Add("ping", "", {{name = "actie", help="id | accept | deny"}}, true, function(source, args)
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)
    local task = args[1]
    local PhoneItem = Player.Functions.GetItemByName("phone")

    if PhoneItem ~= nil then
        if task == "accept" then
            if Pings[src] ~= nil then
                TriggerClientEvent('pings:client:AcceptPing', src, Pings[src], rg.toiminnot.GetPlayer(Pings[src].sender))
                TriggerClientEvent('rg:Ilmoitus', Pings[src].sender, Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname.." accepted your ping!")
                Pings[src] = nil
            else
                TriggerClientEvent('rg:Ilmoitus', src, "You don't have a ping open..", "error")
            end
        elseif task == "deny" then
            if Pings[src] ~= nil then
                TriggerClientEvent('rg:Ilmoitus', Pings[src].sender, "Your ping has been rejected..", "error")
                TriggerClientEvent('rg:Ilmoitus', src, "Tiy rejected the ping..", "success")
                Pings[src] = nil
            else
                TriggerClientEvent('rg:Ilmoitus', src, "You don't have a ping open..", "error")
            end
        else
            TriggerClientEvent('pings:client:DoPing', src, tonumber(args[1]))
        end
    else
        TriggerClientEvent('rg:Ilmoitus', src, "You don't have a phone..", "error")
    end
end)

RegisterServerEvent('pings:server:SendPing')
AddEventHandler('pings:server:SendPing', function(id, coords)
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)
    local Target = rg.toiminnot.GetPlayer(id)
    local PhoneItem = Player.Functions.GetItemByName("phone")

    if PhoneItem ~= nil then
        if Target ~= nil then
            local OtherItem = Target.Functions.GetItemByName("phone")
            if OtherItem ~= nil then
                TriggerClientEvent('rg:Ilmoitus', src, "You sent a ping to "..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname)
                Pings[id] = {
                    coords = coords,
                    sender = src,
                }
                TriggerClientEvent('rg:Ilmoitus', id, "You recived a ping from "..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname..". /ping 'accept | deny'")
            else
                TriggerClientEvent('rg:Ilmoitus', src, "Could not send the ping, person may dont have a phone.", "error")
            end
        else
            TriggerClientEvent('rg:Ilmoitus', src, "This person is not online..", "error")
        end
    else
        TriggerClientEvent('rg:Ilmoitus', src, "You dont have a phone", "error")
    end
end)

RegisterServerEvent('pings:server:SendLocation')
AddEventHandler('pings:server:SendLocation', function(PingData, SenderData)
    TriggerClientEvent('pings:client:SendLocation', PingData.sender, PingData, SenderData)
end)