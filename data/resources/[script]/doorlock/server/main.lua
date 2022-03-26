rg = nil
TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)

local doorInfo = {}

RegisterServerEvent('doorlock:server:setupDoors')
AddEventHandler('doorlock:server:setupDoors', function()
	local src = source
	TriggerClientEvent("doorlock:client:setDoors", Zontti.Doors)
end)

RegisterServerEvent('doorlock:server:updateState')
AddEventHandler('doorlock:server:updateState', function(doorID, state)
	local src = source
	local Player = rg.toiminnot.GetPlayer(src)
	
	Zontti.Doors[doorID].locked = state

	TriggerClientEvent('doorlock:client:setState', -1, doorID, state)
end)


rg.toiminnot.CreateCallback('doorlock:server:GetItem', function(source, cb, item)
  local src = source
  local Player = rg.toiminnot.GetPlayer(src)
  if Player ~= nil then 
    local RadioItem = Player.Functions.GetItemByName(item)
    if RadioItem ~= nil then
      cb(true)
    else
      cb(false)
    end
  else
    cb(false)
  end
end)