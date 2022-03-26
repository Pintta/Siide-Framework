local ModelSpawned = false
local PlayingAnim = false
local CurrentLocation = nil
local playerPed = GetPlayerPed(-1)
local context = GetHashKey("MINI_PROSTITUTE_LOW_PASSENGER")

local Hookers = {
	{id = 1, VoiceName = "HOOKER_LEAVES_ANGRY", modelHash = "s_f_y_hooker_01", x = 128.65, y = -1055.36, z = 29.19, heading = 156.4},
	{id = 2, VoiceName = "HOOKER_LEAVES_ANGRY", modelHash = "s_f_y_hooker_01", x = 154.06, y = -1038.04, z = 29.32, heading = 1.37},
	{id = 3, VoiceName = "HOOKER_LEAVES_ANGRY", modelHash = "s_f_y_hooker_01", x = 324.3, y = -1073.97, z = 29.47, heading = 1.37}, 
	{id = 4, VoiceName = "HOOKER_LEAVES_ANGRY", modelHash = "s_f_y_hooker_01", x = 419.05, y = -987.09, z = 29.38, heading = 57.12},
	{id = 5, VoiceName = "HOOKER_LEAVES_ANGRY", modelHash = "s_f_y_hooker_01", x = 419.27, y = -985.64, z = 29.4, heading = 57.12},
	{id = 6, VoiceName = "HOOKER_LEAVES_ANGRY", modelHash = "s_f_y_hooker_01", x = 391.09, y = -909.32, z = 29.42, heading = 1.37},
	{id = 7, VoiceName = "HOOKER_LEAVES_ANGRY", modelHash = "a_f_y_rurmeth_01", x = 359.04, y = -586.48, z = 28.81, heading = 200.37},
	{id = 8, VoiceName = "HOOKER_LEAVES_ANGRY", modelHash = "a_f_y_rurmeth_01", x = 359.75, y = -585.06, z = 28.82, heading = 215.37},
}

local locations = {
	[1] = {name = "Henkilö #1", pos = {x = 129.63, y = -1060.41, z = 29.19}, size = 1.0},
	[2] = {name = "Henkilö #2", pos = {x = 154.06, y = -1038.04, z = 29.32}, size = 1.0},
	[3] = {name = "Henkilö #3", pos = {x = 324.30, y = -1073.97, z = 29.47}, size = 1.0},
	[4] = {name = "Henkilö #4", pos = {x = 419.05, y = -987.09, z = 29.38}, size = 1.0},
	[5] = {name = "Henkilö #5", pos = {x = 419.27, y = -985.64, z = 29.4}, size = 1.0},
	[6] = {name = "Henkilö #6", pos = {x = 391.09, y = -909.32, z = 29.42}, size = 1.0},
	[7] = {name = "Henkilö #7", pos = {x = 359.04, y = -586.48, z = 28.81}, size = 1.0},
	[8] = {name = "Henkilö #8", pos = {x = 359.75, y = -585.06, z = 28.82}, size = 1.0},
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		coords = GetEntityCoords(playerPed)
		for k,v in pairs(locations) do
			if GetDistanceBetweenCoords(coords, v.pos.x, v.pos.y, v.pos.z, true) < v.size then
				CurrentLocation = v
				break
			else
				CurrentLocation = nil
			end
		end
	end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
	if (not ModelSpawned) then
		for i=1, #Hookers do
			RequestModel(GetHashKey(Hookers[i].modelHash))
        	while not HasModelLoaded(GetHashKey(Hookers[i].modelHash)) do
          	Citizen.Wait(0)
        	end
			SpawnedPed = CreatePed(2, Hookers[i].modelHash, Hookers[i].x, Hookers[i].y, Hookers[i].z, Hookers[i].heading, true, true)
			ModelSpawned = true
			TaskSetBlockingOfNonTemporaryEvents(SpawnedPed, true)
			Citizen.Wait(1)
			TaskStartScenarioInPlace(SpawnedPed, "WORLD_HUMAN_SMOKING", 0, false)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CurrentLocation ~= nil then
			SetTextComponentFormat('STRING')
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustPressed(0,51) then
				TaskEnterVehicle(SpawnedPed, GetVehiclePedIsIn(playerPed, false), -1, 0, 1.0, 1, 0)
			end
		end
	end
end)

RegisterCommand("bj", function(source, args, raw)
	TriggerEvent("hookers:client:blowjob") 
end, false)

RegisterCommand("ulos", function(source, args, raw)
	TriggerEvent("hookers:client:sendhookerhome") 
end, false)

RegisterCommand("sex", function(source, args, raw)
	TriggerEvent("hookers:client:havesex") 
end, false)

RegisterNetEvent("blowjob")
AddEventHandler("hookers:client:blowjob", function(inputText)
	RequestAnimDict("misscarsteal2pimpsex")
	while (not HasAnimDictLoaded("misscarsteal2pimpsex")) do 
	Citizen.Wait(10)
	end
	TaskPlayAnim(SpawnedPed,"misscarsteal2pimpsex","pimpsex_hooker", 1.0, -1.0, 30000, 1, 1, true, true, true)
	TaskPlayAnim(playerPed,"amb@world_human_stand_fire@male@idle_a","idle_c", 1.0, -1.0, 30000, 1, 1, true, true, true) 
end)

RegisterNetEvent("havesex")
AddEventHandler("hookers:client:havesex", function(inputText)
	RequestAnimDict("mini@prostitutes@sexlow_veh")
	while (not HasAnimDictLoaded("mini@prostitutes@sexlow_veh")) do 
	Citizen.Wait(0)
	end
	TaskPlayAnim(SpawnedPed,"mini@prostitutes@sexlow_veh","low_car_sex_loop_female", 1.0, -1.0, 25000, 0, 1, true, true, true)
	TaskPlayAnim(playerPed,"amb@world_human_stand_fire@male@idle_a","lidle_a", 1.0, -1.0, 25000, 0, 1, true, true, true)
end)

RegisterNetEvent("hookers:client:sendhookerhome")
AddEventHandler("hookers:client:sendhookerhome", function(inputText)
	TaskLeaveVehicle(SpawnedPed, vehicle, 0)
end)

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(1000)
		if IsEntityDead(SpawnedPed) then
			SpawnedPed = CreatePed(2, "s_f_y_hooker_01", 128.65, -1055.36, 29.19, 156.4, true, true)
			TaskSetBlockingOfNonTemporaryEvents(SpawnedPed, true)
			Citizen.Wait(1)
			TaskStartScenarioInPlace(SpawnedPed, "WORLD_HUMAN_SMOKING", 0, false)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(1000)
		if IsEntityDead(SpawnedPed) then
			SpawnedPed = CreatePed(2, "s_f_y_hooker_01", 154.06, -1038.04, 29.32, 1.37, true, true)
			TaskSetBlockingOfNonTemporaryEvents(SpawnedPed, true)
			Citizen.Wait(1)
			TaskStartScenarioInPlace(SpawnedPed, "WORLD_HUMAN_SMOKING", 0, false)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(1000)
		if IsEntityDead(SpawnedPed) then
			SpawnedPed = CreatePed(2, "s_f_y_hooker_01", 324.3, -1073.97, 29.47, 1.37, true, true)
			TaskSetBlockingOfNonTemporaryEvents(SpawnedPed, true)
			Citizen.Wait(1)
			TaskStartScenarioInPlace(SpawnedPed, "WORLD_HUMAN_SMOKING", 0, false)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(1000)
		if IsEntityDead(SpawnedPed) then
			SpawnedPed = CreatePed(2, "s_f_y_hooker_01", 419.05, -987.09, 29.38, 57.12, true, true)
			TaskSetBlockingOfNonTemporaryEvents(SpawnedPed, true)
			Citizen.Wait(1)
			TaskStartScenarioInPlace(SpawnedPed, "WORLD_HUMAN_SMOKING", 0, false)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(1000)
		if IsEntityDead(SpawnedPed) then
			SpawnedPed = CreatePed(2, "s_f_y_hooker_01", 419.27, -985.64, 29.4, 57.12, true, true)
			TaskSetBlockingOfNonTemporaryEvents(SpawnedPed, true)
			Citizen.Wait(1)
			TaskStartScenarioInPlace(SpawnedPed, "WORLD_HUMAN_SMOKING", 0, false)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(1000)
		if IsEntityDead(SpawnedPed) then
			SpawnedPed = CreatePed(2, "s_f_y_hooker_01", 391.09, -909.32, 29.42, 1.37, true, true)
			TaskSetBlockingOfNonTemporaryEvents(SpawnedPed, true)
			Citizen.Wait(1)
			TaskStartScenarioInPlace(SpawnedPed, "WORLD_HUMAN_SMOKING", 0, false)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(1000)
		if IsEntityDead(SpawnedPed) then
			SpawnedPed = CreatePed(2, "a_f_y_rurmeth_01", 359.04, -586.48, 28.81, 200.37, true, true)
			TaskSetBlockingOfNonTemporaryEvents(SpawnedPed, true)
			Citizen.Wait(1)
			TaskStartScenarioInPlace(SpawnedPed, "WORLD_HUMAN_SMOKING", 0, false)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(1000)
		if IsEntityDead(SpawnedPed) then
			SpawnedPed = CreatePed(2, "a_f_y_rurmeth_01", 359.75, -585.06, 28.82, 215.37, true, true)
			TaskSetBlockingOfNonTemporaryEvents(SpawnedPed, true)
			Citizen.Wait(1)
			TaskStartScenarioInPlace(SpawnedPed, "WORLD_HUMAN_SMOKING", 0, false)
		end
	end
end)