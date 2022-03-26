rg = nil

TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)

RegisterServerEvent("KickForAFK")
AddEventHandler("KickForAFK", function()
	DropPlayer(source, "You got kicked, you were AFK too long.")
end)

rg.toiminnot.CreateCallback('afkkick:server:GetPermissions', function(source, cb)
    local group = rg.toiminnot.GetPermission(source)
    cb(group)
end)