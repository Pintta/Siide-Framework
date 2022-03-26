RegisterServerEvent("rg:PlayerJoined")
AddEventHandler('rg:PlayerJoined', function()
	local src = source
end)

AddEventHandler('playerDropped', function(reason) 
	local src = source
	print("Poistui: "..GetPlayerName(src))
	TriggerEvent("logs:server:CreateLog", "joinleave", "Dropped", "red", "**".. GetPlayerName(src) .. "** ("..GetPlayerIdentifiers(src)[1]..") left..")
	TriggerEvent("logs:server:sendLog", GetPlayerIdentifiers(src)[1], "joined", {})
	if reason ~= "Reconnecting" and src > 60000 then return false end
	if(src==nil or (rg.Players[src] == nil)) then return false end
	rg.Players[src].Functions.Save()
	rg.Players[src] = nil
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
	deferrals.defer()
	local src = source
	deferrals.update("\nTarkistetaan viisumia...")
	local name = GetPlayerName(src)
	if name == nil then 
		rg.toiminnot.Kick(src, 'Korjaa viisumisi (Steam)', setKickReason, deferrals)
        CancelEvent()
        return false
	end
	if(string.match(name, "[*%%'=`\"]")) then
        rg.toiminnot.Kick(src, 'Sinun viisumissa on ongelmana: ('..string.match(name, "[*%%'=`\"]")..') nämä eivät ole sallittuja (steam)', setKickReason, deferrals)
        CancelEvent()
        return false
	end
	if (string.match(name, "drop") or string.match(name, "table") or string.match(name, "database")) then
        rg.toiminnot.Kick(src, 'Korjaa viisumisi kuntoon (Steam)', setKickReason, deferrals)
        CancelEvent()
        return false
	end
	deferrals.update("\nTarkistetaan identiteettiä..")
    local identifiers = GetPlayerIdentifiers(src)
	local steamid = identifiers[1]
	local license = identifiers[2]
    if (Asetus.IdentifierType == "steam" and (steamid:sub(1,6) == "steam:") == false) then
        rg.toiminnot.Kick(src, 'Tarvitset viisumin (Steam)', setKickReason, deferrals)
        CancelEvent()
		return false
	elseif (Asetus.IdentifierType == "license" and (steamid:sub(1,6) == "license:") == false) then
		rg.toiminnot.Kick(src, 'Tarvitset viisumin (Rockstar)', setKickReason, deferrals)
        CancelEvent()
		return false
    end
	deferrals.update("\nTarkistetaan pari juttua..")
    local isBanned, Reason = rg.toiminnot.IsPlayerBanned(src)
    if(isBanned) then
        rg.toiminnot.Kick(src, Reason, setKickReason, deferrals)
        CancelEvent()
        return false
    end
	deferrals.update("\nTarkistetaan veromaksuja..")
    if(not rg.toiminnot.IsWhitelisted(src)) then
        rg.toiminnot.Kick(src, 'Et ole veronmaksaja (Whitelist)', setKickReason, deferrals)
        CancelEvent()
        return false
    end
	deferrals.update("\nTarkistetaan jonoa..")
    if(rg.Asetus.Kaupunki.Suljettu and not IsPlayerAceAllowed(src, "admin.join")) then
		rg.toiminnot.Kick(_source, 'Kaupungissa on myrskyvaroitus\n'..rg.Asetus.Kaupunki.SuljettuSyy, setKickReason, deferrals)
        CancelEvent()
        return false
	end
	TriggerEvent("logs:server:CreateLog", "joinleave", "Queue", "orange", "**"..name .. "** ("..json.encode(GetPlayerIdentifiers(src))..") in queue..")
	TriggerEvent("logs:server:sendLog", GetPlayerIdentifiers(src)[1], "left", {})
	TriggerEvent("Tulli:playerConnect", src, setKickReason, deferrals)
end)

RegisterServerEvent("rg:server:CloseServer")
AddEventHandler('rg:server:CloseServer', function(reason)
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)
    if rg.toiminnot.HasPermission(source, "admin") or rg.toiminnot.HasPermission(source, "god") then 
        local reason = reason ~= nil and reason or "No specified motive..."
        rg.Asetus.Kaupunki.Suljettu = true
        rg.Asetus.Kaupunki.SuljettuSyy = reason
        TriggerClientEvent("admin:client:SetServerStatus", -1, true)
	else
		rg.toiminnot.Kick(src, "Älä yritä kusta muroihin..", nil, nil)
    end
end)

RegisterServerEvent("rg:server:OpenServer")
AddEventHandler('rg:server:OpenServer', function()
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)
    if rg.toiminnot.HasPermission(source, "admin") or rg.toiminnot.HasPermission(source, "god") then
        rg.Asetus.Kaupunki.Suljettu = false
        TriggerClientEvent("admin:client:SetServerStatus", -1, false)
    else
        rg.toiminnot.Kick(src, "Älä yritä kusta muroihin..", nil, nil)
    end
end)

RegisterServerEvent("rg:UpdatePlayer")
AddEventHandler('rg:UpdatePlayer', function(data)
	local src = source
	local Player = rg.toiminnot.GetPlayer(src)
	if Player ~= nil then
		Player.PlayerData.position = data.position
		local newHunger = Player.PlayerData.metadata["hunger"] - 4.2
		local newThirst = Player.PlayerData.metadata["thirst"] - 3.8
		if newHunger <= 0 then newHunger = 0 end
		if newThirst <= 0 then newThirst = 0 end
		Player.Functions.SetMetaData("thirst", newThirst)
		Player.Functions.SetMetaData("hunger", newHunger)
		Player.Functions.AddMoney("bank", Player.PlayerData.job.payment)
		TriggerClientEvent('rg:Ilmoitus', src, "Sait tilisiirron "..Player.PlayerData.job.payment)
		TriggerClientEvent("hud:client:UpdateNeeds", src, newHunger, newThirst)
		Player.Functions.Save()
	end
end)

RegisterServerEvent("rg:PaivitaPelaajanSijainti")
AddEventHandler("rg:PaivitaPelaajanSijainti", function(position)
	local src = source
	local Player = rg.toiminnot.GetPlayer(src)
	if Player ~= nil then
		Player.PlayerData.position = position
	end
end)

RegisterServerEvent("rg:Server:HuutoKaiku")
AddEventHandler('rg:Server:HuutoKaiku', function(name, ...)
	local src = source
	rg.toiminnot.HuutoKaiku(name, src, function(...)
		TriggerClientEvent("rg:Client:HuutoKaiku", src, name, ...)
	end, ...)
end)

RegisterServerEvent("rg:Server:KaytaTuotetta")
AddEventHandler('rg:Server:KaytaTuotetta', function(item)
	local src = source
	local Player = rg.toiminnot.GetPlayer(src)
	if item ~= nil and item.amount > 0 then
		if rg.toiminnot.CanKaytaTuotetta(item.name) then
			rg.toiminnot.KaytaTuotetta(src, item)
		end
	end
end)

RegisterServerEvent("rg:Server:RemoveItem")
AddEventHandler('rg:Server:RemoveItem', function(itemName, amount, slot)
	local src = source
	local Player = rg.toiminnot.GetPlayer(src)
	Player.Functions.RemoveItem(itemName, amount, slot)
end)

RegisterServerEvent("rg:Server:AddItem")
AddEventHandler('rg:Server:AddItem', function(itemName, amount, slot, info)
	local src = source
	local Player = rg.toiminnot.GetPlayer(src)
	Player.Functions.AddItem(itemName, amount, slot, info)
end)

RegisterServerEvent('rg:Server:SetMetaData')
AddEventHandler('rg:Server:SetMetaData', function(meta, data)
    local src = source
	local Player = rg.toiminnot.GetPlayer(src)
	if meta == "hunger" or meta == "thirst" then
		if data > 100 then
			data = 100
		end
	end
	if Player ~= nil then 
		Player.Functions.SetMetaData(meta, data)
	end
	TriggerClientEvent("hud:client:UpdateNeeds", src, Player.PlayerData.metadata["hunger"], Player.PlayerData.metadata["thirst"])
end)

AddEventHandler('chatMessage', function(source, n, message)
	if string.sub(message, 1, 1) == "/" then
		local args = rg.datapankki.SplitStr(message, " ")
		local command = string.gsub(args[1]:lower(), "/", "")
		CancelEvent()
		if rg.komennot.List[command] ~= nil then
			local Player = rg.toiminnot.GetPlayer(tonumber(source))
			if Player ~= nil then
				table.remove(args, 1)
				if (rg.toiminnot.HasPermission(source, "god") or rg.toiminnot.HasPermission(source, rg.komennot.List[command].permission)) then
					if (rg.komennot.List[command].argsrequired and #rg.komennot.List[command].arguments ~= 0 and args[#rg.komennot.List[command].arguments] == nil) then
					    TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Kaikki kohdat täytettävä..")
					    local agus = ""
					    for name, help in pairs(rg.komennot.List[command].arguments) do
					    	agus = agus .. " ["..help.name.."]"
					    end
				        TriggerClientEvent('chatMessage', source, "/"..command, false, agus)
					else
						rg.komennot.List[command].callback(source, args)
					end
				else
					TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Älä yritä kusta muroihin..")
				end
			end
		end
	end
end)

RegisterServerEvent('rg:CallCommand')
AddEventHandler('rg:CallCommand', function(command, args)
	if rg.komennot.List[command] ~= nil then
		local Player = rg.toiminnot.GetPlayer(tonumber(source))
		if Player ~= nil then
			if (rg.toiminnot.HasPermission(source, "god")) or (rg.toiminnot.HasPermission(source, rg.komennot.List[command].permission)) or (rg.komennot.List[command].permission == Player.PlayerData.job.name) then
				if (rg.komennot.List[command].argsrequired and #rg.komennot.List[command].arguments ~= 0 and args[#rg.komennot.List[command].arguments] == nil) then
					TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Kaikki kohdat täytettävä..")
					local agus = ""
					for name, help in pairs(rg.komennot.List[command].arguments) do
						agus = agus .. " ["..help.name.."]"
					end
					TriggerClientEvent('chatMessage', source, "/"..command, false, agus)
				else
					rg.komennot.List[command].callback(source, args)
				end
			else
				TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Älä yritä kusta muroihin..")
			end
		end
	end
end)

RegisterServerEvent("rg:AddCommand")
AddEventHandler('rg:AddCommand', function(name, help, arguments, argsrequired, callback, persmission)
	rg.komennot.Add(name, help, arguments, argsrequired, callback, persmission)
end)

RegisterServerEvent("rg:ToggleDuty")
AddEventHandler('rg:ToggleDuty', function()
	local src = source
	local Player = rg.toiminnot.GetPlayer(src)
	if Player.PlayerData.job.onduty then
		Player.Functions.SetJobDuty(false)
		TriggerClientEvent('rg:Ilmoitus', src, "Olet nyt vapaalla.")
	else
		Player.Functions.SetJobDuty(true)
		TriggerClientEvent('rg:Ilmoitus', src, "Olet nyt työvuorossa.")
	end
	TriggerClientEvent("rg:Client:SetDuty", src, Player.PlayerData.job.onduty)
end)

Citizen.CreateThread(function()
	rg.toiminnot.datasilta(true, "SELECT * FROM `permissions`", function(result)
		if result[1] ~= nil then
			for k, v in pairs(result) do
				rg.Asetus.KaupunkiOikeudet[v.steam] = {steam = v.steam, license = v.license, permission = v.permission, optin = true}
			end
		end
	end)
end)

rg.toiminnot.CreateCallback('rg:HasItem', function(source, cb, itemName)
	local retval = false
	local Player = rg.toiminnot.GetPlayer(source)
	if Player ~= nil then 
		if Player.Functions.GetItemByName(itemName) ~= nil then
			retval = true
		end
	end
	cb(retval)
end)	

RegisterServerEvent('rg:Command:CheckOwnedVehicle')
AddEventHandler('rg:Command:CheckOwnedVehicle', function(VehiclePlate)
	if VehiclePlate ~= nil then
		rg.toiminnot.datasilta(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..VehiclePlate.."'", function(result)
			if result[1] ~= nil then
				rg.toiminnot.datasilta(false, "UPDATE `player_vehicles` SET `state` = '1' WHERE `citizenid` = '"..result[1].citizenid.."'")
				TriggerEvent('garages:server:RemoveVehicle', result[1].citizenid, VehiclePlate)
			end
		end)
	end
end)