rg = nil
isLoggedIn = false
local requiredItemsShowed = false

Citizen.CreateThread(function()
	while rg == nil do
		TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)
		Citizen.Wait(0)
	end
end)

function DrawText3Ds(x, y, z, text)
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
	while true do
		local inRange = false
		if rg ~= nil then
			local requiredItems = {[1] = {name = rg.datapankki.Items["cryptostick"]["name"], image = rg.datapankki.Items["cryptostick"]["image"]},}
			if isLoggedIn then
				local ped = GetPlayerPed(-1)
				local pos = GetEntityCoords(ped)
				local dist = GetDistanceBetweenCoords(pos, Crypto.Exchange.coords.x, Crypto.Exchange.coords.y, Crypto.Exchange.coords.z, true)
				if dist < 15 then
					inRange = true
					if dist < 1.5 then
						if not Crypto.Exchange.RebootInfo.state then
							DrawText3Ds(Crypto.Exchange.coords.x, Crypto.Exchange.coords.y, Crypto.Exchange.coords.z, '~g~E~w~ - kytke usb tikku')
							if not requiredItemsShowed then
								requiredItemsShowed = true
								TriggerEvent('inventory:client:requiredItems', requiredItems, true)
							end
							if IsControlJustPressed(0, Keys["E"]) then
								rg.toiminnot.HuutoKaiku('crypto:server:HasSticky', function(HasItem)
									if HasItem then
										TriggerEvent("mhacking:show")
										TriggerEvent("mhacking:start", math.random(4, 6), 45, HackingSuccess)
									else
										rg.toiminnot.Notify('Sinulla ei ole oikeaa usb-tikkua..', 'error')
									end
								end)
							end
						else
							DrawText3Ds(Crypto.Exchange.coords.x, Crypto.Exchange.coords.y, Crypto.Exchange.coords.z, 'tietokone käynnistyy uudelleen - '..Crypto.Exchange.RebootInfo.percentage..'%')
						end
					else
						if requiredItemsShowed then
							requiredItemsShowed = false
							TriggerEvent('inventory:client:requiredItems', requiredItems, false)
						end
					end
				end
			end
		end
		if not inRange then
			Citizen.Wait(5000)
		end
		Citizen.Wait(3)
    end
end)

function ExchangeSuccess()
	TriggerServerEvent('crypto:server:ExchangeSuccess', math.random(1, 10))
end

function ExchangeFail()
	local Odd = 5
	local RemoveChance = math.random(1, Odd)
	local LosingNumber = math.random(1, Odd)
	if RemoveChance == LosingNumber then
		TriggerServerEvent('crypto:server:ExchangeFail')
		TriggerServerEvent('crypto:server:SyncReboot')
	end
end

RegisterNetEvent('crypto:client:SyncReboot')
AddEventHandler('crypto:client:SyncReboot', function()
	Crypto.Exchange.RebootInfo.state = true
	SystemCrashCooldown()
end)

function SystemCrashCooldown()
	Citizen.CreateThread(function()
		while Crypto.Exchange.RebootInfo.state do
			if (Crypto.Exchange.RebootInfo.percentage + 1) <= 100 then
				Crypto.Exchange.RebootInfo.percentage = Crypto.Exchange.RebootInfo.percentage + 1
				TriggerServerEvent('crypto:server:Rebooting', true, Crypto.Exchange.RebootInfo.percentage)
			else
				Crypto.Exchange.RebootInfo.percentage = 0
				Crypto.Exchange.RebootInfo.state = false
				TriggerServerEvent('crypto:server:Rebooting', false, 0)
			end
			Citizen.Wait(1200)
		end
	end)
end

function HackingSuccess(success, timeremaining)
    if success then
        TriggerEvent('mhacking:hide')
        ExchangeSuccess()
    else
		TriggerEvent('mhacking:hide')
		ExchangeFail()
	end
end

RegisterNetEvent('rg:Client:OnPlayerLoaded')
AddEventHandler('rg:Client:OnPlayerLoaded', function()
	isLoggedIn = true
	TriggerServerEvent('crypto:server:FetchWorth')
	TriggerServerEvent('crypto:server:GetRebootState')
end)

RegisterNetEvent('crypto:client:UpdateCryptoWorth')
AddEventHandler('crypto:client:UpdateCryptoWorth', function(crypto, amount, history)
	Crypto.Worth[crypto] = amount
	if history ~= nil then
		Crypto.History[crypto] = history
	end
end)

RegisterNetEvent('crypto:client:GetRebootState')
AddEventHandler('crypto:client:GetRebootState', function(RebootInfo)
	if RebootInfo.state then
		Crypto.Exchange.RebootInfo.state = RebootInfo.state
		Crypto.Exchange.RebootInfo.percentage = RebootInfo.percentage
		SystemCrashCooldown()
	end
end)

Citizen.CreateThread(function()
	isLoggedIn = true
	TriggerServerEvent('crypto:server:FetchWorth')
	TriggerServerEvent('crypto:server:GetRebootState')
end)