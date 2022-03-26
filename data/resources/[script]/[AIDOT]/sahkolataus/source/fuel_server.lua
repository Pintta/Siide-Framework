rg = nil
TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)

function round(value, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
end

RegisterServerEvent('sahkolataus:pay')
AddEventHandler('sahkolataus:pay', function(price)
	local src = source
	local pData = rg.toiminnot.GetPlayer(src)
	local amount = round(price)

	if pData.Functions.RemoveMoney('cash', amount, "bought-fuel") then
		TriggerClientEvent("rg:Ilmoitus", src, "Your car is topped up", "success")
	end
end)
