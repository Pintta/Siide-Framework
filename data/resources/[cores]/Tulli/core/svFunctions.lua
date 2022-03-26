rg.toiminnot = {}

rg.toiminnot.datasilta = function(wait, query, cb)
	local rtndata = {}
	local waiting = true
	exports['datasilta']:execute(query, {}, function(data)
		if cb ~= nil and wait == false then
			cb(data)
		end
		rtndata = data
		waiting = false
	end)
	if wait then
		while waiting do
			Citizen.Wait(5)
		end
		if cb ~= nil and wait == true then
			cb(rtndata)
		end
	end
	return rtndata
end

--rg.toiminnot.datasilta = function(wait, query, cb)
--	local rtndata = {}
--	local waiting = true
--	rg.toiminnot.datasilta(query, {}, function(data)
--		if cb ~= nil and wait == false then
--			cb(data)
--		end
--		rtndata = data
--		waiting = false
--	end)
--	if wait then
--		while waiting do
--			Citizen.Wait(5)
--		end
--		if cb ~= nil and wait == true then
--			cb(rtndata)
--		end
--	end
--	return rtndata
--end

rg.toiminnot.GetIdentifier = function(source, idtype)
	local idtype = idtype ~=nil and idtype or Asetus.IdentifierType
	for _, identifier in pairs(GetPlayerIdentifiers(source)) do
		if string.find(identifier, idtype) then
			return identifier
		end
	end
	return nil
end

rg.toiminnot.GetSource = function(identifier)
	for src, player in pairs(rg.Players) do
		local idens = GetPlayerIdentifiers(src)
		for _, id in pairs(idens) do
			if identifier == id then
				return src
			end
		end
	end
	return 0
end

rg.toiminnot.GetPlayer = function(source)
	if type(source) == "number" then
		return rg.Players[source]
	else
		return rg.Players[rg.toiminnot.GetSource(source)]
	end
end

rg.toiminnot.GetPlayerByCitizenId = function(citizenid)
	for src, player in pairs(rg.Players) do
		local cid = citizenid
		if rg.Players[src].PlayerData.citizenid == cid then
			return rg.Players[src]
		end
	end
	return nil
end

rg.toiminnot.GetPlayerByPhone = function(number)
	for src, player in pairs(rg.Players) do
		local cid = citizenid
		if rg.Players[src].PlayerData.charinfo.phone == number then
			return rg.Players[src]
		end
	end
	return nil
end

rg.toiminnot.GetPlayers = function()
	local sources = {}
	for k, v in pairs(rg.Players) do
		table.insert(sources, k)
	end
	return sources
end

rg.toiminnot.CreateCallback = function(name, cb)
	rg.takaisinhuuto[name] = cb
end

rg.toiminnot.HuutoKaiku = function(name, source, cb, ...)
	if rg.takaisinhuuto[name] ~= nil then
		rg.takaisinhuuto[name](source, cb, ...)
	end
end

rg.toiminnot.CreateUseableItem = function(item, cb)
	rg.UseableItems[item] = cb
end

rg.toiminnot.CanKaytaTuotetta = function(item)
	return rg.UseableItems[item] ~= nil
end

rg.toiminnot.KaytaTuotetta = function(source, item)
	rg.UseableItems[item.name](source, item)
end

rg.toiminnot.Kick = function(source, reason, setKickReason, deferrals)
	local src = source
	reason = "\n"..reason.."\n🔸 Liity kansalaisfoorumille "..rg.Asetus.Kaupunki.discord
	if(setKickReason ~=nil) then
		setKickReason(reason)
	end
	Citizen.CreateThread(function()
		if(deferrals ~= nil)then
			deferrals.update(reason)
			Citizen.Wait(2500)
		end
		if src ~= nil then
			DropPlayer(src, reason)
		end
		local i = 0
		while (i <= 4) do
			i = i + 1
			while true do
				if src ~= nil then
					if(GetPlayerPing(src) >= 0) then
						break
					end
					Citizen.Wait(100)
					Citizen.CreateThread(function() 
						DropPlayer(src, reason)
					end)
				end
			end
			Citizen.Wait(5000)
		end
	end)
end

rg.toiminnot.IsWhitelisted = function(source)
	local identifiers = GetPlayerIdentifiers(source)
	local rtn = false
	if (rg.Asetus.Kaupunki.whitelist) then
		rg.toiminnot.datasilta(true, "SELECT * FROM `whitelist` WHERE `"..rg.Asetus.IdentifierType.."` = '".. rg.toiminnot.GetIdentifier(source).."'", function(result)
			local data = result[1]
			if data ~= nil then
				for _, id in pairs(identifiers) do
					if data.steam == id or data.license == id then
						rtn = true
					end
				end
			end
		end)
	else
		rtn = true
	end
	return rtn
end

rg.toiminnot.AddPermission = function(source, permission)
	local Player = rg.toiminnot.GetPlayer(source)
	if Player ~= nil then 
		rg.Asetus.KaupunkiOikeudet[GetPlayerIdentifiers(source)[1]] = {
			steam = GetPlayerIdentifiers(source)[1],
			license = GetPlayerIdentifiers(source)[2],
			permission = permission:lower(),
		}
		rg.toiminnot.datasilta(true, "DELETE FROM `permissions` WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."'")
		rg.toiminnot.datasilta(true, "INSERT INTO `permissions` (`name`, `steam`, `license`, `permission`) VALUES ('"..GetPlayerName(source).."', '"..GetPlayerIdentifiers(source)[1].."', '"..GetPlayerIdentifiers(source)[2].."', '"..permission:lower().."')")
		Player.Functions.PaivitaPelaajaTtiedot()
		TriggerClientEvent('rg:Client:OnPermissionUpdate', source, permission)
	end
end

rg.toiminnot.RemovePermission = function(source)
	local Player = rg.toiminnot.GetPlayer(source)
	if Player ~= nil then 
		rg.Asetus.KaupunkiOikeudet[GetPlayerIdentifiers(source)[1]] = nil	
		rg.toiminnot.datasilta(true, "DELETE FROM `permissions` WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."'")
		Player.Functions.PaivitaPelaajaTtiedot()
	end
end

rg.toiminnot.HasPermission = function(source, permission)
	local retval = false
	local steamid = GetPlayerIdentifiers(source)[1]
	local licenseid = GetPlayerIdentifiers(source)[2]
	local permission = tostring(permission:lower())
	if permission == "user" then
		retval = true
	else
		if rg.Asetus.KaupunkiOikeudet[steamid] ~= nil then 
			if rg.Asetus.KaupunkiOikeudet[steamid].steam == steamid and rg.Asetus.KaupunkiOikeudet[steamid].license == licenseid then
				if rg.Asetus.KaupunkiOikeudet[steamid].permission == permission or rg.Asetus.KaupunkiOikeudet[steamid].permission == "god" then
					retval = true
				end
			end
		end
	end
	return retval
end

rg.toiminnot.GetPermission = function(source)
	local retval = "user"
	Player = rg.toiminnot.GetPlayer(source)
	local steamid = GetPlayerIdentifiers(source)[1]
	local licenseid = GetPlayerIdentifiers(source)[2]
	if Player ~= nil then
		if rg.Asetus.KaupunkiOikeudet[Player.PlayerData.steam] ~= nil then 
			if rg.Asetus.KaupunkiOikeudet[Player.PlayerData.steam].steam == steamid and rg.Asetus.KaupunkiOikeudet[Player.PlayerData.steam].license == licenseid then
				retval = rg.Asetus.KaupunkiOikeudet[Player.PlayerData.steam].permission
			end
		end
	end
	return retval
end

rg.toiminnot.IsOptin = function(source)
	local retval = false
	local steamid = GetPlayerIdentifiers(source)[1]
	if rg.toiminnot.HasPermission(source, "admin") then
		retval = rg.Asetus.KaupunkiOikeudet[steamid].optin
	end
	return retval
end

rg.toiminnot.ToggleOptin = function(source)
	local steamid = GetPlayerIdentifiers(source)[1]
	if rg.toiminnot.HasPermission(source, "admin") then
		rg.Asetus.KaupunkiOikeudet[steamid].optin = not rg.Asetus.KaupunkiOikeudet[steamid].optin
	end
end

rg.toiminnot.IsPlayerBanned = function (source)
	local retval = false
	local message = ""
	rg.toiminnot.datasilta(true, "SELECT * FROM `bans` WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."' OR `license` = '"..GetPlayerIdentifiers(source)[2].."' OR `ip` = '"..GetPlayerIdentifiers(source)[3].."'", function(result)
		if result[1] ~= nil then 
			if os.time() < result[1].expire then
				retval = true
				local timeTable = os.date("*t", tonumber(result[1].expire))
				message = "You were banned from the server:\n"..result[1].reason.."\nFalta : "..timeTable.day.. "/" .. timeTable.month .. "/" .. timeTable.year .. " " .. timeTable.hour.. ":" .. timeTable.min .. "\n"
			else
				rg.toiminnot.datasilta(true, "DELETE FROM `bans` WHERE `id` = "..result[1].id)
			end
		end
	end)
	return retval, message
end