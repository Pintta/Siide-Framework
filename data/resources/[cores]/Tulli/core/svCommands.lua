rg.komennot = {}
rg.komennot.List = {}

rg.komennot.Add = function(name, help, arguments, argsrequired, callback, permission)
	rg.komennot.List[name:lower()] = {
		name = name:lower(),
		permission = permission ~= nil and permission:lower() or "user",
		help = help,
		arguments = arguments,
		argsrequired = argsrequired,
		callback = callback,
	}
end

rg.komennot.Refresh = function(source)
	local Player = rg.toiminnot.GetPlayer(tonumber(source))
	if Player ~= nil then
		for command, info in pairs(rg.komennot.List) do
			if rg.toiminnot.HasPermission(source, "god") or rg.toiminnot.HasPermission(source, rg.komennot.List[command].permission) then
				TriggerClientEvent('chat:addSuggestion', source, "/"..command, info.help, info.arguments)
			end
		end
	end
end

rg.komennot.Add("tp", "Teleport to a player or location", {{name="id/x", help="ID of a player or X position"}, {name="y", help="Y position"}, {name="z", help="Z position"}}, false, function(source, args)
    if (args[1] ~= nil and (args[2] == nil and args[3] == nil)) then
        local Player = rg.toiminnot.GetPlayer(tonumber(args[1]))
        if Player ~= nil then
            TriggerClientEvent('rg:Command:MenePelaajanSijaintiin', source, Player.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Henkilö ei ole kaupungissa..")
        end
    else
        if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
            local x = tonumber(args[1])
            local y = tonumber(args[2])
            local z = tonumber(args[3])
            TriggerClientEvent('rg:Command:MeneSijaintiin', source, x, y, z)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Not every argument is filled in (x, y, z)")
        end
    end
end, "admin") 

rg.komennot.Add("giveperms", "Grant permissions to someone (god/admin)", {{name="id", help="ID of player"}, {name="permission", help="Permission level"}}, true, function(source, args)
	local Player = rg.toiminnot.GetPlayer(tonumber(args[1]))
	local permission = tostring(args[2]):lower()
	if Player ~= nil then
		rg.toiminnot.AddPermission(Player.PlayerData.source, permission)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "The Henkilö ei ole kaupungissa..")	
	end
end, "god")

rg.komennot.Add("removeperms", "Remove someone's permissions", {{name="id", help="ID of player"}}, true, function(source, args)
	local Player = rg.toiminnot.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		rg.toiminnot.RemovePermission(Player.PlayerData.source)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "The Henkilö ei ole kaupungissa..")	
	end
end, "god")

rg.komennot.Add("car", "Spawn a car", {{name="model", help="Car model"}}, true, function(source, args)
	TriggerClientEvent('rg:Command:HaeAjoneuvo', source, args[1])
end, "admin")

rg.komennot.Add("debug", "Enable / disable debug mode", {}, false, function(source, args)
	TriggerClientEvent('koil-debug:toggle', source)
end, "admin")

rg.komennot.Add("dv", "Despawn a vehicle", {}, false, function(source, args)
	TriggerClientEvent('rg:Command:DeleteVehicle', source)
end, "admin")

rg.komennot.Add("tpm", "Teleport to marker", {}, false, function(source, args)
	TriggerClientEvent('rg:Command:MeneMerkille', source)
end, "admin")

rg.komennot.Add("givemoney", "Give money to a player", {{name="id", help="Player ID"},{name="moneytype", help="Type of money (cash, bank, crypto)"}, {name="amount", help="Amount of money"}}, true, function(source, args)
	local Player = rg.toiminnot.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.AddMoney(tostring(args[2]), tonumber(args[3]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "The Henkilö ei ole kaupungissa..")
	end
end, "admin")

rg.komennot.Add("setmoney", "set a players money amount", {{name="id", help="Player ID"},{name="moneytype", help="Type of money (cash, bank, crypto)"}, {name="amount", help="Amount of money"}}, true, function(source, args)
	local Player = rg.toiminnot.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.SetMoney(tostring(args[2]), tonumber(args[3]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Henkilö ei ole kaupungissa..")
	end
end, "admin")

rg.komennot.Add("setjob", "Assign a job to a player", {{name="id", help="Henkilön ID"}, {name="job", help="Name of a job"}, {name="grade", help="Set Grade"}}, true, function(source, args)
	local Player = rg.toiminnot.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.SetJob(tostring(args[2]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Henkilö ei ole kaupungissa..")
	end
end, "admin")

rg.komennot.Add("arikol", "Assign a player to a gang", {{name="id", help="Henkilön ID"}, {name="job", help="Rikollisjärjestö"}, {name="grade", help="Arvo"}}, true, function(source, args)
	local Player = rg.toiminnot.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.AsetaRikollinen(tostring(args[2]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Henkilö ei ole kaupungissa..")
	end
end, "admin")

rg.komennot.Add("work", "See what work do you have", {}, false, function(source, args)
	local Player = rg.toiminnot.GetPlayer(source)
	if Player.PlayerData.job.name ~= "unemployed" then
		TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Työpaikka: "..Player.PlayerData.job.name)
	else
		TriggerClientEvent('rg:Ilmoitus', source, "Et ole töissä", "error")
	end
end)

rg.komennot.Add("katsor", "See in which gang you are", {}, false, function(source, args)
	local Player = rg.toiminnot.GetPlayer(source)
	if Player.PlayerData.rikollinen.name ~= "geen" then
		TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Liiga: "..Player.PlayerData.rikollinen.label)
	else
		TriggerClientEvent('rg:Ilmoitus', source, "Et kuulu mihinkään järjestöön", "error")
	end
end)

rg.komennot.Add("testnotify", "test notify", {{name="text", help="Tekst enzo"}}, true, function(source, args)
	TriggerClientEvent('rg:Ilmoitus', source, table.concat(args, " "), "success")
end, "god")

rg.komennot.Add("clearinv", "Clean a player's inventory", {{name="id", help="Player ID"}}, false, function(source, args)
	local playerId = args[1] ~= nil and args[1] or source 
	local Player = rg.toiminnot.GetPlayer(tonumber(playerId))
	if Player ~= nil then
		Player.Functions.ClearInventory()
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Henkilö ei ole kaupungissa..")
	end
end, "admin")

rg.komennot.Add("ooc", "Message Out Of Character", {}, false, function(source, args)
	local message = table.concat(args, " ")
	TriggerClientEvent("rg:Client:PaikallinenOOC", -1, source, GetPlayerName(source), message)
	local Players = rg.toiminnot.GetPlayers()
	local Player = rg.toiminnot.GetPlayer(source)
	for k, v in pairs(rg.toiminnot.GetPlayers()) do
		if rg.toiminnot.HasPermission(v, "admin") then
			if rg.toiminnot.IsOptin(v) then
				TriggerClientEvent('chatMessage', v, "OOC " .. GetPlayerName(source), "normal", message)
				TriggerEvent("logs:server:CreateLog", "ooc", "OOC", "white", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Message:** " ..message, false)
			end
		end
	end
end)