local mutedPlayers = {}

local volumes = {
	['radio'] = tonumber(GetConvar('voice_defaultVolume', '0.3')) + 0.0,
	['phone'] = tonumber(GetConvar('voice_defaultVolume', '0.3')) + 0.0,
}

radioEnabled, radioPressed, mode = false, false, 2
radioData = {}
callData = {}

function setVolume(volume, volumeType)
	type_check({volume, "number"})
	local volume = volume
	volume = volume / 100
	if volumeType then
		local volumeTbl = volumes[volumeType]
		if volumeTbl then
			LocalPlayer.state:set(volumeType, volume, true)
			volumes[volumeType] = volume
		else
			error(('setVolume got a invalid volume type %s'):format(volumeType))
		end
	else
		for _type, vol in pairs(volumes) do
			volumes[_type] = volume
			LocalPlayer.state:set(_type, volume, true)
		end
	end
end

exports('setRadioVolume', function(vol)
	setVolume(vol, 'radio')
end)
exports('getRadioVolume', function()
	return volumes['radio']
end)
exports("setCallVolume", function(vol)
	setVolume(vol, 'phone')
end)
exports('getCallVolume', function()
	return volumes['phone']
end)

if gameVersion == 'fivem' then
	radioEffectId = CreateAudioSubmix('Radio')
	SetAudioSubmixEffectRadioFx(radioEffectId, 0)
	SetAudioSubmixEffectParamInt(radioEffectId, 0, GetHashKey('default'), 1)
	AddAudioSubmixOutput(radioEffectId, 0)
	phoneEffectId = CreateAudioSubmix('Phone')
	SetAudioSubmixEffectRadioFx(phoneEffectId, 1)
	SetAudioSubmixEffectParamInt(phoneEffectId, 1, GetHashKey('default'), 1)
	SetAudioSubmixEffectParamFloat(phoneEffectId, 1, GetHashKey('freq_low'), 300.0)
	SetAudioSubmixEffectParamFloat(phoneEffectId, 1, GetHashKey('freq_hi'), 6000.0)
	AddAudioSubmixOutput(phoneEffectId, 1)
end

local submixFunctions = {
	['radio'] = function(plySource)
		MumbleSetSubmixForServerId(plySource, radioEffectId)
	end,
	['phone'] = function(plySource)
		MumbleSetSubmixForServerId(plySource, phoneEffectId)
	end
}

local disableSubmixReset = {}

function toggleVoice(plySource, enabled, moduleType)
	if mutedPlayers[plySource] then return end
	logger.verbose('[main] Updating %s to talking: %s with submix %s', plySource, enabled, moduleType)
	if enabled then
		MumbleSetVolumeOverrideByServerId(plySource, enabled and volumes[moduleType])
		if GetConvarInt('voice_enableSubmix', 0) == 1 and gameVersion == 'fivem' then
			if moduleType then
				disableSubmixReset[plySource] = true
				submixFunctions[moduleType](plySource)
			else
				MumbleSetSubmixForServerId(plySource, -1)
			end
		end
	else
		if GetConvarInt('voice_enableSubmix', 0) == 1 and gameVersion == 'fivem' then
			-- garbage collect it
			disableSubmixReset[plySource] = nil
			SetTimeout(250, function()
				if not disableSubmixReset[plySource] then
					MumbleSetSubmixForServerId(plySource, -1)
				end
			end)
		end
		MumbleSetVolumeOverrideByServerId(plySource, -1.0)
	end
end

function playerTargets(...)
	local targets = {...}
	local addedPlayers = {[playerServerId] = true}
	for i = 1, #targets do
		for id, _ in pairs(targets[i]) do
			-- we don't want to log ourself, or listen to ourself
			if addedPlayers[id] and id ~= playerServerId then
				logger.verbose('[main] %s is already target don\'t re-add', id)
				goto skip_loop
			end
			if not addedPlayers[id] then
				logger.verbose('[main] Adding %s as a voice target', id)
				addedPlayers[id] = true
				MumbleAddVoiceTargetPlayerByServerId(voiceTarget, id)
			end
			::skip_loop::
		end
	end
end

function playMicClicks(clickType)
	if micClicks ~= 'true' then return end
	SendNUIMessage({sound = (clickType and "audio_on" or "audio_off"), volume = (clickType and (volumes["radio"]) or 0.05)})
end

function toggleMutePlayer(source)
	if mutedPlayers[source] then
		mutedPlayers[source] = nil
		MumbleSetVolumeOverrideByServerId(source, -1.0)
	else
		mutedPlayers[source] = true
		MumbleSetVolumeOverrideByServerId(source, 0.0)
	end
end

exports('toggleMutePlayer', toggleMutePlayer)

function setVoiceProperty(type, value)
	if type == "radioEnabled" then
		radioEnabled = value
		SendNUIMessage({
			radioEnabled = value
		})
	elseif type == "micClicks" then
		local val = tostring(value)
		micClicks = val
		SetResourceKvp('pma-voice_enableMicClicks', val)
	end
end
exports('setVoiceProperty', setVoiceProperty)
exports('SetMumbleProperty', setVoiceProperty)
exports('SetTokoProperty', setVoiceProperty)
local externalAddress = ''
local externalPort = 0

CreateThread(function()
	while true do
		Wait(500)
		if GetConvar('voice_externalAddress', '') ~= externalAddress or GetConvarInt('voice_externalPort', 0) ~= externalPort then
			externalAddress = GetConvar('voice_externalAddress', '')
			externalPort = GetConvarInt('voice_externalPort', 0)
			MumbleSetServerAddress(GetConvar('voice_externalAddress', ''), GetConvarInt('voice_externalPort', 0))
		end
	end
end)


if gameVersion == 'redm' then
	CreateThread(function()
		while true do
			if IsControlJustPressed(0, 0xA5BDCD3C --[[ Right Bracket ]]) then
				ExecuteCommand('cycleproximity')
			end
			if IsControlJustPressed(0, 0x430593AA --[[ Left Bracket ]]) then
				ExecuteCommand('+radiotalk')
			elseif IsControlJustReleased(0, 0x430593AA --[[ Left Bracket ]]) then
				ExecuteCommand('-radiotalk')
			end

			Wait(0)
		end
	end)
end
