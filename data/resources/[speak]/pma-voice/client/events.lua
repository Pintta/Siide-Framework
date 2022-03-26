AddEventHandler('mumbleConnected', function(address, isReconnecting)
	local voiceModeData = Cfg.voiceModes[mode]
	MumbleSetAudioInputDistance(voiceModeData[1] + 0.0)
	LocalPlayer.state:set('proximity', {
		index = mode,
		distance =  voiceModeData[1],
		mode = voiceModeData[2],
	}, true)
	MumbleSetTalkerProximity(voiceModeData[1] + 0.0)
	MumbleClearVoiceTarget(voiceTarget)
	MumbleSetVoiceTarget(voiceTarget)
	MumbleSetVoiceChannel(playerServerId)
	while MumbleGetVoiceChannelFromServerId(playerServerId) ~= playerServerId do
		Wait(250)
	end
	MumbleAddVoiceTargetChannel(voiceTarget, playerServerId)
	addNearbyPlayers()
end)

AddEventHandler('mumbleDisconnected', function(address)
end)

AddEventHandler('pma-voice:settingsCallback', function(cb)
	cb(Cfg)
end)