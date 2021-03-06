rg = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if rg == nil then
            TriggerEvent("rg:HaeAsia", function(obj) rg = obj end)    
            Citizen.Wait(200)
        end
    end
end)

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while true do
        local InRange = false
        local PlayerPed = GetPlayerPed(-1)
        local PlayerPos = GetEntityCoords(PlayerPed)

        for shop, _ in pairs(Config.Locations) do
            local position = Config.Locations[shop]["coords"]
            for _, loc in pairs(position) do
                local dist = GetDistanceBetweenCoords(PlayerPos, loc["x"], loc["y"], loc["z"])
                if dist < 10 then
                    InRange = true
                    DrawMarker(2, loc["x"], loc["y"], loc["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.2, 0.1, 255, 255, 255, 155, 0, 0, 0, 1, 0, 0, 0)
                    if dist < 1 then
                        DrawText3Ds(loc["x"], loc["y"], loc["z"] + 0.15, '~g~E~w~ - Shop')
                        if IsControlJustPressed(0, Config.Keys["E"]) then
                            local ShopItems = {}
                            ShopItems.label = Config.Locations[shop]["label"]
                            ShopItems.items = Config.Locations[shop]["products"]
                            ShopItems.slots = 30
                            TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..shop, ShopItems)
                        end
                    end
                end
            end
        end
        if not InRange then
            Citizen.Wait(5000)
        end
        Citizen.Wait(5)
    end
end)

RegisterNetEvent('shops:client:UpdateShop')
AddEventHandler('shops:client:UpdateShop', function(shop, itemData, amount)
    TriggerServerEvent('shops:server:UpdateShopItems', shop, itemData, amount)
end)

RegisterNetEvent('shops:client:SetShopItems')
AddEventHandler('shops:client:SetShopItems', function(shop, shopProducts)
    Config.Locations[shop]["products"] = shopProducts
end)

RegisterNetEvent('shops:client:RestockShopItems')
AddEventHandler('shops:client:RestockShopItems', function(shop, amount)
    if Config.Locations[shop]["products"] ~= nil then 
        for k, v in pairs(Config.Locations[shop]["products"]) do 
            Config.Locations[shop]["products"][k].amount = Config.Locations[shop]["products"][k].amount + amount
        end
    end
end)

--Citizen.CreateThread(function()
--    for store,_ in pairs(Config.Locations) do
--        StoreBlip = AddBlipForCoord(Config.Locations[store]["coords"][1]["x"], Config.Locations[store]["coords"][1]["y"], Config.Locations[store]["coords"][1]["z"])
--        SetBlipColour(StoreBlip, 0)
--
--        if Config.Locations[store]["products"] == Config.Products["normal"] then
--            SetBlipSprite(StoreBlip, 52)
--            SetBlipScale(StoreBlip, 0.6)
--        end
--        SetBlipDisplay(StoreBlip, 4)
--        SetBlipAsShortRange(StoreBlip, false)
--        BeginTextCommandSetBlipName("STRING")
--        AddTextComponentSubstringPlayerName(Config.Locations[store]["label"])
--        EndTextCommandSetBlipName(StoreBlip)
--    end
--end)