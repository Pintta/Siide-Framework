rg = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if rg == nil then
            TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)
            Citizen.Wait(200)
        end
    end
end)

isLoggedIn = false

RegisterNetEvent('rg:Client:OnPlayerUnload')
AddEventHandler('rg:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-- MAFIA 01

Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1)
            if isLoggedIn and rg ~= nil then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if PlayerData.rikollinen.name == "mafia01" then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["autotallimafia01"].coords.x, Config.Locations["autotallimafia01"].coords.y, Config.Locations["autotallimafia01"].coords.z, true) < 10.0) then
                        DrawMarker(2, Config.Locations["autotallimafia01"].coords.x, Config.Locations["autotallimafia01"].coords.y, Config.Locations["autotallimafia01"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["autotallimafia01"].coords.x, Config.Locations["autotallimafia01"].coords.y, Config.Locations["autotallimafia01"].coords.z, true) < 1.5) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                DrawText3D(Config.Locations["autotallimafia01"].coords.x, Config.Locations["autotallimafia01"].coords.y, Config.Locations["autotallimafia01"].coords.z, "~g~E~w~ - Guardar Veiculo")
                            else
                                DrawText3D(Config.Locations["autotallimafia01"].coords.x, Config.Locations["autotallimafia01"].coords.y, Config.Locations["autotallimafia01"].coords.z, "~g~E~w~ - Talli")
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                else
                                    autotallimafia01()
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end 
                    end
                else
                    Citizen.Wait(2500)
                end
            else
                Citizen.Wait(2500)
            end
        end
end)


Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1)
            if isLoggedIn and rg ~= nil then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if PlayerData.rikollinen.name == "mafia01" then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["varastomafia01"].coords.x, Config.Locations["varastomafia01"].coords.y, Config.Locations["varastomafia01"].coords.z, true) < 10.0) then
                        DrawMarker(2, Config.Locations["varastomafia01"].coords.x, Config.Locations["varastomafia01"].coords.y, Config.Locations["varastomafia01"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["varastomafia01"].coords.x, Config.Locations["varastomafia01"].coords.y, Config.Locations["varastomafia01"].coords.z, true) < 1.5) then
                                DrawText3D(Config.Locations["varastomafia01"].coords.x, Config.Locations["varastomafia01"].coords.y, Config.Locations["varastomafia01"].coords.z, "~g~E~w~ - Armario ")
                            if IsControlJustReleased(0, Keys["E"]) then
                                print('nonce')
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", "varastomafia01", {
                                    maxweight = 4000000,
                                    slots = 500,
                                })
                                TriggerEvent("inventory:client:SetCurrentStash", "varastomafia01")
                                end
                            end
                    end
                else
                    Citizen.Wait(2500)
                end
            else
                Citizen.Wait(2500)
            end
        end
end)

-- MAFIA 02

Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1)
            if isLoggedIn and rg ~= nil then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if PlayerData.rikollinen.name == "mafia02" then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["autotallimafia02"].coords.x, Config.Locations["autotallimafia02"].coords.y, Config.Locations["autotallimafia02"].coords.z, true) < 10.0) then
                        DrawMarker(2, Config.Locations["autotallimafia02"].coords.x, Config.Locations["autotallimafia02"].coords.y, Config.Locations["autotallimafia02"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["autotallimafia02"].coords.x, Config.Locations["autotallimafia02"].coords.y, Config.Locations["autotallimafia02"].coords.z, true) < 1.5) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                DrawText3D(Config.Locations["autotallimafia02"].coords.x, Config.Locations["autotallimafia02"].coords.y, Config.Locations["autotallimafia02"].coords.z, "~g~E~w~ - Guardar Veiculo")
                            else
                                DrawText3D(Config.Locations["autotallimafia02"].coords.x, Config.Locations["autotallimafia02"].coords.y, Config.Locations["autotallimafia02"].coords.z, "~g~E~w~ - Talli")
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                else
                                    autotallimafia01()
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end 
                    end
                else
                    Citizen.Wait(2500)
                end
            else
                Citizen.Wait(2500)
            end
        end
end)


Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1)
            if isLoggedIn and rg ~= nil then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if PlayerData.rikollinen.name == "mafia02" then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["varastomafia02"].coords.x, Config.Locations["varastomafia02"].coords.y, Config.Locations["varastomafia02"].coords.z, true) < 10.0) then
                        DrawMarker(2, Config.Locations["varastomafia02"].coords.x, Config.Locations["varastomafia02"].coords.y, Config.Locations["varastomafia02"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["varastomafia02"].coords.x, Config.Locations["varastomafia02"].coords.y, Config.Locations["varastomafia02"].coords.z, true) < 1.5) then
                                DrawText3D(Config.Locations["varastomafia02"].coords.x, Config.Locations["varastomafia02"].coords.y, Config.Locations["varastomafia02"].coords.z, "~g~E~w~ - Armario ")
                            if IsControlJustReleased(0, Keys["E"]) then
                                print('nonce')
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", "varastomafia02", {
                                    maxweight = 4000000,
                                    slots = 500,
                                })
                                TriggerEvent("inventory:client:SetCurrentStash", "varastomafia02")
                                end
                            end
                    end
                else
                    Citizen.Wait(2500)
                end
            else
                Citizen.Wait(2500)
            end
        end
end)

-- MAFIA 03

Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1)
            if isLoggedIn and rg ~= nil then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if PlayerData.rikollinen.name == "mafia03" then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["autotallimafia03"].coords.x, Config.Locations["autotallimafia03"].coords.y, Config.Locations["autotallimafia03"].coords.z, true) < 10.0) then
                        DrawMarker(2, Config.Locations["autotallimafia03"].coords.x, Config.Locations["autotallimafia03"].coords.y, Config.Locations["autotallimafia03"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["autotallimafia03"].coords.x, Config.Locations["autotallimafia03"].coords.y, Config.Locations["autotallimafia03"].coords.z, true) < 1.5) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                DrawText3D(Config.Locations["autotallimafia03"].coords.x, Config.Locations["autotallimafia03"].coords.y, Config.Locations["autotallimafia03"].coords.z, "~g~E~w~ - Guardar Veiculo")
                            else
                                DrawText3D(Config.Locations["autotallimafia03"].coords.x, Config.Locations["autotallimafia03"].coords.y, Config.Locations["autotallimafia03"].coords.z, "~g~E~w~ - Talli")
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                else
                                    autotallimafia01()
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end 
                    end
                else
                    Citizen.Wait(2500)
                end
            else
                Citizen.Wait(2500)
            end
        end
end)


Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1)
            if isLoggedIn and rg ~= nil then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if PlayerData.rikollinen.name == "mafia03" then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["varastomafia03"].coords.x, Config.Locations["varastomafia03"].coords.y, Config.Locations["varastomafia03"].coords.z, true) < 10.0) then
                        DrawMarker(2, Config.Locations["varastomafia03"].coords.x, Config.Locations["varastomafia03"].coords.y, Config.Locations["varastomafia03"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["varastomafia03"].coords.x, Config.Locations["varastomafia03"].coords.y, Config.Locations["varastomafia03"].coords.z, true) < 1.5) then
                                DrawText3D(Config.Locations["varastomafia03"].coords.x, Config.Locations["varastomafia03"].coords.y, Config.Locations["varastomafia03"].coords.z, "~g~E~w~ - Armario ")
                            if IsControlJustReleased(0, Keys["E"]) then
                                print('nonce')
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", "varastomafia03", {
                                    maxweight = 4000000,
                                    slots = 500,
                                })
                                TriggerEvent("inventory:client:SetCurrentStash", "varastomafia03")
                                end
                            end
                    end
                else
                    Citizen.Wait(2500)
                end
            else
                Citizen.Wait(2500)
            end
        end
end)

-- MAFIA 04

Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1)
            if isLoggedIn and rg ~= nil then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if PlayerData.rikollinen.name == "mafia04" then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["autotallimafia04"].coords.x, Config.Locations["autotallimafia04"].coords.y, Config.Locations["autotallimafia04"].coords.z, true) < 10.0) then
                        DrawMarker(2, Config.Locations["autotallimafia04"].coords.x, Config.Locations["autotallimafia04"].coords.y, Config.Locations["autotallimafia04"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["autotallimafia04"].coords.x, Config.Locations["autotallimafia04"].coords.y, Config.Locations["autotallimafia04"].coords.z, true) < 1.5) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                DrawText3D(Config.Locations["autotallimafia04"].coords.x, Config.Locations["autotallimafia04"].coords.y, Config.Locations["autotallimafia04"].coords.z, "~g~E~w~ - Guardar Veiculo")
                            else
                                DrawText3D(Config.Locations["autotallimafia04"].coords.x, Config.Locations["autotallimafia04"].coords.y, Config.Locations["autotallimafia04"].coords.z, "~g~E~w~ - Talli")
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                else
                                    autotallimafia01()
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end 
                    end
                else
                    Citizen.Wait(2500)
                end
            else
                Citizen.Wait(2500)
            end
        end
end)


Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1)
            if isLoggedIn and rg ~= nil then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if PlayerData.rikollinen.name == "mafia04" then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["varastomafia04"].coords.x, Config.Locations["varastomafia04"].coords.y, Config.Locations["varastomafia04"].coords.z, true) < 10.0) then
                        DrawMarker(2, Config.Locations["varastomafia04"].coords.x, Config.Locations["varastomafia04"].coords.y, Config.Locations["varastomafia04"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["varastomafia04"].coords.x, Config.Locations["varastomafia04"].coords.y, Config.Locations["varastomafia04"].coords.z, true) < 1.5) then
                                DrawText3D(Config.Locations["varastomafia04"].coords.x, Config.Locations["varastomafia04"].coords.y, Config.Locations["varastomafia04"].coords.z, "~g~E~w~ - Armario ")
                            if IsControlJustReleased(0, Keys["E"]) then
                                print('nonce')
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", "varastomafia04", {
                                    maxweight = 4000000,
                                    slots = 500,
                                })
                                TriggerEvent("inventory:client:SetCurrentStash", "varastomafia04")
                                end
                            end
                    end
                else
                    Citizen.Wait(2500)
                end
            else
                Citizen.Wait(2500)
            end
        end
end)

-- MAFIA 05

Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1)
            if isLoggedIn and rg ~= nil then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if PlayerData.rikollinen.name == "mafia05" then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["autotallimafia05"].coords.x, Config.Locations["autotallimafia05"].coords.y, Config.Locations["autotallimafia05"].coords.z, true) < 10.0) then
                        DrawMarker(2, Config.Locations["autotallimafia05"].coords.x, Config.Locations["autotallimafia05"].coords.y, Config.Locations["autotallimafia05"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["autotallimafia05"].coords.x, Config.Locations["autotallimafia05"].coords.y, Config.Locations["autotallimafia05"].coords.z, true) < 1.5) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                DrawText3D(Config.Locations["autotallimafia05"].coords.x, Config.Locations["autotallimafia05"].coords.y, Config.Locations["autotallimafia05"].coords.z, "~g~E~w~ - Guardar Veiculo")
                            else
                                DrawText3D(Config.Locations["autotallimafia05"].coords.x, Config.Locations["autotallimafia05"].coords.y, Config.Locations["autotallimafia05"].coords.z, "~g~E~w~ - Talli")
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                else
                                    autotallimafia01()
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end 
                    end
                else
                    Citizen.Wait(2500)
                end
            else
                Citizen.Wait(2500)
            end
        end
end)


Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1)
            if isLoggedIn and rg ~= nil then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if PlayerData.rikollinen.name == "mafia05" then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["varastomafia05"].coords.x, Config.Locations["varastomafia05"].coords.y, Config.Locations["varastomafia05"].coords.z, true) < 10.0) then
                        DrawMarker(2, Config.Locations["varastomafia05"].coords.x, Config.Locations["varastomafia05"].coords.y, Config.Locations["varastomafia05"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["varastomafia05"].coords.x, Config.Locations["varastomafia05"].coords.y, Config.Locations["varastomafia05"].coords.z, true) < 1.5) then
                                DrawText3D(Config.Locations["varastomafia05"].coords.x, Config.Locations["varastomafia05"].coords.y, Config.Locations["varastomafia05"].coords.z, "~g~E~w~ - Armario ")
                            if IsControlJustReleased(0, Keys["E"]) then
                                print('nonce')
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", "varastomafia05", {
                                    maxweight = 4000000,
                                    slots = 500,
                                })
                                TriggerEvent("inventory:client:SetCurrentStash", "varastomafia05")
                                end
                            end
                    end
                else
                    Citizen.Wait(2500)
                end
            else
                Citizen.Wait(2500)
            end
        end
end)

-- MAFIA 06

Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1)
            if isLoggedIn and rg ~= nil then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if PlayerData.rikollinen.name == "mafia06" then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["autotallimafia06"].coords.x, Config.Locations["autotallimafia06"].coords.y, Config.Locations["autotallimafia06"].coords.z, true) < 10.0) then
                        DrawMarker(2, Config.Locations["autotallimafia06"].coords.x, Config.Locations["autotallimafia06"].coords.y, Config.Locations["autotallimafia06"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["autotallimafia06"].coords.x, Config.Locations["autotallimafia06"].coords.y, Config.Locations["autotallimafia06"].coords.z, true) < 1.5) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                DrawText3D(Config.Locations["autotallimafia06"].coords.x, Config.Locations["autotallimafia06"].coords.y, Config.Locations["autotallimafia06"].coords.z, "~g~E~w~ - Guardar Veiculo")
                            else
                                DrawText3D(Config.Locations["autotallimafia06"].coords.x, Config.Locations["autotallimafia06"].coords.y, Config.Locations["autotallimafia06"].coords.z, "~g~E~w~ - Talli")
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                else
                                    autotallimafia01()
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end 
                    end
                else
                    Citizen.Wait(2500)
                end
            else
                Citizen.Wait(2500)
            end
        end
end)

Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1)
            if isLoggedIn and rg ~= nil then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if PlayerData.rikollinen.name == "mafia06" then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["varastomafia06"].coords.x, Config.Locations["varastomafia06"].coords.y, Config.Locations["varastomafia06"].coords.z, true) < 10.0) then
                        DrawMarker(2, Config.Locations["varastomafia06"].coords.x, Config.Locations["varastomafia06"].coords.y, Config.Locations["varastomafia06"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["varastomafia06"].coords.x, Config.Locations["varastomafia06"].coords.y, Config.Locations["varastomafia06"].coords.z, true) < 1.5) then
                                DrawText3D(Config.Locations["varastomafia06"].coords.x, Config.Locations["varastomafia06"].coords.y, Config.Locations["varastomafia06"].coords.z, "~g~E~w~ - Armario ")
                            if IsControlJustReleased(0, Keys["E"]) then
                                print('nonce')
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", "varastomafia06", {
                                    maxweight = 4000000,
                                    slots = 500,
                                })
                                TriggerEvent("inventory:client:SetCurrentStash", "varastomafia06")
                                end
                            end
                    end
                else
                    Citizen.Wait(2500)
                end
            else
                Citizen.Wait(2500)
            end
        end
end)

-- MAFIA 07

Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1)
            if isLoggedIn and rg ~= nil then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if PlayerData.rikollinen.name == "mafia07" then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["autotallimafia07"].coords.x, Config.Locations["autotallimafia07"].coords.y, Config.Locations["autotallimafia07"].coords.z, true) < 10.0) then
                        DrawMarker(2, Config.Locations["autotallimafia07"].coords.x, Config.Locations["autotallimafia07"].coords.y, Config.Locations["autotallimafia07"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["autotallimafia07"].coords.x, Config.Locations["autotallimafia07"].coords.y, Config.Locations["autotallimafia07"].coords.z, true) < 1.5) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                DrawText3D(Config.Locations["autotallimafia07"].coords.x, Config.Locations["autotallimafia07"].coords.y, Config.Locations["autotallimafia07"].coords.z, "~g~E~w~ - Guardar Veiculo")
                            else
                                DrawText3D(Config.Locations["autotallimafia07"].coords.x, Config.Locations["autotallimafia07"].coords.y, Config.Locations["autotallimafia07"].coords.z, "~g~E~w~ - Talli")
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                else
                                    autotallimafia01()
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end 
                    end
                else
                    Citizen.Wait(2500)
                end
            else
                Citizen.Wait(2500)
            end
        end
end)

Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1)
            if isLoggedIn and rg ~= nil then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if PlayerData.rikollinen.name == "mafia07" then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["varastomafia07"].coords.x, Config.Locations["varastomafia07"].coords.y, Config.Locations["varastomafia07"].coords.z, true) < 10.0) then
                        DrawMarker(2, Config.Locations["varastomafia07"].coords.x, Config.Locations["varastomafia07"].coords.y, Config.Locations["varastomafia07"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["varastomafia07"].coords.x, Config.Locations["varastomafia07"].coords.y, Config.Locations["varastomafia07"].coords.z, true) < 1.5) then
                                DrawText3D(Config.Locations["varastomafia07"].coords.x, Config.Locations["varastomafia07"].coords.y, Config.Locations["varastomafia07"].coords.z, "~g~E~w~ - Armario ")
                            if IsControlJustReleased(0, Keys["E"]) then
                                print('nonce')
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", "varastomafia07", {
                                    maxweight = 4000000,
                                    slots = 500,
                                })
                                TriggerEvent("inventory:client:SetCurrentStash", "varastomafia07")
                                end
                            end
                    end
                else
                    Citizen.Wait(2500)
                end
            else
                Citizen.Wait(2500)
            end
        end
end)

-- MAFIA 08

Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1)
            if isLoggedIn and rg ~= nil then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if PlayerData.rikollinen.name == "mafia08" then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["autotallimafia08"].coords.x, Config.Locations["autotallimafia08"].coords.y, Config.Locations["autotallimafia08"].coords.z, true) < 10.0) then
                        DrawMarker(2, Config.Locations["autotallimafia08"].coords.x, Config.Locations["autotallimafia08"].coords.y, Config.Locations["autotallimafia08"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["autotallimafia08"].coords.x, Config.Locations["autotallimafia08"].coords.y, Config.Locations["autotallimafia08"].coords.z, true) < 1.5) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                DrawText3D(Config.Locations["autotallimafia08"].coords.x, Config.Locations["autotallimafia08"].coords.y, Config.Locations["autotallimafia08"].coords.z, "~g~E~w~ - Guardar Veiculo")
                            else
                                DrawText3D(Config.Locations["autotallimafia08"].coords.x, Config.Locations["autotallimafia08"].coords.y, Config.Locations["autotallimafia08"].coords.z, "~g~E~w~ - Talli")
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                else
                                    autotallimafia01()
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end 
                    end
                else
                    Citizen.Wait(2500)
                end
            else
                Citizen.Wait(2500)
            end
        end
end)

Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1)
            if isLoggedIn and rg ~= nil then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if PlayerData.rikollinen.name == "mafia08" then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["varastomafia08"].coords.x, Config.Locations["varastomafia08"].coords.y, Config.Locations["varastomafia08"].coords.z, true) < 10.0) then
                        DrawMarker(2, Config.Locations["varastomafia08"].coords.x, Config.Locations["varastomafia08"].coords.y, Config.Locations["varastomafia08"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["varastomafia08"].coords.x, Config.Locations["varastomafia08"].coords.y, Config.Locations["varastomafia08"].coords.z, true) < 1.5) then
                                DrawText3D(Config.Locations["varastomafia08"].coords.x, Config.Locations["varastomafia08"].coords.y, Config.Locations["varastomafia08"].coords.z, "~g~E~w~ - Armario ")
                            if IsControlJustReleased(0, Keys["E"]) then
                                print('nonce')
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", "varastomafia08", {
                                    maxweight = 4000000,
                                    slots = 500,
                                })
                                TriggerEvent("inventory:client:SetCurrentStash", "varastomafia08")
                                end
                            end
                    end
                else
                    Citizen.Wait(2500)
                end
            else
                Citizen.Wait(2500)
            end
        end
end)

-- AUTOTALLIT
function autotallimafia01()
    ped = GetPlayerPed(-1);
    MenuTitle = "Talli"
    ClearMenu()
    Menu.addButton("Ajoneuvot", "ajoneuvotmafia01", nil)
    Menu.addButton("SULJE", "closeMenuFull", nil) 
end

function autotallimafia02()
    ped = GetPlayerPed(-1);
    MenuTitle = "Talli"
    ClearMenu()
    Menu.addButton("Ajoneuvot", "ajoneuvotmafia02", nil)
    Menu.addButton("SULJE", "closeMenuFull", nil) 
end

function autotallimafia03()
    ped = GetPlayerPed(-1);
    MenuTitle = "Talli"
    ClearMenu()
    Menu.addButton("Ajoneuvot", "ajoneuvotmafia03", nil)
    Menu.addButton("SULJE", "closeMenuFull", nil) 
end

function autotallimafia04()
    ped = GetPlayerPed(-1);
    MenuTitle = "Talli"
    ClearMenu()
    Menu.addButton("Ajoneuvot", "ajoneuvotmafia04", nil)
    Menu.addButton("SULJE", "closeMenuFull", nil) 
end

function autotallimafia05()
    ped = GetPlayerPed(-1);
    MenuTitle = "Talli"
    ClearMenu()
    Menu.addButton("Ajoneuvot", "ajoneuvotmafia05", nil)
    Menu.addButton("SULJE", "closeMenuFull", nil) 
end

function autotallimafia06()
    ped = GetPlayerPed(-1);
    MenuTitle = "Talli"
    ClearMenu()
    Menu.addButton("Ajoneuvot", "ajoneuvotmafia06", nil)
    Menu.addButton("SULJE", "closeMenuFull", nil) 
end

function autotallimafia07()
    ped = GetPlayerPed(-1);
    MenuTitle = "Talli"
    ClearMenu()
    Menu.addButton("Ajoneuvot", "ajoneuvotmafia07", nil)
    Menu.addButton("SULJE", "closeMenuFull", nil) 
end

function autotallimafia08()
    ped = GetPlayerPed(-1);
    MenuTitle = "Talli"
    ClearMenu()
    Menu.addButton("Ajoneuvot", "ajoneuvotmafia08", nil)
    Menu.addButton("SULJE", "closeMenuFull", nil) 
end

-- AJONEUVOT
function ajoneuvotmafia01(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Ajoneuvot:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "AjoneuvoUlosmafia01", k, "Talli", " Moottori: 100%", " Kori: 100%", " Aine: 100%")
    end 
    Menu.addButton("TAKAISIN", "autotallimafia01", nil)
end

function ajoneuvotmafia02(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Ajoneuvot:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "AjoneuvoUlosmafia01", k, "Talli", " Moottori: 100%", " Kori: 100%", " Aine: 100%")
    end 
    Menu.addButton("TAKAISIN", "autotallimafia02", nil)
end

function ajoneuvotmafia03(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Ajoneuvot:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "AjoneuvoUlosmafia01", k, "Talli", " Moottori: 100%", " Kori: 100%", " Aine: 100%")
    end 
    Menu.addButton("TAKAISIN", "autotallimafia03", nil)
end

function ajoneuvotmafia04(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Ajoneuvot:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "AjoneuvoUlosmafia01", k, "Talli", " Moottori: 100%", " Kori: 100%", " Aine: 100%")
    end 
    Menu.addButton("TAKAISIN", "autotallimafia04", nil)
end

function ajoneuvotmafia05(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Ajoneuvot:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "AjoneuvoUlosmafia01", k, "Talli", " Moottori: 100%", " Kori: 100%", " Aine: 100%")
    end 
    Menu.addButton("TAKAISIN", "autotallimafia05", nil)
end

function ajoneuvotmafia06(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Ajoneuvot:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "AjoneuvoUlosmafia01", k, "Talli", " Moottori: 100%", " Kori: 100%", " Aine: 100%")
    end 
    Menu.addButton("TAKAISIN", "autotallimafia06", nil)
end

function ajoneuvotmafia07(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Ajoneuvot:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "AjoneuvoUlosmafia01", k, "Talli", " Moottori: 100%", " Kori: 100%", " Aine: 100%")
    end 
    Menu.addButton("TAKAISIN", "autotallimafia07", nil)
end

function ajoneuvotmafia08(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Ajoneuvot:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "AjoneuvoUlosmafia01", k, "Talli", " Moottori: 100%", " Kori: 100%", " Gasol: 100%")
    end 
    Menu.addButton("TAKAISIN", "autotallimafia08",nil)
end

function AjoneuvoUlosmafia01(vehicleInfo)
    local coords = Config.Locations["autotallimafia01"].coords
    rg.toiminnot.HaeAjoneuvo(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "MAFIA01"..tostring(math.random(1000, 9999)))
        local color = GetIsVehiclePrimaryColourCustom(veh)
        SetVehicleCustomPrimaryColour(veh, 224,0,0)
        SetVehicleCustomSecondaryColour(veh, 224,0,0)
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:AsetaOmistaja", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)
end

-- AJONEUVON OMINAISUUDET

function AjoneuvoUlosmafia05(vehicleInfo)
    local coords = Config.Locations["autotallimafia05"].coords
    rg.toiminnot.HaeAjoneuvo(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "MAFIA02"..tostring(math.random(1000, 9999)))
        local color = GetIsVehiclePrimaryColourCustom(veh)
        SetVehicleCustomPrimaryColour(veh, 224,0,0)
        SetVehicleCustomSecondaryColour(veh, 224,0,0)
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:AsetaOmistaja", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)
end

function AjoneuvoUlosmafia03(vehicleInfo)
    local coords = Config.Locations["autotallimafia03"].coords
    rg.toiminnot.HaeAjoneuvo(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "MAFIA03"..tostring(math.random(1000, 9999)))
        local color = GetIsVehiclePrimaryColourCustom(veh)
        SetVehicleCustomPrimaryColour(veh, 224,0,0)
        SetVehicleCustomSecondaryColour(veh, 224,0,0)
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:AsetaOmistaja", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)
end

function AjoneuvoUlosmafia02(vehicleInfo)
    local coords = Config.Locations["autotallimafia02"].coords
    rg.toiminnot.HaeAjoneuvo(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "MAFIA04"..tostring(math.random(1000, 9999)))
        local color = GetIsVehiclePrimaryColourCustom(veh)
        SetVehicleCustomPrimaryColour(veh, 224,0,0)
        SetVehicleCustomSecondaryColour(veh, 224,0,0)
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:AsetaOmistaja", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)
end

function AjoneuvoUlosCartel(vehicleInfo)
    local coords = Config.Locations["autotallimafia08"].coords
    rg.toiminnot.HaeAjoneuvo(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "MAFIA05"..tostring(math.random(1000, 9999)))
        local color = GetIsVehiclePrimaryColourCustom(veh)
        SetVehicleCustomPrimaryColour(veh, 0,0,0)
        SetVehicleCustomSecondaryColour(veh, 0,0,0)
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:AsetaOmistaja", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)
end

function AjoneuvoUlosmafia06(vehicleInfo)
    local coords = Config.Locations["autotallimafia06"].coords
    rg.toiminnot.HaeAjoneuvo(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "MAFIA06"..tostring(math.random(1000, 9999)))
        local color = GetIsVehiclePrimaryColourCustom(veh)
        SetVehicleCustomPrimaryColour(veh, 45, 216, 0)
        SetVehicleCustomSecondaryColour(veh, 45, 216, 0)
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:AsetaOmistaja", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)
end

function AjoneuvoUlosMafia(vehicleInfo)
    local coords = Config.Locations["autotallimafia07"].coords
    rg.toiminnot.HaeAjoneuvo(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "MAFIA07"..tostring(math.random(1000, 9999)))
        local color = GetIsVehiclePrimaryColourCustom(veh)
        SetVehicleCustomPrimaryColour(veh, 0,0,0)
        SetVehicleCustomSecondaryColour(veh, 0,0,0)
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:AsetaOmistaja", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)
end

function AjoneuvoUlosMafia(vehicleInfo)
    local coords = Config.Locations["autotallimafia08"].coords
    rg.toiminnot.HaeAjoneuvo(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "MAFIA08"..tostring(math.random(1000, 9999)))
        local color = GetIsVehiclePrimaryColourCustom(veh)
        SetVehicleCustomPrimaryColour(veh, 0,0,0)
        SetVehicleCustomSecondaryColour(veh, 0,0,0)
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:AsetaOmistaja", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)
end

-- VALIKKO

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end