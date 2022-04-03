rg = nil
TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)

local CurrentWeather = "RAIN"
local DynamicWeather = false
local baseTime = 0
local timeOffset = 0
local freezeTime = false
local blackout = false

AvailableWeatherTypes = { 
    'NEUTRAL', 
    'SMOG',
    'CLOUDS',
    'RAIN',
    'THUNDER',
}

AvailableTimeTypes = 'NIGHT'

RegisterServerEvent('weathersync:server:RequestStateSync')
AddEventHandler('weathersync:server:RequestStateSync', function()
    TriggerClientEvent('weathersync:client:SyncWeather', -1, CurrentWeather, blackout)
    TriggerClientEvent('weathersync:client:SyncTime', -1, baseTime, timeOffset, freezeTime)
end)

function FreezeElement(element)
    if element == 'weather' then
        DynamicWeather = not DynamicWeather
    else
        freezeTime = not freezeTime
    end
end

RegisterServerEvent('weathersync:server:setWeather')
AddEventHandler('weathersync:server:setWeather', function(type)
    local src = source
    if rg.toiminnot.HasPermission(src, "admin") then
        if src ~= nil then
            TriggerEvent("logs:server:CreateLog", "weather", "Changed weather", "red", "**".. GetPlayerName(src) .. "**")
        end
        CurrentWeather = string.upper(type)
        TriggerEvent('weathersync:server:RequestStateSync')
    end
end)

RegisterServerEvent('weathersync:server:toggleBlackout')
AddEventHandler('weathersync:server:toggleBlackout', function()
    local src = source
    if rg.toiminnot.HasPermission(src, "admin") then
        ToggleBlackout()
    end
end)

RegisterServerEvent('weathersync:server:setTime')
AddEventHandler('weathersync:server:setTime', function(hour, minute)
    local src = source
    if rg.toiminnot.HasPermission(src, "admin") then
        SetExactTime(hour, minute)
    end
end)

function SetWeather(type)
    CurrentWeather = string.upper(type)
    TriggerEvent('weathersync:server:RequestStateSync')
end

function SetTime(type)
    if type:upper() == AvailableTimeTypes[1] then
        ShiftToMinute(0)
        ShiftToHour(9)
        TriggerEvent('weathersync:server:RequestStateSync')
    elseif type:upper() == AvailableTimeTypes[2] then
        ShiftToMinute(0)
        ShiftToHour(12)
        TriggerEvent('weathersync:server:RequestStateSync')
    elseif type:upper() == AvailableTimeTypes[3] then
        ShiftToMinute(0)
        ShiftToHour(18)
        TriggerEvent('weathersync:server:RequestStateSync')
    else
        ShiftToMinute(0)
        ShiftToHour(23)
        TriggerEvent('weathersync:server:RequestStateSync')
    end
end

function SetExactTime(hour, minute)
    local argh = tonumber(hour)
    local argm = tonumber(minute)
    if argh < 24 then
        ShiftToHour(argh)
    else
        ShiftToHour(0)
    end
    if argm < 60 then
        ShiftToMinute(argm)
    else
        ShiftToMinute(0)
    end
    local newtime = math.floor(((baseTime+timeOffset)/60)%24) .. ":"
    local minute = math.floor((baseTime+timeOffset)%60)
    if minute < 10 then
        newtime = newtime .. "0" .. minute
    else
        newtime = newtime .. minute
    end
    TriggerEvent('weathersync:server:RequestStateSync')
end

function ToggleBlackout()
    blackout = not blackout
    TriggerEvent('weathersync:server:RequestStateSync')
end

function ShiftToMinute(minute)
    timeOffset = timeOffset - (((baseTime+timeOffset) % 60) - minute)
end

function ShiftToHour(hour)
    timeOffset = timeOffset - ((((baseTime+timeOffset)/60) % 24) - hour) * 60
end

function NextWeatherStage()
    if CurrentWeather == "CLEAR" or CurrentWeather == "CLOUDS" or CurrentWeather == "RAIN"  then
        local new = math.random(1,2)
        if new == 1 then
            CurrentWeather = "CLEARING"
        else
            CurrentWeather = "OVERCAST"
        end
    elseif CurrentWeather == "CLEARING" or CurrentWeather == "OVERCAST" then
        local new = math.random(1,6)
        if new == 1 then
            if CurrentWeather == "CLEARING" then CurrentWeather = "FOGGY" else CurrentWeather = "RAIN" end
        elseif new == 2 then
            CurrentWeather = "CLOUDS"
        elseif new == 3 then
            CurrentWeather = "CLEAR"
        elseif new == 4 then
            CurrentWeather = "RAIN"
        elseif new == 5 then
            CurrentWeather = "SMOG"
        else
            CurrentWeather = "FOGGY"
        end
    elseif CurrentWeather == "THUNDER" or CurrentWeather == "RAIN" then
        CurrentWeather = "CLEARING"
    elseif CurrentWeather == "SMOG" or CurrentWeather == "FOGGY" then
        CurrentWeather = "CLEAR"
    end
    TriggerEvent("weathersync:server:RequestStateSync")
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local newBaseTime = os.time(os.date("!*t"))/2 + 360
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime			
        end
        baseTime = newBaseTime
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        TriggerClientEvent('weathersync:client:SyncTime', -1, baseTime, timeOffset, freezeTime)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        TriggerClientEvent('weathersync:client:SyncWeather', -1, CurrentWeather, blackout)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7200000)
        if DynamicWeather then
            NextWeatherStage()
        end
    end
end)
