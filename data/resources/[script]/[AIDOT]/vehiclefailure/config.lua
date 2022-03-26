BackEngineVehicles = {
    'ninef',
    'adder',
    'vagner',
    't20',
    'infernus',
    'zentorno',
    'reaper',
    'comet2',
    'comet3',
    'jester',
    'jester2',
    'cheetah',
    'cheetah2',
    'prototipo',
    'turismor',
    'pfister811',
    'ardent',
    'nero',
    'nero2',
    'tempesta',
    'vacca',
    'bullet',
    'osiris',
    'entityxf',
    'turismo2',
    'fmj',
    're7b',
    'tyrus',
    'italigtb',
    'penetrator',
    'monroe',
    'ninef2',
    'stingergt',
    'surfer',
    'surfer2',
    'comet3',
}

	Config			= {}
	Config.Paid		= true
	Config.Price	= 199

cfg = {
	deformationMultiplier = -1,
	deformationExponent = 0.4,
	collisionDamageExponent = 0.6,
	damageFactorEngine = 3.0,
	damageFactorBody = 3.0,
	damageFactorPetrolTank = 32.0,
	engineDamageExponent = 0.3,
	weaponsDamageMultiplier = 1.2,
	degradingHealthSpeedFactor = 2,
	cascadingFailureSpeedFactor = 4.0,
	degradingFailureThreshold = 250.0,
	cascadingFailureThreshold = 200.0,
	engineSafeGuard = 50.0,
	torqueMultiplierEnabled = true,
	limpMode = false,
	limpModeMultiplier = 0.15,
	preventVehicleFlip = true,
	sundayDriver = true,
	sundayDriverAcceleratorCurve = 7.5,
	sundayDriverBrakeCurve = 5.0,
	displayBlips = false,
	compatibilityMode = false,
	randomTireBurstInterval = 0,
	classDamageMultiplier = {[0] = 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.0, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3}
}

repairCfg = {
	mechanics = {},
	fixMessages = { "Poista ruoste pepsodentilla..",},
    fixMessageCount = 7,
    noFixMessages = {"Never try to make something that isn't broken, but you didn't listen"},
	noFixMessageCount = 6
}

RepairEveryoneWhitelisted = true