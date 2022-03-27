rg = nil
TriggerEvent("rg:HaeAsia", function(obj)
    rg = obj
end)

rg.toiminnot.CreateCallback("scoreboard:GetPlayers", function(source, cb)
    local players = {}
    for k, player in pairs(rg.toiminnot.GetPlayers()) do
        Player = rg.toiminnot.GetPlayer(player)
        if Player ~= nil then
            local charinfo = Player.PlayerData.charinfo
            players[k] = {
                ["name"] = GetPlayerName(player) ~= nil and GetPlayerName(player) or "Undefined",
                ["charName"] = ("%s %s"):format(charinfo.firstname, charinfo.lastname),
                ["id"] = player
            }
        end
    end
    cb(players)
end)
