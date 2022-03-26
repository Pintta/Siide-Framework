rg = nil

TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)

rg.toiminnot.CreateCallback('dumpsearch:getItem', function(source, cb)
	local src = source
    local ply = rg.toiminnot.GetPlayer(src)
    local luck = math.random(1, 3)

    if luck == 2 then
        local luck2 = math.random(1, 4)
        local luck3 = math.random(1, 1000)
        local luck4 = math.random(1, 10000)
        local luck5 = math.random(1, 100000)
        local luck6 = math.random(1, 1000000)
        
        local src = source
        local Player = rg.toiminnot.GetPlayer(src)
        local Amount = math.random(2,6)
        local ItemData = rg.datapankki.Items["plastic"]

        if luck4 == 100 then	   
            ply.Functions.AddItem('weapon_snspistol', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, rg.datapankki.Items['weapon_snspistol'], "add")  
        elseif luck3 == 1 then   
            ply.Functions.AddItem('weapon_stungun', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, rg.datapankki.Items['weapon_stungun'], "add")
            Player.Functions.AddItem(rg.datapankki.Items["plastic"].name, Amount)
            TriggerClientEvent('inventory:client:ItemBox', src, rg.datapankki.Items["plastic"], "add")
            Player.Functions.AddItem(rg.datapankki.Items["steel"].name, Amount)
            TriggerClientEvent('inventory:client:ItemBox', src, rg.datapankki.Items["steel"], "add")         
        elseif luck2 == 1 then
            Player.Functions.AddItem(rg.datapankki.Items["plastic"].name, Amount)
            TriggerClientEvent('inventory:client:ItemBox', src, rg.datapankki.Items["plastic"], "add")
            Player.Functions.AddItem(rg.datapankki.Items["steel"].name, Amount)
            TriggerClientEvent('inventory:client:ItemBox', src, rg.datapankki.Items["steel"], "add")
        elseif luck4 == 1 then
            Player.Functions.AddItem(rg.datapankki.Items["pizza_07"].name, Amount)
            TriggerClientEvent('inventory:client:Itembox', src, rg.datapankki.Items["pizza_07"], "add")
            Player.Functions.AddItem(rg.datapankki.Items["jerry_can"].name, Amount)
            TriggerClientEvent('inventory:client:Itembox', src, rg.datapankki.Items["jerry_can"], "add")
            Player.Functions.AddItem(rg.datapankki.Items["iron"].name, Amount)
            TriggerClientEvent('inventory:client:Itembox', src, rg.datapankki.Items["iron"], "add")
            Player.Functions.AddItem(rg.datapankki.Items["aluminum"].name, Amount)
            TriggerClientEvent('inventory:client:Itembox', src, rg.datapankki.Items["aluminum"], "add")
        elseif luck5 == 1 then
            Player.Functions.AddItem(rg.datapankki.Items["taikinapohja"].name, Amount)
            TriggerClientEvent('inventory:client:Itembox', src, rg.datapankki.Items["taikinapohja"], "add")
            Player.Functions.AddItem(rg.datapankki.Items["lawyerpass"].name, Amount)
            TriggerClientEvent('inventory:client:Itembox', src, rg.datapankki.Items["lawyerpass"], "add")
            Player.Functions.AddItem(rg.datapankki.Items["lockpick"].name, Amount)
            TriggerClientEvent('inventory:client:Itembox', src, rg.datapankki.Items["lockpick"], "add")
            Player.Functions.AddItem(rg.datapankki.Items["weapon_pipebomb"].name, Amount)
            TriggerClientEvent('inventory:client:Itembox', src, rg.datapankki.Items["weapon_pipebomb"], "add")
        elseif luck6 == 1 then
            Player.Functions.AddItem(rg.datapankki.Items["rolex"].name, Amount)
            TriggerClientEvent('inventory:client:Itembox', src, rg.datapankki.Items["rolex"], "add")
            Player.Functions.AddItem(rg.datapankki.Items["handcuffs"].name, Amount)
            TriggerClientEvent('inventory:client:Itembox', src, rg.datapankki.Items["handcuffs"], "add")
            Player.Functions.AddItem(rg.datapankki.Items["whiskey"].name, Amount)
            TriggerClientEvent('inventory:client:Itembox', src, rg.datapankki.Items["whiskey"], "add")
            Player.Functions.AddItem(rg.datapankki.Items["weapon_molotov"].name, Amount)
            TriggerClientEvent('inventory:client:Itembox', src, rg.datapankki.Items["weapon_molotov"], "add")
        else
            Player.Functions.AddItem(rg.datapankki.Items["plastic"].name, Amount)
            TriggerClientEvent('inventory:client:ItemBox', src, rg.datapankki.Items["plastic"], "add")
        end		
        TriggerClientEvent('rg:Ilmoitus', src, 'Löysit jotain arvokasta..', 'success', 2000)
    else
        TriggerClientEvent('rg:Ilmoitus', src, 'No voi vittu..', 'error', 2000)
    end
end)

RegisterServerEvent('dumpsearch:getItem')
AddEventHandler('dumpsearch:getItem', function()
    rg.toiminnot.BanInjection(source, 'dumpsearch (getItem)')
end)