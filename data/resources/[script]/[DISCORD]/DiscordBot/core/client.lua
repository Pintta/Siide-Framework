Citizen.CreateThread(function()
	local DeathReason, Killer, DeathCauseHash, Weapon
	while true do
		Citizen.Wait(0)
		if IsEntityDead(PlayerPedId()) then
			Citizen.Wait(500)
			local PedKiller = GetPedSourceOfDeath(PlayerPedId())
			DeathCauseHash = GetPedCauseOfDeath(PlayerPedId())
			Weapon = WeaponNames[tostring(DeathCauseHash)]
			if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
				Killer = NetworkGetPlayerIndexFromPed(PedKiller)
			elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
				Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
			end
			if (Killer == PlayerId()) then
				DeathReason = 'KYS'
			elseif (Killer == nil) then
				DeathReason = 'jokin muu'
			else
				if IsMelee(DeathCauseHash) then
					DeathReason = 'Melee'
				elseif IsTorch(DeathCauseHash) then
					DeathReason = 'Tuli'
				elseif IsKnife(DeathCauseHash) then
					DeathReason = 'Puukko'
				elseif IsPistol(DeathCauseHash) then
					DeathReason = 'Pistooli'
				elseif IsSub(DeathCauseHash) then
					DeathReason = 'SMG'
				elseif IsRifle(DeathCauseHash) then
					DeathReason = 'Kivääri'
				elseif IsLight(DeathCauseHash) then
					DeathReason = 'à mitraillé'
				elseif IsShotgun(DeathCauseHash) then
					DeathReason = 'Haulikko'
				elseif IsSniper(DeathCauseHash) then
					DeathReason = 'AWP'
				elseif IsHeavy(DeathCauseHash) then
					DeathReason = 'Raskas tuliase'
				elseif IsMinigun(DeathCauseHash) then
					DeathReason = 'Miniguni'
				elseif IsBomb(DeathCauseHash) then
					DeathReason = 'Pommi'
				elseif IsVeh(DeathCauseHash) then
					DeathReason = 'Ajoneuvo'
				elseif IsVK(DeathCauseHash) then
					DeathReason = 'à aplati'
				else
					DeathReason = 'à tué'
				end
			end
			if DeathReason == 'KYS' or DeathReason == 'jokin muu' then
				TriggerServerEvent('DiscordBot:playerDied', GetPlayerName(PlayerId()) .. ' ' .. DeathReason .. '.', Weapon)
			else
				TriggerServerEvent('DiscordBot:playerDied', GetPlayerName(Killer) .. ' ' .. DeathReason .. ' ' .. GetPlayerName(PlayerId()) .. '.', Weapon)
			end
			Killer = nil
			DeathReason = nil
			DeathCauseHash = nil
			Weapon = nil
		end
		while IsEntityDead(PlayerPedId()) do
			Citizen.Wait(0)
		end
	end
end)

function IsMelee(Weapon)
	local Weapons = {'WEAPON_UNARMED', 'WEAPON_CROWBAR', 'WEAPON_BAT', 'WEAPON_GOLFCLUB', 'WEAPON_HAMMER', 'WEAPON_NIGHTSTICK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsTorch(Weapon)
	local Weapons = {'WEAPON_MOLOTOV'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsKnife(Weapon)
	local Weapons = {'WEAPON_DAGGER', 'WEAPON_KNIFE', 'WEAPON_SWITCHBLADE', 'WEAPON_HATCHET', 'WEAPON_BOTTLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsPistol(Weapon)
	local Weapons = {'WEAPON_SNSPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_PISTOL', 'WEAPON_APPISTOL', 'WEAPON_COMBATPISTOL'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSub(Weapon)
	local Weapons = {'WEAPON_MICROSMG', 'WEAPON_SMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsRifle(Weapon)
	local Weapons = {'WEAPON_CARBINERIFLE', 'WEAPON_MUSKET', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_ASSAULTRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_COMPACTRIFLE', 'WEAPON_BULLPUPRIFLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsLight(Weapon)
	local Weapons = {'WEAPON_MG', 'WEAPON_COMBATMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsShotgun(Weapon)
	local Weapons = {'WEAPON_BULLPUPSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_DBSHOTGUN', 'WEAPON_PUMPSHOTGUN', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSniper(Weapon)
	local Weapons = {'WEAPON_MARKSMANRIFLE', 'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_ASSAULTSNIPER', 'WEAPON_REMOTESNIPER'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsHeavy(Weapon)
	local Weapons = {'WEAPON_GRENADELAUNCHER', 'WEAPON_RPG', 'WEAPON_FLAREGUN', 'WEAPON_HOMINGLAUNCHER', 'WEAPON_FIREWORK', 'VEHICLE_WEAPON_TANK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsMinigun(Weapon)
	local Weapons = {'WEAPON_MINIGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsBomb(Weapon)
	local Weapons = {'WEAPON_GRENADE', 'WEAPON_PROXMINE', 'WEAPON_EXPLOSION', 'WEAPON_STICKYBOMB'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVeh(Weapon)
	local Weapons = {'VEHICLE_WEAPON_ROTORS'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVK(Weapon)
	local Weapons = {'WEAPON_RUN_OVER_BY_CAR', 'WEAPON_RAMMED_BY_CAR'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

WeaponNames = {
	[tostring(GetHashKey('WEAPON_UNARMED'))] = 'Désarmé',
	[tostring(GetHashKey('WEAPON_KNIFE'))] = 'Couteau',
	[tostring(GetHashKey('WEAPON_NIGHTSTICK'))] = 'Nightstick',
	[tostring(GetHashKey('WEAPON_HAMMER'))] = 'Marteau',
	[tostring(GetHashKey('WEAPON_BAT'))] = 'Batte de Baseball',
	[tostring(GetHashKey('WEAPON_GOLFCLUB'))] = 'Club de Golf',
	[tostring(GetHashKey('WEAPON_CROWBAR'))] = 'Pied de Biche',
	[tostring(GetHashKey('WEAPON_PISTOL'))] = 'Pistolet',
	[tostring(GetHashKey('WEAPON_COMBATPISTOL'))] = 'Pistolet de combat',
	[tostring(GetHashKey('WEAPON_APPISTOL'))] = 'Pistolet AP',
	[tostring(GetHashKey('WEAPON_PISTOL50'))] = 'Pistolet .50',
	[tostring(GetHashKey('WEAPON_MICROSMG'))] = 'Micro SMG',
	[tostring(GetHashKey('WEAPON_SMG'))] = 'SMG',
	[tostring(GetHashKey('WEAPON_ASSAULTSMG'))] = 'Assault SMG',
	[tostring(GetHashKey('WEAPON_ASSAULTRIFLE'))] = 'Fusil d\'Assaut',
	[tostring(GetHashKey('WEAPON_CARBINERIFLE'))] = 'Carabine d\'Assaut',
	[tostring(GetHashKey('WEAPON_ADVANCEDRIFLE'))] = 'Fusil Avancé',
	[tostring(GetHashKey('WEAPON_MG'))] = 'MG',
	[tostring(GetHashKey('WEAPON_COMBATMG'))] = 'Combat MG',
	[tostring(GetHashKey('WEAPON_PUMPSHOTGUN'))] = 'Fusil à pompe',
	[tostring(GetHashKey('WEAPON_SAWNOFFSHOTGUN'))] = 'Fusil de chasse à canon tronçonné',
	[tostring(GetHashKey('WEAPON_ASSAULTSHOTGUN'))] = 'Fusil de chasse d\'assaut',
	[tostring(GetHashKey('WEAPON_BULLPUPSHOTGUN'))] = 'Fusil de chasse Bullpup',
	[tostring(GetHashKey('WEAPON_STUNGUN'))] = 'Tazer',
	[tostring(GetHashKey('WEAPON_SNIPERRIFLE'))] = 'Fusil de sniper',
	[tostring(GetHashKey('WEAPON_HEAVYSNIPER'))] = 'Fusil de sniper Lourd',
	[tostring(GetHashKey('WEAPON_REMOTESNIPER'))] = 'Tireur d\'élite à distance',
	[tostring(GetHashKey('WEAPON_GRENADELAUNCHER'))] = 'Lance-grenades',
	[tostring(GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE'))] = 'Lance-grenades à fumée',
	[tostring(GetHashKey('WEAPON_RPG'))] = 'RPG',
	[tostring(GetHashKey('WEAPON_PASSENGER_ROCKET'))] = 'Passenger Rocket',
	[tostring(GetHashKey('WEAPON_AIRSTRIKE_ROCKET'))] = 'Airstrike Rocket',
	[tostring(GetHashKey('WEAPON_STINGER'))] = 'Stinger [Vehicle]',
	[tostring(GetHashKey('WEAPON_MINIGUN'))] = 'Minigun',
	[tostring(GetHashKey('WEAPON_GRENADE'))] = 'Grenade',
	[tostring(GetHashKey('WEAPON_STICKYBOMB'))] = 'Sticky Bomb',
	[tostring(GetHashKey('WEAPON_SMOKEGRENADE'))] = 'Gaz lacrymogène',
	[tostring(GetHashKey('WEAPON_BZGAS'))] = 'BZ Gas',
	[tostring(GetHashKey('WEAPON_MOLOTOV'))] = 'Molotov',
	[tostring(GetHashKey('WEAPON_FIREEXTINGUISHER'))] = 'Extincteur d\'incendie',
	[tostring(GetHashKey('WEAPON_PETROLCAN'))] = 'Jerry Can',
	[tostring(GetHashKey('OBJECT'))] = 'Object',
	[tostring(GetHashKey('WEAPON_BALL'))] = 'Ball',
	[tostring(GetHashKey('WEAPON_FLARE'))] = 'Flare',
	[tostring(GetHashKey('VEHICLE_WEAPON_TANK'))] = 'Tank Cannon',
	[tostring(GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET'))] = 'Rockets',
	[tostring(GetHashKey('VEHICLE_WEAPON_PLAYER_LASER'))] = 'Laser',
	[tostring(GetHashKey('AMMO_RPG'))] = 'Rocket',
	[tostring(GetHashKey('AMMO_TANK'))] = 'Tank',
	[tostring(GetHashKey('AMMO_SPACE_ROCKET'))] = 'Rocket',
	[tostring(GetHashKey('AMMO_PLAYER_LASER'))] = 'Laser',
	[tostring(GetHashKey('AMMO_ENEMY_LASER'))] = 'Laser',
	[tostring(GetHashKey('WEAPON_RAMMED_BY_CAR'))] = 'Bousculé en voiture',
	[tostring(GetHashKey('WEAPON_BOTTLE'))] = 'Bottle',
	[tostring(GetHashKey('WEAPON_GUSENBERG'))] = 'Gusenberg Sweeper',
	[tostring(GetHashKey('WEAPON_SNSPISTOL'))] = 'SNS Pistol',
	[tostring(GetHashKey('WEAPON_VINTAGEPISTOL'))] = 'Pistolet Vintage',
	[tostring(GetHashKey('WEAPON_DAGGER'))] = 'Antique Cavalry Dagger',
	[tostring(GetHashKey('WEAPON_FLAREGUN'))] = 'Flare Gun',
	[tostring(GetHashKey('WEAPON_HEAVYPISTOL'))] = 'Pistolet lourd',
	[tostring(GetHashKey('WEAPON_SPECIALCARBINE'))] = 'Carabine spéciale',
	[tostring(GetHashKey('WEAPON_MUSKET'))] = 'Mousquet',
	[tostring(GetHashKey('WEAPON_FIREWORK'))] = 'Lanceur de feux d\'artifice',
	[tostring(GetHashKey('WEAPON_MARKSMANRIFLE'))] = 'Marksman Rifle',
	[tostring(GetHashKey('WEAPON_HEAVYSHOTGUN'))] = 'Fusil de chasse lourd',
	[tostring(GetHashKey('WEAPON_PROXMINE'))] = 'Proximity Mine',
	[tostring(GetHashKey('WEAPON_HOMINGLAUNCHER'))] = 'Homing Launcher',
	[tostring(GetHashKey('WEAPON_HATCHET'))] = 'Hatchet',
	[tostring(GetHashKey('WEAPON_COMBATPDW'))] = 'Combat PDW',
	[tostring(GetHashKey('WEAPON_KNUCKLE'))] = 'Knuckle Duster',
	[tostring(GetHashKey('WEAPON_MARKSMANPISTOL'))] = 'Marksman Pistol',
	[tostring(GetHashKey('WEAPON_MACHETE'))] = 'Machete',
	[tostring(GetHashKey('WEAPON_MACHINEPISTOL'))] = 'Machine Pistol',
	[tostring(GetHashKey('WEAPON_FLASHLIGHT'))] = 'Lampe Torche',
	[tostring(GetHashKey('WEAPON_DBSHOTGUN'))] = 'Fusil de chasse à double canon',
	[tostring(GetHashKey('WEAPON_COMPACTRIFLE'))] = 'Fusil compact',
	[tostring(GetHashKey('WEAPON_SWITCHBLADE'))] = 'lame de commutateur',
	[tostring(GetHashKey('WEAPON_REVOLVER'))] = 'Revolver lourd',
	[tostring(GetHashKey('WEAPON_FIRE'))] = 'Feu',
	[tostring(GetHashKey('WEAPON_HELI_CRASH'))] = 'Heli Crash',
	[tostring(GetHashKey('WEAPON_RUN_OVER_BY_CAR'))] = 'Écrasé par une voiture',
	[tostring(GetHashKey('WEAPON_HIT_BY_WATER_CANNON'))] = 'Frappé par un canon à eau',
	[tostring(GetHashKey('WEAPON_EXHAUSTION'))] = 'Épuisement',
	[tostring(GetHashKey('WEAPON_EXPLOSION'))] = 'Explosion',
	[tostring(GetHashKey('WEAPON_ELECTRIC_FENCE'))] = 'Electric Fence',
	[tostring(GetHashKey('WEAPON_BLEEDING'))] = 'Bleeding',
	[tostring(GetHashKey('WEAPON_DROWNING_IN_VEHICLE'))] = 'Noyade dans un véhicule',
	[tostring(GetHashKey('WEAPON_DROWNING'))] = 'Drowning',
	[tostring(GetHashKey('WEAPON_BARBED_WIRE'))] = 'Barbed Wire',
	[tostring(GetHashKey('WEAPON_VEHICLE_ROCKET'))] = 'Vehicle Rocket',
	[tostring(GetHashKey('WEAPON_BULLPUPRIFLE'))] = 'Bullpup Rifle',
	[tostring(GetHashKey('WEAPON_ASSAULTSNIPER'))] = 'Assault Sniper',
	[tostring(GetHashKey('VEHICLE_WEAPON_ROTORS'))] = 'Rotors',
	[tostring(GetHashKey('WEAPON_RAILGUN'))] = 'Railgun',
	[tostring(GetHashKey('WEAPON_AIR_DEFENCE_GUN'))] = 'Air Defence Gun',
	[tostring(GetHashKey('WEAPON_AUTOSHOTGUN'))] = 'Automatic Shotgun',
	[tostring(GetHashKey('WEAPON_BATTLEAXE'))] = 'Battle Axe',
	[tostring(GetHashKey('WEAPON_COMPACTLAUNCHER'))] = 'Compact Grenade Launcher',
	[tostring(GetHashKey('WEAPON_MINISMG'))] = 'Mini SMG',
	[tostring(GetHashKey('WEAPON_PIPEBOMB'))] = 'Pipebomb',
	[tostring(GetHashKey('WEAPON_POOLCUE'))] = 'Poolcue',
	[tostring(GetHashKey('WEAPON_WRENCH'))] = 'Wrench',
	[tostring(GetHashKey('WEAPON_SNOWBALL'))] = 'Snowball',
	[tostring(GetHashKey('WEAPON_ANIMAL'))] = 'Animal',
	[tostring(GetHashKey('WEAPON_COUGAR'))] = 'Cougar'
}
