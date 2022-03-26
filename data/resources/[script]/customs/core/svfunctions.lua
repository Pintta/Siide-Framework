function removePlayerCashMoney(playerId, amount)
    playerId = tonumber(playerId)
    amount = math.floor(tonumber(amount))
    
    if (not playerId or playerId < 1 or not GetPlayerName(playerId)) then return end
    if (not amount or amount <= 0) then return end

    if (not rg) then return end
    
    local rgPlayer = rg.toiminnot.GetPlayer(playerId)
    if (rgPlayer) then
        rgPlayer.Functions.RemoveMoney('cash', amount)
    end
end
