rg = nil
TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)

rg.komennot.Add("testrepair", "for testing the script", {}, false, function(source, args)
	local _player = rg.toiminnot.GetPlayer(source)
	if _player.PlayerData.job.name == "mechanic" then 
	TriggerClientEvent('ft-repair:client:triggerMenu', source)
	end
end)