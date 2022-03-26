rg = nil
TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)

local VehicleStatus = {}
local VehicleDrivingDistance = {}

rg.toiminnot.CreateCallback('vehicletuning:server:GetDrivingDistances', function(source, cb)
    cb(VehicleDrivingDistance)
end)

RegisterServerEvent("vehiclemod:server:setupVehicleStatus")
AddEventHandler("vehiclemod:server:setupVehicleStatus", function(plate, engineHealth, bodyHealth)
    local src = source
    local engineHealth = engineHealth ~= nil and engineHealth or 1000.0
    local bodyHealth = bodyHealth ~= nil and bodyHealth or 1000.0
    if VehicleStatus[plate] == nil then 
        if IsVehicleOwned(plate) then
            local statusInfo = GetVehicleStatus(plate)
            if statusInfo == nil then 
                statusInfo =  {
                    ["engine"] = engineHealth,
                    ["body"] = bodyHealth,
                    ["radiator"] = Config.MaxStatusValues["radiator"],
                    ["axle"] = Config.MaxStatusValues["axle"],
                    ["brakes"] = Config.MaxStatusValues["brakes"],
                    ["clutch"] = Config.MaxStatusValues["clutch"],
                    ["fuel"] = Config.MaxStatusValues["fuel"],
                }
            end
            VehicleStatus[plate] = statusInfo
            TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, statusInfo)
        else
            local statusInfo = {
                ["engine"] = engineHealth,
                ["body"] = bodyHealth,
                ["radiator"] = Config.MaxStatusValues["radiator"],
                ["axle"] = Config.MaxStatusValues["axle"],
                ["brakes"] = Config.MaxStatusValues["brakes"],
                ["clutch"] = Config.MaxStatusValues["clutch"],
                ["fuel"] = Config.MaxStatusValues["fuel"],
            }
            VehicleStatus[plate] = statusInfo
            TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, statusInfo)
        end
    else
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterServerEvent('vehicletuning:server:UpdateDrivingDistance')
AddEventHandler('vehicletuning:server:UpdateDrivingDistance', function(amount, plate)
    VehicleDrivingDistance[plate] = amount

    TriggerClientEvent('vehicletuning:client:UpdateDrivingDistance', -1, VehicleDrivingDistance[plate], plate)

    rg.toiminnot.datasilta(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            rg.toiminnot.datasilta(false, "UPDATE `player_vehicles` SET `drivingdistance` = '"..amount.."' WHERE `plate` = '"..plate.."'")
        end
    end)
end)

rg.toiminnot.CreateCallback('vehicletuning:server:IsVehicleOwned', function(source, cb, plate)
    local retval = false
    rg.toiminnot.datasilta(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = true
        end
        cb(retval)
    end)
end)

RegisterServerEvent('vehicletuning:server:LoadStatus')
AddEventHandler('vehicletuning:server:LoadStatus', function(veh, plate)
    VehicleStatus[plate] = veh
    TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, veh)
end)

RegisterServerEvent("vehiclemod:server:updatePart")
AddEventHandler("vehiclemod:server:updatePart", function(plate, part, level)
    if VehicleStatus[plate] ~= nil then
        if part == "engine" or part == "body" then
            VehicleStatus[plate][part] = level
            if VehicleStatus[plate][part] < 0 then
                VehicleStatus[plate][part] = 0
            elseif VehicleStatus[plate][part] > 1000 then
                VehicleStatus[plate][part] = 1000.0
            end
        else
            VehicleStatus[plate][part] = level
            if VehicleStatus[plate][part] < 0 then
                VehicleStatus[plate][part] = 0
            elseif VehicleStatus[plate][part] > 100 then
                VehicleStatus[plate][part] = 100
            end
        end
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterServerEvent('vehicletuning:server:SetPartLevel')
AddEventHandler('vehicletuning:server:SetPartLevel', function(plate, part, level)
    if VehicleStatus[plate] ~= nil then
        VehicleStatus[plate][part] = level
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterServerEvent("vehiclemod:server:fixEverything")
AddEventHandler("vehiclemod:server:fixEverything", function(plate)
    if VehicleStatus[plate] ~= nil then 
        for k, v in pairs(Config.MaxStatusValues) do
            VehicleStatus[plate][k] = v
        end
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterServerEvent("vehiclemod:server:saveStatus")
AddEventHandler("vehiclemod:server:saveStatus", function(plate)
    if VehicleStatus[plate] ~= nil then
        exports['datasilta']:execute('UPDATE player_vehicles SET status = @status WHERE plate = @plate', {['@status'] = json.encode(VehicleStatus[plate]), ['@plate'] = plate})
    end
end)

function IsVehicleOwned(plate)
    local retval = false
    rg.toiminnot.datasilta(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = true
        end
    end)
    return retval
end

function GetVehicleStatus(plate)
    local retval = nil
    rg.toiminnot.datasilta(true, "SELECT `status` FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = result[1].status ~= nil and json.decode(result[1].status) or nil
        end
    end)
    return retval
end

rg.komennot.Add("setvehiclestatus", "Zet vehicle status", {{name="part", help="Type status dat je wilt bewerken"}, {name="amount", help="Level van de status"}}, true, function(source, args)
    local part = args[1]:lower()
    local level = tonumber(args[2])
    TriggerClientEvent("vehiclemod:client:setPartLevel", source, part, level)
end, "god")

rg.toiminnot.CreateCallback('vehicletuning:server:GetAttachedVehicle', function(source, cb)
    cb(Config.Plates)
end)

rg.toiminnot.CreateCallback('vehicletuning:server:IsMechanicAvailable', function(source, cb)
	local amount = 0
	for k, v in pairs(rg.toiminnot.GetPlayers()) do
        local Player = rg.toiminnot.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "mechanic" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    cb(amount)
end)

RegisterServerEvent('vehicletuning:server:SetAttachedVehicle')
AddEventHandler('vehicletuning:server:SetAttachedVehicle', function(veh, k)
    if veh ~= false then
        Config.Plates[k].AttachedVehicle = veh
        TriggerClientEvent('vehicletuning:client:SetAttachedVehicle', -1, veh, k)
    else
        Config.Plates[k].AttachedVehicle = nil
        TriggerClientEvent('vehicletuning:client:SetAttachedVehicle', -1, false, k)
    end
end)

RegisterServerEvent('vehicletuning:server:CheckForItems')
AddEventHandler('vehicletuning:server:CheckForItems', function(part)
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)
    local RepairPart = Player.Functions.GetItemByName(Config.RepairCostAmount[part].item)

    if RepairPart ~= nil then
        if RepairPart.amount >= Config.RepairCostAmount[part].costs then
            TriggerClientEvent('vehicletuning:client:RepaireeePart', src, part)
            Player.Functions.RemoveItem(Config.RepairCostAmount[part].item, Config.RepairCostAmount[part].costs)

            for i = 1, Config.RepairCostAmount[part].costs, 1 do
                TriggerClientEvent('inventory:client:ItemBox', src, rg.datapankki.Items[Config.RepairCostAmount[part].item], "remove")
                Citizen.Wait(500)
            end
        else
            TriggerClientEvent('rg:Ilmoitus', src, "Você não tem o suficiente "..rg.datapankki.Items[Config.RepairCostAmount[part].item]["label"].." (min. "..Config.RepairCostAmount[part].costs.."x)", "error")
        end
    else
        TriggerClientEvent('rg:Ilmoitus', src, "Você não tem "..rg.datapankki.Items[Config.RepairCostAmount[part].item]["label"].." contigo!", "error")
    end
end)

function IsAutrgzed(CitizenId)
    local retval = false
    for _, cid in pairs(Config.AutrgzedIds) do
        if cid == CitizenId then
            retval = true
            break
        end
    end
    return retval
end

rg.komennot.Add("contratarmecanico", "Dê a alguém um emprego de mecânico", {{name="id", help="ID Do Jogador"}}, false, function(source, args)
    local Player = rg.toiminnot.GetPlayer(source)

    if IsAutrgzed(Player.PlayerData.citizenid) then
        local TargetId = tonumber(args[1])
        if TargetId ~= nil then
            local TargetData = rg.toiminnot.GetPlayer(TargetId)
            if TargetData ~= nil then
                TargetData.Functions.SetJob("mechanic")
                TriggerClientEvent('rg:Ilmoitus', TargetData.PlayerData.source, "Você contratou como funcionário da Auto Care!")
                TriggerClientEvent('rg:Ilmoitus', source, "Você tem ("..TargetData.PlayerData.charinfo.firstname..") contratado como funcionário da Auto Care!")
            end
        else
            TriggerClientEvent('rg:Ilmoitus', source, "Você deve fornecer um ID de jogador!")
        end
    else
        TriggerClientEvent('rg:Ilmoitus', source, "Você não pode fazer isso!", "error") 
    end
end)

rg.komennot.Add("despedirmecanico", "Tirar o emprego de mecânico de alguém", {{name="id", help="ID Do Jogador"}}, false, function(source, args)
    local Player = rg.toiminnot.GetPlayer(source)

    if IsAutrgzed(Player.PlayerData.citizenid) then
        local TargetId = tonumber(args[1])
        if TargetId ~= nil then
            local TargetData = rg.toiminnot.GetPlayer(TargetId)
            if TargetData ~= nil then
                if TargetData.PlayerData.job.name == "mechanic" then
                    TargetData.Functions.SetJob("unemployed")
                    TriggerClientEvent('rg:Ilmoitus', TargetData.PlayerData.source, "Você foi demitido como funcionário da Auto Care!")
                    TriggerClientEvent('rg:Ilmoitus', source, "Você foi ("..TargetData.PlayerData.charinfo.firstname..") despedido como funcionário da Auto Care!")
                else
                    TriggerClientEvent('rg:Ilmoitus', source, "Este não é um funcionário da Autocare!", "error")
                end
            end
        else
            TriggerClientEvent('rg:Ilmoitus', source, "Você deve fornecer um ID de jogador!", "error")
        end
    else
        TriggerClientEvent('rg:Ilmoitus', source, "Você não pode fazer isso!", "error")
    end
end)

rg.toiminnot.CreateCallback('vehicletuning:server:GetStatus', function(source, cb, plate)
    if VehicleStatus[plate] ~= nil and next(VehicleStatus[plate]) ~= nil then
        cb(VehicleStatus[plate])
    else
        cb(nil)
    end
end)