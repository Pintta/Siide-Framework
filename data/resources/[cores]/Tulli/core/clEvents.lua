RegisterNetEvent('rg:Command:MenePelaajanSijaintiin')
AddEventHandler('rg:Command:MenePelaajanSijaintiin', function(othersource)
    local coords = rg.toiminnot.GetCoords(GetPlayerPed(GetPlayerFromServerId(othersource)))
    local entity = GetPlayerPed(-1)
    if IsPedInAnyVehicle(entity, false) then
        entity = GetVehiclePedIsUsing(entity)
    end
    SetEntityCoords(entity, coords.x, coords.y, coords.z)
    SetEntityHeading(entity, coords.a)
end) 

RegisterNetEvent('rg:Command:MeneSijaintiin')
AddEventHandler('rg:Command:MeneSijaintiin', function(x, y, z)
    local entity = GetPlayerPed(-1)
    if IsPedInAnyVehicle(entity, false) then
        entity = GetVehiclePedIsUsing(entity)
    end
    SetEntityCoords(entity, x, y, z)
end) 

RegisterNetEvent('rg:Command:HaeAjoneuvo')
AddEventHandler('rg:Command:HaeAjoneuvo', function(model)
	rg.toiminnot.HaeAjoneuvo(model, function(vehicle)
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
		TriggerEvent("vehiclekeys:client:AsetaOmistaja", GetVehicleNumberPlateText(vehicle))
	end)
end)

RegisterNetEvent('rg:Command:DeleteVehicle')
AddEventHandler('rg:Command:DeleteVehicle', function()
	local vehicle = rg.toiminnot.GetClosestVehicle()
	if IsPedInAnyVehicle(GetPlayerPed(-1)) then vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false) else vehicle = rg.toiminnot.GetClosestVehicle() end
	rg.toiminnot.DeleteVehicle(vehicle)
end)

RegisterNetEvent('rg:Command:Revive')
AddEventHandler('rg:Command:Revive', function()
	local coords = rg.toiminnot.GetCoords(GetPlayerPed(-1))
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z+0.2, coords.a, true, false)
	SetPlayerInvincible(GetPlayerPed(-1), false)
	ClearPedBloodDamage(GetPlayerPed(-1))
end)

RegisterNetEvent('rg:Command:MeneMerkille')
AddEventHandler('rg:Command:MeneMerkille', function()
	Citizen.CreateThread(function()
		local entity = PlayerPedId()
		if IsPedInAnyVehicle(entity, false) then
			entity = GetVehiclePedIsUsing(entity)
		end
		local success = false
		local blipFound = false
		local blipIterator = GetBlipInfoIdIterator()
		local blip = GetFirstBlipInfoId(8)
		while DoesBlipExist(blip) do
			if GetBlipInfoIdType(blip) == 4 then
				cx, cy, cz = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ReturnResultAnyway(), Citizen.ResultAsVector()))
				blipFound = true
				break
			end
			blip = GetNextBlipInfoId(blipIterator)
		end
		if blipFound then
			DoScreenFadeOut(250)
			while IsScreenFadedOut() do
				Citizen.Wait(250)
			end
			local groundFound = false
			local yaw = GetEntityHeading(entity)
			for i = 0, 1000, 1 do
				SetEntityCoordsNoOffset(entity, cx, cy, ToFloat(i), false, false, false)
				SetEntityRotation(entity, 0, 0, 0, 0 ,0)
				SetEntityHeading(entity, yaw)
				SetGameplayCamRelativeHeading(0)
				Citizen.Wait(0)
				if GetGroundZFor_3dCoord(cx, cy, ToFloat(i), cz, false) then
					cz = ToFloat(i)
					groundFound = true
					break
				end
			end
			if not groundFound then
				cz = -300.0
			end
			success = true
		end
		if success then
			SetEntityCoordsNoOffset(entity, cx, cy, cz, false, false, true)
			SetGameplayCamRelativeHeading(0)
			if IsPedSittingInAnyVehicle(PlayerPedId()) then
				if GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() then
					SetVehicleOnGroundProperly(GetVehiclePedIsUsing(PlayerPedId()))
				end
			end
			DoScreenFadeIn(250)
		end
	end)
end)

RegisterNetEvent('rg:Player:AsetaPelaajantiedot')
AddEventHandler('rg:Player:AsetaPelaajantiedot', function(val)
	rg.pelaajatiedot = val
end)

RegisterNetEvent('rg:Player:PaivitaPelaajaTtiedot')
AddEventHandler('rg:Player:PaivitaPelaajaTtiedot', function()
	local data = {}
	data.position = rg.toiminnot.GetCoords(GetPlayerPed(-1))
	TriggerServerEvent('rg:UpdatePlayer', data)
end)

RegisterNetEvent('rg:Player:PaivitaPelaajanSijainti')
AddEventHandler('rg:Player:PaivitaPelaajanSijainti', function()
	local position = rg.toiminnot.GetCoords(GetPlayerPed(-1))
	TriggerServerEvent('rg:PaivitaPelaajanSijainti', position)
end)

RegisterNetEvent('rg:Client:PaikallinenOOC')
AddEventHandler('rg:Client:PaikallinenOOC', function(playerId, playerName, message)
	local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerId)), false)
    local pos = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 20.0) then
		TriggerEvent("chatMessage", "OOC " .. playerName, "normal", message)
    end
end)

RegisterNetEvent('rg:Ilmoitus')
AddEventHandler('rg:Ilmoitus', function(text, type, length)
	rg.toiminnot.Notify(text, type, length)
end)

RegisterNetEvent('rg:Client:HuutoKaiku')
AddEventHandler('rg:Client:HuutoKaiku', function(name, ...)
	if rg.takaisinhuuto[name] ~= nil then
		rg.takaisinhuuto[name](...)
		rg.takaisinhuuto[name] = nil
	end
end)

RegisterNetEvent("rg:Client:KaytaTuotetta")
AddEventHandler('rg:Client:KaytaTuotetta', function(item)
	TriggerServerEvent("rg:Server:KaytaTuotetta", item)
end)