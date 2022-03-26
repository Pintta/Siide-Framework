rg = nil
TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)



rg.komennot.Add("binds", "Open bind menu", {}, false, function(source, args)
    local Player = rg.toiminnot.GetPlayer(source)
	TriggerClientEvent("commandbinding:client:openUI", source)
end)

RegisterServerEvent('commandbinding:server:setKeyMeta')
AddEventHandler('commandbinding:server:setKeyMeta', function(keyMeta)
    local src = source
    local ply = rg.toiminnot.GetPlayer(src)

    ply.Functions.SetMetaData("commandbinds", keyMeta)
end)