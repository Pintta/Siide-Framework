rg = nil

TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)

local permissions = {
    ["kick"] = "admin",
    ["ban"] = "admin",
    ["noclip"] = "admin",
    ["kickall"] = "admin",
    ["managegroup"] = "admin"
}

RegisterServerEvent('admin:server:togglePlayerNoclip')
AddEventHandler('admin:server:togglePlayerNoclip', function(playerId, reason)
    local src = source
    if rg.toiminnot.HasPermission(src, permissions["noclip"]) then
        TriggerClientEvent("admin:client:toggleNoclip", playerId)
    end
end)

RegisterServerEvent('admin:server:killPlayer')
AddEventHandler('admin:server:killPlayer', function(playerId)
    local src = source
    if rg.toiminnot.HasPermission(src, permissions["kickall"]) then
        TriggerClientEvent('hospital:client:KillPlayer', playerId)
    end
end)

RegisterServerEvent('admin:server:kickPlayer')
AddEventHandler('admin:server:kickPlayer', function(playerId, reason)
    local src = source
    if rg.toiminnot.HasPermission(src, permissions["kick"]) then
        DropPlayer(playerId, "You've been kicked from the server:\n"..reason.."\n\n🔸 Join our Discord for more information: https://discord.gg/mVjvDf8Aaq")
    end
end)

RegisterServerEvent('admin:server:Freeze')
AddEventHandler('admin:server:Freeze', function(playerId, toggle)
    local src = source
    if rg.toiminnot.HasPermission(src, permissions["kickall"]) then
        TriggerClientEvent('admin:client:Freeze', playerId, toggle)
    end
end)

RegisterServerEvent('admin:server:serverKick')
AddEventHandler('admin:server:serverKick', function(reason)
    local src = source
    if rg.toiminnot.HasPermission(src, permissions["kickall"]) then
        for k, v in pairs(rg.toiminnot.GetPlayers()) do
            if v ~= src then 
                DropPlayer(v, "You've been kicked from the server:\n"..reason.."\n\n🔸 Join our Discord for more information: https://discord.gg/mVjvDf8Aaq")
            end
        end
    end
end)

local suffix = {
    "hihi",
    "#yolo",
    "hmm slurpie",
    "yeet terug naar esx",
}

RegisterServerEvent('admin:server:banPlayer')
AddEventHandler('admin:server:banPlayer', function(playerId, time, reason)
    local src = source
    if rg.toiminnot.HasPermission(src, permissions["ban"]) then
        local time = tonumber(time)
        local banTime = tonumber(os.time() + time)
        if banTime > 2147483647 then
            banTime = 2147483647
        end
        local timeTable = os.date("*t", banTime)
        TriggerClientEvent('chatMessage', -1, "BANHAMMER", "error", GetPlayerName(playerId).." foi banido por: "..reason.." "..suffix[math.random(1, #suffix)])
        rg.toiminnot.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`, `bannedby`) VALUES ('"..GetPlayerName(playerId).."', '"..GetPlayerIdentifiers(playerId)[1].."', '"..GetPlayerIdentifiers(playerId)[2].."', '"..GetPlayerIdentifiers(playerId)[3].."', '"..GetPlayerIdentifiers(playerId)[4].."', '"..reason.."', "..banTime..", '"..GetPlayerName(src).."')")
        DropPlayer(playerId, "Você foi banido do servidor:\n"..reason.."\n\nAcaba "..timeTable["day"].. "/" .. timeTable["month"] .. "/" .. timeTable["year"] .. " " .. timeTable["hour"].. ":" .. timeTable["min"] .. "\n🔸 Kijk op onze discord voor meer informatie: https://discord.gg/Ttr6fY6")
    end
end)
RegisterServerEvent('admin:server:revivePlayer')
AddEventHandler('admin:server:revivePlayer', function(target)
    local src = source
    if rg.toiminnot.HasPermission(src, permissions["kickall"]) then
	    TriggerClientEvent('hospital:client:Revive', target)
    end
end)

rg.komennot.Add("anuciostaff", "Advertise a message to all", {}, false, function(source, args)
    local msg = table.concat(args, " ")
    for i = 1, 3, 1 do
        TriggerClientEvent('chatMessage', -1, "SYSTEM", "error", msg)
    end
end, "admin")

rg.komennot.Add("admin", "Open admin menu", {}, false, function(source, args)
    local group = rg.toiminnot.GetPermission(source)
    TriggerClientEvent('admin:client:openMenu', source, group)
end, "admin")

rg.komennot.Add("report", "Send a report to administrators (only when needed, do not abuse this!)", {{name="message", help="Message"}}, true, function(source, args)
    local msg = table.concat(args, " ")
    local Player = rg.toiminnot.GetPlayer(source)
    TriggerClientEvent('admin:client:SendReport', -1, GetPlayerName(source), source, msg)
    TriggerClientEvent('chatMessage', source, "Report sent.", "normal", msg)
    TriggerEvent("logs:server:CreateLog", "report", "Report", "green", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Report:** " ..msg, false)
    TriggerEvent("logs:server:sendLog", Player.PlayerData.citizenid, "reportreply", {message=msg})
end)

rg.komennot.Add("staffchat", "Send a message to all team members", {{name="message", help="Message"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    TriggerClientEvent('admin:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, "admin")

rg.komennot.Add("givenuifocus", "Give nui focus", {{name="id", help="Player id"}, {name="focus", help="Set focus on/off"}, {name="mouse", help="Set mouse on/off"}}, true, function(source, args)
    local playerid = tonumber(args[1])
    local focus = args[2]
    local mouse = args[3]

    TriggerClientEvent('admin:client:GiveNuiFocus', playerid, focus, mouse)
end, "admin")

rg.komennot.Add("s", "Send a message to all team members", {{name="message", help="Message"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    TriggerClientEvent('admin:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, "admin")

rg.komennot.Add("avisos", "Warn a player", {{name="ID", help="Player"}, {name="Reason", help="Mention a reason"}}, true, function(source, args)
    local targetPlayer = rg.toiminnot.GetPlayer(tonumber(args[1]))
    local senderPlayer = rg.toiminnot.GetPlayer(source)
    table.remove(args, 1)
    local msg = table.concat(args, " ")

    local myName = senderPlayer.PlayerData.name

    local warnId = "NOTICE-"..math.random(1111, 9999)

    if targetPlayer ~= nil then
        TriggerClientEvent('chatMessage', targetPlayer.PlayerData.source, "SYSTEM", "error", "You were warned by:: "..GetPlayerName(source)..", Reason: "..msg)
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "You have warned "..GetPlayerName(targetPlayer.PlayerData.source).." for: "..msg)
        rg.toiminnot.ExecuteSql(false, "INSERT INTO `player_warns` (`senderIdentifier`, `targetIdentifier`, `reason`, `warnId`) VALUES ('"..senderPlayer.PlayerData.steam.."', '"..targetPlayer.PlayerData.steam.."', '"..msg.."', '"..warnId.."')")
    else
        TriggerClientEvent('rg:Ilmoitus', source, 'This player is not online', 'error')
    end 
end, "admin")

rg.komennot.Add("veravisos", "See Staff Notices for a Player", {{name="ID", help="Player"}, {name="Warning", help="Notice number, (1, 2 or 3 etc.)"}}, false, function(source, args)
    if args[2] == nil then
        local targetPlayer = rg.toiminnot.GetPlayer(tonumber(args[1]))
        rg.toiminnot.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(result)
            print(json.encode(result))
            TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", targetPlayer.PlayerData.name.." have "..tablelength(result).." NOTICE/S!")
        end)
    else
        local targetPlayer = rg.toiminnot.GetPlayer(tonumber(args[1]))

        rg.toiminnot.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(warnings)
            local selectedWarning = tonumber(args[2])

            if warnings[selectedWarning] ~= nil then
                local sender = rg.toiminnot.GetPlayer(warnings[selectedWarning].senderIdentifier)

                TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", targetPlayer.PlayerData.name.." was warned by "..sender.PlayerData.name..", Reason: "..warnings[selectedWarning].reason)
            end
        end)
    end
end, "admin")

rg.komennot.Add("apagaraviso", "Delete notices from a person", {{name="ID", help="Player"}, {name="Warning", help="Notice number, (1, 2 or 3 etc.)"}}, true, function(source, args)
    local targetPlayer = rg.toiminnot.GetPlayer(tonumber(args[1]))

    rg.toiminnot.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(warnings)
        local selectedWarning = tonumber(args[2])

        if warnings[selectedWarning] ~= nil then
            local sender = rg.toiminnot.GetPlayer(warnings[selectedWarning].senderIdentifier)

            TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "You deleted warning ("..selectedWarning..") , Reason: "..warnings[selectedWarning].reason)
            rg.toiminnot.ExecuteSql(false, "DELETE FROM `player_warns` WHERE `warnId` = '"..warnings[selectedWarning].warnId.."'")
        end
    end)
end, "admin")

function tablelength(table)
    local count = 0
    for _ in pairs(table) do 
        count = count + 1 
    end
    return count
end

rg.komennot.Add("reportr", "Reply to a report", {}, false, function(source, args)
    local playerId = tonumber(args[1])
    table.remove(args, 1)
    local msg = table.concat(args, " ")
    local OtherPlayer = rg.toiminnot.GetPlayer(playerId)
    local Player = rg.toiminnot.GetPlayer(source)
    if OtherPlayer ~= nil then
        TriggerClientEvent('chatMessage', playerId, "ADMIN - "..GetPlayerName(source), "warning", msg)
        TriggerClientEvent('rg:Ilmoitus', source, "Reply sent")
        TriggerEvent("logs:server:sendLog", Player.PlayerData.citizenid, "reportreply", {otherCitizenId=OtherPlayer.PlayerData.citizenid, message=msg})
        for k, v in pairs(rg.toiminnot.GetPlayers()) do
            if rg.toiminnot.HasPermission(v, "admin") then
                if rg.toiminnot.IsOptin(v) then
                    TriggerClientEvent('chatMessage', v, "ReportReply("..source..") - "..GetPlayerName(source), "warning", msg)
                    TriggerEvent("logs:server:CreateLog", "report", "Report Reply", "red", "**"..GetPlayerName(source).."** responded to the: **"..OtherPlayer.PlayerData.name.. " **(ID: "..OtherPlayer.PlayerData.source..") **Message:** " ..msg, false)
                end
            end
        end
    else
        TriggerClientEvent('rg:Ilmoitus', source, "Is not online", "error")
    end
end, "admin")

rg.komennot.Add("setmodel", "Change to a model that you like..", {{name="model", help="Name of the model"}, {name="id", help="Id of the Player (empty for yourself)"}}, false, function(source, args)
    local model = args[1]
    local target = tonumber(args[2])

    if model ~= nil or model ~= "" then
        if target == nil then
            TriggerClientEvent('admin:client:SetModel', source, tostring(model))
        else
            local Trgt = rg.toiminnot.GetPlayer(target)
            if Trgt ~= nil then
                TriggerClientEvent('admin:client:SetModel', target, tostring(model))
            else
                TriggerClientEvent('rg:Ilmoitus', source, "This person is not online..", "error")
            end
        end
    else
        TriggerClientEvent('rg:Ilmoitus', source, "You did not set a model..", "error")
    end
end, "admin")

rg.komennot.Add("setspeed", "Change to a speed you like..", {}, false, function(source, args)
    local speed = args[1]

    if speed ~= nil then
        TriggerClientEvent('admin:client:SetSpeed', source, tostring(speed))
    else
        TriggerClientEvent('rg:Ilmoitus', source, "You did not set a speed.. (`fast` for super-run, `normal` for normal)", "error")
    end
end, "admin")


rg.komennot.Add("admincar", "Save the vehicle in your garage", {}, false, function(source, args)
    local ply = rg.toiminnot.GetPlayer(source)
    TriggerClientEvent('admin:client:SaveCar', source)
end, "admin")

RegisterServerEvent('admin:server:SaveCar')
AddEventHandler('admin:server:SaveCar', function(mods, vehicle, hash, plate)
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)
    rg.toiminnot.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] == nil then
            rg.toiminnot.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..vehicle.model.."', '"..vehicle.hash.."', '"..json.encode(mods).."', '"..plate.."', 0)")
            TriggerClientEvent('rg:Ilmoitus', src, 'The vehicle is now yours!', 'success', 5000)
        else
            TriggerClientEvent('rg:Ilmoitus', src, 'This vehicle is already yours..', 'error', 3000)
        end
    end)
end)

rg.komennot.Add("verreports", "Switching Receive Reports", {}, false, function(source, args)
    rg.toiminnot.ToggleOptin(source)
    if rg.toiminnot.IsOptin(source) then
        TriggerClientEvent('rg:Ilmoitus', source, "You are receiving reports", "success")
    else
        TriggerClientEvent('rg:Ilmoitus', source, "You are not receiving reports", "error")
    end
end, "admin")

RegisterCommand("kickall", function(source, args, rawCommand)
    local src = source
    
    if src > 0 then
        local reason = table.concat(args, ' ')
        local Player = rg.toiminnot.GetPlayer(src)

        if rg.toiminnot.HasPermission(src, "god") then
            if args[1] ~= nil then
                for k, v in pairs(rg.toiminnot.GetPlayers()) do
                    local Player = rg.toiminnot.GetPlayer(v)
                    if Player ~= nil then 
                        DropPlayer(Player.PlayerData.source, reason)
                    end
                end
            else
                TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Mention a reason..')
            end
        else
            TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'You can not do that..')
        end
    else
        for k, v in pairs(rg.toiminnot.GetPlayers()) do
            local Player = rg.toiminnot.GetPlayer(v)
            if Player ~= nil then 
                DropPlayer(Player.PlayerData.source, "Hello Ananás Head 🍍 - We are resicting the server, check your Discord for more information! (https://discord.gg/mVjvDf8Aaq)")
            end
        end
    end
end, false)

RegisterServerEvent('admin:server:bringTp')
AddEventHandler('admin:server:bringTp', function(targetId, coords)
    TriggerClientEvent('admin:client:bringTp', targetId, coords)
end)

rg.toiminnot.CreateCallback('admin:server:hasPermissions', function(source, cb, group)
    local src = source
    local retval = false

    if rg.toiminnot.HasPermission(src, group) then
        retval = true
    end
    cb(retval)
end)

RegisterServerEvent('admin:server:setPermissions')
AddEventHandler('admin:server:setPermissions', function(targetId, group)
    local src = source
    if rg.toiminnot.HasPermission(src, permissions["managegroup"]) then
        rg.toiminnot.AddPermission(targetId, group.rank)
        TriggerClientEvent('rg:Ilmoitus', targetId, 'Added Permission '..group.label)
    end
end)

RegisterServerEvent('admin:server:OpenSkinMenu')
AddEventHandler('admin:server:OpenSkinMenu', function(targetId)
    local src = source
    if rg.toiminnot.HasPermission(src, permissions["noclip"]) then
        TriggerClientEvent("clothing:client:openMenu", targetId)
    end
end)

RegisterServerEvent('admin:server:SendReport')
AddEventHandler('admin:server:SendReport', function(name, targetSrc, msg)
    local src = source
    local Players = rg.toiminnot.GetPlayers()

    if rg.toiminnot.HasPermission(src, "admin") then
        if rg.toiminnot.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "REPORT - "..name.." ("..targetSrc..")", "report", msg)
        end
    end
end)

RegisterServerEvent('admin:server:StaffChatMessage')
AddEventHandler('admin:server:StaffChatMessage', function(name, msg)
    local src = source
    local Players = rg.toiminnot.GetPlayers()

    if rg.toiminnot.HasPermission(src, "admin") then
        if rg.toiminnot.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "STAFFCHAT - "..name, "error", msg)
        end
    end
end)

rg.komennot.Add("setammo", "Staff: define munição manual para uma arma.", {{name="amount", help="Amount of bullets, for example: 20"}, {name="weapon", help="Name of the weapen, for example: WEAPON_VINTAGEPISTOL"}}, false, function(source, args)
    local src = source
    local weapon = args[2]
    local amount = tonumber(args[1])

    if weapon ~= nil then
        TriggerClientEvent('weapons:client:SetWeaponAmmoManual', src, weapon, amount)
    else
        TriggerClientEvent('weapons:client:SetWeaponAmmoManual', src, "current", amount)
    end
end, 'admin')