secondsUntilKick = 1800

local group = "user"
local isLoggedIn = false

rg = nil

TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)

RegisterNetEvent('rg:Client:OnPlayerLoaded')
AddEventHandler('rg:Client:OnPlayerLoaded', function()
    rg.toiminnot.HuutoKaiku('afkkick:server:GetPermissions', function(UserGroup)
        group = UserGroup
    end)
    isLoggedIn = true
end)

RegisterNetEvent('rg:Client:OnPermissionUpdate')
AddEventHandler('rg:Client:OnPermissionUpdate', function(UserGroup)
    group = UserGroup
end)


Citizen.CreateThread(function()
	while true do
		Wait(1000)
        playerPed = GetPlayerPed(-1)
        if isLoggedIn then
            if group == "user" then
                currentPos = GetEntityCoords(playerPed, true)
                if prevPos ~= nil then
                    if currentPos == prevPos then
                        if time ~= nil then
                            if time > 0 then
                                if time == (900) then
                                    rg.toiminnot.Notify('You are AFK and you are about to be ' .. math.ceil(time / 60) .. ' minutes kicked!', 'error', 10000)
                                elseif time == (600) then
                                    rg.toiminnot.Notify('You are AFK and you are about to be ' .. math.ceil(time / 60) .. ' minutes kicked!', 'error', 10000)
                                elseif time == (300) then
                                    rg.toiminnot.Notify('You are AFK and you are about to be ' .. math.ceil(time / 60) .. ' minutes kicked!', 'error', 10000)
                                elseif time == (150) then
                                    rg.toiminnot.Notify('You are AFK and you are about to be ' .. math.ceil(time / 60) .. ' minutes kicked!', 'error', 10000)   
                                elseif time == (60) then
                                    rg.toiminnot.Notify('You are AFK and you are about to be ' .. math.ceil(time / 60) .. ' minutes kicked!', 'error', 10000) 
                                elseif time == (30) then
                                    rg.toiminnot.Notify('You are AFK and you are about to be ' .. time .. ' seconds kicked!', 'error', 10000)  
                                elseif time == (20) then
                                    rg.toiminnot.Notify('You are AFK and you are about to be ' .. time .. ' seconds kicked!', 'error', 10000)    
                                elseif time == (10) then
                                    rg.toiminnot.Notify('You are AFK and you are about to be ' .. time .. ' seconds kicked!', 'error', 10000)                                                                                                             
                                end
                                time = time - 1
                            else
                                TriggerServerEvent("KickForAFK")
                            end
                        else
                            time = secondsUntilKick
                        end
                    else
                        time = secondsUntilKick
                    end
                end
                prevPos = currentPos
            end
        end
    end
end)