rg = nil

local citizenid = nil
local playerData = nil
local updateInterval = 30000

Citizen.CreateThread(function() 
    while rg == nil do
        TriggerEvent("rg:HaeAsia", function(obj) rg = obj end)    
        Citizen.Wait(200)
    end
end)

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end