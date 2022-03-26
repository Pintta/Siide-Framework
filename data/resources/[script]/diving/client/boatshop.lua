local ClosestBerth = 1
local BoatsSpawned = false
local ModelLoaded = true
local SpawnedBoats = {}
local Buying = false

-- Berth's Boatshop Loop

Citizen.CreateThread(function()
    while true do
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        local BerthDist = GetDistanceBetweenCoords(pos, rgBoatshop.Locations["berths"][1]["coords"]["boat"]["x"], rgBoatshop.Locations["berths"][1]["coords"]["boat"]["y"], rgBoatshop.Locations["berths"][1]["coords"]["boat"]["z"], false)

        if BerthDist < 100 then
            SetClosestBerthBoat()
            if not BoatsSpawned then
                SpawnBerthBoats()
            end
        elseif BerthDist > 110 then
            if BoatsSpawned then
                BoatsSpawned = false
            end
        end

        Citizen.Wait(1000)
    end
end)

function SpawnBerthBoats()
    for loc,_ in pairs(rgBoatshop.Locations["berths"]) do
        if SpawnedBoats[loc] ~= nil then
            rg.toiminnot.DeleteVehicle(SpawnedBoats[loc])
        end
		local model = GetHashKey(rgBoatshop.Locations["berths"][loc]["boatModel"])
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local veh = CreateVehicle(model, rgBoatshop.Locations["berths"][loc]["coords"]["boat"]["x"], rgBoatshop.Locations["berths"][loc]["coords"]["boat"]["y"], rgBoatshop.Locations["berths"][loc]["coords"]["boat"]["z"], false, false)

        SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(veh)
		SetEntityInvincible(veh,true)
        SetEntityHeading(veh, rgBoatshop.Locations["berths"][loc]["coords"]["boat"]["h"])
        SetVehicleDoorsLocked(veh, 3)

		FreezeEntityPosition(veh,true)     
        SpawnedBoats[loc] = veh
    end
    BoatsSpawned = true
end

function SetClosestBerthBoat()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil

    for id, veh in pairs(rgBoatshop.Locations["berths"]) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, rgBoatshop.Locations["berths"][id]["coords"]["buy"]["x"], rgBoatshop.Locations["berths"][id]["coords"]["buy"]["y"], rgBoatshop.Locations["berths"][id]["coords"]["buy"]["z"], true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, rgBoatshop.Locations["berths"][id]["coords"]["buy"]["x"], rgBoatshop.Locations["berths"][id]["coords"]["buy"]["y"], rgBoatshop.Locations["berths"][id]["coords"]["buy"]["z"], true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, rgBoatshop.Locations["berths"][id]["coords"]["buy"]["x"], rgBoatshop.Locations["berths"][id]["coords"]["buy"]["y"], rgBoatshop.Locations["berths"][id]["coords"]["buy"]["z"], true)
            current = id
        end
    end
    if current ~= ClosestBerth then
        ClosestBerth = current
    end
end

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        local inRange = false

        local distance = GetDistanceBetweenCoords(pos, rgBoatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["x"], rgBoatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["y"], rgBoatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["z"], true)

        if distance < 15 then
            local BuyLocation = {
                x = rgBoatshop.Locations["berths"][ClosestBerth]["coords"]["buy"]["x"],
                y = rgBoatshop.Locations["berths"][ClosestBerth]["coords"]["buy"]["y"],
                z = rgBoatshop.Locations["berths"][ClosestBerth]["coords"]["buy"]["z"]
            }

            DrawMarker(25, BuyLocation.x, BuyLocation.y, BuyLocation.z, 0.0, 0.0, 0.0, 0.0, 1.1, 1.1, 0.9, 0.9, 0.9, 255, 55, 15, 255, false, false, false, true, false, false, false)
            local BuyDistance = GetDistanceBetweenCoords(pos, BuyLocation.x, BuyLocation.y, BuyLocation.z, true)

            if BuyDistance < 2 then                
                local currentBoat = rgBoatshop.Locations["berths"][ClosestBerth]["boatModel"]

                DrawMarker(35, rgBoatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["x"], rgBoatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["y"], rgBoatshop.Locations["berths"][ClosestBerth]["coords"]["boat"]["z"] + 1.5, 0.0, 0.0, 0.0, 0.0, 5.0, 1.0, 1.0, 0.1, -0.8, 15, 255, 55, 255, true, false, false, true, false, false, false)

                if not Buying then
                    DrawText3D(BuyLocation.x, BuyLocation.y, BuyLocation.z + 0.3, '~b~E~w~ - Buy '..rgBoatshop.ShopBoats[currentBoat]["label"]..' for ~g~$'..rgBoatshop.ShopBoats[currentBoat]["price"])
                    if IsControlJustPressed(0, Keys["E"]) then
                        Buying = true
                    end
                else
                    DrawText3D(BuyLocation.x, BuyLocation.y, BuyLocation.z + 0.3, 'Are you sure? ~g~7~w~ YES! / ~r~8~w~ Nope! ~b~($'..rgBoatshop.ShopBoats[currentBoat]["price"]..')')
                    if IsControlJustPressed(0, Keys["7"]) or IsDisabledControlJustReleased(0, Keys["7"]) then
                        TriggerServerEvent('diving:server:BuyBoat', rgBoatshop.Locations["berths"][ClosestBerth]["boatModel"], ClosestBerth)
                        Buying = false
                    elseif IsControlJustPressed(0, Keys["8"]) or IsDisabledControlJustReleased(0, Keys["8"]) then
                        Buying = false
                    end
                end
            elseif BuyDistance > 2.5 then
                if Buying then
                    Buying = false
                end
            end
        end

        Citizen.Wait(3)
    end
end)

RegisterNetEvent('diving:client:BuyBoat')
AddEventHandler('diving:client:BuyBoat', function(boatModel, plate)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    rg.toiminnot.HaeAjoneuvo(boatModel, function(veh)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        exports['LegacyFuel']:SetFuel(veh, 100)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, rgBoatshop.HaeAjoneuvo.h)
        TriggerEvent("vehiclekeys:client:AsetaOmistaja", GetVehicleNumberPlateText(veh))
    end, rgBoatshop.HaeAjoneuvo, false)
    SetTimeout(1000, function()
        DoScreenFadeIn(250)
    end)
end)

Citizen.CreateThread(function()
    BoatShop = AddBlipForCoord(rgBoatshop.Locations["berths"][1]["coords"]["boat"]["x"], rgBoatshop.Locations["berths"][1]["coords"]["boat"]["y"], rgBoatshop.Locations["berths"][1]["coords"]["boat"]["z"])

    SetBlipSprite (BoatShop, 410)
    SetBlipDisplay(BoatShop, 4)
    SetBlipScale  (BoatShop, 0.8)
    SetBlipAsShortRange(BoatShop, true)
    SetBlipColour(BoatShop, 81)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Laituri")
    EndTextCommandSetBlipName(BoatShop)
end)