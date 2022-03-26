Config = {}

Config.AttachedVehicle = nil

Config.Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

Config.AutrgzedIds = {
    "CITIZENID",
}

Config.MaxStatusValues = {
    ["engine"] = 1000.0,
    ["body"] = 1000.0,
    ["radiator"] = 100,
    ["axle"] = 100,
    ["brakes"] = 100,
    ["clutch"] = 100,
    ["fuel"] = 100,
}

Config.ValuesLabels = {
    ["engine"] = "Motor",
    ["body"] = "Chassi",
    ["radiator"] = "Radiador",
    ["axle"] = "Eixo de Transmissão",
    ["brakes"] = "Travões",
    ["clutch"] = "Transmissão",
    ["fuel"] = "Tanque de Combustivel",
}

Config.RepairCost = {
    ["body"] = "plastic",
    ["radiator"] = "plastic",
    ["axle"] = "steel",
    ["brakes"] = "iron",
    ["clutch"] = "aluminum",
    ["fuel"] = "plastic",
}

Config.RepairCostAmount = {
    ["engine"] = {item = "metalscrap", costs = 0},
    ["body"] = {item = "plastic", costs = 0},
    ["radiator"] = {item = "steel", costs = 0},
    ["axle"] = {item = "aluminum", costs = 0},
    ["brakes"] = {item = "copper", costs = 0},
    ["clutch"] = {item = "copper", costs = 0},
    ["fuel"] = {item = "plastic", costs = 0},
}

Config.Businesses = {
    "FIRMA",
}

Config.Plates = {
    [1] = {coords = {x = 937.91, y = -970.64, z = 39.49, h = 271.5, r = 1.0}, AttachedVehicle = nil},
    [2] = {coords = {x = 922.37, y = -979.86, z = 39.49, h = 271.5, r = 1.0}, AttachedVehicle = nil},
    [3] = {coords = {x = 921.54, y = -962.17, z = 39.49, h = 274.5, r = 1.0}, AttachedVehicle = nil},
    [4] = {coords = {x = 949.89, y = -947.75, z = 39.49, h = 90.5, r = 1.0}, AttachedVehicle = nil},
}

Config.Locations = {
    ["exit"] = {x = 945.13, y = -975.84, z = 39.49, h = 181.5, r = 1.0},
    ["stash"] = {x = 947.62, y = -972.46, z = 39.49, h = 274.5, r = 1.0},
    ["duty"] = {x = 950.73, y = -968.64, z = 39.5, h = 180.5, r = 1.0},
    ["vehicle"] = {x = 937.93, y = -990.7, z = 38.42, h = 94.5, r = 1.0}, 
}

Config.Vehicles = {
    ["flatbed"] = "Flatbed",
}

Config.MinimalMetersForDamage = {
    [1] = {min = 8000, max = 12000, multiplier = {min = 1, max = 8}},
    [2] = {min = 12000, max = 16000, multiplier = {min = 8, max = 16}},
    [3] = {min = 12000, max = 16000, multiplier = {min = 16, max = 24}},
}

Config.Damages = {
    ["radiator"] = "Moottori leipas kiinni",
    ["axle"] = "Alusta lahonnut",
    ["brakes"] = "Jarrut leikanneet kiinni",
    ["clutch"] = "Vaihdelaatikko taitaa olla säpäleinä",
    ["fuel"] = "Jotain vuotaa ja pahasti",
}