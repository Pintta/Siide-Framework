rg = nil
TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)



rg.komennot.Add("shuff", "Switch from seats", {}, false, function(source, args)
    TriggerClientEvent('seatshuff:client:Shuff', source)
end)