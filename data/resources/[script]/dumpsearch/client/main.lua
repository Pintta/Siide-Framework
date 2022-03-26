rg = nil

local PlayerData = {}
local isLoggedIn = false
local percent    = false
local searching  = false

cachedBins = {}

closestBin = {
    'prop_dumpster_01a',
    'prop_dumpster_02a',
    'prop_dumpster_02b',
    'prop_cs_dumpster_01a',
    'p_dumpster_t',
    'prop_dumpster_3a',
    'prop_dumpster_4b',
    'prop_dumpster_4',
    'prop_dumpster_01a',
    'prop_snow_dumpster_01',
    'prop_bin_07b',
    'prop_bin_beach_01d',
    'prop_bin_01a',
    'prop_bin_beach_01a',
    'prop_bin_delpiero_b',
    'zprop_bin_01a_old',
    'prop_bin_07c',
    'prop_bin_10b',
    'prop_bin_10a',
    'prop_bin_14a',
    'prop_bin_11a',
    'prop_bin_06a',
    'prop_bin_07d',
    'prop_bin_11b',
    'prop_bin_04a',
    'prop_bin_delpiero',
    'prop_bin_09a',
    'prop_bin_08a',
    'prop_bin_02a',
    'prop_bin_03a',
    'prop_bin_13a',
    'prop_bin_08open',
    'prop_bin_12a',
    'prop_bin_14b',
    'prop_bin_05a',
    'prop_bin_07a'
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if rg == nil then
            TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)
            Citizen.Wait(200)
        end
    end
end)

RegisterNetEvent("rg:Client:OnPlayerLoaded")
AddEventHandler("rg:Client:OnPlayerLoaded", function()
    PlayerJob = rg.toiminnot.GetPlayerData().job
    isLoggedIn = true
end)


DrawText3Ds = function(x, y, z, text)
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

Citizen.CreateThread(function()
    Citizen.Wait(100)
    while true do
        
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for i = 1, #closestBin do
            local x = GetClosestObjectOfType(playerCoords, 1.0, GetHashKey(closestBin[i]), false, false, false)
            local entity = nil
            if DoesEntityExist(x) then
                sleep  = 5
                entity = x
                bin    = GetEntityCoords(entity)
                if IsControlJustReleased(0, 38) then
                    if not cachedBins[entity] then
                        openBin(entity)
                    else	
                        rg.toiminnot.Notify('No voi vittu..',"error", 3500)
                    end
                end
                break
            else
                sleep = 1000
            end
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    while true do

        local sleep = 1000

        if percent then

            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            for i = 1, #closestBin do

                local x = GetClosestObjectOfType(playerCoords, 1.0, GetHashKey(closestBin[i]), false, false, false)
                local entity = nil
                
                if DoesEntityExist(x) then
                    sleep  = 5
                    entity = x
                    bin    = GetEntityCoords(entity)
                    DrawText3Ds(bin.x, bin.y, bin.z + 1.5, TimeLeft .. '~g~%~s~')
                    break
                end
            end
        end
        Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if searching then
            DisableControlAction(0, 73) 
        end
    end
end)

openBin = function(entity)
    rg.toiminnot.Progressbar("search_register", "Tutkit..", 18000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "amb@prop_human_bum_bin@base",
        anim = "base",
        flags = 50,
    }, {}, {}, function()
        searching = true
        cachedBins[entity] = true
        rg.toiminnot.HuutoKaiku('dumpsearch:getItem', function(result)
        end)
        ClearPedTasks(PlayerPedId())
        StopAnimTask(GetPlayerPed(-1), "amb@prop_human_bum_bin@base", "base", 1.0)
        searching = false  
    end, function()
        GetMoney = false
        StopAnimTask(GetPlayerPed(-1), "amb@prop_human_bum_bin@base", "base", 1.0)
        ClearPedTasks(GetPlayerPed(-1))
        rg.toiminnot.Notify("No nyt meni ihan vituiksi..", "error")
    end)
	
end