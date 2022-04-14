local radioChannel = 0

function syncRadioData(radioTable)
	radioData = radioTable
	logger.info('[radio] Syncing radio table.')
	if GetConvarInt('voice_debugMode', 0) >= 4 then
		print('-------- RADIO TABLE --------')
		tPrint(radioData)
		print('-----------------------------')
	end
	for tgt, enabled in pairs(radioTable) do
		if tgt ~= playerServerId then
			toggleVoice(tgt, enabled, 'radio')
		end
	end
end
RegisterNetEvent('pma-voice:syncRadioData', syncRadioData)

function setTalkingOnRadio(plySource, enabled)
	toggleVoice(plySource, enabled, 'radio')
	radioData[plySource] = enabled
	playMicClicks(enabled)
end

RegisterNetEvent('pma-voice:setTalkingOnRadio', setTalkingOnRadio)

function addPlayerToRadio(plySource)
	radioData[plySource] = false
	if radioPressed then
		logger.info('[radio] %s joined radio %s while we were talking, adding them to targets', plySource, radioChannel)
		playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
	else
		logger.info('[radio] %s joined radio %s', plySource, radioChannel)
	end
end
RegisterNetEvent('pma-voice:addPlayerToRadio', addPlayerToRadio)

function removePlayerFromRadio(plySource)
	if plySource == playerServerId then
		logger.info('[radio] Left radio %s, cleaning up.', radioChannel)
		for tgt, _ in pairs(radioData) do
			if tgt ~= playerServerId then
				toggleVoice(tgt, false, 'radio')
			end
		end
		radioData = {}
		playerTargets(MumbleIsPlayerTalking(PlayerId()) and callData or {})
	else
		radioData[plySource] = nil
		toggleVoice(plySource, false)
		if radioPressed then
			logger.info('[radio] %s left radio %s while we were talking, updating targets.', plySource, radioChannel)
			playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
		else
			logger.info('[radio] %s has left radio %s', plySource, radioChannel)
		end
	end
end
RegisterNetEvent('pma-voice:removePlayerFromRadio', removePlayerFromRadio)

function setRadioChannel(channel)
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	TriggerServerEvent('pma-voice:setPlayerRadio', channel)
	radioChannel = channel
	if GetConvarInt('voice_enableUi', 1) == 1 then
		SendNUIMessage({
			radioChannel = channel,
			radioEnabled = radioEnabled
		})
	end
end

exports('setRadioChannel', setRadioChannel)
exports('SetRadioChannel', setRadioChannel)

exports('removePlayerFromRadio', function()
	setRadioChannel(0)
end)

exports('addPlayerToRadio', function(_radio)
	local radio = tonumber(_radio)
	if radio then
		setRadioChannel(radio)
	end
end)

function isDead()
	if GetResourceState("pma-ambulance") ~= "missing" then
		if LocalPlayer.state.isDead then
			return true
		end
	elseif IsPlayerDead(PlayerId()) then
		return true
	end
end

RegisterCommand('+radiotalk', function()
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	if isDead() then return end
	if not radioPressed and radioEnabled then
		if radioChannel > 0 then
			logger.info('[radio] Start broadcasting, update targets and notify server.')
			playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
			TriggerServerEvent('pma-voice:setTalkingOnRadio', true)
			radioPressed = true
			playMicClicks(true)
			if GetConvarInt('voice_enableRadioAnim', 0) == 1 and not (GetConvarInt('voice_disableVehicleRadioAnim', 0) == 1 and IsPedInAnyVehicle(PlayerPedId(), false)) then
				RequestAnimDict('random@arrests')
				while not HasAnimDictLoaded('random@arrests') do
					Citizen.Wait(10)
				end
				TaskPlayAnim(PlayerPedId(), "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0)
			end
			Citizen.CreateThread(function()
				TriggerEvent("pma-voice:radioActive", true)
				while radioPressed do
					Wait(0)
					SetControlNormal(0, 249, 1.0)
					SetControlNormal(1, 249, 1.0)
					SetControlNormal(2, 249, 1.0)
				end
			end)
		end
	end
end, false)

RegisterCommand('-radiotalk', function()
	if radioChannel > 0 or radioEnabled and radioPressed then
		radioPressed = false
		MumbleClearVoiceTargetPlayers(voiceTarget)
		playerTargets(MumbleIsPlayerTalking(PlayerId()) and callData or {})
		TriggerEvent("pma-voice:radioActive", false)
		playMicClicks(false)
		if GetConvarInt('voice_enableRadioAnim', 0) == 1 then
			StopAnimTask(PlayerPedId(), "random@arrests", "generic_radio_enter", -4.0)
		end
		TriggerServerEvent('pma-voice:setTalkingOnRadio', false)
	end
end, false)
if gameVersion == 'fivem' then
	RegisterKeyMapping('+radiotalk', 'Talk over Radio', 'keyboard', GetConvar('voice_defaultRadio', 'LMENU'))
end

function syncRadio(_radioChannel)
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	logger.info('[radio] radio set serverside update to radio %s', radioChannel)
	radioChannel = _radioChannel
end

RegisterNetEvent('pma-voice:clSetPlayerRadio', syncRadio)
