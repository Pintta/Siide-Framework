rg = nil

TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)

RegisterServerEvent('logs:server:CreateLog')
AddEventHandler('logs:server:CreateLog', function(name, title, color, message, tagEveryone)
    local tag = tagEveryone ~= nil and tagEveryone or false
    local webHook = Config.Webhooks[name] ~= nil and Config.Webhooks[name] or Config.Webhooks["default"]
    local embedData = {
        {
            ["title"] = title,
            ["color"] = Config.Colors[color] ~= nil and Config.Colors[color] or Config.Colors["default"],
            ["footer"] = {
            ["text"] = os.date("%c"),
            },
            ["description"] = message,
        }
    }
    PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "Monica",embeds = embedData}), { ['Content-Type'] = 'application/json' })
    Citizen.Wait(100)
    if tag then
        PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "Monica", content = ""}), { ['Content-Type'] = 'application/json' })
    end
end)

rg.komennot.Add("testwebhook", "Test Your Discord Webhook For Logs (God Only)", {}, false, function(source, args)
    TriggerEvent("logs:server:CreateLog", "default", "TestWebhook", "default", "Triggered **a** test webhook :)")
end, "god")