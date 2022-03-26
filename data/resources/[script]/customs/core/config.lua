Config = Config or {}

Config.detailCardMenuPosition = 0
Config.cashPosition = 0
Config.IsUpgradesOnlyForWhitelistJobPoints = true

Config.Keys = {
    action = {key = 38, label = 'E', name = '~INPUT_PICKUP~'}
}

Config.DefaultActionDistance = 8.0

Config.DefaultBlip = {
    enable = true,
    type = 72,
    color = 0,
    title = 'Korjauspenkki',
    scale = 0.5
}

Config.Positions = {
    { -- bennys
        pos = {x = -338.93, y = -135.96, z = 38.33},
        whitelistJobName = 'mechanic',
        blip = {
            enable = true,
            type = 72,
            color = 0,
            title = 'Mekaanikko',
            scale = 0.5
        },
        actionDistance = 7.0
    },
    { -- topsecret
        pos = {x = 732.29, y = -1088.72, z = 21.73},
        whitelistJobName = 'topsecret',
        blip = {
            enable = true,
            type = 72,
            color = 0,
            title = 'Top Secret',
            scale = 0.5
        },
    }
}