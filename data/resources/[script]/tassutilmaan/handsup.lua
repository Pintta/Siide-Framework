
Citizen.CreateThread(function()

	while true do
		Citizen.Wait(5)

			if (IsControlJustPressed(0,73)) then
			local player = PlayerPedId()
	
			if (DoesEntityExist(player) and not IsEntityDead(player)) then
	
				if IsEntityPlayingAnim(player, "random@mugging3", "handsup_standing_base", 3) then
					ClearPedSecondaryTask(player)
				else
					loadAnimDict("random@mugging3")
					TaskPlayAnim(player, "random@mugging3", "handsup_standing_base", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
					RemoveAnimDict("random@mugging3")
				end
			end
		end
	end
end)

function loadAnimDict(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(500)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)


		if IsControlJustReleased(0, 73) then
			ClearPedTasks(PlayerPedId())
		end
				end
			end)
