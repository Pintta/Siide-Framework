rg = nil
TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000)
        GenerateVehicleList()
        Citizen.Wait((1000 * 60) * 60)
    end
end)

RegisterServerEvent('scrapyard:server:LoadVehicleList')
AddEventHandler('scrapyard:server:LoadVehicleList', function()
    local src = source
    TriggerClientEvent("scapyard:client:setNewVehicles", src, Config.CurrentVehicles)
end)


RegisterServerEvent('scrapyard:server:ScrapVehicle')
AddEventHandler('scrapyard:server:ScrapVehicle', function(listKey)
    local src = source 
    local Player = rg.toiminnot.GetPlayer(src)
    if Config.CurrentVehicles[listKey] ~= nil then 
        for i = 1, math.random(3, 7), 1 do
            local item = Config.Items[math.random(1, #Config.Items)]
            Player.Functions.AddItem(item, math.random(35, 60))
            TriggerClientEvent('inventory:client:ItemBox', src, rg.datapankki.Items[item], 'add')
            Citizen.Wait(500)
        end
        local Luck = math.random(1, 8)
        local Odd = math.random(1, 8)
        if Luck == Odd then
            local random = math.random(20, 40)
            Player.Functions.AddItem("rubber", random)
            TriggerClientEvent('inventory:client:ItemBox', src, rg.datapankki.Items["rubber"], 'add')
        end
        Config.CurrentVehicles[listKey] = nil
        TriggerClientEvent("scapyard:client:setNewVehicles", -1, Config.CurrentVehicles)
    end
end)

function GenerateVehicleList()
    Config.CurrentVehicles = {}
    for i = 1, 20, 1 do
        local randVehicle = Config.Vehicles[math.random(1, #Config.Vehicles)]
        if not IsInList(randVehicle) then
            Config.CurrentVehicles[i] = randVehicle
        end
    end
    TriggerClientEvent("scapyard:client:setNewVehicles", -1, Config.CurrentVehicles)
end

function IsInList(name)
    local retval = false
    if Config.CurrentVehicles ~= nil and next(Config.CurrentVehicles) ~= nil then 
        for k, v in pairs(Config.CurrentVehicles) do
            if Config.CurrentVehicles[k] == name then 
                retval = true
            end
        end
    end
    return retval
end
