rg = nil

Citizen.CreateThread(function()
	while rg == nil do
		TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)
		Citizen.Wait(0)
	end
end)



AddEventHandler('lockpick:client:openLockpick', function(callback)
    lockpickCallback = callback
    openLockpick(true)
end)

RegisterNUICallback('callback', function(data, cb)
    openLockpick(false)
	lockpickCallback(data.success)
    cb('ok')
end)

RegisterNUICallback('exit', function()
    openLockpick(false)
end)

openLockpick = function(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        toggle = bool,
    })
    SetCursorLocation(0.5, 0.2)
    lockpicking = bool
end