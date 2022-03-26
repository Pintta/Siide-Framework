rg = nil
TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)

rg.komennot.Add("setlawyer", "Set someone as a lawyer", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = rg.toiminnot.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = rg.toiminnot.GetPlayer(playerId)
    if Player.PlayerData.job.name == "judge" then
        if OtherPlayer ~= nil then 
            local lawyerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
            }
            OtherPlayer.Functions.SetJob("lawyer")
            OtherPlayer.Functions.AddItem("lawyerpass", 1, false, lawyerInfo)
            TriggerClientEvent("rg:Ilmoitus", source, "You was" .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname .. " hired as a lawyer")
            TriggerClientEvent("rg:Ilmoitus", OtherPlayer.PlayerData.source, "Now you are a lawyer.")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, rg.datapankki.Items["lawyerpass"], "add")
        else
            TriggerClientEvent("rg:Ilmoitus", source, "This person is not present.", "error")
        end
    else
        TriggerClientEvent("rg:Ilmoitus", source, "You have no rights ...", "error")
    end
end)

rg.komennot.Add("removelawyer", "Remove someone as lawyer", {{name="id", help="id player"}}, true, function(source, args)
    local Player = rg.toiminnot.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = rg.toiminnot.GetPlayer(playerId)
    if Player.PlayerData.job.name == "judge" then
        if OtherPlayer ~= nil then 
            --OtherPlayer.Functions.SetJob("unemployed")
            TriggerClientEvent("rg:Ilmoitus", OtherPlayer.PlayerData.source, "You are now unemployed.")
            TriggerClientEvent("rg:Ilmoitus", source, "You were ".. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname .. " removed as a lawyer")
        else
            TriggerClientEvent("rg:Ilmoitus", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("rg:Ilmoitus", source, "You have no rights..", "error")
    end
end)

rg.toiminnot.CreateUseableItem("lawyerpass", function(source, item)
    local Player = rg.toiminnot.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("justice:client:showLawyerLicense", -1, source, item.info)
    end
end)