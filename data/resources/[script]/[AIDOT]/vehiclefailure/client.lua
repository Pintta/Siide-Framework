rg = nil

local pedInSameVehicleLast=false
local vehicle
local lastVehicle
local vehicleClass
local fCollisionDamageMult = 0.0
local fDeformationDamageMult = 0.0
local fEngineDamageMult = 0.0
local fBrakeForce = 1.0
local isBrakingForward = false
local isBrakingReverse = false
local healthEngineLast = 1000.0
local healthEngineCurrent = 1000.0
local healthEngineNew = 1000.0
local healthEngineDelta = 0.0
local healthEngineDeltaScaled = 0.0
local healthBodyLast = 1000.0
local healthBodyCurrent = 1000.0
local healthBodyNew = 1000.0
local healthBodyDelta = 0.0
local healthBodyDeltaScaled = 0.0
local healthPetrolTankLast = 1000.0
local healthPetrolTankCurrent = 1000.0
local healthPetrolTankNew = 1000.0
local healthPetrolTankDelta = 0.0
local healthPetrolTankDeltaScaled = 0.0
local tireBurstLuckyNumber
local showPro = false

math.randomseed(GetGameTimer());

local tireBurstMaxNumber = cfg.randomTireBurstInterval * 1200;

if cfg.randomTireBurstInterval ~= 0 then 
	tireBurstLuckyNumber = math.random(tireBurstMaxNumber)
end

local fixMessagePos = math.random(repairCfg.fixMessageCount)
local noFixMessagePos = math.random(repairCfg.noFixMessageCount)

Citizen.CreateThread(function()
	while rg == nil do
		TriggerEvent("rg:HaeAsia", function(obj) rg = obj end)   
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	if (cfg.displayBlips == true) then
		for _, item in pairs(repairCfg.mechanics) do
			item.blip = AddBlipForCoord(item.x, item.y, item.z)
			SetBlipSprite(item.blip, item.id)
			SetBlipScale(item.blip, 0.8)
			SetBlipAsShortRange(item.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(item.name)
			EndTextCommandSetBlipName(item.blip)
		end
	end
end)

RegisterNetEvent('vehiclefailure:client:RepairVehicle')
AddEventHandler('vehiclefailure:client:RepairVehicle', function()
	local vehicle = rg.toiminnot.GetClosestVehicle()
	if vehicle ~= nil and vehicle ~= 0 then
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local vehpos = GetEntityCoords(vehicle)
		if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 5.0) and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
			local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
			if (IsBackEngine(GetEntityModel(vehicle))) then
				drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
			end
			if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, drawpos) < 2.0) and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
				RepairVehicle(vehicle)
			else
				ShowEnginePos = true
			end
		end
	end
end)

RegisterNetEvent('vehiclefailure:client:RepairVehicleFull')
AddEventHandler('vehiclefailure:client:RepairVehicleFull', function()
	local vehicle = rg.toiminnot.GetClosestVehicle()
	if vehicle ~= nil and vehicle ~= 0 then
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local vehpos = GetEntityCoords(vehicle)
		if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 5.0) and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
			local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
			if (IsBackEngine(GetEntityModel(vehicle))) then
				drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
			end
			if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, drawpos) < 2.0) and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
				RepairVehicleFull(vehicle)
			else
				ShowEnginePos = true
			end
		end
	end
end)

function CleanVehicle(vehicle)
	local ped = GetPlayerPed(-1)
	local pos = GetEntityCoords(ped)
	TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_MAID_CLEAN", 0, true)
	print('deu')
	rg.toiminnot.Progressbar("repair_vehicle", "PUTSAAT..", math.random(10000, 20000), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function()
		rg.toiminnot.Notify("Valmis.")
		SetVehicleDirtLevel(vehicle, 0.1)
        SetVehicleUndriveable(vehicle, false)
		WashDecalsFromVehicle(vehicle, 1.0)
		TriggerServerEvent('vehiclefailure:server:removewashingkit', vehicle)
		TriggerEvent('inventory:client:ItemBox', rg.datapankki.Items["cleaningkit"], "remove")
		ClearAllPedProps(GetPlayerPed(-1))
		ClearPedTasks(GetPlayerPed(-1))
	end, function()
		rg.toiminnot.Notify("No voi vittu..", "error")
		ClearAllPedProps(GetPlayerPed(-1))
		ClearPedTasks(GetPlayerPed(-1))
	end)
end

RegisterNetEvent('vehiclefailure:client:SyncWash')
AddEventHandler('vehiclefailure:client:SyncWash', function(veh)
	SetVehicleDirtLevel(veh, 0.1)
	SetVehicleUndriveable(veh, false)
	WashDecalsFromVehicle(veh, 1.0)
end)

RegisterNetEvent('vehiclefailure:client:CleanVehicle')
AddEventHandler('vehiclefailure:client:CleanVehicle', function()
	local vehicle = rg.toiminnot.GetClosestVehicle()
	if vehicle ~= nil and vehicle ~= 0 then
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local vehpos = GetEntityCoords(vehicle)
		if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 3.0) and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
			CleanVehicle(vehicle)	
		end
	end
end)

function RepairVehicleFull(vehicle)
	if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorOpen(vehicle, 5, false, false)
    else
        SetVehicleDoorOpen(vehicle, 4, false, false)
	end
	print('deu')
	rg.toiminnot.Progressbar("repair_vehicle", "KORJAAT..", math.random(20000, 30000), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function()
		StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
		rg.toiminnot.Notify("Valmis.")
		SetVehicleEngineHealth(vehicle, 1000.0)
		if (IsBackEngine(GetEntityModel(vehicle))) then
			SetVehicleDoorShut(vehicle, 5, false)
		else
			SetVehicleDoorShut(vehicle, 4, false)
		end
		TriggerServerEvent('vehiclefailure:removeItem', "advancedrepairkit")
	end, function()
		StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
		rg.toiminnot.Notify("No voi vittu..", "error")
		if (IsBackEngine(GetEntityModel(vehicle))) then
			SetVehicleDoorShut(vehicle, 5, false)
		else
			SetVehicleDoorShut(vehicle, 4, false)
		end
	end)
end

function RepairVehicle(vehicle)
	if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorOpen(vehicle, 5, false, false)
    else
        SetVehicleDoorOpen(vehicle, 4, false, false)
	end
	print('deu')
	rg.toiminnot.Progressbar("repair_vehicle", "KORJAAT..", math.random(10000, 20000), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function()
		StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
		rg.toiminnot.Notify("Valmis.")
		SetVehicleEngineHealth(vehicle, 1000.0)
		if (IsBackEngine(GetEntityModel(vehicle))) then
			SetVehicleDoorShut(vehicle, 5, false)
		else
			SetVehicleDoorShut(vehicle, 4, false)
		end
		TriggerServerEvent('vehiclefailure:removeItem', "repairkit")
	end, function()
		StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
		rg.toiminnot.Notify("No voi vittu..", "error")
		if (IsBackEngine(GetEntityModel(vehicle))) then
			SetVehicleDoorShut(vehicle, 5, false)
		else
			SetVehicleDoorShut(vehicle, 4, false)
		end
	end)
end

function IsBackEngine(vehModel)
    for _, model in pairs(BackEngineVehicles) do
        if GetHashKey(model) == vehModel then
            return true
        end
    end
    return false
end

local function notification(msg)
	rg.toiminnot.Notify(msg)
end

local function isPedDrivingAVehicle()
	local ped = GetPlayerPed(-1)
	vehicle = GetVehiclePedIsIn(ped, false)
	if IsPedInAnyVehicle(ped, false) then
		if GetPedInVehicleSeat(vehicle, -1) == ped then
			local class = GetVehicleClass(vehicle)
			if class ~= 21 and class ~= 13 then
				return true
			end
		end
	end
	return false
end

local function IsNearMechanic()
	local ped = GetPlayerPed(-1)
	local pedLocation = GetEntityCoords(ped, 0)
	for _, item in pairs(repairCfg.mechanics) do
		local distance = GetDistanceBetweenCoords(item.x, item.y, item.z,  pedLocation["x"], pedLocation["y"], pedLocation["z"], true)
		if distance <= item.r then
			return true
		end
	end
end

local function fscale(inputValue, originalMin, originalMax, newBegin, newEnd, curve)
	local OriginalRange = 0.0
	local NewRange = 0.0
	local zeroRefCurVal = 0.0
	local normalizedCurVal = 0.0
	local rangedValue = 0.0
	local invFlag = 0
	if (curve > 10.0) then curve = 10.0 end
	if (curve < -10.0) then curve = -10.0 end
	curve = (curve * -.1)
	curve = 10.0 ^ curve
	if (inputValue < originalMin) then
	  inputValue = originalMin
	end
	if inputValue > originalMax then
	  inputValue = originalMax
	end
	OriginalRange = originalMax - originalMin
	if (newEnd > newBegin) then
		NewRange = newEnd - newBegin
	else
	  NewRange = newBegin - newEnd
	  invFlag = 1
	end
	zeroRefCurVal = inputValue - originalMin
	normalizedCurVal  =  zeroRefCurVal / OriginalRange
	if (originalMin > originalMax) then
	  return 0
	end
	if (invFlag == 0) then
		rangedValue =  ((normalizedCurVal ^ curve) * NewRange) + newBegin
	else
		rangedValue =  newBegin - ((normalizedCurVal ^ curve) * NewRange)
	end
	return rangedValue
end

local function tireBurstLottery()
	local tireBurstNumber = math.random(tireBurstMaxNumber)
	if tireBurstNumber == tireBurstLuckyNumber then
		if GetVehicleTyresCanBurst(vehicle) == false then return end
		local numWheels = GetVehicleNumberOfWheels(vehicle)
		local affectedTire
		if numWheels == 2 then
			affectedTire = (math.random(2)-1)*4
		elseif numWheels == 4 then
			affectedTire = (math.random(4)-1)
			if affectedTire > 1 then affectedTire = affectedTire + 2 end
		elseif numWheels == 6 then
			affectedTire = (math.random(6)-1)
		else
			affectedTire = 0
		end
		SetVehicleTyreBurst(vehicle, affectedTire, false, 1000.0)
		tireBurstLuckyNumber = math.random(tireBurstMaxNumber)
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        if showPro then
            rg.toiminnot.DrawText3D(pos.x, pos.y, pos.z, TimeLeft .. '~g~%')
        end
    end
end)

RegisterNetEvent('iens:repair')
AddEventHandler('iens:repair', function()
	if isPedDrivingAVehicle() then
		local ped = GetPlayerPed(-1)
		vehicle = GetVehiclePedIsIn(ped, false)
		if IsNearMechanic() then
			return
		end
		if GetVehicleEngineHealth(vehicle) < cfg.cascadingFailureThreshold + 5 then
			if GetVehicleOilLevel(vehicle) > 0 then
				SetVehicleUndriveable(vehicle,false)
				SetVehicleEngineHealth(vehicle, cfg.cascadingFailureThreshold + 5)
				SetVehiclePetrolTankHealth(vehicle, 750.0)
				healthEngineLast=cfg.cascadingFailureThreshold +5
				healthPetrolTankLast=750.0
					SetVehicleEngineOn(vehicle, true, false)
				SetVehicleOilLevel(vehicle,(GetVehicleOilLevel(vehicle)/3)-0.5)
				notification("~g~" .. repairCfg.fixMessages[fixMessagePos] .. ", vai agora a uma oficina!")
				fixMessagePos = fixMessagePos + 1
				if fixMessagePos > repairCfg.fixMessageCount then fixMessagePos = 1 end
			else
				notification("~r~O veiculo esta demasiado danificado!")
			end
		else
			notification("~y~" .. repairCfg.noFixMessages[noFixMessagePos])
			noFixMessagePos = noFixMessagePos + 1
			if noFixMessagePos > repairCfg.noFixMessageCount then noFixMessagePos = 1 end
		end
	else
		notification("~y~Tens que estar dentro de um veiculo!")
	end
end)

RegisterNetEvent('iens:repaira')
AddEventHandler('iens:repaira', function()
	if isPedDrivingAVehicle() then
		local ped = GetPlayerPed(-1)
		vehicle = GetVehiclePedIsIn(ped, false)
		SetVehicleDirtLevel(vehicle)
		SetVehicleUndriveable(vehicle, false)
		WashDecalsFromVehicle(vehicle, 1.0)
		notification("Veiculo reparado com CMD-STAFF!")
		SetVehicleFixed(vehicle)
		healthBodyLast=1000.0
		healthEngineLast=1000.0
		healthPetrolTankLast=1000.0
		SetVehicleEngineOn(vehicle, true, false)
		return
	else
		notification("Tens que estar dentro de um veiculo!")
	end
end)

RegisterNetEvent('iens:besked')
AddEventHandler('iens:besked', function()
	notification("~r~Há assistência rodoviária disponível, ligue através do seu telefone!")
end)

RegisterNetEvent('iens:notAllowed')
AddEventHandler('iens:notAllowed', function()
	notification("~r~Você não tem permissão para reparar veículos")
end)

if cfg.torqueMultiplierEnabled or cfg.preventVehicleFlip or cfg.limpMode then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if cfg.torqueMultiplierEnabled or cfg.sundayDriver or cfg.limpMode then
				if pedInSameVehicleLast then
					local factor = 1.0
					if cfg.torqueMultiplierEnabled and healthEngineNew < 900 then
						factor = (healthEngineNew+200.0) / 1100
					end
					if cfg.sundayDriver and GetVehicleClass(vehicle) ~= 14 then
						local accelerator = GetControlValue(2,71)
						local brake = GetControlValue(2,72)
						local speed = GetEntitySpeedVector(vehicle, true)['y']
						local brk = fBrakeForce
						if speed >= 1.0 then
							if accelerator > 127 then
								local acc = fscale(accelerator, 127.0, 254.0, 0.1, 1.0, 10.0-(cfg.sundayDriverAcceleratorCurve*2.0))
								factor = factor * acc
							end
							if brake > 127 then
								isBrakingForward = true
								brk = fscale(brake, 127.0, 254.0, 0.01, fBrakeForce, 10.0-(cfg.sundayDriverBrakeCurve*2.0))
							end
						elseif speed <= -1.0 then
							if brake > 127 then
								local rev = fscale(brake, 127.0, 254.0, 0.1, 1.0, 10.0-(cfg.sundayDriverAcceleratorCurve*2.0))
								factor = factor * rev
							end
							if accelerator > 127 then
								isBrakingReverse = true
								brk = fscale(accelerator, 127.0, 254.0, 0.01, fBrakeForce, 10.0-(cfg.sundayDriverBrakeCurve*2.0))
							end
						else
							local entitySpeed = GetEntitySpeed(vehicle)
							if entitySpeed < 1 then
								if isBrakingForward == true then
									DisableControlAction(2,72,true)
									SetVehicleForwardSpeed(vehicle,speed*0.98)
									SetVehicleBrakeLights(vehicle,true)
								end
								if isBrakingReverse == true then
									DisableControlAction(2,71,true)
									SetVehicleForwardSpeed(vehicle,speed*0.98)
									SetVehicleBrakeLights(vehicle,true)
								end
								if isBrakingForward == true and GetDisabledControlNormal(2,72) == 0 then
									isBrakingForward=false
								end
								if isBrakingReverse == true and GetDisabledControlNormal(2,71) == 0 then
									isBrakingReverse=false
								end
							end
						end
						if brk > fBrakeForce - 0.02 then brk = fBrakeForce end
						SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fBrakeForce', brk)
					end
					if cfg.limpMode == true and healthEngineNew < cfg.engineSafeGuard + 5 then
						factor = cfg.limpModeMultiplier
					end
					SetVehicleEngineTorqueMultiplier(vehicle, factor)
				end
			end
			if cfg.preventVehicleFlip then
				local roll = GetEntityRoll(vehicle)
				if (roll > 75.0 or roll < -75.0) and GetEntitySpeed(vehicle) < 2 then
					DisableControlAction(2,59,true)
					DisableControlAction(2,60,true)
				end
			end
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)
		local ped = GetPlayerPed(-1)
		if isPedDrivingAVehicle() then
			vehicle = GetVehiclePedIsIn(ped, false)
			vehicleClass = GetVehicleClass(vehicle)
			healthEngineCurrent = GetVehicleEngineHealth(vehicle)
			if healthEngineCurrent == 1000 then healthEngineLast = 1000.0 end
			healthEngineNew = healthEngineCurrent
			healthEngineDelta = healthEngineLast - healthEngineCurrent
			healthEngineDeltaScaled = healthEngineDelta * cfg.damageFactorEngine * cfg.classDamageMultiplier[vehicleClass]
			healthBodyCurrent = GetVehicleBodyHealth(vehicle)
			if healthBodyCurrent == 1000 then healthBodyLast = 1000.0 end
			healthBodyNew = healthBodyCurrent
			healthBodyDelta = healthBodyLast - healthBodyCurrent
			healthBodyDeltaScaled = healthBodyDelta * cfg.damageFactorBody * cfg.classDamageMultiplier[vehicleClass]
			healthPetrolTankCurrent = GetVehiclePetrolTankHealth(vehicle)
			if cfg.compatibilityMode and healthPetrolTankCurrent < 1 then
				healthPetrolTankLast = healthPetrolTankCurrent
			end
			if healthPetrolTankCurrent == 1000 then healthPetrolTankLast = 1000.0 end
			healthPetrolTankNew = healthPetrolTankCurrent
			healthPetrolTankDelta = healthPetrolTankLast-healthPetrolTankCurrent
			healthPetrolTankDeltaScaled = healthPetrolTankDelta * cfg.damageFactorPetrolTank * cfg.classDamageMultiplier[vehicleClass]
			if healthEngineCurrent > cfg.engineSafeGuard+1 then
				SetVehicleUndriveable(vehicle,false)
			end
			if healthEngineCurrent <= cfg.engineSafeGuard+1 and cfg.limpMode == false then
				local vehpos = GetEntityCoords(vehicle)
				StartParticleFxLoopedAtCoord("ent_ray_heli_aprtmnt_l_fire", vehpos.x, vehpos.y, vehpos.z-0.7, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
				SetVehicleUndriveable(vehicle,true)
			end
			if vehicle ~= lastVehicle then
				pedInSameVehicleLast = false
			end
			if pedInSameVehicleLast == true then
				if healthEngineCurrent ~= 1000.0 or healthBodyCurrent ~= 1000.0 or healthPetrolTankCurrent ~= 1000.0 then
					local healthEngineCombinedDelta = math.max(healthEngineDeltaScaled, healthBodyDeltaScaled, healthPetrolTankDeltaScaled)
					if healthEngineCombinedDelta > (healthEngineCurrent - cfg.engineSafeGuard) then
						healthEngineCombinedDelta = healthEngineCombinedDelta * 0.7
					end
					if healthEngineCombinedDelta > healthEngineCurrent then
						healthEngineCombinedDelta = healthEngineCurrent - (cfg.cascadingFailureThreshold / 5)
					end
					healthEngineNew = healthEngineLast - healthEngineCombinedDelta
					if healthEngineNew > (cfg.cascadingFailureThreshold + 5) and healthEngineNew < cfg.degradingFailureThreshold then
						healthEngineNew = healthEngineNew-(0.038 * cfg.degradingHealthSpeedFactor)
					end
					if healthEngineNew < cfg.cascadingFailureThreshold then
						healthEngineNew = healthEngineNew-(0.1 * cfg.cascadingFailureSpeedFactor)
					end
					if healthEngineNew < cfg.engineSafeGuard then
						healthEngineNew = cfg.engineSafeGuard
					end
					if cfg.compatibilityMode == false and healthPetrolTankCurrent < 750 then
						healthPetrolTankNew = 750.0
					end
					if healthBodyNew < 0  then
						healthBodyNew = 0.0
					end
				end
			else
				fDeformationDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDeformationDamageMult')
				fBrakeForce = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fBrakeForce')
				local newFDeformationDamageMult = fDeformationDamageMult ^ cfg.deformationExponent
				if cfg.deformationMultiplier ~= -1 then SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDeformationDamageMult', newFDeformationDamageMult * cfg.deformationMultiplier) end
				if cfg.weaponsDamageMultiplier ~= -1 then SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fWeaponDamageMult', cfg.weaponsDamageMultiplier/cfg.damageFactorBody) end
				fCollisionDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fCollisionDamageMult')
				local newFCollisionDamageMultiplier = fCollisionDamageMult ^ cfg.collisionDamageExponent
				SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fCollisionDamageMult', newFCollisionDamageMultiplier)
				fEngineDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fEngineDamageMult')
				local newFEngineDamageMult = fEngineDamageMult ^ cfg.engineDamageExponent
				SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fEngineDamageMult', newFEngineDamageMult)
				if healthBodyCurrent < cfg.cascadingFailureThreshold then
					healthBodyNew = cfg.cascadingFailureThreshold
				end
				pedInSameVehicleLast = true
			end
			if healthEngineNew ~= healthEngineCurrent then
				SetVehicleEngineHealth(vehicle, healthEngineNew)
				local dmgFactr = (healthEngineCurrent - healthEngineNew)
				if dmgFactr > 0.8 then
					DamageRandomComponent()
				end
			end
			if healthBodyNew ~= healthBodyCurrent then 
				SetVehicleBodyHealth(vehicle, healthBodyNew) 
				local dmgFactr = (healthBodyCurrent - healthBodyNew)
				DamageRandomComponent()
			end
			if healthPetrolTankNew ~= healthPetrolTankCurrent then 
				SetVehiclePetrolTankHealth(vehicle, healthPetrolTankNew)
			end
			healthEngineLast = healthEngineNew
			healthBodyLast = healthBodyNew
			healthPetrolTankLast = healthPetrolTankNew
			lastVehicle=vehicle
			if cfg.randomTireBurstInterval ~= 0 and GetEntitySpeed(vehicle) > 10 then tireBurstLottery() end
		else
			if pedInSameVehicleLast == true then
				lastVehicle = GetVehiclePedIsIn(ped, true)				
				if cfg.deformationMultiplier ~= -1 then 
					SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fDeformationDamageMult', fDeformationDamageMult)
				end
				SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fBrakeForce', fBrakeForce)
				if cfg.weaponsDamageMultiplier ~= -1 then 
					SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fWeaponDamageMult', cfg.weaponsDamageMultiplier) 
				end
				SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fCollisionDamageMult', fCollisionDamageMult)
				SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fEngineDamageMult', fEngineDamageMult)
			end
			pedInSameVehicleLast = false
		end
	end
end)

local DamageComponents = {
    "radiator",
    "axle",
    "clutch",
	"fuel",
	"brakes",
}

function DamageRandomComponent()
	local dmgFctr = math.random() + math.random(0, 2)
	local randomComponent = DamageComponents[math.random(1, #DamageComponents)]
	local randomDamage = (math.random() + math.random(0, 1)) * dmgFctr
end

function procent(time)
    showPro = true
    TimeLeft = 0
    repeat
        TimeLeft = TimeLeft + 1
        Citizen.Wait(time)
    until(TimeLeft == 100)
    showPro = false
end