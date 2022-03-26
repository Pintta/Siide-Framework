rg = nil
TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)

local DrivingSchools = {
    "PAE31194",
    "TRB56419",
    "UNA59325",
    "LWR55470",
    "APJ79416",
    "FUN28030",
}

RegisterServerEvent('cityhall:server:requestId')
AddEventHandler('cityhall:server:requestId', function(identityData)
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)

    local licenses = {
        ["driver"] = true,
        ["business"] = false
    }

    local info = {}
    if identityData.item == "id_card" then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
    elseif identityData.item == "driver_license" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.type = "A1-A2-A | AM-B | C1-C-CE"
    end

    Player.Functions.AddItem(identityData.item, 1, nil, info)

    TriggerClientEvent('inventory:client:ItemBox', src, rg.datapankki.Items[identityData.item], 'add')
end)

RegisterServerEvent('cityhall:server:sendDriverTest')
AddEventHandler('cityhall:server:sendDriverTest', function()
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)
    for k, v in pairs(DrivingSchools) do 
        local SchoolPlayer = rg.toiminnot.GetPlayerByCitizenId(v)
        if SchoolPlayer ~= nil then 
            TriggerClientEvent("cityhall:client:sendDriverEmail", SchoolPlayer.PlayerData.source, Player.PlayerData.charinfo)
        else
            local mailData = {
                sender = "City Hall",
                subject = "Request driving lessons",
                message = "Dear,<br /><br />We just received a message that someone wants to take driving lessons.<br />If you are willing to teach, please contact us:<br />Name: <strong>".. Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. "<br />Phone number: <strong>"..Player.PlayerData.charinfo.phone.."</strong><br/><br/>Kind regards,<br />City Hall Los Santos",
                button = {}
            }
            TriggerEvent("phone:server:sendNewEventMail", v, mailData)
        end
    end
    TriggerClientEvent('rg:Ilmoitus', src, 'An email has been sent to driving schools, you will be contacted when they can', "success", 5000)
end)

RegisterServerEvent('cityhall:server:ApplyJob')
AddEventHandler('cityhall:server:ApplyJob', function(job)
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)
    local JobInfo = rg.datapankki.Jobs[job]

    Player.Functions.SetJob(job)

    TriggerClientEvent('rg:Ilmoitus', src, 'Congratulations, you have a new job! ('..JobInfo.label..')')
end)

rg.komennot.Add("darcartadeconducao", "Driving license", {{"id", "ID Of the player"}}, true, function(source, args)
    local Player = rg.toiminnot.GetPlayer(source)
    if IsWhitelistedSchool(Player.PlayerData.citizenid) then
        local SearchedPlayer = rg.toiminnot.GetPlayer(tonumber(args[1]))
        if SearchedPlayer ~= nil then
            local driverLicense = SearchedPlayer.PlayerData.metadata["licences"]["driver"]
            if not driverLicense then
                local licenses = {
                    ["driver"] = true,
                    ["business"] = SearchedPlayer.PlayerData.metadata["licences"]["business"]
                }
                SearchedPlayer.Functions.SetMetaData("licences", licenses)
                TriggerClientEvent('rg:Ilmoitus', SearchedPlayer.PlayerData.source, "You passed! Get your license at cityhall", "success", 5000)
            else
                TriggerClientEvent('rg:Ilmoitus', src, "We cant give your license..", "error")
            end
        end
    end
end)

function IsWhitelistedSchool(citizenid)
    local retval = false
    for k, v in pairs(DrivingSchools) do 
        if v == citizenid then
            retval = true
        end
    end
    return retval
end

RegisterServerEvent('cityhall:server:banPlayer')
AddEventHandler('cityhall:server:banPlayer', function()
    local src = source
    TriggerClientEvent('chatMessage', -1, "QB Anti-Cheat", "error", GetPlayerName(src).." banned")
    rg.toiminnot.datasilta(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`, `bannedby`) VALUES ('"..GetPlayerName(src).."', '"..GetPlayerIdentifiers(src)[1].."', '"..GetPlayerIdentifiers(src)[2].."', '"..GetPlayerIdentifiers(src)[3].."', '"..GetPlayerIdentifiers(src)[4].."', 'Abuse localhost:13172 for POST requests', 2145913200, '"..GetPlayerName(src).."')")
    DropPlayer(src, "This is not how things work right? ;). For more information go to our discord: ")
end)